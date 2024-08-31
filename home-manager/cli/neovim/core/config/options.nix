_: {
  programs.nixvim.globals = {
    mapleader = " ";
    maplocalleader = "\\";

    root_spec = ["lsp" [".git" "lua"] "cwd"];

    autoformat = true;

    # Set filetype to `bigfile` for files larger than 1.5 MB Only vim syntax
    # will be enabled (with the correct filetype) LSP, treesitter and other ft
    # plugins will be disabled. mini.animate will also be disabled.
    bigfile_size = 1024 * 1024 * 1.5; # 1.5 MB
  };
  programs.nixvim.opts = {
    autowrite = true;
    colorcolumn = ["80" "120"];
    completeopt = "menu,menuone,noselect";
    conceallevel = 2;
    confirm = true; # Confirm to save changes before exiting modified buffer
    cursorline = true; # Enable highlight of current line
    expandtab = true; # Space instead of tabs
    fileencodings = ["ucs-bom" "utf-8" "GB18030" "gbk"];
    fillchars = {
      foldopen = "";
      foldclose = "";
      fold = " ";
      foldsep = " ";
      diff = "╱";
      eob = " ";
    };
    foldlevel = 99;
    formatexpr = "v:lua.require('conform').formatexpr()";
    formatoptions = "jcroqlnt"; # tcqj
    grepformat = "%f:%l:%c:%m";
    hlsearch = true;
    ignorecase = true;
    inccommand = "nosplit"; # Preview incremental substitute
    incsearch = true;
    jumpoptions = "view";
    laststatus = 3; # Global statusline
    linebreak = true; # Wrap lines at convenient points
    list = true; # Show some invisible characters
    mouse = "a"; # Enable mouse mode
    number = true; # Line number
    pumblend = 0; # Popup blend
    pumheight = 10; # Maximum number of entries in a popup
    relativenumber = true; # Relative line numbers
    scrolloff = 4; # Lines of context
    sessionoptions = [
      "buffers"
      "curdir"
      "tabpages"
      "winsize"
      "help"
      "globals"
      "skiprtp"
      "folds"
    ];
    shiftround = true;
    shiftwidth = 2; # Size of an indent
    showmode = false;
    sidescrolloff = 8; # Columns of context
    signcolumn = "yes"; # Always show the signcolumn
    smartcase = true; # Don't ignore case with capitals
    spelllang = ["en"];
    splitbelow = true; # Put new windows below current
    splitkeep = "screen";
    splitright = true; # Put new windows right of current
    tabstop = 2; # Number of spaces tabs count for
    termguicolors = true; # True color support
    timeoutlen = 300;
    undofile = true;
    undolevels = 100000;
    updatetime = 200; # Save swap file and trigger CursorHold
    virtualedit = "block"; # Allow cursor to move where there is no text in virtual block mode
    whichwrap = "<,>,h,l,[,]";
    wildmode = "longest:full,full"; # Command-line completion mode
    winminwidth = 5; # Minimum window width
    wrap = false; # Disable line wrap
    smoothscroll = true;
  };

  programs.nixvim.diagnostics = {
    float = {
      border = "rounded";
    };
  };

  programs.nixvim.extraConfigLua = ''
    vim.opt.clipboard = vim.env.SSH_TTY and "" or "unnamedplus" -- Sync with system clipboard
    vim.opt.shortmess:append({ W = true, I = true, c = true, C = true })
    vim.opt.spelloptions:append("noplainbuffer")

    vim.o.exrc = true;

    if vim.fn.has("wsl") == 1 then
        vim.g.clipboard = {
            name = "WslClipboard",
            -- Install Neovim on host (Windows) to use faster global clipboard
            copy = {
                ["+"] = { "/mnt/c/Program Files/Neovim/bin/win32yank.exe", "-i", "--crlf" },
                ["*"] = { "/mnt/c/Program Files/Neovim/bin/win32yank.exe", "-i", "--crlf" },
            },
            paste = {
                ["+"] = { "/mnt/c/Program Files/Neovim/bin/win32yank.exe", "-o", "--lf" },
                ["*"] = { "/mnt/c/Program Files/Neovim/bin/win32yank.exe", "-o", "--lf" },
            },
            cache_enabled = 0,
        }
    end
  '';

  programs.nixvim.luaLoader.enable = true;

  programs.nixvim.clipboard.providers.wl-copy.enable = true;
}
