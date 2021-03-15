#!/usr/bin/env bash
cd "$( dirname "$0" )"

# Make sure amixer is ready
if ! amixer sset PCM "10%" >/dev/null && amixer sget PCM | grep "10%" >/dev/null; then
  echo "amixer not ready yet"
  exit 1
fi

# Maintenance
./maintenance.sh &

# Volume
./volume.py &

# Music
./music.sh &

# Loop
while true; do
  sleep 0.5
done
