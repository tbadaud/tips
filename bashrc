#!/bin/bash

# If not running interactively, don't do anything
[ -z "$PS1" ] && return

PS1="b@\W> "

ulimit -c unlimited #coredump

# don't put duplicate lines in the history. See bash(1) for more options
# don't overwrite GNU Midnight Commander's setting of `ignorespace'.
HISTCONTROL=$HISTCONTROL${HISTCONTROL+:}ignoredups
# ... or force ignoredups and ignorespace
HISTCONTROL=ignoreboth
# append to the history file, don't overwrite it
shopt -s histappend

shopt -s checkwinsize

shopt -s cdspell                # autocorrects cd misspellings
shopt -s nocaseglob             # pathname expansion will be treated
                                # as case-insensitive
#set completion-ignore-case on

if [ -f /etc/bash_completion ] && ! shopt -oq posix; then
    . /etc/bash_completion
fi

export EDITOR='emacs'
export PAGER='less'

alias reload='. ~/.bashrc'

alias ne='emacs'
alias grep='grep --color=auto'
alias ls='ls --color=auto'
alias ll='ls -lh'
alias la='ls -A'
alias df='df -h'

# Bash Color
txtblk='\033[0;30m' # Black - Regular
txtred='\033[0;31m' # Red
txtgrn='\033[0;32m' # Green
txtylw='\033[0;33m' # Yellow
txtblu='\033[0;34m' # Blue
txtpur='\033[0;35m' # Purple
txtcyn='\033[0;36m' # Cyan
txtwht='\033[0;37m' # White
bldblk='\033[1;30m' # Black - Bold
bldred='\033[1;31m' # Red
bldgrn='\033[1;32m' # Green
bldylw='\033[1;33m' # Yellow
bldblu='\033[1;34m' # Blue
bldpur='\033[1;35m' # Purple
bldcyn='\033[1;36m' # Cyan
bldwht='\033[1;37m' # White
unkblk='\033[4;30m' # Black - Underline
undred='\033[4;31m' # Red
undgrn='\033[4;32m' # Green
undylw='\033[4;33m' # Yellow
undblu='\033[4;34m' # Blue
undpur='\033[4;35m' # Purple
undcyn='\033[4;36m' # Cyan
undwht='\033[4;37m' # White
bakblk='\033[40m'   # Black - Background
bakred='\033[41m'   # Red
badgrn='\033[42m'   # Green
bakylw='\033[43m'   # Yellow
bakblu='\033[44m'   # Blue
bakpur='\033[45m'   # Purple
bakcyn='\033[46m'   # Cyan
bakwht='\033[47m'   # White
txtrst='\033[0m'    # Text Reset

clean() {
    SEARCH='.'
    if [ $# -gt 0 ]; then
	SEARCH="$1"
    fi
    find ${SEARCH} -maxdepth 1 \( -name "*~" -or -name ".*~" -or -name "*\#" -or -name "*.core" \) -exec rm -fv {} \;
}
fclean() {
    SEARCH='.'
    if [ $# -gt 0 ]; then
	SEARCH="$1"
    fi
    find ${SEARCH} \( -name "*~" -or -name ".*~" -or -name "*\#" -or -name "*.core" \) -exec rm -fv {} \;
}
