# -*- mode: sh -*-
ZSHDIR=$HOME/.zsh
source $ZSHDIR/antigen.zsh
fpath=($ZSHDIR/completion $fpath)

# Detect OSX
DARWIN=0
if [[ $(uname) == "Darwin" ]]; then
  DARWIN=1;
fi

if [ $DARWIN -eq 1 ]; then
    export VIRTUALENVWRAPPER_PYTHON=/usr/local/bin/python
    export PATH="/usr/local/bin:$PATH"
fi


antigen-bundle zsh-users/zsh-syntax-highlighting
antigen-bundle zsh-users/zsh-completions
gfpath=(~/.antigen/repos/https-COLON--SLASH--SLASH-github.com-SLASH-zsh-users-SLASH-zsh-completions.git $fpath)

antigen-bundle robbyrussell/oh-my-zsh plugins/git
antigen-bundle robbyrussell/oh-my-zsh plugins/debian
antigen-bundle robbyrussell/oh-my-zsh plugins/pip
antigen-bundle robbyrussell/oh-my-zsh plugins/virtualenvwrapper
antigen-apply

# Disable underline of paths
ZSH_HIGHLIGHT_STYLES[path]='none'

# Debian doesn't seem to have a TMPDIR variable any more :(
[ -z "$TMPDIR" ] && TMPDIR=/tmp/

# Set up the prompt
if [[ $TERM == "dumb" ]]; then	# in emacs
    PS1='%(?..[%?])%!:%~%# '
    # for tramp to not hang, need the following. cf:
    # http://www.emacswiki.org/emacs/TrampMode
    unsetopt zle
    unsetopt prompt_cr
    setopt prompt_subst
    source ~/.zsh/emacs.zsh-theme
else
    setopt prompt_subst
    autoload -U colors
    colors
    source ~/.zsh/arrsim.zsh-theme
fi

autoload -U add-zsh-hook

#
# environment variables
#
export GPGKEY=22B1092ADDDC47DD

export DEBEMAIL="russell.sim@gmail.com"
export DEBFULLNAME="Russell Sim"

export MAIL="russell.sim@gmail.com"

export CC="gcc"

#
# Aliases
#
alias zshconfig="source ~/.zshrc"
alias gtypist="gtypist -bi"

#
# Paths
#

# Python Virtualenv
if [ -d "$HOME/.virtualenv" ]
then
    PATH="$HOME/.virtualenv/bin/:$PATH"
fi

# Cask
if [ -d "$HOME/.cask" ]; then
  PATH="$HOME/.cask/bin:$PATH"
fi

# CIM
if [ -d "$HOME/.cim" ]; then
    CIM_HOME=/home/russell/.cim;
    if [ -s "$CIM_HOME/init.sh" ]; then
        . "$CIM_HOME/init.sh"
    fi
fi

# Home dir bin
if [ -d "$HOME/bin" ] ; then
    PATH="$HOME/bin:$PATH"
fi

setopt appendhistory histignorealldups sharehistory autocd extendedglob dvorak

# Use emacs keybindings even if our EDITOR is set to vi
bindkey -e
bindkey '\ew' kill-region
bindkey '^r' history-incremental-search-backward
bindkey "^[[5~" up-line-or-history
bindkey "^[[6~" down-line-or-history

# make search up and down work, so partially type and hit up/down to find relevant stuff
bindkey '^[[A' up-line-or-search
bindkey '^[[B' down-line-or-search

bindkey "^[[H" beginning-of-line
bindkey "^[[1~" beginning-of-line
bindkey "^[OH" beginning-of-line
bindkey "^[[F"  end-of-line
bindkey "^[[4~" end-of-line
bindkey "^[OF" end-of-line
bindkey ' ' magic-space    # also do history expansion on space

bindkey "^[[1;5C" forward-word
bindkey "^[[1;5D" backward-word

bindkey '^[[Z' reverse-menu-complete

# Make the delete key (or Fn + Delete on the Mac) work instead of outputting a ~
bindkey '^?' backward-delete-char
bindkey "^[[3~" delete-char
bindkey "^[3;5~" delete-char
bindkey "\e[3~" delete-char

# Keep 1000 lines of history within the shell and save it to ~/.zsh_history:
HISTSIZE=1000
SAVEHIST=1000
HISTFILE=~/.zsh_history

# Use modern completion system
autoload -Uz compinit
compinit

unsetopt menu_complete   # do not autoselect the first completion entry
unsetopt flowcontrol
setopt auto_menu         # show completion menu on succesive tab press
setopt complete_in_word
setopt always_to_end

zstyle ':completion:*' auto-description 'specify: %d'
zstyle ':completion:*' completer _expand _complete _correct _approximate
zstyle ':completion:*:match:*' original only
zstyle ':completion:*:approximate:*' max-errors 1 numeric
zstyle ':completion:*' format 'Completing %d'
zstyle ':completion:*' group-name ''
zstyle ':completion:*' menu select=2
if [ $DARWIN -eq 1 ]; then
    eval "$(gdircolors -b)"
else
    eval "$(dircolors -b)"
fi
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

function rehash-hosts {
    # use /etc/hosts and known_hosts for hostname completion
    [ -r /etc/ssh/ssh_known_hosts ] && _global_ssh_hosts=(${${${${(f)"$(</etc/ssh/ssh_known_hosts)"}:#[\|]*}%%\ *}%%,*}) || _ssh_hosts=()
    [ -r ~/.ssh/known_hosts ] && _ssh_hosts=(${${${${(f)"$(<$HOME/.ssh/known_hosts)"}:#[\|]*}%%\ *}%%,*}) || _ssh_hosts=()
    [ -r /etc/hosts ] && : ${(A)_etc_hosts:=${(s: :)${(ps:\t:)${${(f)~~"$(</etc/hosts)"}%%\#*}##[:blank:]#[^[:blank:]]#}}} || _etc_hosts=()
    hosts=(
        "$_global_ssh_hosts[@]"
        "$_ssh_hosts[@]"
        "$_etc_hosts[@]"
        "$HOST"
        localhost
    )
    zstyle ':completion:*:hosts' hosts $hosts
}

rehash-hosts

# Don't complete uninteresting users
zstyle ':completion:*:*:*:users' ignored-patterns \
        adm amanda apache avahi beaglidx bin cacti canna clamav daemon \
        dbus distcache dovecot fax ftp games gdm gkrellmd gopher irc \
        hacluster haldaemon halt hsqldb ident junkbust ldap lp mail \
        mailman mailnull mldonkey mysql nagios list proxy libuuid\
        named netdump news nfsnobody nobody nscd ntp nut nx openvpn \
        operator pcap postfix privoxy pulse pvm quagga radvd \
        rpc rpcuser rpm shutdown squid sshd sync uucp vcsa xfs rtkit \
        statd usbmux saned speech-dispatcher hplip dovenull Debian-exim \
        Debian-gdm colord bitlbee backup cl-builder dnsmasq gnats man \
        messagebus sys memcache mongodb mpd puppet puppetdb uuidd nagios \
        _graphite stunnel4

# ... unless we really want to.
zstyle '*' single-ignored show


# make deleting part of a dns entry easier.
WORDCHARS=''

NOVA_DIR=/usr/local/src/python-novaclient
if [ -e $NOVA_DIR ]; then
    autoload -U bashcompinit;bashcompinit;source $NOVA_DIR/tools/nova.bash_completion
fi

# Add an "alert" alias for long running commands.  Use like so:
#   sleep 10; alert
alias alert='notify-send --urgency=low -i "$([ $? = 0 ] && echo terminal || echo error)" "$(history|tail -n1|sed -e '\''s/^\s*[0-9]\+\s*//;s/[;&|]\s*alert$//'\'')"'

if [ $SSH_TTY ]; then
    export EDITOR='emacs -nw'
    export GIT_EDITOR="emacs -nw"
    export BZR_EDITOR="emacs -nw"
    alias emacs="emacs -nw"
else
    export EDITOR='emacsclient'
    export GIT_EDITOR="emacsclient"
    export BZR_EDITOR="emacsclient"
fi

alias mkvirtualenv1='mkvirtualenv $(basename $PWD)'

#
# ls colors
#

autoload colors; colors;
export LSCOLORS="Gxfxcxdxbxegedabagacad"
#export LS_COLORS

# Enable ls colors
if [ "$DISABLE_LS_COLORS" != "true" ]
then
  # Find the option for using colors in ls, depending on the version: Linux or BSD
  ls --color -d . &>/dev/null 2>&1 && alias ls='ls --color=tty' || alias ls='ls -G'
fi

#setopt no_beep
setopt auto_cd
setopt multios
setopt cdablevarS

if [[ "$COLORTERM" == "gnome-terminal" ]]
then
    TERM=xterm-256color
fi

# Scheme
function join {
    local IFS="$1";
    shift;
    echo "$*";
}
export GUILE_LOAD_PATH=$(join ';' `ls -d ~/projects/scheme/*(N)`)

#
# grep colors
#
export GREP_COLOR='1;32'

#
# Less Colors for Man Pages
#

export LESS_TERMCAP_mb=$'\E[01;31m'       # begin blinking
export LESS_TERMCAP_md=$'\E[01;38;5;74m'  # begin bold
export LESS_TERMCAP_me=$'\E[0m'           # end mode
export LESS_TERMCAP_se=$'\E[0m'           # end standout-mode
export LESS_TERMCAP_so=$'\E[38;33;246m'   # begin standout-mode - info box
export LESS_TERMCAP_ue=$'\E[0m'           # end underline
export LESS_TERMCAP_us=$'\E[04;38;5;146m' # begin underline


#export PYTHONDONTWRITEBYTECODE=true

# Openstack RC Files
osrc() { source ~/.os/$1; }
compdef "_path_files -f -W ~/.os/" osrc

function gread_link {
    TARGET_FILE=$1

    cd `dirname $TARGET_FILE`
    TARGET_FILE=`basename $TARGET_FILE`

    # Iterate down a (possible) chain of symlinks
    while [ -L "$TARGET_FILE" ]
    do
        TARGET_FILE=`readlink $TARGET_FILE`
        cd `dirname $TARGET_FILE`
        TARGET_FILE=`basename $TARGET_FILE`
    done

    # Compute the canonicalized name by finding the physical path
    # for the directory we're in and appending the target file.
    PHYS_DIR=`pwd -P`
    RESULT=$PHYS_DIR/$TARGET_FILE
    echo $RESULT
}

# PDSH
export PDSH_RCMD_TYPE="ssh"
export PDSH_GENDERS_FILE=$(gread_link ~/.genders)

# git-buildpackage default target.
export DIST=unstable
export ARCH=amd64

# Virtualenv
export VIRTUAL_ENV_DISABLE_PROMPT="True"
export WORKON_HOME=~/.virtualenvs/

# Pip
export PIP_DOWNLOAD_CACHE=~/.egg-cache

# EMACS launcher
e () {
    if [ $DARWIN -eq 1 ]; then
        EMACS=/Applications/Emacs.app/Contents/MacOS/Emacs
        EMACSCLIENT=/Applications/Emacs.app/Contents/MacOS/bin/emacsclient
    else
        EMACS=emacs
        EMACSCLIENT=emacsclient
    fi

    tempuid=`id -u`
    EMACSSERVER=$TMPDIR/emacs$tempuid/server

    if [ -f $HOME/.emacsconfig ]; then
        source $HOME/.emacsconfig
    fi

    if [ -z "$DISPLAY" ]; then
        $EMACS -n "$@"
    else
    if [ $DARWIN -eq 1 ]; then
        if [ -e "$EMACSSERVER" ]; then
            $EMACSCLIENT -n "$@" &
        else
            $EMACS --eval "(server-start)" "$@" &
        fi
    else
        if [ -e "$EMACSSERVER" ]; then
            $EMACSCLIENT -n "$@"
        else
            $EMACS --eval "(server-start)" "$@" &
        fi
    fi
    fi
}

# edit file in console
ec () {
    if [ $DARWIN -eq 1 ]; then
        EMACS=/Applications/Emacs.app/Contents/MacOS/Emacs
    else
        EMACS=emacs
    fi
    $EMACS -nw "$@"
}

# edit file with root permissions
E () {
    if [ $DARWIN -eq 1 ]; then
        EMACSCLIENT=/Applications/Emacs.app/Contents/MacOS/bin/emacsclient
    else
        EMACSCLIENT=emacsclient
    fi
    $EMACSCLIENT-n -a emacs "/sudo:root@localhost:$PWD/$1"
}

# edit file in console with a root permissions.
EC () {
    if [ $DARWIN -eq 1 ]; then
        EMACS=/Applications/Emacs.app/Contents/MacOS/Emacs
    else
        EMACS=emacs
    fi
    $EMACS -nw "/sudo:root@localhost:$PWD/$1"
}

function ssh-push-key {
  ssh "$@" "echo '`cat ~/.ssh/id_rsa.pub`' >> ~/.ssh/authorized_keys"
}

if [ -n "$SSH_CONNECTION" ]
then

    _IP=$(echo -n $SSH_CONNECTION | cut -d\  -f3)
    _RHOSTNAME=$(host $_IP 2>/dev/null | sed -n 's/.*pointer \(.*\)[.]/\1/p')
    _HOSTIP=$(hostname -i 2>/dev/null)

    if [[ "$_IP" == "$_HOSTIP" ]]; then
        _HOST=$(hostname -f 2>/dev/null)
    elif [ -n "$_RHOSTNAME" ]; then
        _HOST="$_RHOSTNAME"
    else
        _HOST="$_IP"
    fi

else
    _HOST=$(hostname -f 2>/dev/null)
fi

function eterm-precmd {
    echo -e "\033AnSiTu" "$LOGNAME"
    echo -e "\033AnSiTh" "$_HOST"
    echo -e "\033AnSiTc" "$(pwd)"
    echo -e "\033AnSiTp" "$(basename $SHELL)"
}

function eterm-preexec {
    echo -e "\033AnSiTp" $(echo "$1" | cut -d ' ' -f 1)
}

# Track directory, username, and cwd for remote logons.
if [ "$TERM" = "eterm-color" ]; then
    add-zsh-hook precmd eterm-precmd
    add-zsh-hook preexec eterm-preexec
fi

function openstack_clear {
    if [ -n "$(env | awk -F '=' '/OS_/ { print $1 }')" ]; then
       unset $(env | awk -F '=' '/OS_/ { print $1 }')
    fi
    default_prompt
}

function ansible-vault-diff {
    diff -u \
         <(ansible-vault view <(git show HEAD^:./${1})) \
         <(ansible-vault view <(git show HEAD:./${1}))
}

if [ -f "$HOME/.zshrc.local" ]; then
    . "$HOME/.zshrc.local"
fi
