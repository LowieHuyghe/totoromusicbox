#!/usr/bin/env bash
cd "$( dirname "$0" )"

# Volume
./volume.py init || exit 1
./volume.py &

# Music
./music.sh &

# Loop
while true; do
  sleep 0.5
done
