#HISTCONTROL=erasedups

## Lets set some options
## http://zsh.sourceforge.net/Doc/Release/Options.html
setopt AUTO_CD
setopt EXTENDED_GLOB
unsetopt CASE_GLOB

setopt APPEND_HISTORY
setopt HIST_IGNORE_DUPS
HISTFILE=~/.histfile
HISTSIZE=1000
SAVEHIST=1000

bindkey -e
bindkey '\e[3~' delete-char

# The following lines were added by compinstall
zstyle :compinstall filename $HOME'/.zshrc'
autoload -Uz compinit
compinit
# End of lines added by compinstall

zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}'
#zstyle ':completion:*:killall:*' command 'ps -u $USER -o cmd'

fg_black=%{$'\e[0;30m'%}
fg_red=%{$'\e[0;31m'%}
fg_green=%{$'\e[0;32m'%}
fg_brown=%{$'\e[0;33m'%}
fg_blue=%{$'\e[0;34m'%}
fg_purple=%{$'\e[0;35m'%}
fg_cyan=%{$'\e[0;36m'%}
fg_lgray=%{$'\e[0;37m'%}
fg_dgray=%{$'\e[1;30m'%}
fg_lred=%{$'\e[1;31m'%}
fg_lgreen=%{$'\e[1;32m'%}
fg_yellow=%{$'\e[1;33m'%}
fg_lblue=%{$'\e[1;34m'%}
fg_pink=%{$'\e[1;35m'%}
fg_lcyan=%{$'\e[1;36m'%}
fg_white=%{$'\e[1;37m'%}
PROMPT="${fg_green}%n@%m ${fg_yellow}%d> ${fg_white}
$ "

alias grep='grep --color=auto'
alias ls='ls --color=auto'
alias ll='ls -lh'
alias la='ls -A'
alias reload='source ~/.zshrc'

alias ocaml='rlwrap ocaml'
alias npp='/cygdrive/c/Program\ Files\ \(x86\)/Notepad++/notepad++.exe'
#alias django-admin='/cygdrive/c/Python27/Lib/site-packages/django/bin/django-admin.py'

export EDITOR='emacs'
export PAGER='less'

if [ `ps a | grep emacs | grep -v grep | wc -l` -lt 1 ]; then
	emacs --daemon
fi
alias ne='emacsclient -t'

clean() {
    if [ $# -eq 1 ]; then SEARCH="$1"; else SEARCH="."; fi
    command find ${SEARCH} -maxdepth 1 \( -name '*~' -or -name '#*#' -or -name '.#*' \) -exec rm -fv {} \;
}

fclean() {
    if (( $# == 1 )) then SEARCH="$1"; else SEARCH="."; fi
    command find ${SEARCH} \( -name '*~' -or -name '#*#'  -or -name '.#*' \) -exec rm -fv {} \;
}
