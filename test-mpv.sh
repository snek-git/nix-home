#!/bin/bash

# Exit on any error
set -e

echo "Testing mpv video clip functionality..."

# Create a temporary input.conf with debug info
TEMP_DIR=$(mktemp -d)
echo "Creating temporary directory: $TEMP_DIR"

# Create a debug input.conf
cat > "$TEMP_DIR/input.conf" << EOF
Ctrl+c script-binding console/enable; print-text "DEBUG: Ctrl+C was pressed"
Ctrl+v script-message-to videoclip start-clip
EOF

# Create a dummy video file
DD_CMD="dd if=/dev/zero of=$TEMP_DIR/test.mp4 bs=1M count=10"
echo "Creating test video file with: $DD_CMD"
eval $DD_CMD

# Launch mpv with debug settings
MPV_CMD="mpv --msg-level=all=debug --input-conf=$TEMP_DIR/input.conf --log-file=$TEMP_DIR/mpv.log $TEMP_DIR/test.mp4"
echo "Launching mpv with: $MPV_CMD"
echo "Press Ctrl+C to see if the key is recognized (should open console)"
echo "Press Ctrl+V to test videoclip functionality"
echo "Check $TEMP_DIR/mpv.log for debug info when done"
eval $MPV_CMD

echo "Test complete. Log file is at $TEMP_DIR/mpv.log" 