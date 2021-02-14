#!/usr/bin/env bash
set -e
cd "$( dirname "$0" )"

# Set volume lower
echo "Setting volume"
amixer sset PCM 70% >/dev/null

# Maintenance
./maintenance.sh &

# Play song
echo "Playing song"
while true; do
  mpg123 -z ../../music/*.mp3
done
