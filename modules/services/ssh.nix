{
  flake.modules = {
    nixos.ssh = {
      services.openssh = {
        enable = true;
        ports = [ 2222 ];
        settings = {
          PermitRootLogin = "prohibit-password";
          PasswordAuthentication = false;
        };
      };
    };

    darwin.ssh = {
      services.openssh = {
        enable = true;
        extraConfig = ''
          PermitRootLogin no
          PubkeyAuthentication yes
          PasswordAuthentication no
          ChallengeResponseAuthentication no
        '';
      };
    };
  };
}
