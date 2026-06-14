#!/bin/sh

choice="$(printf '%s\n' Logout Reboot Suspend | rofi -dmenu -p Power)"

case "$choice" in
  Logout)
    swaymsg exit
    ;;
  Reboot)
    systemctl reboot
    ;;
  Suspend)
    systemctl suspend
    ;;
esac
