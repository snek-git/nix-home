#!/usr/bin/env bash

# A simple wrapper script to launch games with MangoHud enabled
# Usage: game-launcher [command to launch game]

# Enable MangoHud for this process
export MANGOHUD=1
export MANGOHUD_DLSYM=1

# If we have gamemoderun available, use it
if command -v gamemoderun &> /dev/null; then
    echo "Launching with GameMode and MangoHud: $@"
    exec gamemoderun "$@"
else
    echo "Launching with MangoHud: $@"
    exec "$@"
fi 