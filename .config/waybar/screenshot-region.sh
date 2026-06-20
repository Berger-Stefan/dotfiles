#!/usr/bin/env sh
set -eu

dir="${XDG_PICTURES_DIR:-$HOME/Pictures}/Screenshots"
mkdir -p "$dir"

geometry="$(slurp)"
if [ -z "$geometry" ]; then
  exit 0
fi

file="$dir/screenshot-$(date +%Y%m%d-%H%M%S).png"
grim -g "$geometry" "$file"

if command -v wl-copy >/dev/null 2>&1; then
  wl-copy --type image/png < "$file"
fi

if command -v notify-send >/dev/null 2>&1; then
  notify-send "Screenshot" "Saved and copied: $file"
fi

