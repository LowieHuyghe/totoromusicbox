#!/usr/bin/env sh
set -e
cd "$( dirname "$0" )"

echo "Start dhcpcd"
sudo systemctl start dhcpcd

echo "Start networking"
sudo systemctl start networking

echo "Starting ssh"
sudo systemctl start ssh
