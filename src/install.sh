#!/usr/bin/env sh
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
echo "Disable dhcpcd"
sudo systemctl disable dhcpcd
echo "Disable wpa_supplicant"
sudo systemctl disable wpa_supplicant
echo "Disable networking"
sudo systemctl disable networking

echo "Disable ssh"
sudo systemctl disable ssh
echo "Disable sshswitch"
sudo systemctl disable sshswitch

echo "Disable rsync"
sudo systemctl disable rsync

echo "Disable syslog"
sudo systemctl disable syslog
echo "Disable rsyslog"
sudo systemctl disable rsyslog

echo "Disable bluetooth"
sudo systemctl disable bluetooth

echo "Disable ntp"
sudo systemctl disable ntp.service
echo "Disable dphys-swapfile"
sudo systemctl disable dphys-swapfile.service
echo "Disable keyboard-setup"
sudo systemctl disable keyboard-setup.service
echo "Disable apt-daily"
sudo systemctl disable apt-daily.service
echo "Disable wifi-country"
sudo systemctl disable wifi-country.service
echo "Disable hciuart"
sudo systemctl disable hciuart.service
echo "Disable raspi-config"
sudo systemctl disable raspi-config.service
echo "Disable avahi-daemon"
sudo systemctl disable avahi-daemon.service
echo "Disable triggerhappy"
sudo systemctl disable triggerhappy.service

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
