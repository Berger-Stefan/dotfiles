#!/usr/bin/env sh
set -eu

bat="${BATTERY:-BAT1}"
base="/sys/class/power_supply/$bat"

json_escape() {
  printf '%s' "$1" | sed 's/\\/\\\\/g; s/"/\\"/g'
}

read_value() {
  file="$base/$1"
  if [ -r "$file" ]; then
    cat "$file" 2>/dev/null || printf '0'
  else
    printf '0'
  fi
}

format_time() {
  minutes=$1
  if [ "$minutes" -le 0 ]; then
    return
  fi
  hours=$((minutes / 60))
  mins=$((minutes % 60))
  if [ "$hours" -gt 0 ]; then
    printf '%dh%02dm' "$hours" "$mins"
  else
    printf '%dm' "$mins"
  fi
}

capacity="$(read_value capacity)"
status="$(read_value status)"
energy_now="$(read_value energy_now)"
energy_full="$(read_value energy_full)"
power_now="$(read_value power_now)"

case "$status" in
  Charging) icon="󰂄"; class="charging" ;;
  Full) icon="󰁹"; class="full" ;;
  *) icon="󰁹"; class="" ;;
esac

if [ "$capacity" -le 10 ] 2>/dev/null; then
  class="critical"
elif [ "$capacity" -le 25 ] 2>/dev/null; then
  class="warning"
fi

time_text=""
if [ "$power_now" -gt 0 ] 2>/dev/null; then
  case "$status" in
    Discharging)
      minutes=$((energy_now * 60 / power_now))
      time_text="$(format_time "$minutes")"
      ;;
    Charging)
      remaining=$((energy_full - energy_now))
      if [ "$remaining" -gt 0 ] 2>/dev/null; then
        minutes=$((remaining * 60 / power_now))
        time_text="$(format_time "$minutes")"
      fi
      ;;
  esac
fi

text="$icon ${capacity}%"
if [ -n "$time_text" ]; then
  text="$text $time_text"
fi

tooltip="Battery: ${capacity}%\\nStatus: ${status}"
if [ -n "$time_text" ]; then
  tooltip="$tooltip\\nTime: $time_text"
fi

printf '{"text":"%s","tooltip":"%s","class":"%s"}\n' \
  "$(json_escape "$text")" \
  "$(json_escape "$tooltip")" \
  "$(json_escape "$class")"
