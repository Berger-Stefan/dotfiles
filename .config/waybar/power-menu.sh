#!/bin/sh

choice="$(printf '%s\n' Logout Reboot Shutdown | rofi -dmenu -p Power)"

case "$choice" in
  Logout)
    swaymsg exit
    ;;
  Reboot)
    systemctl reboot
    ;;
  Shutdown)
    systemctl poweroff
    ;;
esac
