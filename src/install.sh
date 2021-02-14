#!/usr/bin/env bash
set -e
cd "$( dirname "$0" )"

# Support mp3
if ! which mpg123 >/dev/null; then
  echo "Installing mpg123"
  sudo apt-get install -y mpg123
else
  echo "mpg123 already installed"
fi

# Disable networking by default
disable_services=(
  "dhcpcd.service"
  "wpa_supplicant.service"
  "networking.service"
  "ssh.service"
  "sshswitch.service"
  "rsync.service"
  "syslog.service"
  "rsyslog.service"
  "bluetooth.service"
  "ntp.service"
  "dphys-swapfile.service"
  "keyboard-setup.service"
  "apt-daily.service"
  "wifi-country.service"
  "hciuart.service"
  "raspi-config.service"
  "avahi-daemon.service"
  "triggerhappy.service"
  "rpi-eeprom-update.service"
  "rpi-display-backlight.service"
  "raspberrypi-net-mods.service"
  "systemd-timesyncd.service"
  "apt-daily.service"
  "apt-daily.timer"
  "apt-daily-upgrade.timer"
  "apt-daily-upgrade.service"
  "man-db.timer"
  "man-db.service"
)
for disable_service in "${disable_services[@]}"; do
  if sudo systemctl status "$disable_service" | grep loaded | grep -E '.(service|timer); enabled' >/dev/null; then
    echo "Disable $disable_service"
    sudo systemctl disable "$disable_service"
  else
    echo "$disable_service already disabled"
  fi
done

echo "Setting up totoromusicplayer-service"
cat <<EOF | sudo tee /etc/systemd/system/totoromusicplayer.service >/dev/null
[Unit]
Description=Totoro Music Player
DefaultDependencies=false

[Service]
Type=simple
Restart=always
RestartSec=1
User=pi
ExecStart=$( pwd )/run.sh

[Install]
WantedBy=basic.target
EOF
echo "Disable totoromusicplayer-service"
sudo systemctl disable totoromusicplayer
echo "Enable totoromusicplayer-service"
sudo systemctl enable totoromusicplayer

# echo "Show all running services"
# sudo systemctl list-unit-files --type=service --state=enabled
# echo "Show startup time"
# systemd-analyze critical-chain
# systemd-analyze blame
