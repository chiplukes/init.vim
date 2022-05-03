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

else
  " Assume some flavor of Linux
  " check if termux
  if isdirectory('/data/data/com.termux')
  	" made a virtual environment per :help provider-python
  	let g:python3_host_prog=expand('/data/data/com.termux/files/usr/bin/python')
  else
   	" made a virtual environment per :help provider-python
  	let g:python3_host_prog=expand('~/.pyenv/versions/py3neovim/bin/python')
  endif

endif


" plugins

call plug#begin()
Plug 'easymotion/vim-easymotion'
Plug 'tpope/vim-commentary'
Plug 'tpope/vim-surround'
Plug 'itchyny/lightline.vim'
Plug 'junegunn/vim-easy-align'
Plug 'scrooloose/nerdtree', { 'on':  'NERDTreeToggle' }
Plug 'mhinz/vim-signify'
Plug 'davidhalter/jedi-vim', { 'for':  'python' }
Plug 'cocopon/iceberg.vim'
Plug 'w0rp/ale'
Plug 'lifepillar/vim-cheat40'
if has('nvim')
  Plug 'Shougo/deoplete.nvim', { 'do': ':UpdateRemotePlugins' }
else
  Plug 'Shougo/deoplete.nvim'
  Plug 'roxma/nvim-yarp'
  Plug 'roxma/vim-hug-neovim-rpc'
endif
let g:deoplete#enable_at_startup = 1
let g:deoplete#_python_version_check = 1

" Linux only stuff
if !(has('win32') || has('win64'))
  " FZF already installed manually, could also use vim-plug to install
  Plug '~/.fzf'
  Plug 'lambdalisue/vim-pyenv'
endif

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
set clipboard=unnamedplus

"" space setting
" ---------
set expandtab       " expand tabs to spaces.
set tabstop=4       " The number of spaces a tab is
set softtabstop=4   " While performing editing operations
set shiftwidth=4    " Number of spaces to use in auto(indent)
set smarttab        " Tab insert blanks according to 'shiftwidth'
set autoindent      " Use same indenting on new lines
set smartindent     " Smart autoindenting on new lines
set shiftround      " Round indent to multiple of 'shiftwidth'

"" Searching
" ---------
set ignorecase      " Search ignoring case
set smartcase       " Keep case when searching with *
set infercase       " Adjust case in insert completion mode
set incsearch       " Incremental search
set hlsearch        " Highlight search results
set wrapscan        " Searches wrap around the end of the file
set showmatch       " Jump to matching bracket
set matchpairs+=<:> " Add HTML brackets to pair matching
set matchtime=1     " Tenths of a second to show the matching paren
set cpoptions-=m    " showmatch will wait 0.5s or until a char is typed
set grepprg=ag

"" appearance
" ---------
syntax on
set backspace=indent,eol,start
set colorcolumn=80      " Highlight the 80th character limit
set completeopt=menu
set cursorline
set inccommand=nosplit
set number              " Show line numbers
set relativenumber
"set shortmess=a
set showcmd
set showmode
set list                " Show hidden characters
set splitbelow
set splitright
set wrap



augroup MyAutoCmd " {{{

	"" autocmd Rc BufEnter * EnableStripWhitespaceOnSave

	" Highlight current line only on focused window
	autocmd WinEnter,InsertLeave * set cursorline
	autocmd WinLeave,InsertEnter * set nocursorline

	" Automatically set read-only for files being edited elsewhere
	autocmd SwapExists * nested let v:swapchoice = 'o'

	" Update filetype on save if empty
	autocmd BufWritePost * nested
		\ if &l:filetype ==# '' || exists('b:ftdetect')
		\ |   unlet! b:ftdetect
		\ |   filetype detect
		\ | endif

	" When editing a file, always jump to the last known cursor position.
	" Don't do it when the position is invalid or when inside an event handler
	autocmd BufReadPost *
		\ if &ft !~ '^git\c' && ! &diff && line("'\"") > 0 && line("'\"") <= line("$")
		\|   execute 'normal! g`"zvzz'
		\| endif

augroup END " }}}



"" keymaps
" ---------

" Toggle fold
nnoremap <CR> za

" Focus the current fold by closing all others
nnoremap <z-Return> zMza

" Improve scroll, credits: https://github.com/Shougo
nnoremap <expr> zz (winline() == (winheight(0)+1) / 2) ?
	\ 'zt' : (winline() == 1) ? 'zb' : 'zz'
noremap <expr> <C-f> max([winheight(0) - 2, 1])
	\ ."\<C-d>".(line('w$') >= line('$') ? "L" : "M")
noremap <expr> <C-b> max([winheight(0) - 2, 1])
	\ ."\<C-u>".(line('w0') <= 1 ? "H" : "M")
noremap <expr> <C-e> (line("w$") >= line('$') ? "j" : "3\<C-e>")
noremap <expr> <C-y> (line("w0") <= 1         ? "k" : "3\<C-y>")

" Use tab for indenting in visual mode
vnoremap <Tab> >gv|
vnoremap <S-Tab> <gv
nnoremap > >>_
nnoremap < <<_

" When pressing <leader>cd switch to the directory of the open buffer
map <Leader>cd :lcd %:p:h<CR>:pwd<CR>

let g:mapleader = "\<space>"

nnoremap <expr> j v:count ? 'j' : 'gj'
nnoremap <expr> k v:count ? 'k' : 'gk'
nnoremap gj j
nnoremap gk k
nnoremap <esc><esc> :nohlsearch<cr>
nnoremap Y y$

" handle the following a little different in Windows GUI
if (has('win32') || has('win64'))
		nmap <leader>1 :set lines=100 columns=180<CR><C-w>o
		nmap <leader>2 :set lines=100 columns=360<CR><C-w>v <C-w>=
else
		map <leader>1 <c-w>o
		map <leader>2 <c-w>v <C-w>=
endif

" bind Ctrl+<movement> keys to move around the windows, instead of using Ctrl+w + <movement>
" Every unnecessary keystroke that can be saved is good for your health :)
map <c-j> <c-w>j
map <c-k> <c-w>k
map <c-l> <c-w>l
map <c-h> <c-w>h

" Manage buffers like tabs
" Th" Manage buffers like tabs
" This allows buffers to be hidden if you've modified a buffer.
" This is almost a must if you wish to use buffers in this way.

" This allows buffers to be hidden if you've modified a buffer.
" This is almost a must if you wish to use buffers in this way.
set hidden
" https://joshldavis.com/2014/04/05/vim-tab-madness-buffers-vs-tabs/
" To open a new empty buffer
" This replaces :tabnew which I used to bind to this mapping
nmap <leader>T :enew<cr>

" Move to the next buffer
nmap <leader>l :bnext<CR>

" Move to the previous buffer
nmap <leader>h :bprevious<CR>

" Close the current buffer and move to the previous one
" This replicates the idea of closing a tab
nmap <leader>bq :bp <BAR> bd #<CR>

" Show all open buffers and their status
nmap <leader>bl :ls<CR>


" Totally Custom
" --------------

" Run Vivado Tcl script
" http://vim.wikia.com/wiki/Execute_external_programs_asynchronously_under_Windows
":nnoremap <Leader>v :!vivado -mode batch -source %:p

" Run Picoblaze build batch file
"function PythonThis()
"    :w
"    :python3 import vim
"    :python3 import sys
"    :python3 b = vim.current.buffer
"    :python3 sys.argv = [b.name]
"    :py3file $HOME\.config\nvim\tools\python_this.py
"endfunction
":nnoremap <Leader>pb :exec PythonThis()

" Trim whitespace, retab, and set file type to Dos
function CleanUp()
    :e ++ff=dos
    :w
    let l:save_cursor = getpos('.')
    %s/\s\+$//e
    call setpos('.', l:save_cursor)
    :retab
endfunction
command! CleanUp call CleanUp()

" ignore whitespace with vim diff
set diffopt+=iwhite
set diffexpr=DiffW()
function DiffW()
  let opt = ""
   if &diffopt =~ "icase"
     let opt = opt . "-i "
   endif
   if &diffopt =~ "iwhite"
     let opt = opt . "-w " " swapped vim's -b with -w
   endif
   silent execute "!diff -a --binary " . opt .
     \ v:fname_in . " " . v:fname_new .  " > " . v:fname_out
endfunction


" --------------
" plugin settings
" --------------

" Jedi-Vim
let g:jedi#popup_on_dot = 0
let g:jedi#popup_select_first = 0
let g:jedi#completions_enabled = 0
let g:jedi#auto_vim_configuration = 0
let g:jedi#show_call_signatures = 0
if has('python3')
    let g:jedi#force_py_version = 3
endif

"" tree view
nnoremap <F2> :NERDTreeToggle<CR>
nnoremap ;aF   :NERDTreeFind<CR

"" easymotion
nmap s <Plug>(easymotion-s2)

"" deoplete
let g:deoplete#auto_complete_start_length = 1
inoremap <expr><tab> pumvisible() ? "\<c-n>" : "\<tab>"
inoremap <expr><s-tab> pumvisible() ? "\<c-p>" : "\<s-tab>"

" EasyAlign
" Start interactive EasyAlign in visual mode (e.g. vipga)
xmap ga <Plug>(EasyAlign)
" Start interactive EasyAlign for a motion/text object (e.g. gaip)
nmap ga <Plug>(EasyAlign)

"" lightline
let g:lightline = { 'colorscheme': 'iceberg' }


"" vim-cheat40
let g:cheat40_use_default = 1

"" colorscheme
colorscheme jellybeans

highlight Normal      ctermbg=none
highlight NonText     ctermbg=none
highlight EndOfBuffer ctermbg=none
highlight VertSplit   cterm=none ctermfg=240 ctermbg=240



"" fix for neovim bug where buffers don't show up
if @% == ""
  bd
endif
