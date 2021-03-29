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

# Support gpio-usage
echo "Installing rpi.gpio"
sudo apt-get install -y python-rpi.gpio python3-rpi.gpio

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

boot_config_lines=(
  "disable_splash=1"
  "boot_delay=0"
  "force_turbo=1"
  # !!! WATCH OUT WITH OVERCLOCK U1 NEEDED!
  # "dtoverlay=sdhost,overclock_50=100"
  "dtoverlay=pi3-disable-wifi"
  "dtoverlay=pi3-disable-bt"
)
for boot_config_line in "${boot_config_lines[@]}"; do
  if ! grep -E "^$boot_config_line\$" /boot/config.txt >/dev/null; then
    echo "Adding $boot_config_line to /boot/config.txt"
    echo "$boot_config_line" | sudo tee /boot/config.txt >/dev/null
  else
    echo "$boot_config_line already in /boot/config.txt"
  fi
done

echo "Setting up totoromp-service"
cat <<EOF | sudo tee /etc/systemd/system/totoromp.service >/dev/null
[Unit]
Description=Totoro Music Player
DefaultDependencies=false

[Service]
Type=simple
Restart=always
RestartSec=1
User=pi
ExecStart=$( pwd )/service.sh

[Install]
WantedBy=local-fs.target
EOF
echo "Disable totoromp-service"
sudo systemctl disable totoromp
echo "Enable totoromp-service"
sudo systemctl enable totoromp

if [ -e "/Music" ]; then
  echo "Symbolic link in root for Music exists"
else
  echo "Creating symbolic link in root for Music"
  sudo ln -s "$( pwd )/../music" /Music
fi

# echo "Show all running services"
# sudo systemctl list-unit-files --type=service --state=enabled
# echo "Show startup time"
# systemd-analyze critical-chain
# systemd-analyze blame
