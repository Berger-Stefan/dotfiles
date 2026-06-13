#!/usr/bin/env bash
set -euo pipefail

if ! command -v pactl >/dev/null 2>&1 || ! command -v rofi >/dev/null 2>&1; then
  command -v pavucontrol >/dev/null 2>&1 && exec pavucontrol
  exit 1
fi

describe_device() {
  local kind="$1"
  local id="$2"
  local label="Sink"
  [[ "$kind" == "sources" ]] && label="Source"

  pactl list "$kind" | awk -v label="$label" -v id="$id" '
    $1 == label && $2 == "#" id { in_block = 1; next }
    $1 == label && in_block { exit }
    in_block && /^[[:space:]]*Description:/ {
      sub(/^[[:space:]]*Description:[[:space:]]*/, "")
      print
      exit
    }
  '
}

move_streams() {
  local stream_kind="$1"
  local move_cmd="$2"
  local target="$3"

  pactl list short "$stream_kind" 2>/dev/null | awk '{print $1}' | while read -r stream_id; do
    [[ -n "$stream_id" ]] && pactl "$move_cmd" "$stream_id" "$target" >/dev/null 2>&1 || true
  done
}

default_sink="$(pactl get-default-sink 2>/dev/null || true)"
default_source="$(pactl get-default-source 2>/dev/null || true)"

menu=""
while read -r id name _; do
  [[ -z "${id:-}" || -z "${name:-}" ]] && continue
  description="$(describe_device sinks "$id")"
  [[ -z "$description" ]] && description="$name"
  marker=""
  [[ "$name" == "$default_sink" ]] && marker="  *"
  menu+="󰕾  ${description}${marker}  (output:${id})"$'\n'
done < <(pactl list short sinks)

while read -r id name _; do
  [[ -z "${id:-}" || -z "${name:-}" || "$name" == *.monitor ]] && continue
  description="$(describe_device sources "$id")"
  [[ -z "$description" ]] && description="$name"
  marker=""
  [[ "$name" == "$default_source" ]] && marker="  *"
  menu+="󰍬  ${description}${marker}  (input:${id})"$'\n'
done < <(pactl list short sources)

selection="$(printf "%s" "$menu" | rofi -dmenu -i -p "Audio")" || exit 0
[[ -z "$selection" ]] && exit 0

if [[ "$selection" =~ \(output:([0-9]+)\)$ ]]; then
  target="${BASH_REMATCH[1]}"
  pactl set-default-sink "$target"
  move_streams sink-inputs move-sink-input "$target"
elif [[ "$selection" =~ \(input:([0-9]+)\)$ ]]; then
  target="${BASH_REMATCH[1]}"
  pactl set-default-source "$target"
  move_streams source-outputs move-source-output "$target"
fi
