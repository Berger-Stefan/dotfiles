#!/bin/sh

mem_total_kib="$(awk '/^MemTotal:/ { print $2 }' /proc/meminfo)"
mem_available_kib="$(awk '/^MemAvailable:/ { print $2 }' /proc/meminfo)"
swap_total_kib="$(awk '/^SwapTotal:/ { print $2 }' /proc/meminfo)"
swap_free_kib="$(awk '/^SwapFree:/ { print $2 }' /proc/meminfo)"

mem_used_kib=$(( mem_total_kib - mem_available_kib ))
swap_used_kib=$(( swap_total_kib - swap_free_kib ))

mem_used_gib="$(awk "BEGIN { printf \"%.1f\", $mem_used_kib / 1048576 }")"
mem_total_gib="$(awk "BEGIN { printf \"%.0f\", $mem_total_kib / 1048576 }")"
swap_used_gib="$(awk "BEGIN { printf \"%.1f\", $swap_used_kib / 1048576 }")"
swap_total_gib="$(awk "BEGIN { printf \"%.0f\", $swap_total_kib / 1048576 }")"
mem_percent=$(( 100 * mem_used_kib / mem_total_kib ))

printf '{"text":" %s/%sG","tooltip":"Memory: %s%%\\nRAM: %s / %s GiB\\nSwap: %s / %s GiB"}\n' \
  "$mem_used_gib" "$mem_total_gib" "$mem_percent" "$mem_used_gib" "$mem_total_gib" "$swap_used_gib" "$swap_total_gib"
