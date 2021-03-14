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
  # Use own sort as mpg123 does not really seem random.
  # Feed them 10 songs at a time. When done, just loop.
  find ../../music -name "*.mp3" | sort --random-sort | xargs -d '\n' -n10 mpg123
done
