#!/usr/bin/env bash
cd "$( dirname "$0" )"

# Maintenance
./run/maintenance.sh &

while true; do
  ./run/music.sh
  sleep 0.5
done
