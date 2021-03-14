#!/usr/bin/env bash
cd "$( dirname "$0" )"

# Play song
echo "Playing song"
while true; do
  # Use own sort as mpg123 does not really seem random.
  # Feed them 10 songs at a time. When done, just loop.
  find ../../music -name "*.mp3" | sort --random-sort | xargs -d '\n' -n10 mpg123
done
