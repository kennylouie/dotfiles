#!/bin/bash

#optionally you can add pacman/apt-get commands here to also install packages

# this script will create a personal bashrc, zshrc, tmux config, and vimrc for initial amazon ec2 ubuntu server
# personal bashrc configuration
# you can add all your favorite aliases
cat > ~/.usrrc <<EOF
cd() { builtin cd "\$@" && ls -alrt; }
alias tmux="tmux -2"
alias ta="tmux attach -t"
alias tnew="tmux new -s"
alias tls="tmux ls"
alias tkill="tmux kill-session -t"
function tkillall() {
	session=\$(tmux ls | awk '{print \$1}')
	for sessions in \$sessions
	do
		tmux kill-session -t $sessions
	done
}
EOF
echo "source ~/.usrrc" >> ~/.bashrc #either this or bash_profile works
echo "source ~/.usrrc" >> ~/.bash_profile
source ~/.bashrc
source ~/.bash_profile

# zshrc

#creating our zshrc files for within tmux
cat > ~/.zshrc <<EOF
# general #
# 1. enabling 256 color in terminal
export TERM="xterm-256color" 
# 2. sanity check for doing rm *
setopt RM_STAR_WAIT
# 3. spell check
setopt CORRECT
#
# 4. vim as editor
export EDITOR="vim"
export USE_EDITOR=\$EDITOR
export VISUAL=\$EDITOR
#
# 5. ls -al on every cd
function chpwd() {
	ls -alrt
}
#
# completion colors
#
export CLICOLOR=1
export GREP_OPTIONS='--color=auto'
export LSCOLORS=Exbxcxdxexehfhabahacad
#
source ~/.shell_config.k
EOF

# tmux configuration
cat > ~/.tmux.conf <<EOF
## General

set-option -g default-shell /bin/zsh
set -g default-terminal "screen-256color"
set -s escape-time 0
set -sg repeat-time 600
set -s quiet on
set -g mode-keys vi

set -g history-limit 5000

# reload configuration
bind r source-file ~/.tmux.conf \; display 'tmux resourced!'

## display

set -g base-index 1
setw -g pane-base-index 1

setw -g automatic-rename on
set -g renumber-windows on

set -g set-titles on

set -g display-panes-time 800
set -g display-time 1000

# clear history

bind -n C-l send-keys C-l \; run 'sleep 0.05 && tmux clear-history'

# activity

set -g monitor-activity on
set -g visual-activity off

##  navigation

# find session

bind C-f command-prompt -p find-session 'switch-client -t %%'

# pane navigation

bind -r h select-pane -L
bind -r j select-pane -D
bind -r k select-pane -U
bind -r l select-pane -R
bind > swap-pane -D
bind < swap-pane -U

# pane resizing

bind -r H resize-pane -L 2
bind -r J resize-pane -D 2
bind -r K resize-pane -U 2
bind -r L resize-pane -R 2

# window navigation

unbind n
unbind p
bind -r C-h previous-window
bind -r C-l next-window
bind Tab last-window

# split panes

bind | split-window -h
bind - split-window -v

# list choice

bind -t vi-choice h tree-collapse
bind -t vi-choice l tree-expand
run -b 'tmux bind -t vi-choice K start-of-list 2> /dev/null'
run -b 'tmux bind -t vi-choice J end-of-list 2> /dev/null'
bind -t vi-choice H tree-collapse-all
bind -t vi-choice L tree-expand-all
bind -t vi-choice Escape cancel

# edit mode

bind -ct vi-edit H start-of-line
bind -ct vi-edit L end-of-line
bind -ct vi-edit q cancel
bind -ct vi-edit Escape cancel

# copy mode

bind Enter copy-mode
bind b list-buffers
bind p paste-buffer
bind P choose-buffer

bind -t vi-copy v begin-selection
bind -t vi-copy C-v rectangle-toggle
bind -t vi-copy y copy-selection
bind -t vi-copy Escape cancel
bind -t vi-copy H start-of-line
bind -t vi-copy L end-of-line

# status line

set-option -g status-position bottom

set -g status-bg "#212523"
set -g status-fg "#ededed"
set-window-option -g window-status-current-bg "#add2f0"
set-window-option -g window-status-current-fg "#212523"

set-option -g status on
set-option -g status-interval 1

set -g pane-border-fg '#212523'
set -g pane-active-border-fg '#212523'

set-option -g message-fg white
set-option -g message-bg black
set-option -g message-attr bright
set -g status-left " "
set -g status-justify left
setw -g window-status-format         ' #(echo "#{pane_current_command}") '
setw -g window-status-current-format ' #(echo "#{pane_current_command}") '
set -g status-right " "

# reloading sessions

set -g @resurrect-capture-pane-contents 'on'
set -g @resurrect-processes 'ssh'
run-shell ~/clone/path/resurrect.tmux
EOF

# saving tmux states
git clone https://github.com/tmux-plugins/tmux-resurrect ~/clone/path

# vimrc
cat > ~/.vimrc <<EOF
"general
syntax enable

filetype on
filetype indent on
filetype plugin on

colorscheme gruvbox
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

hi vertsplit ctermfg=238 ctermbg=235
hi LineNr ctermfg=237
hi StatusLine ctermfg=235 ctermbg=245
hi StatusLineNC ctermfg=235 ctermbg=237
hi Search ctermbg=58 ctermfg=15
hi Default ctermfg=1
hi clear SignColumn
hi SignColumn ctermbg=235
hi GitGutterAdd ctermbg=235 ctermfg=245
hi GitGutterChange ctermbg=235 ctermfg=245
hi GitGutterDelete ctermbg=235 ctermfg=245
hi GitGutterChangeDelete ctermbg=235 ctermfg=245
hi EndOfBuffer ctermfg=237 ctermbg=235

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

nnoremap <S-L> <S-\$>
nnoremap H 0
vnoremap <S-L> <S-\$>
vnoremap H 0
onoremap <S-L> <S-\$>
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

"netrw

"toggle netrw file explorer
fun! VexToggle(dir)
	if exists("t:vex_buf_nr")
		call VexClose()
	else
		call VexOpen(a:dir)
	endif
endf
fun! VexOpen(dir)
	let g:netrw_browse_split=4
	let vex_width = 25

	execute "Vexplore " . a:dir
	let t:vex_buf_nr = bufnr("%")
	wincmd H

	call VexSize(vex_width)
endf
fun! VexClose()
	let cur_win_nr = winnr()
	let target_nr = ( cur_win_nr == 1 ? winnr("#") : cur_win_nr )

	1wincmd w
	close
	unlet t:vex_buf_nr

	execute (target_nr - 1) . "wincmd w"
	call NormalizeWidths()
endf
fun! VexSize(vex_width)
	execute "vertical resize" . a:vex_width
	set winfixwidth
	call NormalizeWidths()
endf
fun! NormalizeWidths()
	let eadir_pref = &eadirection
	set eadirection=hor
	set equalalways! equalalways!
	let &eadirection = eadir_pref
endf
augroup NetrwGroup
	autocmd! BufEnter * call NormalizeWidths()
augroup END
noremap <Leader>f :call VexToggle(getcwd())<CR>
noremap <Leader>F :call VexToggle("")<CR>

" Change directory to the current buffer when opening files.
let g:netrw_liststyle = 3
let g:netrw_banner = 0
"let g:netrw_winsize = 25
let g:netrw_altv = 1
let g:netrw_list_hide='.*\.swp\$'

"cycling through buffers

nnoremap <C-w>H :bprevious<CR>
nnoremap <C-w>L :bnext<CR>

"cycling through tabs

nnoremap <Leader>H :tabp<CR>
nnoremap <Leader>L :tabn<CR>

"resizing split buffer panes
nnoremap <C-w>+ :res -5<CR>
nnoremap <C-w>_ :res +5<CR>
nnoremap <C-w>< :vertical resize -5<CR>
nnoremap <C-w>> :vertical resize +5<CR>

"buffer listing
nnoremap <Leader>ls :ls<CR>
EOF

# vim colors
git clone https://github.com/morhetz/gruvbox.git ~/.vim #you can add your favorite colours

# vim status config
mkdir ~/.vim/bundle
git clone https://github.com/vim-airline/vim-airline.git ~/.vim/bundle/airline
