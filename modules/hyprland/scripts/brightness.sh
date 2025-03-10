#!/usr/bin/env bash

# This script handles monitor brightness changes more efficiently
# It prevents multiple ddcutil processes from running at the same time
# and implements debouncing for rapid keypresses

# Create a lockfile to prevent multiple instances from running simultaneously
LOCKFILE="/tmp/brightness_control.lock"

# Function to clean up lockfile on exit
cleanup() {
  rm -f "$LOCKFILE"
}

# Set up trap to clean lockfile on exit
trap cleanup EXIT

# Check if another instance is running
if [ -f "$LOCKFILE" ]; then
  # If lockfile exists but is older than 5 seconds, remove it (stale lock)
  if [ $(($(date +%s) - $(stat -c %Y "$LOCKFILE"))) -gt 5 ]; then
    rm -f "$LOCKFILE"
  else
    echo "Another instance is running, exiting"
    exit 0
  fi
fi

# Create lockfile
touch "$LOCKFILE"

# Get current brightness for display 1
CURRENT1=$(ddcutil getvcp 10 --display 1 2>/dev/null | grep -oP 'current value = \K\d+' || echo "50")

# Check if display 2 exists
DISPLAY2_EXISTS=$(ddcutil detect 2>/dev/null | grep -c "Display 2")

if [ "$DISPLAY2_EXISTS" -gt 0 ]; then
  CURRENT2=$(ddcutil getvcp 10 --display 2 2>/dev/null | grep -oP 'current value = \K\d+' || echo "50")
else
  CURRENT2=$CURRENT1
fi

# Get direction from argument
DIRECTION=$1
AMOUNT=${2:-10}

# Calculate new brightness
if [ "$DIRECTION" = "up" ]; then
  NEW1=$((CURRENT1 + AMOUNT))
  NEW2=$((CURRENT2 + AMOUNT))
  
  # Cap at 100
  [ $NEW1 -gt 100 ] && NEW1=100
  [ $NEW2 -gt 100 ] && NEW2=100
else
  NEW1=$((CURRENT1 - AMOUNT))
  NEW2=$((CURRENT2 - AMOUNT))
  
  # Don't go below 0
  [ $NEW1 -lt 0 ] && NEW1=0
  [ $NEW2 -lt 0 ] && NEW2=0
fi

# Set brightness for display 1
ddcutil setvcp 10 $NEW1 --display 1 2>/dev/null

# Set brightness for display 2 if it exists
if [ "$DISPLAY2_EXISTS" -gt 0 ]; then
  ddcutil setvcp 10 $NEW2 --display 2 2>/dev/null
fi

# Show notification if notify-send is available
if command -v notify-send &> /dev/null; then
  notify-send -r 9999 -t 500 "Brightness" "Monitor 1: $NEW1%\nMonitor 2: $NEW2%" -h int:value:$NEW1
fi

# Cleanup lockfile
rm -f "$LOCKFILE" 