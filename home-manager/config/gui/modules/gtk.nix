{config, ...}: {
  stylix.targets.gtk.enable = config.profile.guiSoftwares.enable;

  gtk = {
    gtk4.theme = config.gtk.theme;
  };
}
