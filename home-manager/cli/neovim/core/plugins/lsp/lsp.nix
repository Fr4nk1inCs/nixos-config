_: let
  severity = s: "vim.diagnostic.severity.${s}";
in {
  programs.nixvim = {
    plugins.lsp = {
      enable = true;
      inlayHints = true;

      keymaps = {
        lspBuf = {
          # see fuzzy_finder.nix for better navigation
          # gd = {
          #   action = "definition";
          #   desc = "Goto Definition";
          # };
          # gr = {
          #   action = "references";
          #   desc = "References";
          #   nowait = true;
          # };
          # gI = {
          #   action = "implementation";
          #   desc = "Goto implementation";
          # };
          # gy = {
          #   action = "type_definition";
          #   desc = "Goto t[y]pe definition";
          # };
          K = {
            action = "hover";
            desc = "Hover";
          };
          gK = {
            action = "signature_help";
            desc = "Signature help";
          };
          "<leader>cr" = {
            action = "rename";
            desc = "Rename";
          };
        };
        extra = [
          {
            key = "<c-s>";
            action.__raw = "vim.lsp.buf.signature_help";
            mode = "i";
            options.desc = "Signature help";
          }
          {
            key = "<leader>ca";
            action.__raw = "vim.lsp.buf.code_action";
            mode = ["n" "v"];
            options.desc = "Code action";
          }
          {
            key = "<leader>cc";
            action.__raw = "vim.lsp.codelens.run";
            mode = ["n" "v"];
            options.desc = "Run codelens";
          }
          {
            key = "<leader>cC";
            action.__raw = "vim.lsp.codelens.refresh";
            options.desc = "Refresh & Display codelens";
          }
        ];
        silent = true;
      };
    };

    diagnostics = {
      underline = true;
      update_in_insert = false;
      virtual_text = {
        spacing = 4;
        source = "if_many";
      };
      severity_sort = true;
      signs.text.__raw = ''
        {
          [${severity "ERROR"}] = " ",
          [${severity "WARN"}] = " ",
          [${severity "INFO"}] = " ",
          [${severity "HINT"}] = " "
        }'';
    };

    plugins.which-key.settings.spec = [
      {
        __unkeyed-1 = "g";
        group = "goto";
      }
    ];

    extraConfigLuaPost = ''
      do
        utils.toggle.keymap(
          "<leader>ud",
          "diagnostics",
          function() -- get
            return vim.diagnostic.is_enabled and vim.diagnostic.is_enabled()
          end,
          vim.diagnostic.enable -- set
        )

        utils.toggle.keymap(
          "<leader>uh",
          "inlay hints",
          function() -- get
            return vim.lsp.inlay_hint.is_enabled({ bufnr = 0 })
          end,
          function(state) -- set
            vim.lsp.inlay_hint.enable(state, { bufnr = 0 })
          end
        )
      end
    '';
  };

  # programs.nixvim.extraConfigLuaPre = ''
  #   do
  #     local icons = utils.icons.diagnostics
  #     for severity, icon in pairs(icons) do
  #       local name = "DiagnosticSign" .. severity:gsub("^%l", string.upper)
  #       vim.fn.sign_define(name, { text = icon, texthl = name, numhl = "" })
  #     end
  #   end
  # '';
}
