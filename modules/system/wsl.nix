{
  pkgs,
  lib,
  ...
}: {
  # This is a temporary workaround for WSL
  # See issues:
  # - https://github.com/nix-community/NixOS-WSL/issues/171
  # - https://github.com/microsoft/WSL/issues/9213
  users.defaultUserShell = let
    wrapper = pkgs.writeShellScriptBin "shell-wrapper" ''
      . /etc/set-environment
      exec ${pkgs.zsh}/bin/zsh "$@"
    '';
  in
    lib.mkForce "${wrapper}/bin/shell-wrapper";
}
