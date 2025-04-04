#!/usr/bin/env bash

# Config
HISTORY_SIZE=20
MEM_FILE="/run/user/$(id -u)/waybar_mem_history"

# Get memory usage percentage using free and awk
MEM_USAGE=$(free | awk '/^Mem:/ {printf "%.0f", $3/$2 * 100.0}')

# Ensure usage is a number
if ! [[ "$MEM_USAGE" =~ ^[0-9]+$ ]]; then
    MEM_USAGE=0
fi

# Initialize history file if it doesn't exist
if [ ! -f "$MEM_FILE" ]; then
    touch "$MEM_FILE"
fi

# Add current value to history
echo "$MEM_USAGE" >> "$MEM_FILE"

# Trim history to HISTORY_SIZE
EXISTING_LINES=$(wc -l < "$MEM_FILE")
if [ "$EXISTING_LINES" -gt "$HISTORY_SIZE" ]; then
    tail -n "$HISTORY_SIZE" "$MEM_FILE" > "${MEM_FILE}.tmp" && mv "${MEM_FILE}.tmp" "$MEM_FILE"
fi

# Generate sparkline graph using absolute path
GRAPH=$(${pkgs.sparkline}/bin/spark $(cat "$MEM_FILE"))

# Get detailed memory info for tooltip
MEM_INFO=$(free -h | awk '/^Mem:/ {printf "Used: %s / Total: %s", $3, $2}')

# Output JSON for Waybar
printf '{"text": "%s %s%%", "tooltip": "%s"}\n' "$GRAPH" "$MEM_USAGE" "$MEM_INFO" 