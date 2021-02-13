#!/usr/bin/env sh
set -e
cd "$( dirname "$0" )"

# Support mp3
if ! which mpg123 > /dev/null; then
  echo "Installing mpg123"
  sudo apt-get install -y mpg123
fi

# Set volume lower
echo "Setting volume to 80%"
amixer sset PCM 80%
