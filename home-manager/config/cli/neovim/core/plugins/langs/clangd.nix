{
  pkgs,
  lib,
  ...
}: let
  codelldb = "${pkgs.vscode-extensions.vadimcn.vscode-lldb}/share/vscode/extensions/vadimcn.vscode-lldb/adapter/codelldb";
in {
  programs.nixvim.plugins = {
    treesitter.grammarPackages = with pkgs.vimPlugins.nvim-treesitter.builtGrammars; [
      c
      cpp
    ];
    clangd-extensions = {
      enable = true;
      ast = {
        roleIcons = {
          type = "";
          declaration = "";
          expression = "";
          specifier = "";
          statement = "";
          templateArgument = "";
        };
        kindIcons = {
          compound = "";
          recovery = "";
          translationUnit = "";
          packExpansion = "";
          templateTypeParm = "";
          templateTemplateParm = "";
          templateParamObject = "";
        };
      };
    };

    lsp.servers.clangd = {
      enable = true;

      rootDir.__raw = ''
        function(fname)
          local util = require("lspconfig.util")
          return util.root_pattern(
            "Makefile",
            "configure.ac",
            "configure.in",
            "config.h.in",
            "meson.build",
            "meson_options.txt",
            "build.ninja"
          )(fname) or util.root_pattern(
            "compile_commands.json",
            "compile_flags.txt"
          )(fname) or util.find_git_ancestor(fname)
        end
      '';

      cmd = [
        "clangd"
        "--background-index"
        "--clang-tidy"
        "--header-insertion=iwyu"
        "--completion-style=detailed"
        "--function-arg-placeholders"
        "--fallback-style=llvm"
      ];

      extraOptions = {
        capabilities = {
          offsetEncoding = ["utf-16"];
        };
        init_options = {
          usePlaceholders = true;
          completeUnimported = true;
          clangdFileStatus = true;
        };
      };
    };

    cmp.settings.sorting.comparators = [
      "require('cmp.config.compare').offset"
      "require('cmp.config.compare').exact"
      "require('clangd_extensions.cmp_scores')"
      "require('cmp.config.compare').recently_used"
      "require('cmp.config.compare').locality"
      "require('cmp.config.compare').kind"
      "require('cmp.config.compare').length"
      "require('cmp.config.compare').order"
    ];

    dap = {
      adapters.servers.codelldb = {
        host = "localhost";
        port = "\${port}";
        executable = {
          command = codelldb;
          args = [
            "--port"
            "\${port}"
          ];
        };
      };

      configurations.c = [
        {
          name = "Launch File";
          type = "codelldb";
          request = "launch";
          program.__raw = ''
            function()
              return vim.fn.input("Path to executable: ", vim.fn.getcwd() .. "/", "file")
            end
          '';
          cwd = "\${workspaceFolder}";
        }
        {
          name = "Attach to Process";
          type = "codelldb";
          request = "attach";
          pid.__raw = ''require("dap.utils").pick_process'';
          cwd = "\${workspaceFolder}";
        }
      ];

      configurations.cpp = [
        {
          name = "Launch File";
          type = "codelldb";
          request = "launch";
          program.__raw = ''
            function()
              return vim.fn.input("Path to executable: ", vim.fn.getcwd() .. "/", "file")
            end
          '';
          cwd = "\${workspaceFolder}";
        }
        {
          name = "Attach to Process";
          type = "codelldb";
          request = "attach";
          pid.__raw = ''require("dap.utils").pick_process'';
          cwd = "\${workspaceFolder}";
        }
      ];
    };
  };

  home.file.".clangd" = let
    inherit (pkgs) apple-sdk;
    inherit (pkgs.gcc13) cc;
    inherit (cc) version;
  in
    lib.mkIf pkgs.stdenv.isDarwin {
      text = ''
        If:
          PathMatch: [.*\.c, .*\.cpp, .*\.cc, .*\.hpp, .*\.h]
        CompileFlags:
          Add:
            - -I${cc}/include
            - -I${cc}/include/c++/${version}
            - -I${cc}/include/c++/${version}/backward
            - -I${cc}/include/c++/${version}/aarch64-apple-darwin
            - -I${cc}/lib/gcc/aarch64-apple-darwin/${version}/include
            - -I${cc}/lib/gcc/aarch64-apple-darwin/${version}/include-fixed
            - -I${apple-sdk}/Platforms/MacOSX.platform/Developer/SDKs/MacOSX.sdk/usr/include
            - -I${apple-sdk}/MacOSX.plarform/Developer/SDKs/MacOSX.sdk/System/Library/Frameworks
      '';
    };
}
