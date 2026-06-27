{
  flake.modules.homeManager.cli = { pkgs, lib, ... }: {
    home.packages = with pkgs; [
      herdr
    ];

    programs =
      let
        herdrSrc = pkgs.herdr.src;
        herdrIntegrationAssets = "${herdrSrc}/src/integration/assets";
      in
      {
        pi-coding-agent.extensions.herdr-agent-state = "${herdrIntegrationAssets}/pi/herdr-agent-state.ts";

        claude-code =
          let
            script = pkgs.writeShellApplication {
              name = "herdr-agent-state";
              text = ''
                bash '${herdrIntegrationAssets}/claude/herdr-agent-state.sh' session
              '';
              runtimeInputs = with pkgs; [ python3 ];
            };
          in
          {
            settings = {
              hooks.SessionStart = [
                {
                  hooks = [
                    {
                      command = lib.getExe script;
                      timeout = 10;
                      type = "command";
                    }
                  ];
                  matcher = "*";
                }
              ];
            };
          };
      };

  };
}
