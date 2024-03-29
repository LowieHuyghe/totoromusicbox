#!/usr/bin/env bash
cd "$( dirname "$0" )"

# Init volume first so we're sure amixer is loaded and available,
# service.sh will try again, and again, and again.
./volume.py init || exit 1
# Volume control
./volume.py &

# Music player
./music.sh &

# Loop
while true; do
  sleep 0.5
done
