_: {
  programs.nixvim.plugins.dashboard = {
    enable = true;

    settings = {
      config = {
        header = [
          "███████╗██████╗ ██╗  ██╗███╗   ██╗██╗  ██╗ ██╗██╗███╗   ██╗"
          "██╔════╝██╔══██╗██║  ██║████╗  ██║██║ ██╔╝███║██║████╗  ██║"
          "█████╗  ██████╔╝███████║██╔██╗ ██║█████╔╝ ╚██║██║██╔██╗ ██║"
          "██╔══╝  ██╔══██╗╚════██║██║╚██╗██║██╔═██╗  ██║██║██║╚██╗██║"
          "██║     ██║  ██║     ██║██║ ╚████║██║  ██╗ ██║██║██║ ╚████║"
          "╚═╝     ╚═╝  ╚═╝     ╚═╝╚═╝  ╚═══╝╚═╝  ╚═╝ ╚═╝╚═╝╚═╝  ╚═══╝"
          ""
        ];

        shortcut = [
          {
            desc = "Quit";
            icon = " ";
            key = "q";
            action = "qa";
          }
        ];

        project = {
          action.__raw = ''
            function(path)
              vim.fn.chdir(path)
              vim.cmd("SessionRestore")
            end
          '';
        };

        packages.enable = false;
      };
    };
  };
}
