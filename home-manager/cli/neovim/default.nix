{
  lib,
  pkgs,
  ...
}: {
  programs.neovim = {
    enable = true;

    defaultEditor = true;

    viAlias = true;
    vimAlias = true;
    vimdiffAlias = true;

    withNodeJs = true;
    withPython3 = true;
    withRuby = true;

    extraPackages = with pkgs; [
      # Dependent binaries
      gcc
      unzip
      gnumake
      fswatch

      # Make mason.nvim happy :(
      (python3.withPackages (ps: [ps.pynvim]))
      cargo
      go

      # LSPs
      basedpyright
      clang-tools
      gopls
      jdt-language-server
      ltex-ls
      lua-language-server
      neocmakelsp
      nil
      ruff-lsp
      rust-analyzer-unwrapped
      shellcheck
      tailwindcss-language-server
      taplo
      texlab
      tinymist
      vscode-langservers-extracted
      yaml-language-server

      nodePackages.vscode-json-languageserver
      nodePackages.typescript-language-server
      nodePackages."@astrojs/language-server"

      # Debuggers
      delve
      gdb
      lldb
      (python3.withPackages (ps: [ps.debugpy]))

      # Formatters
      alejandra
      black
      cmake-format
      gofumpt
      gotools
      isort
      shfmt
      stylua

      nodePackages.prettier

      # Tree-sitter
      tree-sitter

      # Linter
      cmake-lint

      # Typst
      typst
      typst-preview
      websocat
    ];

    plugins = [
      (pkgs.vimPlugins.nvim-treesitter.withPlugins (p:
        with p; [
          astro
          bash
          c
          cmake
          cpp
          css
          diff
          go
          gomod
          gosum
          gowork
          html
          java
          javascript
          jsdoc
          json
          json5
          jsonc
          latex
          llvm
          lua
          luadoc
          luap
          markdown
          markdown_inline
          mlir
          ninja
          python
          query
          regex
          ron
          rst
          rust
          tablegen
          toml
          tsx
          typescript
          verilog
          vim
          vimdoc
          xml
          yaml
        ]))
    ];
  };

  programs.zsh.shellAliases = {
    "v" = "nvim";
  };

  xdg.configFile.nvim.source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/nixos-config/home-manager/cli/neovim/nvim";
}
