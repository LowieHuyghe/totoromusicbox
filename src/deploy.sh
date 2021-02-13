#!/usr/bin/env bash
set -e
cd "$( dirname "$0" )"

ssh pi@10.42.0.107 bash <<EOF
set -e
cd totoromusicplayer
echo "Installing"
./src/install.sh
EOF
