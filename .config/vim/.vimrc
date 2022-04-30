set nocompatible              " be iMproved, required

let mapleader = " "
nnoremap ; :

filetype plugin indent on
set tabstop=4
set shiftwidth=4
set expandtab

set colorcolumn=80,120

set noswapfile
set wildmode=longest,list,full
set wildmenu

set wildignore+=*.pyc
set wildignore+=*._build/
set wildignore+=*/coverage/
set wildignore+=*/node_modules/
set wildignore+=*/.git/

set number relativenumber
set nuw=6

set cursorline
set showmatch

"set list
"set listchars=trail:~

" set the runtime path to include Vundle and initialize
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()
" alternatively, pass a path where Vundle should install plugins
"call vundle#begin('~/some/path/here')

" let Vundle manage Vundle, required
Plugin 'VundleVim/Vundle.vim'
" The following are examples of different formats supported.
" Keep Plugin commands between vundle#begin/end.
" plugin on GitHub repo
Plugin 'tpope/vim-fugitive'
" plugin from http://vim-scripts.org/vim/scripts.html
" Plugin 'L9'
" Git plugin not hosted on GitHub
Plugin 'git://git.wincent.com/command-t.git'
" The sparkup vim script is in a subdirectory of this repo called vim.
" Pass the path to set the runtimepath properly.
Plugin 'rstacruz/sparkup', {'rtp': 'vim/'}
Plugin 'sonph/onehalf', { 'rtp': 'vim' }
Plugin 'morhetz/gruvbox'
" Install L9 and avoid a Naming conflict if you've already installed a
" different version somewhere else.
" Plugin 'ascenator/L9', {'name': 'newL9'}
Plugin 'valloric/youcompleteme'

Plugin 'prettier/vim-prettier', { 'do': 'npm install --frozen-lockfile --production', 'for': ['javascript', 'typescript'] }
Plugin 'Lokaltog/powerline', {'rtp': 'powerline/bindings/vim/'}
Plugin 'kien/ctrlp.vim'
Plugin 'fatih/vim-go'
Plugin 'python-mode/python-mode'
Plugin 'iamcco/markdown-preview.nvim'

" All of your Plugins must be added before the following line
call vundle#end()            " required

" To ignore plugin indent changes, instead use:
"filetype plugin on
"
" Brief help
" :PluginList       - lists configured plugins
" :PluginInstall    - installs plugins; append `!` to update or just :PluginUpdate
" :PluginSearch foo - searches for foo; append `!` to refresh local cache
" :PluginClean      - confirms removal of unused plugins; append `!` to auto-approve removal
"
" see :h vundle for more details or wiki for FAQ
" Put your non-Plugin stuff after this line

set laststatus=2
"
"

syntax on
set t_Co=256
set cursorline
colorscheme gruvbox
set termguicolors
set background=dark

set guifont=DejaVu\ Sans\ Mono\ for\ Powerline\ 8
"set guifont=Fira\ Code\ 8

"colorscheme onehalfdark
"let g:airline_theme='onehalfdark'
"let g:lightline = { 'colorscheme': 'onehalfdark' }

let g:prettier#autoformat = 1
let g:prettier#autoformat_require_pragma = 0

let g:pymode_python = 'python3'
let g:pymode_syntax = 1
let g:pymode_syntax_all = 1
let g:pymode_options = 1
let g:pymode_options_max_line_length = 100

let g:mkdp_auto_start = 1
let g:mkdp_auto_close = 1

let g:ctrlp_custom_ignore = 'node_modules\|DS_Store\|git'

" Custom commands
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

let s:clip = '/mnt/c/Windows/System32/clip.exe'
if executable(s:clip)
    augroup WSLYank
        autocmd!
        autocmd TextYankPost * if v:event.operator ==# 'y' | call system('cat |' . s:clip, @0) | endif
    augroup END
endif

" Auto formats XML and JSON files
com! FormatXML %!python3 -c "import xml.dom.minidom as xmld, sys; dom = xmld.parse(sys.stdin); lines = dom.toprettyxml(); print('\n'.join([s for s in lines.splitlines() if s.strip()]))"
com! FormatJSON %!python3 -c "import json, sys, collections; print(json.dumps(json.load(sys.stdin, object_pairs_hook=collections.OrderedDict), indent=4))"

"autocmd FileType json autocmd BufWritePre <buffer> :FormatJSON
"autocmd FileType xml autocmd BufWritePre <buffer> :FormatXML
