#!/usr/bin/env bash
set -e
cd "$( dirname "$0" )"

SRC_DIR="/Users/lowie/Files/Documents/Projects/2021/Totori Storyteller/music"
DEST_DIR="/home/pi/totoromusicplayer/music"

echo "Create temp"
TEMP_DIR="$( mktemp -d )"

echo "Create symlinks"
for f in "$SRC_DIR"/*.mp3; do
  SHA="$( echo "$f" | shasum | cut -d" " -f1 )"
  ln -s "$f" "$TEMP_DIR/${SHA:0:10}.mp3"
done

echo "Rsync"
rsync -vrL "$TEMP_DIR/" "pi@10.42.0.107:$DEST_DIR/" --delete

echo "Remove temp"
rm -rf "$TEMP_DIR"
