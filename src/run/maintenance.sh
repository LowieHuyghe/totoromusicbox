#!/usr/bin/env bash
cd "$( dirname "$0" )"

# If usb device is connected, start maintenance mode
if ! lsusb | grep 'Device 002' >/dev/null; then
  exit 0
fi

# Maintenance mode
echo "Entering maintenance mode"

# Start certain services
start_services=(
  "dhcpcd"
  "networking"
  "ssh"
)
for start_service in "${start_services[@]}"; do
  echo "Start $start_service"
  sudo systemctl start "$start_service"
done
