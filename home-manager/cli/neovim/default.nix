{
  config,
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
      clang-tools
      gopls
      jdt-language-server
      ltex-ls
      lua-language-server
      nil
      ruff-lsp
      rust-analyzer-unwrapped
      shellcheck
      taplo
      texlab
      tinymist
      vscode-langservers-extracted
      yaml-language-server

      nodePackages.vscode-json-languageserver
      nodePackages.pyright
      nodePackages.typescript-language-server

      # Debuggers
      delve
      gdb
      lldb
      (python3.withPackages (ps: [ps.debugpy]))

      # Formatters
      alejandra
      black
      gofumpt
      gotools
      isort
      shfmt
      stylua

      # Tree-sitter
      tree-sitter

      # Typst
      typst
      typst-preview
      websocat
    ];

    plugins = [
      (pkgs.vimPlugins.nvim-treesitter.withPlugins (p: [
        p.bash
        p.c
        p.diff
        p.go
        p.gomod
        p.gowork
        p.gosum
        p.html
        p.javascript
        p.jsdoc
        p.json
        p.jsonc
        p.latex
        p.lua
        p.luadoc
        p.luap
        p.markdown
        p.markdown_inline
        p.python
        p.query
        p.regex
        p.toml
        p.tsx
        p.typescript
        p.vim
        p.vimdoc
        p.xml
        p.yaml
        p.json5
        p.cpp
        p.java
        p.ron
        p.rust
        p.ninja
        p.rst
        p.verilog
      ]))
    ];
  };

  programs.zsh.shellAliases = {
    "v" = "nvim";
  };

  xdg.configFile.nvim.source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/nixos-config/home-manager/cli/neovim/nvim";
}
