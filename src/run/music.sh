#!/usr/bin/env bash
set -e
cd "$( dirname "$0" )"

# Set volume lower
echo "Setting volume"
VOLUME="70%"
amixer sset PCM "$VOLUME" >/dev/null
echo "Checking volume"
if ! amixer sget PCM | grep "$VOLUME" >/dev/null; then
  echo "Failed to set volume"
  exit 1
fi

# Play song
echo "Playing song"
while true; do
  mpg123 -z ../../music/*.mp3
done
