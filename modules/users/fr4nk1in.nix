{
  self,
  lib,
  ...
}:
let
  username = "fr4nk1in";
in
{
  flake.modules = lib.mkMerge [
    (self.lib.createUser username true)
    {
      homeManager.${username} =
        {
          config,
          lib,
          ...
        }:
        {
          imports = with self.modules.homeManager; [
            system-desktop
          ];

          programs.git.settings.user = {
            name = "Fr4nk1in";
            email = "fushen@mail.ustc.edu.cn";
          };

          age.secrets = {
            fr4nk1in-ed25519 = {
              file = self.lib.getAgeSource "fr4nk1in-ed25519.age";
              path = "${config.home.homeDirectory}/.ssh/fr4nk1in-ed25519";
              mode = "0600";
              symlink = false;
            };
            whisk = {
              file = self.lib.getAgeSource "whisk.age";
              path = "${config.home.homeDirectory}/.ssh/whisk";
              mode = "0600";
              symlink = false;
            };
            sshconfig-lab = {
              file = self.lib.getAgeSource "sshconfig-lab.age";
              path = "${config.home.homeDirectory}/.ssh/config.d/lab";
            };
            sshconfig-personal = {
              file = self.lib.getAgeSource "sshconfig-personal.age";
              path = "${config.home.homeDirectory}/.ssh/config.d/personal";
            };

            atuin-key = lib.optionalAttrs config.programs.atuin.enable {
              file = self.lib.getAgeSource "atuin-key.age";
              path = config.programs.atuin.settings.key_path;
              mode = "0600";
              symlink = false;
            };
          };
        };
    }
  ];
}
