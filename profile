# -*- mode: sh -*-
# ~/.profile: executed by the command interpreter for login shells.
# This file is not read by bash(1), if ~/.bash_profile or ~/.bash_login
# exists.
# see /usr/share/doc/bash/examples/startup-files for examples.
# the files are located in the bash-doc package.

# the default umask is set in /etc/profile; for setting the umask
# for ssh logins, install and configure the libpam-umask package.
#umask 022
# Detect OSX
DARWIN=false
if [[ $(uname) == "Darwin" ]]; then
    DARWIN=true;
fi

if $DARWIN; then
    export VIRTUALENVWRAPPER_PYTHON=/usr/local/bin/python
    export PATH="/usr/local/bin:$PATH"
fi

if $DARWIN; then
    eval "$(gdircolors -b)"
else
    eval "$(dircolors -b)"
fi

# if running bash
if [ -n "$BASH_VERSION" ]; then
    # include .bashrc if it exists
    if [ -f "$HOME/.bashrc" ]; then
        . "$HOME/.bashrc"
    fi
fi

# Debian doesn't seem to have a TMPDIR variable any more :(
[ -z "$TMPDIR" ] && export TMPDIR=/tmp/

# Android SDK
if [ -d "/opt/android-sdk-linux_x86/tools/" ] ; then
    PATH="/opt/android-sdk-linux_x86/tools/:$PATH"
fi

# OSX texinfo support
if [ -d "/usr/texbin/" ]
then
    PATH="/usr/texbin/:$PATH"
fi

# Python home dir virtualenv
if [ -d "$HOME/.virtualenv" ]
then
    PATH="$HOME/.virtualenv/bin/:$PATH"
fi

# Yarn
if [ -d "$HOME/.yarn/bin" ]
then
    export PATH="$HOME/.yarn/bin:$PATH"
fi

# Common Lisp
if [ -d "$HOME/.cim" ]; then
    CIM_HOME=$HOME/.cim;
    if [ -s "$CIM_HOME/init.sh" ]; then
        . "$CIM_HOME/init.sh"
    fi
fi

# Cask for OSX
if [ -d "$HOME/.cask" ]; then
  PATH="$HOME/.cask/bin:$PATH"
fi


# NodeJS
export NPM_PACKAGES="$HOME/.npm-packages"
PATH="$NPM_PACKAGES/bin:$PATH"
MANPATH="$NPM_PACKAGES/share/man:$(manpath)"
export NODE_PATH="$NPM_PACKAGES/lib/node_modules:$NODE_PATH"
if [ ! -d "$NPM_PACKAGES" ] ; then
    mkdir $NPM_PACKAGES
fi

if [ -d "$HOME/.nvm" ]; then
    export NVM_DIR="$HOME/.nvm"
    if $DARWIN; then
        source "/usr/local/opt/nvm/nvm.sh"
    else
        source "$NVM_DIR/nvm.sh"
    fi
fi

# Guile scheme path
join () {
    local IFS="$1";
    shift;
    echo "$*";

}

if [ -d ~/projects/scheme/ ]; then
    export GUILE_LOAD_PATH=$(join ':' `find ~/projects/scheme/ -mindepth 1 -maxdepth 1 -type d`)
fi

if [ -d "/usr/local/MacGPG2/bin/" ]; then
    PATH="/usr/local/MacGPG2/bin/:$PATH"
fi

export GPGKEY=22B1092ADDDC47DD

export MAIL="russell.sim@gmail.com"
export DEBEMAIL=$MAIL
export DEBFULLNAME="Russell Sim"
export CC="gcc"


alias gtypist="gtypist -bi"

gread_link () {
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

# Python virtualenv/pip
#export PYTHONDONTWRITEBYTECODE=true
export WORKON_HOME=${HOME}/.virtualenvs
export PIP_DOWNLOAD_CACHE=${HOME}/.egg-cache

export PATH
export MANPATH

export LSCOLORS="exfxcxdxbxegedabagacad"
export LS_COLORS="di=34:ln=35:so=32:pi=33:ex=31:bd=34;46:cd=34;43:su=30;41:sg=30;46:tw=30;42:ow=30;43"

#
# grep colors
#
export GREP_COLOR='1;32'

#
# Less Colors for Man Pages
#
export LESS_TERMCAP_mb=$(tput bold; tput setaf 2) # green
export LESS_TERMCAP_md=$(tput bold; tput setaf 6) # cyan
export LESS_TERMCAP_me=$(tput sgr0)
export LESS_TERMCAP_so=$(tput bold; tput setaf 3; tput setab 4) # yellow on blue
export LESS_TERMCAP_se=$(tput rmso; tput sgr0)
export LESS_TERMCAP_us=$(tput smul; tput bold; tput setaf 7) # white
export LESS_TERMCAP_ue=$(tput rmul; tput sgr0)
export LESS_TERMCAP_mr=$(tput rev)
export LESS_TERMCAP_mh=$(tput dim)
export LESS_TERMCAP_ZN=$(tput ssubm)
export LESS_TERMCAP_ZV=$(tput rsubm)
export LESS_TERMCAP_ZO=$(tput ssupm)
export LESS_TERMCAP_ZW=$(tput rsupm)

# add the .local/bin directory to the path
if [ -d "$HOME/.local/bin" ]; then
    PATH="$HOME/.local/bin:$PATH"
fi

# set PATH so it includes user's private bin if it exists
if [ -d "$HOME/bin" ] ; then
    PATH="$HOME/bin:$PATH"
fi
