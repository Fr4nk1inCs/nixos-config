{
  pkgs,
  config,
  lib,
  ...
}: let
  cfg = config.homeManagerConfig.gui;
  enable = cfg.enable && cfg.software.enable;
in
  with pkgs; {
    config.home.packages = lib.optionals enable [
      # browser
      google-chrome

      # note taking
      obsidian

      # file syncing
      onedrive

      # document viewer
      gnome.evince
      zathura

      # screen capture
      obs-studio

      # video player
      mpv
      vlc

      # online meeting
      zoom-us

      # remote desktop
      parsec-bin

      # image editing
      inkscape

      # code editor
      neovide

      # academic research
      zotero-beta

      # instant messaging
      qq
      telegram-desktop

      # file explorer
      gnome.nautilus

      # streaming music
      spotify

      # system management
      gnome.baobab # disk usage analyzer
      # clash-verge-rev # proxy
    ];
  }
