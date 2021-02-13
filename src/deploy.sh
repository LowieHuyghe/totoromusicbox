#!/usr/bin/env sh
set -e
cd "$( dirname "$0" )"

ssh pi@10.42.0.107 bash <<EOF
set -e
cd totoromusicplayer
echo "Installing"
./install.sh
EOF
