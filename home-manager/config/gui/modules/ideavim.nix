{
  config,
  lib,
  ...
}: let
  inherit (config.homeManagerConfig.gui) enable;
in {
  config.xdg.configFile."ideavim/ideavimrc" = lib.mkIf enable {
    text = ''
      let mapleader=' '

      set clipboard+=unnamedplus,ideaput
      set colorcolumn=80,120
      set hlsearch
      set ignorecase
      set incsearch
      set list
      set relativenumber
      set scrolloff=4
      set showcmd
      set showmode
      set sidescrolloff=8
      set smartcase
      set notimeout
      set unwrap
      set virtualedit=block
      set whichwrap=<,>,h,l,[,]

      set ideacopypreprocess
      set ideaglobalmode
      set ideajoin


      nnoremap <silent> <esc> :nohlsearch<cr><esc>
      " yank
      nnoremap <silent> Y y$
      " window navigation
      nnoremap <silent> <c-h> <c-w>h
      nnoremap <silent> <c-j> <c-w>j
      nnoremap <silent> <c-k> <c-w>k
      nnoremap <silent> <c-l> <c-w>l
      " resize window
      nnoremap <silent> <c-up> :resize +2<cr>
      nnoremap <silent> <c-down> :resize -2<cr>
      nnoremap <silent> <c-left> :vertical resize -2<cr>
      nnoremap <silent> <c-right> :vertical resize +2<cr>
      " buffers
      nnoremap <silent> <leader>bb :e #<cr>
      nnoremap <silent> <leader>` :e #<cr>
      " better indent
      vnoremap <silent> < <gv
      vnoremap <silent> > >gv
      " line movement
      nnoremap <silent> <c-s-j> :m .+1<cr>==
      nnoremap <silent> <c-s-k> :m .-2<cr>==
      vnoremap <silent> <c-s-j> :m '>+1<cr>gv=gv
      vnoremap <silent> <c-s-k> :m '<-2<cr>gv=gv
      inoremap <silent> <c-s-j> <esc>:m .+1<cr>==gi
      inoremap <silent> <c-s-k> <esc>:m .-2<cr>==gi

      " tab navigation
      map H <Action>(NextTab)
      map L <Action>(PreviousTab)
      map <leader>bd <Action>(CloseActiveTab)
      " diagnostics
      map ]e <Action>(GotoNextError)
      map [e <Action>(GotoPreviousError)
      map ]d <Action>(GotoNextError)
      map [d <Action>(GotoPreviousError)
      map <leader>cd <Action>(ShowErrorDescription)
      " terminal
      map <c-\> <Action>(ActivateTerminalToolWindow)
      " language navigation
      map gd  <Action>(GotoImplementation)
      map gpd <Action>(QuickImplementations)
      map gy  <Action>(GotoTypeDeclaration)
      map gpy <Action>(QuickTypeDefinition)
      map gr  <Action>(FindUsages)
      map K   <Action>(ShowHoverInfo)
      map <leader>cr <Action>(RenameElement)
      map <leader>ca <Action>(ShowIntentionActions)
      map <leader>cf <Action>(ReformatCode)
      " like fzf
      map <leader>ff <Action>(GotoFile)
      map <leader>sg <Action>(FindInPath)
      map <leader>ss <Action>(GotoSymbol)
      " git
      map <leader>gg <Action>(Vcs.QuickListPopupAction)

      " plugins
      set which-key
      set NERDTree
      nnoremap <silent> <leader>e :NERDTreeToggle<cr>
      nnoremap <silent> <leader>fe :NERDTreeFocus<cr>
      map s <Action>(flash.search)

      Plug 'tpope/vim-commentary'
      Plug 'machakann/vim-highlightedyank'
    '';
  };
}
