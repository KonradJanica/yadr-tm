#!/bin/sh

if [ ! -d "$HOME/.yadr" ]; then
    echo "Installing YADR-TM for the first time"
    git clone https://github.com/tullie/yadr-tm "$HOME/.yadr"
    cd "$HOME/.yadr"
    [ "$1" = "ask" ] && export ASK="true"
    rake install
else
    echo "YADR is already installed"
fi
