set nu
syntax on
set background=dark
color solarized

" Enable filetype plugins and disable vi compatibility
set nocompatible
filetype on
filetype plugin on

" Dash isn't word separator
set iskeyword+=-

" Automatically reload changes if detected
set autoread

" Show info in the window title
set title

" Number of screen lines to show around the cursor
set scrolloff=3

" Keep long history
set history=1000

" By default disable hlsearch
set nohlsearch

" Use manual foldmethod
set foldmethod=manual

" Disable swap files
set noswapfile

" Disable beackup files
set nobackup

" Hide mouse while typing
set mousehide

" Show match for partly typed search command
set incsearch

" Ignore case when using a search pattern
set ignorecase

" Smartcase for search queries
set smartcase

" Enable ruler on bottom-right corner
set ruler

" Enable indention
set autoindent
set copyindent
set smartindent

" Enable color line to prevent long lines
set colorcolumn=121

" Set tabstop end expad tabs to spaces
set tabstop=4
set shiftwidth=4

" Hide tabline
" set showtabline=0

" Enable undo history between sessions
set undofile
set undodir=~/.vim/undodir
set undolevels=1000
set undoreload=10000

" Show incomplete command on footer
set showcmd

" For normal navigation on breaked lines
nnoremap j gj
nnoremap k gk

" Custom whitespaces and tabs view
" set list
" set listchars=trail:·,tab:··

" Set leader button
let mapleader = ","

" Set 256 color terminal
set t_Co=256
