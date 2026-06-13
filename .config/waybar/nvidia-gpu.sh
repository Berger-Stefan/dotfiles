#!/bin/sh

stats="$(nvidia-smi --query-gpu=temperature.gpu,utilization.gpu,memory.used,memory.total,power.draw --format=csv,noheader,nounits 2>/dev/null | head -n 1)"

[ -n "$stats" ] || exit 0

temp="$(printf '%s' "$stats" | awk -F ', ' '{print $1}')"
util="$(printf '%s' "$stats" | awk -F ', ' '{print $2}')"
mem_used="$(printf '%s' "$stats" | awk -F ', ' '{print $3}')"
mem_total="$(printf '%s' "$stats" | awk -F ', ' '{print $4}')"
power="$(printf '%s' "$stats" | awk -F ', ' '{print int($5 + 0.5)}')"
mem_used_gib="$(awk "BEGIN { printf \"%.1f\", $mem_used / 1024 }")"
mem_total_gib="$(awk "BEGIN { printf \"%.0f\", $mem_total / 1024 }")"

printf '{"text":"󰢮 %s%% %s/%sG %s°C","tooltip":"GPU: %s%%\\nTemp: %s°C\\nVRAM: %s / %s MiB\\nPower: %s W"}\n' \
  "$util" "$mem_used_gib" "$mem_total_gib" "$temp" "$util" "$temp" "$mem_used" "$mem_total" "$power"
