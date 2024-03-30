{ config, pkgs, ... }:

{
  programs.neovim = {
    enable = true;
    package = pkgs.neovim-nightly;

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
      fswatch

      # LSPs
      jdt-language-server
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

      llvmPackages_latest.clang-unwrapped

      nodePackages.vscode-json-languageserver
      nodePackages.pyright
      nodePackages.typescript-language-server

      # Formatters
      black
      stylua
      shfmt
      alejandra

      # Tree-sitter
      tree-sitter
    ];

    plugins = [
      (pkgs.vimPlugins.nvim-treesitter.withPlugins (p: [
        p.bash
        p.c
        p.diff
        p.html
        p.javascript
        p.jsdoc
        p.json
        p.jsonc
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
      ]))
    ];
  };

  programs.zsh.shellAliases = {
    "v" = "nvim";
  };

  xdg.configFile.nvim.source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/nixos-config/home-manager/cli/neovim/nvim";
}


  #   ◍ rust-analyzer
  #
  #   ◍ stylua
  #
  #   ◍ taplo
  #
  #   ◍ texlab
  #
  #
  # Queued
  #   ◍ clangd
  #   ◍ eslint-lsp
  #   ◍ ruff-lsp
  #   ◍ typst-lsp
  #
  # Installed
  #   ◍ jdtls
  #   ◍ json-lsp jsonls
  #   ◍ lua-language-server lua_ls
  #   ◍ pyright
  #   ◍ shellcheck
  #   ◍ shfmt
  #   ◍ typescript-language-server tsserver
  #   ◍ yaml-language-server yamlls
