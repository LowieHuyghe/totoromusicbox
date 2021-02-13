#!/usr/bin/env bash
set -e
cd "$( dirname "$0" )"

# If usb device is connected, start maintenance mode
if lsusb | grep 'Device 002' >/dev/null; then
  # Maintenance mode
  echo "Entering maintenance mode"
  ./run/maintenance.sh &
fi

# Set volume lower
echo "Setting volume to 80%"
amixer sset PCM 80% > /dev/null

# Play song
echo "Playing song"
mpg123 ./music/spirited-away.mp3
