#!/usr/bin/env bash
set -e
cd "$( dirname "$0" )"

if [ -z "$UPDATED" ]; then
  echo "Pulling repo"
  git pull

  # Run install
  UPDATED=TRUE ./install.sh
  exit $?
fi

# Support mp3
if ! which mpg123 >/dev/null; then
  echo "Installing mpg123"
  sudo apt-get install -y mpg123
else
  echo "mpg123 already installed"
fi

# Disable networking by default
disable_services=(
  "dhcpcd"
  "wpa_supplicant"
  "networking"
  "ssh"
  "sshswitch"
  "rsync"
  "syslog"
  "rsyslog"
  "bluetooth"
  "ntp"
  "dphys-swapfile"
  "keyboard-setup"
  "apt-daily"
  "wifi-country"
  "hciuart"
  "raspi-config"
  "avahi-daemon"
  "triggerhappy"
  "rpi-eeprom-update"
  "rpi-display-backlight"
  "raspberrypi-net-mods"
  "systemd-timesyncd"
)
for disable_service in "${disable_services[@]}"; do
  if sudo systemctl status "$disable_service" | grep loaded | grep '.service; enabled' >/dev/null; then
    echo "Disable $disable_service"
    sudo systemctl disable "$disable_service"
  else
    echo "$disable_service already disabled"
  fi
done

# echo "Show all running services"
# sudo systemctl list-unit-files --type=service --state=enabled
# echo "Show startup time"
# systemd-analyze critical-chain
# systemd-analyze blame

if ! grep "$( pwd )/run.sh" /etc/rc.local >/dev/null; then
  echo "Please add the following line to /etc/rc.local:"
  echo "$( pwd )/run.sh & >/dev/null 2>$( pwd )/log.txt"
else
  echo "/etc/rc.local already setup"
fi
