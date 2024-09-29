_: let
  map = keymap: {
    inherit (keymap) key;
    mode = "n";
    inherit (keymap) action;
    options = {
      inherit (keymap) desc;
      silent = true;
    };
  };
  jump = direction: {
    __raw = ''
      function() require("todo-comments").jump_${direction}() end
    '';
  };
  fzf = keywords: {
    __raw = ''
      function() require("todo-comments.fzf").todo({ keywords = ${keywords} }) end
    '';
  };
in {
  programs.nixvim.plugins.todo-comments = {
    enable = true;
  };

  programs.nixvim.keymaps = [
    (map
      {
        key = "]t";
        action = jump "next";
        desc = "Next todo comment";
      })
    (map
      {
        key = "[t";
        action = jump "prev";
        desc = "Previous todo comment";
      })
    (map
      {
        key = "<leader>xt";
        action = "<cmd>Trouble todo toggle<cr>";
        desc = "Todo (Trouble)";
      })
    (map
      {
        key = "<leader>xT";
        action = "<cmd>Trouble todo toggle filter = { tag = {TODO,FIX,FIXME} }<cr>";
        desc = "Todo/Fix/Fixme (Trouble)";
      })
    (map
      {
        key = "<leader>st";
        action = fzf "nil";
        desc = "Search todo comments";
      })
    (map
      {
        key = "<leader>sT";
        action = fzf ''{ "TODO", "FIX", "FIXME" }'';
        desc = "Search todo comments (TODO, FIX, FIXME)";
      })
  ];
}
