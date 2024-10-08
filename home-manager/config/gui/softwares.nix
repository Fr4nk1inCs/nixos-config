{
  pkgs,
  config,
  lib,
  ...
}: let
  cfg = config.homeManagerConfig;
  enable = cfg.gui.enable && cfg.gui.software.enable && cfg.system == "linux";
in {
  config.home.packages = lib.optionals enable (
    with pkgs; [
      # browser
      google-chrome
      # instant messaging
      telegram-desktop
      # streaming music
      spotify
      # remote code editing
      vscode
      # screen capture
      obs-studio
      # file syncing
      onedrive
      # document viewer
      evince
      zathura
      # note taking
      obsidian
      # video player
      mpv
      vlc
      # remote desktop
      parsec-bin
      # image editing
      inkscape
      # academic research
      zotero
      # instant messaging
      qq
      # file explorer
      nautilus
      # system management
      baobab # disk usage analyzer
    ]
  );
}
