#!/usr/bin/env sh
set -e
cd "$( dirname "$0" )"

# Set volume lower
echo "Setting volume to 80%"
amixer sset PCM 80% > /dev/null

if ifconfig | grep eth0 >/dev/null; then
  # Maintenance mode
  echo "Entering maintenance mode"

  echo "Starting ssh"
  sudo systemctl start ssh

  echo "Starting dhcpd"
  sudo systemctl start dhcpd
else
  # Play song
  echo "Playing song"
  mpg123 ./music/spirited-away.mp3
fi
