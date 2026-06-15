{ config, ... }: {
  stylix.targets.gtk.enable = config.profile.guiSoftwares.enable;
}
