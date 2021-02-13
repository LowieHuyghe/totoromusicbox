#!/usr/bin/env sh
set -e
cd "$( dirname "$0" )"

# Set volume lower
echo "Setting volume to 80%"
amixer sset PCM 80% > /dev/null

# Play song
echo "Playing song"
mpg123 ./music/spirited-away.mp3
