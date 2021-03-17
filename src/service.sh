#!/usr/bin/env bash
cd "$( dirname "$0" )"

# Maintenance
./run/maintenance.sh &

# Loop
while true; do
  ./run/main.sh
  sleep 0.5
done
