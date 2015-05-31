#!/bin/sh

if [ ! -d "$HOME/.yadr" ]; then
    echo "Installing YADR-TM for the first time"
    echo "Patching .bashrc ..."
    cat .bashrc >> "
# Copy working directory
if [ -e /dev/clipboard ]; then
   alias pbcopy='cat >/dev/clipboard'
      alias pbpaste='cat /dev/clipboard'
fi

alias cpwd="pwd | tr -d '\n' | pbcopy"

# Go shortcuts
alias gointerview="cd /cygdrive/c/aPrograming/interview/"
alias gocg="cd /cygdrive/c/aPrograming/svn/a1194898/2015/s1/cg/assignment2/"
alias gocna="cd /cygdrive/c/aPrograming/svn/a1194898/2015/s1/cna/AlternatingBit"

# LS color on
alias ls="ls --color=always"

# Screen Cygwin hack
alias screen="rm -rf /tmp/uscreens/; screen"

# Use experimental opengl
export LIBGL_USE_WGL=1
# export LIBGL_ALWAYS_INDIRECT=1"

    git clone https://github.com/KonradJanica/yadr-tm "$HOME/.yadr"
    cd "$HOME/.yadr"
    [ "$1" = "ask" ] && export ASK="true"
    rake install
else
    echo "YADR is already installed"
fi
