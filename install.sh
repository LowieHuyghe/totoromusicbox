#!/usr/bin/env sh
set -e
cd "$( dirname "$0" )"

# Support mp3
if ! which mpg123 >/dev/null; then
  echo "Installing mpg123"
  sudo apt-get install -y mpg123
else
  echo "mpg123 already installed"
fi

if ! grep "$( pwd )/run.sh" /etc/rc.local >/dev/null; then
  echo "Please add the following line to /etc/rc.local:"
  echo "$( pwd )/run.sh & >/dev/null 2>$( pwd )/log.txt"
else
  echo "/etc/rc.local already setup"
fi
