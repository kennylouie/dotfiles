"general
syntax enable
filetype on
filetype indent on
filetype plugin on
set background=dark
set encoding=utf8
set number
set ruler
set noautowrite
set noswapfile
set nowb
set nobackup
set nocompatible
set viminfo='0,:0,<0,@0,f0,/0
set backspace=indent,eol,start

"spacing
set smarttab
set shiftwidth=4
set tabstop=4
set ai
set si
set wrap

"search
set incsearch
set smartcase
set ignorecase
set showmatch
nnoremap <Leader>3 :set hlsearch!<CR>

"nav shortkeys
nnoremap <S-L> <S-$>
nnoremap H 0
vnoremap <S-L> <S-$>
vnoremap H 0
onoremap <S-L> <S-$>
onoremap H 0

"making tab escape
nnoremap <Tab> <Esc>
vnoremap <Tab> <Esc>gV
onoremap <Tab> <Esc>
inoremap <Tab> <Esc>\`^
inoremap <Leader><Tab> <Tab>

"plugins
set runtimepath^=~/.vim/bundle/airline

"airline
let g:airline#extensions#tabline#enabled = 1

"buffers
set hidden

"creating new empty buffer
nnoremap <Leader>T :enew<CR>

"cycling through buffers
nnoremap <Leader>H :bprevious<CR>
nnoremap <Leader>L :bnext<CR>

"Close current buffer and move to the previous one
nnoremap <Leader>bq :bp <BAR> bd #<CR>

"resizing split buffer panes
nnoremap <C-w>+ :res -5<CR>
nnoremap <C-w>_ :res +5<CR>
nnoremap <C-w>< :vertical resize -5<CR>
nnoremap <C-w>> :vertical resize +5<CR>

"buffer listing
nnoremap <Leader>ls :ls<CR>

"netrw
let g:netrw_banner = 0
let g:netrw_liststyle = 3
let g:netrw_browse_split = 4
let g:netrw_altv = 1
let g:netrw_winsize = 25
augroup ProjectDrawer
	  autocmd!
	    autocmd VimEnter * :Vexplore
	augroup END
