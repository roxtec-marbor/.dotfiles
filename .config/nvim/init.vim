" -----------------------------------------------------
" Neovim configurations.                               |
" @Author Marin Borg 2021/08/20.                       |
" _____________________________________________________


" Keybinds
" _________________________________________________________
let mapleader = " "

" Reconfiguring tabs in visual and normal mode.
nnoremap > >>_
vnoremap < <gv

nnoremap < <<_
vnoremap > >gv

filetype plugin indent on
" show existing tab with 4 spaces width
set tabstop=4
" when indenting with '>', use 4 spaces width
set shiftwidth=4
" On pressing tab, insert 4 spaces
set expandtab

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
augroup strip_whitespaces_on_save
    autocmd!
    autocmd BufWritePre * %s/\s\+$//e
augroup END


" Plugins
" _________________________________________________________________
call plug#begin(stdpath('config') . '/plugged')
" Language Servers (Some requires to be imported first to avoid errors)
Plug 'fatih/vim-go', {'do': ':GoInstallBinaries'}
Plug 'sheerun/vim-polyglot'
" Plug 'OmniSharp/omnisharp-vim'


" Themes
"Plug 'arcticicestudio/nord-vim'
" onedark
Plug 'joshdick/onedark.vim'
Plug 'gruvbox-community/gruvbox'
Plug 'ambv/black'
Plug 'flazz/vim-colorschemes'
Plug 'chriskempson/base16-vim'

" Status bars
"Plug 'glepnir/galaxyline.nvim' , {'branch': 'main'}
"Plug 'hoob3rt/lualine.nvim'

" Tab bars
Plug 'kyazdani42/nvim-web-devicons'
Plug 'romgrk/barbar.nvim'


" LSP
Plug 'neovim/nvim-lspconfig'
Plug 'nvim-lua/completion-nvim'
Plug 'glepnir/lspsaga.nvim'
Plug 'simrat39/symbols-outline.nvim'
Plug 'rust-lang/rust.vim'
Plug 'darrikonn/vim-gofmt'

" Neovim Tree sitter
Plug 'nvim-treesitter/nvim-treesitter', {'do': 'TSUpdate'}
Plug 'nvim-treesitter/playground'

" Debugger Plugins
Plug 'puremourning/vimspector'
Plug 'szw/vim-maximizer'
Plug 'vim-utils/vim-man'

" Git intergation
Plug 'tpope/vim-fugitive'
Plug 'junegunn/gv.vim'
Plug 'airblade/vim-gitgutter'

" Undo history and makes it easier to browse and switch between different undo branches (almost like git)
Plug 'mbbill/undotree'

" Leverage the power of Vim's compiler plugins without being bound by synchronicity.  Kick off builds and test suites using one of several asynchronous adapters (including tmux, screen, iTerm, Windows, and a headless mode), and when the job completes, errors will be loaded and parsed automatically
Plug 'tpope/vim-dispatch'

" To learn basic VIM movements
Plug 'theprimeagen/vim-be-good'

" Helps Navigating files (Needs configuration, have not started on it)
Plug 'tpope/vim-projectionist'

" telescope requirements...
Plug 'nvim-lua/popup.nvim'
Plug 'nvim-lua/plenary.nvim'
Plug 'nvim-telescope/telescope.nvim'
Plug 'nvim-telescope/telescope-fzy-native.nvim'

" Multip-cursor support
Plug 'terryma/vim-multiple-cursors'

" Prettier (Not yet setup)
Plug 'sbdchd/neoformat'

" Translates x spaces to tab symbols
Plug 'Yggdroot/indentLine'

" Definition previewer - Requires an LSP-server for the given file..
Plug 'rmagatti/goto-preview'
call plug#end()


" PLUGIN CONFIGURATIONS
" ______________________________________________________________________

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


" Debuggers
" ______________________________________________________________________
" let g:vimspector_install_gadgets = [ 'debugpy', 'vscode-cpptools', 'CodeLLDB' ]
" Switch to your python3 path
let g:python3_host_prog = '/usr/bin/python3'
let g:vim_be_good_log_file = 1
let g:vim_apm_log = 1

if executable('rg')
  let g:rg_derive_root='true'
endif


" Language servers and autocompletions and fomatters
" ______________________________________________________________________________
"Auto-complete
"
set completeopt=menuone,noinsert,noselect
let g:completion_matching_strategy_list = ['exact', 'substring', 'fuzzy']

" LSP
" - Install command | server alias:
" npm install -g pyright || gopls
" npm install -g typescript-language-server || tsserver
" npm i -g bash-language-server || bashls
" npm install -g dockerfile-language-server-nodejs || dockerls
" i
" GO111MODULE=on go get golang.org/x/tools/gopls@latest || gopls

"let g:go_bin_path = $HOME."/go/bin"

lua require('lspconfig').tsserver.setup{ on_attach=require'completion'.on_attach }
lua require('lspconfig').pyright.setup{ on_attach=require'completion'.on_attach }
lua require('lspconfig').gopls.setup{ on_attach=require'completion'.on_attach }
lua require('lspconfig').bashls.setup{ on_attach=require'completion'.on_attach }
lua require('lspconfig').dockerls.setup{}


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



" Handle 'hidden' characters
" ______________________________________________________
"
" Display x spaces as tabs.
let g:indentLine_setColors = 1
"let g:indentLine_color_gui = '#CCCCCC'
let g:indentLine_char_list = ['|']



" Tab-bar configurations
nnoremap <silent>    <A-,> :BufferPrevious<CR>
nnoremap <silent>    <A-.> :BufferNext<CR>
" Re-order to previous/next
nnoremap <silent>    <A-<> :BufferMovePrevious<CR>
nnoremap <silent>    <A->> :BufferMoveNext<CR>
" Goto buffer in position...
nnoremap <silent>    <A-1> :BufferGoto 1<CR>
nnoremap <silent>    <A-2> :BufferGoto 2<CR>
nnoremap <silent>    <A-3> :BufferGoto 3<CR>
nnoremap <silent>    <A-4> :BufferGoto 4<CR>
nnoremap <silent>    <A-5> :BufferGoto 5<CR>
nnoremap <silent>    <A-6> :BufferGoto 6<CR>
nnoremap <silent>    <A-7> :BufferGoto 7<CR>
nnoremap <silent>    <A-8> :BufferGoto 8<CR>
nnoremap <silent>    <A-9> :BufferLast<CR>
" Pin/unpin buffer
nnoremap <silent>    <A-p> :BufferPin<CR>
" Close buffer
nnoremap <silent>    <A-c> :BufferClose<CR>
" Wipeout buffer
"                          :BufferWipeout<CR>
" Close commands
"                          :BufferCloseAllButCurrent<CR>
"                          :BufferCloseAllButPinned<CR>
"                          :BufferCloseBuffersLeft<CR>
"                          :BufferCloseBuffersRight<CR>
" Magic buffer-picking mode
nnoremap <silent> <C-s>    :BufferPick<CR>
nnoremap <silent> <leader>bb :BufferOrderByBufferNumber<CR>
nnoremap <silent> <leader>bd :BufferOrderByDirectory<CR>
nnoremap <silent> <leader>bl :BufferOrderByLanguage<CR>
nnoremap <silent> <leader>bw :BufferOrderByWindowNumber<CR>

let bufferline = get(g:, 'bufferline', {})
let bufferline.add_in_buffer_number_order = v:false
let bufferline.animation = v:true
let bufferline.auto_hide = v:false
let bufferline.tabpages = v:true
let bufferline.closable = v:true
let bufferline.clickable = v:true
let bufferline.exclude_ft = ['javascript']
let bufferline.exclude_name = ['package.json']
let bufferline.icons = v:true
let bufferline.icon_custom_colors = v:true
let bufferline.icon_separator_active = '▎'
let bufferline.icon_separator_inactive = '▎'
let bufferline.icon_close_tab = ''
let bufferline.icon_close_tab_modified = '●'
let bufferline.icon_pinned = '車'
let bufferline.insert_at_end = v:false
let bufferline.maximum_padding = 4
let bufferline.maximum_length = 30
let bufferline.semantic_letters = v:true
let bufferline.letters =
  \ 'asdfjkl;ghnmxcvbziowerutyqpASDFJKLGHNMXCVBZIOWERUTYQP'
let bufferline.no_name_title = v:null



" Preview definitions
" -----------------------------------------------------
lua require('goto-preview').setup { width = 120; height = 15; default_mappings = false; debug = false; opacity = nil; post_open_hook = nil; }

nnoremap gpd <cmd>lua require('goto-preview').goto_preview_definition()<CR>
nnoremap gpi <cmd>lua require('goto-preview').goto_preview_implementation()<CR>
nnoremap gpc <cmd>lua require('goto-preview').close_all_win()<CR>
