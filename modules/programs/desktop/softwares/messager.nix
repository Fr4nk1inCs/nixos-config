{
  flake.modules.darwin.desktop = {
    homebrew.casks = [
      "feishu"
      "qq"
      "wechat"
      "wechatwork"
    ];
  };

  flake.modules.homeManager.desktop = { pkgs, lib, ... }: {
    home.packages = [
      pkgs.ayugram-desktop
    ]
    ++ lib.optionals pkgs.stdenv.hostPlatform.isLinux (
      with pkgs;
      [
        feishu
        qq
        wechat
      ]
    );
  };
}
