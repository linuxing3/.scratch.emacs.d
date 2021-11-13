#!/bin/sh
  export LANG=en_US.utf-8
  export LC_COLLATE="en_US.UTF-8"
  export GTK_IM_MODULE=fcitx
  export QT_IM_MODULE=fcitx
  export XMODIFIERS="@im=fcitx"

  # Set the screen DPI (uncomment this if needed!)
  xrdb ~/.scratch.emacs.d/exwm/Xresources
  xrdb ~/.Xdefaults 

  # Run the screen compositor
  compton &

  # Enable screen locking on suspend
  xss-lock -- slock &

  # Fire it up
  exec dbus-launch --exit-with-session emacs --with-profile scratch -l ~/.scratch.emacs.d/desktop.el
