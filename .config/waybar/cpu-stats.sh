#!/bin/sh

read_cpu() {
  awk '/^cpu / { print $2, $3, $4, $5, $6, $7, $8 }' /proc/stat
}

set -- $(read_cpu)
prev_total=$(( $1 + $2 + $3 + $4 + $5 + $6 + $7 ))
prev_idle=$(( $4 + $5 ))

sleep 0.2

set -- $(read_cpu)
total=$(( $1 + $2 + $3 + $4 + $5 + $6 + $7 ))
idle=$(( $4 + $5 ))

diff_total=$(( total - prev_total ))
diff_idle=$(( idle - prev_idle ))

if [ "$diff_total" -gt 0 ]; then
  usage=$(( (100 * (diff_total - diff_idle)) / diff_total ))
else
  usage=0
fi

temp_file=""
for hwmon in /sys/class/hwmon/hwmon*; do
  [ -r "$hwmon/name" ] || continue
  name="$(cat "$hwmon/name")"
  case "$name" in
    coretemp|k10temp|zenpower)
      temp_file="$hwmon/temp1_input"
      break
      ;;
  esac
done

[ -n "$temp_file" ] || temp_file="$(find /sys/class/hwmon -name temp1_input 2>/dev/null | head -n 1)"

if [ -n "$temp_file" ] && [ -r "$temp_file" ]; then
  temp=$(( $(cat "$temp_file") / 1000 ))
else
  temp="?"
fi

load="$(awk '{print $1, $2, $3}' /proc/loadavg)"

printf '{"text":" %s%% %s°C","tooltip":"CPU: %s%%\\nTemp: %s°C\\nLoad: %s"}\n' \
  "$usage" "$temp" "$usage" "$temp" "$load"
