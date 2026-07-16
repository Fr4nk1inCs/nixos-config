{
  stdenvNoCC,
  lib,
  vscode-utils,
  pyrefly,
  vscode-extension-update-script,
}:

vscode-utils.buildVscodeMarketplaceExtension (
  let
    archMap = {
      "x86_64-linux" = "linux-x64";
      "aarch64-linux" = "linux-arm64";
      "x86_64-darwin" = "darwin-x64";
      "aarch64-darwin" = "darwin-arm64";
    };
    versionData = lib.importJSON ./pyrefly.json;
    platforms = lib.mapAttrsToList (platform: _: platform) versionData.hashes;
  in
  {
    mktplcRef = {
      name = "pyrefly";
      publisher = "meta";
      inherit (versionData) version;
      hash =
        versionData.hashes.${stdenvNoCC.hostPlatform.system}
          or (throw "Unsupported system ${stdenvNoCC.hostPlatform.system}");
      arch =
        archMap.${stdenvNoCC.hostPlatform.system}
          or (throw "Unsupported system ${stdenvNoCC.hostPlatform.system}");
    };

    postInstall = ''
      test -x "$out/$installPrefix/bin/pyrefly" || {
        echo "Replacing the bundled pyrefly binary failed, because 'bundled/libs/bin/pyrefly' is missing."
        echo "Update the package to the match the new path/behavior."
        exit 1
      }

      ln -sf ${lib.getExe pyrefly} "$out/$installPrefix/bin/pyrefly"
    '';

    passthru.updateScript = vscode-extension-update-script { };

    meta = with lib; {
      license = licenses.mit;
      changelog = "https://marketplace.visualstudio.com/items/meta.pyrefly/changelog";
      description = "Python autocomplete, typechecking, code navigation and more! Powered by Pyrefly, an open-source language server";
      downloadPage = "https://marketplace.visualstudio.com/items?itemName=meta.pyrefly";
      homepage = "https://pyrefly.org";
      inherit platforms;
    };
  }
)
