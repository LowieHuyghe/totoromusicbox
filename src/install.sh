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

if ! grep "$( pwd )/run.sh" /etc/rc.local >/dev/null; then
  echo "Please add the following line to /etc/rc.local:"
  echo "$( pwd )/run.sh & >/dev/null 2>$( pwd )/log.txt"
else
  echo "/etc/rc.local already setup"
fi

# Disable networking by default
echo "Disable dhcpd"
sudo systemctl disable dhcpd
echo "Disable dhcpd5"
sudo systemctl disable dhcpd5
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
echo "Disable systemd-timesyncd"
sudo systemctl disable systemd-timesyncd

echo "Disable bluetooth"
sudo systemctl disable bluetooth

# echo "Show all running services"
# sudo systemctl list-unit-files --type=service --state=enabled
