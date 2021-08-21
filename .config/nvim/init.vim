" Neovim configurations.
" @Author Marin Borg 2021/08/20.

" Keybinds
let mapleader = " "


" Shift tab to redo tab on line, tab to tab in line.
nnoremap <Tab> >>_
nnoremap <S-Tab> <<_
inoremap <S-Tab> <C-D>
vnoremap <Tab> >gv
vnoremap <S-Tab> <gv



" Remove .swp files
set noswapfile
set wildmode=longest,list,full
set wildmenu
"ignore files
set wildignore+=*.pyc
set wildignore+=*._build/
set wildignore+=*/coverage/
set wildignore+=*/node_modules/
set wildignore+=*/.git/

" turn hybrid line numbers on
set number relativenumber
set nuw=6

" Display hidden characters
set listchars=eol:¬,trail:~,extends:>,precedes:<
set list
highlight Visual cterm=reverse ctermbg=NONE

" Highlight current row
augroup CursorLine
  au!
  au VimEnter,WinEnter,BufWinEnter * setlocal cursorline
  au WinLeave * setlocal nocursorline
augroup END

" Highligts yanked lines,
augroup highlight_yank
  autocmd!
  autocmd TextYankPost * silent! lua require'vim.highlight'.on_yank({timeout = 40})
augroup END

" Removes traling whitespaces.
"augroup strip_whitespaces_on_save
"  autocmd!
"  autocmd BufWritePre * %s/\s\+$//e
"augroup END




" Plugins
" _________________________________________________________________
call plug#begin(stdpath('config') . '/plugged')
" Language Servers
Plug 'fatih/vim-go', {'do': ':GoInstallBinaries'}
Plug 'sheerun/vim-polyglot'
" Plug 'OmniSharp/omnisharp-vim'

" Themes
" nord
"Plug 'arcticicestudio/nord-vim'
" onedark
Plug 'joshdick/onedark.vim'

" Yes I am sneaky snek now
Plug 'ambv/black'

" Plevvim lsp Plugins
Plug 'neovim/nvim-lspconfig'
Plug 'nvim-lua/completion-nvim'
" Plug 'nvim-lua/completion-nvim'
Plug 'glepnir/lspsaga.nvim'
Plug 'simrat39/symbols-outline.nvim'
" Plug 'tjdevries/nlua.nvim'
" Plug 'tjdevries/lsp_extentions.nvim'

" Neovim Tree shitter
Plug 'nvim-treesitter/nvim-treesitter', {'do': 'TSUpdate'}
Plug 'nvim-treesitter/playground'

" Debugger Plugins
Plug 'puremourning/vimspector'
Plug 'szw/vim-maximizer'

Plug 'rust-lang/rust.vim'
Plug 'darrikonn/vim-gofmt'
Plug 'tpope/vim-fugitive'
Plug 'junegunn/gv.vim'
Plug 'vim-utils/vim-man'
Plug 'mbbill/undotree'
Plug 'tpope/vim-dispatch'
Plug 'theprimeagen/vim-be-good'
Plug 'gruvbox-community/gruvbox'
Plug 'tpope/vim-projectionist'

" telescope requirements...
Plug 'nvim-lua/popup.nvim'
Plug 'nvim-lua/plenary.nvim'
Plug 'nvim-telescope/telescope.nvim'
Plug 'nvim-telescope/telescope-fzy-native.nvim'

Plug 'flazz/vim-colorschemes'
Plug 'chriskempson/base16-vim'

Plug 'terryma/vim-multiple-cursors'
Plug 'airblade/vim-gitgutter'
" HARPOON!!
Plug 'mhinz/vim-rfc'

" prettier
Plug 'sbdchd/neoformat'

" should I try another status bar???
Plug 'glepnir/galaxyline.nvim' , {'branch': 'main'}
Plug 'hoob3rt/lualine.nvim'

Plug 'tpope/vim-fugitive'
Plug 'Yggdroot/indentLine'

Plug 'rmagatti/goto-preview'
call plug#end()


" PLUGIN CONFIGURATIONS
" ______________________________________________________________________

" Debuggers
" ______________________________________________________________________
" let g:vimspector_install_gadgets = [ 'debugpy', 'vscode-cpptools', 'CodeLLDB' ]
let g:python3_host_prog = '/usr/bin/python3'
let g:vim_be_good_log_file = 1
let g:vim_apm_log = 1

if executable('rg')
  let g:rg_derive_root='true'
endif

" Theme
" ______________________________________________________________________________________
"Use 24-bit (true-color) mode in Vim/Neovim when outside tmux.
"If you're using tmux version 2.2 or later, you can remove the outermost $TMUX check and use tmux's 24-bit color support
"(see < http://sunaku.github.io/tmux-24bit-color.html#usage > for more information.)
if (empty($TMUX))
  if (has("nvim"))
    "For Neovim 0.1.3 and 0.1.4 < https://github.com/neovim/neovim/pull/2198 >
    let $NVIM_TUI_ENABLE_TRUE_COLOR=1
  endif
  "For Neovim > 0.1.5 and Vim > patch 7.4.1799 < https://github.com/vim/vim/commit/61be73bb0f965a895bfb064ea3e55476ac175162 >
  "Based on Vim patch 7.4.1770 (`guicolors` option) < https://github.com/vim/vim/commit/8a633e3427b47286869aa4b96f2bfc1fe65b25cd >
  " < https://github.com/neovim/neovim/wiki/Following-HEAD#20160511 >
  if (has("termguicolors"))
    set termguicolors
  endif
endif

syntax on
colorscheme onedark




" Language servers and autocompletions and fomatters
" ______________________________________________________________________________
"Auto-complete
"
set completeopt=menuone,noinsert,noselect
let g:completion_matching_strategy_list = ['exact', 'substring', 'fuzzy']

" LSP
"
" npm install -g pyright || gopls
" npm install -g typescript-language-server || tsserver
" npm i -g bash-language-server || bashls
" GO111MODULE=on go get golang.org/x/tools/gopls@latest || gopls

"let g:go_bin_path = $HOME."/go/bin"

lua require('lspconfig').tsserver.setup{ on_attach=require'completion'.on_attach }
lua require('lspconfig').pyright.setup{ on_attach=require'completion'.on_attach }
lua require('lspconfig').gopls.setup{ on_attach=require'completion'.on_attach }
lua require('lspconfig').bashls.setup{ on_attach=require'completion'.on_attach }


" Formatters (REQUIRES MORE WORK)
"
"let g:neoformat_run_all_formatters = 1

augroup fmt
  autocmd!
  autocmd BufWritePre * undojoin | Neoformat
augroup END


" Tree viewers and file-search
" __________________________________________________________________________
" Using Lua functions
nnoremap <leader>ff <cmd>lua require('telescope.builtin').find_files()<cr>
nnoremap <leader>fg <cmd>lua require('telescope.builtin').live_grep()<cr>
nnoremap <leader>fb <cmd>lua require('telescope.builtin').buffers()<cr>
nnoremap <leader>fh <cmd>lua require('telescope.builtin').help_tags()<cr>


" Quality of life.
" ______________________________________________________
"
" Display x spaces as tabs.
let g:indentLine_setColors = 1
"let g:indentLine_color_gui = '#CCCCCC'
let g:indentLine_char_list = ['|']



lua require('goto-preview').setup { width = 120; height = 15; default_mappings = false; debug = false; opacity = nil; post_open_hook = nil; }

nnoremap gpd <cmd>lua require('goto-preview').goto_preview_definition()<CR>
nnoremap gpi <cmd>lua require('goto-preview').goto_preview_implementation()<CR>
nnoremap gpc <cmd>lua require('goto-preview').close_all_win()<CR>
