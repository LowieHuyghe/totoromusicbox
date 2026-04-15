#!/usr/bin/env bash
set -e
cd "$( dirname "$0" )"

usage() {
  echo "Usage: $0 <src_dir> <rpi_host>"
  echo
  echo "Sync mp3 files to the Totoro Music Box."
  echo
  echo "Arguments:"
  echo "  src_dir   Local directory containing mp3 files"
  echo "  rpi_host  Raspberry Pi hostname or IP address"
  exit 1
}

[[ $# -ne 2 ]] && usage

SRC_DIR="$1"
RPI_HOST="$2"
DEST_DIR="/home/pi/totoromusicplayer/music"

[[ ! -d "$SRC_DIR" ]] && echo "Error: '$SRC_DIR' is not a directory" && exit 1

echo "Create temp"
TEMP_DIR="$( mktemp -d )"

echo "Create symlinks"
for f in "$SRC_DIR"/*.mp3; do
  SHA="$( echo "$f" | shasum | cut -d" " -f1 )"
  ln -s "$f" "$TEMP_DIR/${SHA:0:10}.mp3"
done

echo "Rsync"
rsync -vrL "$TEMP_DIR/" "pi@$RPI_HOST:$DEST_DIR/" --delete

echo "Remove temp"
rm -rf "$TEMP_DIR"
