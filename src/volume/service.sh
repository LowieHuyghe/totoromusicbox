#!/usr/bin/env bash
cd "$( dirname "$0" )"

while true; do
  python3 ./run/volume.py
  sleep 0.5
done
