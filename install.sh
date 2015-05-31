#!/bin/sh

if [ ! -d "$HOME/.yadr" ]; then
  echo "Installing YADR-TM for the first time"
  echo "Patching .bashrc ..."
  echo "
# Copy working directory
if [ -e /dev/clipboard ]; then
  alias pbcopy='cat >/dev/clipboard'
  alias pbpaste='cat /dev/clipboard'
fi

alias cpwd=\"pwd | tr -d '\n' | pbcopy\"

# Go shortcuts
alias gointerview=\"cd /cygdrive/c/aPrograming/interview/\"
alias gocg=\"cd /cygdrive/c/aPrograming/svn/a1194898/2015/s1/cg/assignment2/\"
alias gocna=\"cd /cygdrive/c/aPrograming/svn/a1194898/2015/s1/cna/AlternatingBit\"
alias gopro=\"cd /cygdrive/c/aPrograming/\"

# LS color on, dir first, human readable sizes
alias ls=\"ls --color=always --group-directories-first -s -h\"

# Screen Cygwin hack
alias screen=\"rm -rf /tmp/uscreens/; screen\"

# Use experimental opengl
export LIBGL_USE_WGL=1
# export LIBGL_ALWAYS_INDIRECT=1" >> .bashrc

# Use fish as default shell if it exists
if [ -d "~/.config/fish" ]; then
  echo "Patching config.fish ..."
  cd ~/.config/fish
  echo "
  # Copy working directory
  alias pbcopy 'cat >/dev/clipboard'
  alias pbpaste 'cat /dev/clipboard'

  alias cpwd \"pwd | tr -d '\n' | pbcopy\"

  # Go shortcuts
  alias gointerview \"cd /cygdrive/c/aPrograming/interview/\"
  alias gocg        \"cd /cygdrive/c/aPrograming/svn/a1194898/2015/s1/cg/assignment2/\"
  alias gocna       \"cd /cygdrive/c/aPrograming/svn/a1194898/2015/s1/cna/AlternatingBit\"
  alias gopro       \"cd /cygdrive/c/aPrograming/\"

  # LS color on, dir first, human readable sizes
  alias ls=\"ls --color=always --group-directories-first -s -h\"" >> config.fish

  mkdir functions
  cd functions
  rm fish_user_key_bindings.fish
  touch fish_user_key_bindings.fish
  # Make Ctrl-n into autocomplete
  echo "bind \\cn accept-autosuggestion" >> fish_user_key_bindings.fish
else
  echo "Error: Fish not found or not installed"
fi

echo "Rebuilding fbpanel ..."
echo "Adding autohide ..."
cd ~/.config/fbpanel
rm ~/.config/fbpanel/multiwindow
touch ~/.config/fbpanel/multiwindow
echo "# http://fbpanel.sourceforge.net/docs.html#config

# Default settings are commented out
Global {
    Edge = top
    Allign = left
    WidthType = request
#   HeightType = pixel
#   Height = 26
#   Margin = 0
#   SetDockType = true
#   SetPartialStrut = true
#   Transparent = false
    TintColor = #363B3B
#   Alpha = 127
    Autohide = true
    RoundCorners = false
#   RoundCornersRadius = 7
#   Layer = above
    SetLayer = true
#   MaxElemHeight = 200
}

plugin {
    type = menu
#   expand = false
#   padding = 0
    config {
        icon = X
        systemmenu {
        }
        separator {
        }
        item {
            name = Cygwin Terminal
            icon = utilities-terminal
            action = mintty
        }
        item {
            name = Exit Cygwin/X
            icon = application-exit
            action = /usr/libexec/fbpanel/xlogout
        }
    }
}
plugin {
    type = tray
    expand = true
    padding = 2
}
plugin {
    type = icons
#   expand = false
#   padding = 0
    config {
        DefaultIcon = X
    }
}" >> multiwindow

echo "Rebuilding startxwinrc ..."
cd /etc/X11/app-defaults/xinit
rm /etc/X11/app-defaults/xinit/startxwinrc
touch /etc/X11/app-defaults/xinit/startxwinrc
echo "#!/bin/sh
# Copyright (C) 1999 - 2005, 2014 Red Hat, Inc. All rights reserved. This
# copyrighted material is made available to anyone wishing to use, modify,
# copy, or redistribute it subject to the terms and conditions of the
# GNU General Public License version 2.
#
# You should have received a copy of the GNU General Public License
# along with this program; if not, write to the Free Software
# Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
#
# Authors:
#	Yaakov Selkowitz <yselkowi@redhat.com>

# redirect errors to a file in user's home directory if we can
if [ -z "$GDMSESSION" ]; then
    # GDM redirect output itself in a smarter fashion
    errfile="$HOME/.xsession-errors"
    if ( umask 077 && cp /dev/null "$errfile" 2> /dev/null ); then
        chmod 600 "$errfile"
        [ -x /sbin/restorecon ] && /sbin/restorecon $errfile
        exec > "$errfile" 2>&1
    else
        errfile=$(mktemp -q /tmp/xses-$USER.XXXXXX)
        if [ $? -eq 0 ]; then
            exec > "$errfile" 2>&1
        fi
    fi
fi

# Mandatorily source xinitrc-common, which is common code shared between the
# Xsession and xinitrc scripts which has been factored out to avoid duplication
. /etc/X11/xinit/xinitrc-common

# The user may have their own clients they want to run.  If they don't,
# fall back to system defaults.
if [ -f $HOME/.startxwinrc ] ; then
    exec $CK_XINIT_SESSION $SSH_AGENT $HOME/.startxwinrc || \
    exec $CK_XINIT_SESSION $SSH_AGENT $HOME/.startxwinrc
else
    export QT_STYLE_OVERRIDE="gtk"
    # default settings
    [ -x /usr/bin/xdg-user-dirs-gtk-update ] && /usr/bin/xdg-user-dirs-gtk-update
    [ -x /usr/bin/gsettings-data-convert ] && /usr/bin/gsettings-data-convert

    if [ -x /usr/libexec/mate-notification-daemon ] ; then
        /usr/libexec/mate-notification-daemon &
    elif [ -x /usr/libexec/notification-daemon ] ; then
        /usr/libexec/notification-daemon &
    elif [ -x /usr/lib/xfce4/notifyd/xfce4-notifyd ] ; then
        /usr/lib/xfce4/notifyd/xfce4-notifyd &
    elif [ -x /usr/bin/lxqt-notificationd ] ; then
        /usr/bin/lxqt-notificationd &
    fi

    if [ -x /usr/bin/start-pulseaudio-x11 ] ; then
        /usr/bin/start-pulseaudio-x11
	if [ -x /usr/bin/pasystray ] ; then
	    /usr/bin/pasystray &
	elif [ -x /usr/bin/mate-volume-control-applet ] ; then
	    /usr/bin/mate-volume-control-applet &
	fi
    fi

    if [ -x /usr/bin/gnome-keyring-daemon ] ; then
        eval `/usr/bin/gnome-keyring-daemon --start`
        export GNOME_KEYRING_CONTROL GPG_AGENT_INFO SSH_AUTH_SOCK
    fi

    [ -x /usr/bin/krb5-auth-dialog ] && /usr/bin/krb5-auth-dialog &

    if [ -x /usr/libexec/evolution/3.12/evolution-alarm-notify ] ; then
        /usr/libexec/evolution/3.12/evolution-alarm-notify &
    elif [ -x /usr/libexec/evolution/3.10/evolution-alarm-notify ] ; then
        /usr/libexec/evolution/3.10/evolution-alarm-notify &
    fi

    [ -x /usr/bin/seahorse-sharing ] && /usr/bin/seahorse-sharing &
    [ -x /usr/bin/zeitgeist-datahub ] && /usr/bin/zeitgeist-datahub &
    [ -x /usr/bin/gnome-terminal ] && /usr/bin/gnome-terminal &
    [ -x /usr/bin/fbxkb ] && /usr/bin/fbxkb &
    [ -x /usr/bin/fbpanel ] && exec /usr/bin/fbpanel -p multiwindow
fi" >> startxwinrc

echo "Patching screenrc ..."
cd /etc
echo "
# Disable vim scrollback buffer
altscreen on

# bottom toolbar
autodetach on 
startup_message off 
hardstatus alwayslastline 
shelltitle 'bash'

hardstatus string '%{gk}[%{wk}%?%-Lw%?%{=b kR}(%{W}%n*%f %t%?(%u)%?%{=b kR})%{= w}%?%+Lw%?%? %{g}][%{d}%l%{g}][ %{= w}%Y/%m/%d %0C:%s%a%{g} ]%{W}'" >> screenrc

git clone https://github.com/KonradJanica/yadr-tm "$HOME/.yadr"
cd "$HOME/.yadr"
[ "$1" = "ask" ] && export ASK="true"
rake install
else
  echo "YADR is already installed"
fi
