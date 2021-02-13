#!/usr/bin/env bash
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
while true; do
  mpg123 -z ../music/*.mp3
done
