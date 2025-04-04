#!/usr/bin/env bash

# Wob socket path
WOBSOCK_PATH="/run/user/$(id -u)/wob.sock"

# Function to get current actual brightness from monitor 1
get_actual_brightness() {
    ddcutil --noverify --brief -b 6 getvcp 10 | cut -d' ' -f4
}

# Function to set brightness on both monitors
set_brightness() {
    local new_value=$1
    if [[ "$new_value" =~ ^[0-9]+$ ]]; then
        ddcutil --noverify -b 6 setvcp 10 "$new_value"
        ddcutil --noverify -b 8 setvcp 10 "$new_value"
    else 
        echo "Error: Invalid brightness value '$new_value'" >&2
        exit 1
    fi
}

# Function to send value to wob
send_to_wob() {
    local value=$1
    if [[ -n "$value" && -S "$WOBSOCK_PATH" ]]; then
        echo "$value" > "$WOBSOCK_PATH" 2>/dev/null
    fi
}

# --- Actions --- 

case "$1" in
    "up")
        current=$(get_actual_brightness)
        if [[ "$current" =~ ^[0-9]+$ ]]; then
            new=$((current + 10))
            [[ $new -gt 100 ]] && new=100
            set_brightness "$new"
            send_to_wob "$new"
        else
            echo "Error: Could not get current brightness ('$current')." >&2
            exit 1
        fi
        ;;
    "down")
        current=$(get_actual_brightness)
        if [[ "$current" =~ ^[0-9]+$ ]]; then
            new=$((current - 10))
            [[ $new -lt 0 ]] && new=0
            set_brightness "$new"
            send_to_wob "$new"
        else
             echo "Error: Could not get current brightness ('$current')." >&2
             exit 1
        fi
        ;;
    "get")
        # Get ACTUAL brightness for Waybar display
        brightness_val=$(get_actual_brightness)
        if [[ -n "$brightness_val" && "$brightness_val" =~ ^[0-9]+$ ]]; then
             echo "$brightness_val"
        else
             echo "??"
             exit 1
        fi
        ;;
    *)
        echo "Usage: $0 {up|down|get}"
        exit 1
        ;;
esac 