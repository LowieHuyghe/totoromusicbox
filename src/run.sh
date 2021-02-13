#!/usr/bin/env bash
cd "$( dirname "$0" )"

# Maintenance
./run/maintenance.sh &

# Set volume lower
echo "Setting volume"
amixer sset PCM 70% > /dev/null

# Play song
echo "Playing song"
while true; do
  mpg123 -z ../music/*.mp3
done
