#!/bin/bash

## This is shell script that will add my flavour of tmux and vim config.
## This script is meant as a template for your own customizations.

## Take in a username for naming of dotfiles.
read -p "Please type in a username: " username
read -p "Your username is $username. Is this correct? [Type YES in uppercase] " confirmation

if [ "$confirmation" != "YES" ]
then
	exit 1
fi

## The following will be made into a config file. This is where you can add your own configurations.
cat > .$username <<EOF
## This is $username's bashrc configuration

## cd will print out all files in directory
cd() { builtin cd \$@ && ls -alrt; }

## tmux aliases
alias tmux="tmux -2"
alias ta="tmux attach -t"
alias tnew="tmux new -s"
alias tls="tmux ls"
alias tkill="tmux kill-session -t"
function tkillall() {
	sessions=\$(tmux ls | awk '{print \$1}')
	for session in \$sessions
	do
		tmux kill-session -t \$sessions
	done
}

## Other configurations, e.g. git commands
EOF
echo -e ".$username created."

## tmux configuration
cat > .tmux.conf <<EOF
## This is .$username's tmux configuration file.

## General
set -g default-terminal "screen-256color"
set -s escape-time 0
set -sg repeat-time 600
set -s quiet on

set -g history-limit 5000

## reload configuration
bind r source-file $HOME/.tmux.conf \; display 'tmux resourced!'

## display
set -g base-index 1
setw -g pane-base-index 1

setw -g automatic-rename on
set -g renumber-windows on

set -g set-titles on

set -g display-panes-time 800
set -g display-time 1000

## clear history
bind -n C-l send-keys C-l \; run 'sleep 0.05 && tmux clear-history'

## activity
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

## window navigation
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

## status line
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

## reloading sessions
set -g @resurrect-capture-pane-contents 'on'
set -g @resurrect-processes 'ssh'

## reloading vim session
set -g @ressurect-strategy-vim 'session'

##
run-shell $HOME/$username.tmux.ressurect/resurrect.tmux
EOF
echo -e ".tmux.conf created."

## saving tmux states using tmux-ressurection
## check if the folder already exists
if [ -d "$username.tmux.ressurect" ]
then
  echo -e "$username.tmux.ressurection already exists. Will not be overwritten.\nYou may reclone the repo by checking out tmux-ressurect"
else
	git clone https://github.com/tmux-plugins/tmux-resurrect $username.tmux.ressurect
fi

## vimrc
cat > .vimrc <<EOF
"This is $username's vim config file.

"general
syntax enable
filetype on
filetype indent on
filetype plugin on
set smartindent
set omnifunc=syntaxcomplete#Complete
set background=dark
set encoding=utf8
set number
set ruler
set noautowrite
set nocompatible
set viminfo='0,:0,<0,@0,f0,/0
set backspace=indent,eol,start
set pastetoggle=<C-B>
set noswapfile
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
"hi EndOfBuffer ctermfg=237 ctermbg=235

"bracket and quotes completion
inoremap {      {}<Left>
inoremap {<CR>  {<CR>}<Esc>O
inoremap <expr> }  strpart(getline('.'), col('.')-1, 1) == "}" ? "\<Right>" : "}"
 
inoremap        (  ()<Left>
inoremap (<CR>  (<CR>)<Esc>O
inoremap <expr> )  strpart(getline('.'), col('.')-1, 1) == ")" ? "\<Right>" : ")"
 
inoremap        [  []<Left>
inoremap [<CR>  [<CR>]<Esc>O
inoremap <expr> ]  strpart(getline('.'), col('.')-1, 1) == "]" ? "\<Right>" : "]"
 
inoremap <expr> ' strpart(getline('.'), col('.')-1, 1) == "\'" ? "\<Right>" : "\'\'\<Left>"
inoremap <expr> " strpart(getline('.'), col('.')-1, 1) == "\"" ? "\<Right>" : "\"\"\<Left>"

"automatic wrap around highlighted text
xnoremap <leader>( xi()<Esc>P
xnoremap <leader>" xi""<Esc>P
xnoremap <leader>' xi''<Esc>P
xnoremap <leader>[ xi[]<Esc>P
xnoremap <leader>{ xi{}<Esc>P

"autcompletion
set omnifunc=syntaxcomplete#Complete
set completeopt=longest,menuone
:inoremap <expr> <CR> pumvisible() ? "\<C-y>" : "\<C-g>u\<CR>"
inoremap <expr> <C-n> pumvisible() ? '<C-n>' :
  \ '<C-n><C-r>=pumvisible() ? "\<lt>Down>" : ""<CR>'
inoremap <expr> <M-,> pumvisible() ? '<C-n>' :
  \ '<C-x><C-o><C-n><C-p><C-r>=pumvisible() ? "\<lt>Down>" : ""<CR>'
" open omni completion menu closing previous if open and opening new menu without changing the text
inoremap <expr> <C-Space> (pumvisible() ? (col('.') > 1 ? '<Esc>i<Right>' : '<Esc>i') : '') .
            \ '<C-x><C-o><C-r>=pumvisible() ? "\<lt>C-n>\<lt>C-p>\<lt>Down>" : ""<CR>'
" open user completion menu closing previous if open and opening new menu without changing the text
inoremap <expr> <S-Space> (pumvisible() ? (col('.') > 1 ? '<Esc>i<Right>' : '<Esc>i') : '') .
            \ '<C-x><C-u><C-r>=pumvisible() ? "\<lt>C-n>\<lt>C-p>\<lt>Down>" : ""<CR>'

"spacing
set smarttab
set shiftwidth=2
set tabstop=2
set expandtab
set wrap

"search
set incsearch
set smartcase
set ignorecase
set showmatch
nnoremap <Leader>3 :set hlsearch!<CR>

"nav shortkeys
nnoremap H 0
vnoremap H 0
onoremap H 0
nnoremap L \$
vnoremap L \$
onoremap L \$
nnoremap \$ L
vnoremap \$ L
onoremap \$ L

"making tab escape
nnoremap <Tab> <Esc>
vnoremap <Tab> <Esc>gV
onoremap <Tab> <Esc>
inoremap <Tab> <Esc>\`^
inoremap <Leader><Tab> <Tab>

"netrw
inoremap <Leader>f :Vexplore<CR>
nnoremap <Leader>f :Vexplore<CR>
vnoremap <Leader>f :Vexplore<CR>
onoremap <Leader>f :Vexplore<CR>
let g:netrw_liststyle=3
let g:netrw_banner=0
let g:netrw_altv=1
let g:netrw_browse_split = 4
let g:netrw_winsize = 25

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
nnoremap <C-w>a :ls<CR>

"buffer deletion
nnoremap <C-w>q :bd<CR>
EOF
echo -e ".vimrc created.\n"

## Closing with sourcing the new .$username file into bashrc
read -p "Would you like to add the .$username file to your .bashrc file? [Type YES in uppercase] " addToBashrcResponse

if [ "$addToBashrcResponse" == "YES" ]
then
	echo "source .$username" >> $HOME/.bashrc 
	source $HOME/.bashrc
else
	echo -e "To make this file work, you will need to source the .$username file in your bashrc\nby adding source .$username to the end of your .bashrc file"
fi

echo -e "Finished. Please move all the config files and .$username.tmux.ressurect folder to your home directory."
