{
  flake.modules = {
    nixos.sudo = {
      # Password is needed when using sudo
      security.sudo.wheelNeedsPassword = true;
    };

    darwin.sudo = {
      security.pam.services.sudo_local.touchIdAuth = true;
    };
  };
}
