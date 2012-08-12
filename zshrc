# -*- mode: sh -*-
# Path to your oh-my-zsh configuration.
ZSHDIR=$HOME/.zsh
source $ZSHDIR/antigen.zsh

antigen-bundle zsh-users/zsh-syntax-highlighting

antigen-apply

# Path to your oh-my-zsh configuration.
ZSH=$HOME/.oh-my-zsh

# Debian doesn't seem to have a TMPDIR variable any more :(
[ -z "$TMPDIR" ] && TMPDIR=/tmp/

# Set up the prompt
if [[ $TERM == "dumb" ]]; then	# in emacs
    PS1='%(?..[%?])%!:%~%# '
    # for tramp to not hang, need the following. cf:
    # http://www.emacswiki.org/emacs/TrampMode
    unsetopt zle
    unsetopt prompt_cr
    unsetopt prompt_subst
    unfunction precmd
    unfunction preexec
else
    ZSH_THEME="dstufft"
fi
# Set name of the theme to load.
# Look in ~/.oh-my-zsh/themes/
# Optionally, if you set this to "random", it'll load a random theme each
# time that oh-my-zsh is loaded.


# Example aliases
alias zshconfig="source ~/.zshrc"
# alias ohmyzsh="mate ~/.oh-my-zsh"

# Set to this to use case-sensitive completion
# CASE_SENSITIVE="true"

# Comment this out to disable weekly auto-update checks
# DISABLE_AUTO_UPDATE="true"

# Uncomment following line if you want to disable colors in ls
# DISABLE_LS_COLORS="true"

# Uncomment following line if you want to disable autosetting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment following line if you want red dots to be displayed while waiting for completion
# COMPLETION_WAITING_DOTS="true"

# Which plugins would you like to load? (plugins can be found in ~/.oh-my-zsh/plugins/*)
# Custom plugins may be added to ~/.oh-my-zsh/custom/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
plugins=(git debian virtualenvwrapper pip rbenv rvm)

if [ ! -e ~/.oh-my-zsh ]; then
    git clone git://github.com/robbyrussell/oh-my-zsh.git ~/.oh-my-zsh
fi

source $ZSH/oh-my-zsh.sh

# Customize to your needs...
export PATH=/home/russell/bin:/home/russell/bin:/usr/local/bin:/usr/bin:/bin:/usr/local/games:/usr/games

# Detect OSX
DARWIN=0
if [[ $(uname) == "Darwin" ]]; then
  DARWIN=1;
fi

setopt histignorealldups sharehistory

# Use emacs keybindings even if our EDITOR is set to vi
bindkey -e

# Keep 1000 lines of history within the shell and save it to ~/.zsh_history:
HISTSIZE=1000
SAVEHIST=1000
HISTFILE=~/.zsh_history

# Use modern completion system
autoload -Uz compinit
compinit

zstyle ':completion:*' auto-description 'specify: %d'
zstyle ':completion:*' completer _expand _complete _correct _approximate
zstyle ':completion:*:match:*' original only
zstyle ':completion:*:approximate:*' max-errors 1 numeric
zstyle ':completion:*' format 'Completing %d'
zstyle ':completion:*' group-name ''
zstyle ':completion:*' menu select=2
eval "$(dircolors -b)"
zstyle ':completion:*:default' list-colors ${(s.:.)LS_COLORS}
zstyle ':completion:*' list-colors ''
zstyle ':completion:*' list-prompt %SAt %p: Hit TAB for more, or the character to insert%s
zstyle ':completion:*' matcher-list '' 'm:{a-z}={A-Z}' 'm:{a-zA-Z}={A-Za-z}' 'r:|[._-]=* r:|=* l:|=*'
zstyle ':completion:*' menu select=long
zstyle ':completion:*' select-prompt %SScrolling active: current selection at %p%s
zstyle ':completion:*' use-compctl false
zstyle ':completion:*' verbose true

zstyle ':completion:*:*:kill:*:processes' list-colors '=(#b) #([0-9]#)*=0=01;31'
zstyle ':completion:*:kill:*' command 'ps -u $USER -o pid,%cpu,tty,cputime,cmd'
zstyle ':completion:*:*:kill:*' menu yes select
zstyle ':completion:*:kill:*'   force-list always

# Add an "alert" alias for long running commands.  Use like so:
#   sleep 10; alert
alias alert='notify-send --urgency=low -i "$([ $? = 0 ] && echo terminal || echo error)" "$(history|tail -n1|sed -e '\''s/^\s*[0-9]\+\s*//;s/[;&|]\s*alert$//'\'')"'

case "$TERM" in
    xterm*)
        export GIT_EDITOR="emacsclient"
        export BZR_EDITOR="emacsclient"
        ;;
    *)
        export GIT_EDITOR="emacs"
        export BZR_EDITOR="emacs"
        ;;
esac

#export PYTHONDONTWRITEBYTECODE=true

export PDSH_RCMD_TYPE="ssh"
export PDSH_GENDERS_FILE=`readlink -f ~/.genders`

# git-buildpackage default target.
export DIST=unstable 
export ARCH=amd64

# EMACS launcher
e () {
    if [ $DARWIN -eq 1 ]; then
	    EMACS=/Applications/Emacs.app/Contents/MacOS/Emacs
    else
	    EMACS=emacs
    fi
    EMACSCLIENT=emacsclient

    tempuid=`id -u`
    EMACSSERVER=$TMPDIR/emacs$tempuid/server

    if [ -f $HOME/.emacsconfig ]; then
	    source $HOME/.emacsconfig
    fi

    if [ -z "$DISPLAY" ]; then
	    exec $EMACS -n "$@"
    else
	if [ $DARWIN -eq 1 ]; then
	    if [ -e "$EMACSSERVER" ]; then
		    exec $EMACSCLIENT -n "$@" &
	    else
		    exec $EMACS --eval "(server-start)" "$@" &
	    fi
	else
	    if [ -e "$EMACSSERVER" ]; then
		    $EMACSCLIENT -n "$@"
	    else
		    exec $EMACS --eval "(server-start)" "$@" &
	    fi
	fi
    fi
}
