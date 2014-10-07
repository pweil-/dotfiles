"  This vimrc use Vundle to manage packages.  To install Vundle use the
"  following steps:
"
"  git clone https://github.com/gmarik/Vundle.vim.git ~/.vim/bundle/Vundle.vim
"
"  Launch vim and run :PluginInstall
"

" ---------------------------- Start Vundle Configuration --------------------
"
set nocompatible              " be iMproved, required
filetype off                  " required

" set the runtime path to include Vundle and initialize
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()
" " alternatively, pass a path where Vundle should install plugins
" "call vundle#begin('~/some/path/here')
"
" let Vundle manage Vundle, required
Plugin 'gmarik/Vundle.vim'

Plugin 'scrooloose/nerdtree'
Plugin 'scrooloose/syntastic'
Plugin 'kien/ctrlp.vim'
Bundle 'Lokaltog/vim-powerline'
Plugin 'fatih/vim-go'
Plugin 'airblade/vim-gitgutter'
Plugin "Shougo/neocomplcache"

" All of your Plugins must be added before the following line
call vundle#end()            " required
filetype plugin indent on    " required
" ---------------------------- End Vundle Configuration --------------------


set nu
syntax on

set background=dark
let g:solarized_termcolors=16
set t_Co=16
color solarized


" Enable filetype plugins and disable vi compatibility
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
set mouse=a

" Show match for partly typed search command
set incsearch

" Split to the right or below
set splitright
set splitbelow

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

" Set tabstop end expad tabs to spaces
set tabstop=4
set shiftwidth=4

set expandtab

" Hide tabline
" set showtabline=0

if version > 703
   " Enable color line to prevent long lines
   set colorcolumn=121

   " Enable undo history between sessions
   set undofile
   set undodir=~/.vim/undodir
   set undolevels=1000
   set undoreload=10000
endif

" Show incomplete command on footer
set showcmd

" For normal navigation on breaked lines
nnoremap j gj
nnoremap k gk

" Custom whitespaces and tabs view
set list
" set listchars=trail:·,tab:··

" Set leader button
let mapleader = ","


" Turn off auto working path feature (CtrlP)
let g:ctrlp_working_path_mode = ''


" Added from the OpenShift vimrc
"flag problematic whitespace (trailing and spaces before tabs)
""Note you get the same by doing let c_space_errors=1 but
"this rule really applies to everything.

"highlight RedundantSpaces term=standout ctermbg=red guibg=red
"match RedundantSpaces /\s\+$\| \+\ze\t/ "\ze sets end of match so only spaces highlighted
"set listchars=tab:>-,trail:.,extends:>

" End Added from the OpenShift vimrc
