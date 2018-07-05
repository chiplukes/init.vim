" Windows stuff
if (has('win32') || has('win64'))

  let g:python3_host_prog='C:/Python36/python.exe'
  let g:python_host_prog='C:/Python27/python.exe'

  set nocompatible
  " source $VIMRUNTIME/vimrc_example.vim " fixme remove?
  source $VIMRUNTIME/mswin.vim
  behave mswin

  " Adjustments to $PATH:
  " Path to Batch tools folder
  let s:toolsbin = expand('~/.config/tools')
  " Add tools path to $PATH if running on Windows and tools exists
  if isdirectory(s:toolsbin)
	  let $PATH .= ';' . s:toolsbin
  endif

  " Path to MinGW
  let s:mingwbin =  'C:\tools\msys64\mingw64\bin'
  " Add Mingw's path to $PATH if running on Windows and Mingw exists
  if isdirectory(s:mingwbin)
	  let $PATH .= ';' . s:mingwbin
  endif

  " Path to Msys
  let s:msysbin =  'C:\tools\msys64\usr\bin'
  " Add Msys path to $PATH if running on Windows and Msys exists
  if isdirectory(s:msysbin)
	  let $PATH .= ';' . s:msysbin
  endif

endif


" plugins

call plug#begin()

Plug 'easymotion/vim-easymotion'
Plug 'tpope/vim-commentary'
Plug 'tpope/vim-surround'
Plug 'itchyny/lightline.vim'

Plug 'Shougo/deoplete.nvim', { 'do': ':UpdateRemotePlugins' }

"" color

Plug 'cocopon/iceberg.vim'

call plug#end()


" pure vim

augroup Rc
	autocmd!
augroup END

set autoread
set nobackup
set nolazyredraw
set nowritebackup
set swapfile
set tildeop
set ttyfast
set visualbell
set wildmenu
set wildmode=full
filetype plugin indent on
autocmd Rc BufWinEnter * set mouse=

"" space setting

set autoindent
set list
set shiftround
set shiftwidth=2
set smartindent
set smarttab
set tabstop=4

"" appearance

syntax on
set backspace=indent,eol,start
set colorcolumn=80
set completeopt=menu
set cursorline
set hlsearch
set inccommand=nosplit
set incsearch
set number
set relativenumber
set shortmess=a
set showcmd
set showmatch
set showmode
set splitbelow
set splitright
set wrap
"" autocmd Rc BufEnter * EnableStripWhitespaceOnSave

"" keymaps

let g:mapleader = "\<space>"

nnoremap <expr> j v:count ? 'j' : 'gj'
nnoremap <expr> k v:count ? 'k' : 'gk'
nnoremap gj j
nnoremap gk k
nnoremap <esc><esc> :nohlsearch<cr>
nnoremap Y y$


" plugin settings

"" deoplete

let g:deoplete#enable_at_startup = 1
let g:deoplete#auto_complete_start_length = 1
inoremap <expr><tab> pumvisible() ? "\<c-n>" : "\<tab>"
inoremap <expr><s-tab> pumvisible() ? "\<c-p>" : "\<s-tab>"


"" lightline

let g:lightline = { 'colorscheme': 'iceberg' }


"" colorscheme

colorscheme iceberg

highlight Normal      ctermbg=none
highlight NonText     ctermbg=none
highlight EndOfBuffer ctermbg=none
highlight VertSplit   cterm=none ctermfg=240 ctermbg=240
