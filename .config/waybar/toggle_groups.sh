#!/bin/bash

LIVE_FILE="$HOME/.config/waybar/modules/groups.jsonc"
BAK_FILE="$HOME/.config/waybar/modules/groups.jsonc.bak"
TMP_FILE="$HOME/.config/waybar/modules/groups.jsonc.tmp"

if [ -f "$BAK_FILE" ]; then
  mv "$LIVE_FILE" "$TMP_FILE"
  mv "$BAK_FILE" "$LIVE_FILE"
  mv "$TMP_FILE" "$BAK_FILE"

  killall -SIGUSR2 waybar
else
  echo "Error backup file groups.jsonc.bak not found!"
fi
