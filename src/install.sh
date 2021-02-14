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
WantedBy=basic.target
EOF
echo "Disable totoromp-service"
sudo systemctl disable totoromp
echo "Enable totoromp-service"
sudo systemctl enable totoromp

if ! [ -f "/home/pi/.ssh/authorized_keys" ]; then
  echo "Creating authorized_keys"
  cat <<EOF > /home/pi/.ssh/authorized_keys
ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQDMggwhKF7jLu+pKl+4OlRzzfb49yJCvqYCHbh8WVf6DHnnaxSAb0h0/m4FgKlCOc35nSTCzRqLziw99GQ6TXBI1KJF4TCG/3GgjHOYtJLlmLb3eZU034HrBGJyT6bv9yCdbUawr5jS9yR6bz/3RiY6xcrYdvVpFLjey4aPWpMuTCPMVh3zvH/GDoLn77RXHm8NSg55ysUb2WPZvlkA/zRtJtUod0LNi8HyaZPl5anRLyyBCoBucM8q22DVHt2DGgmuCLzOoB07xM9VKYh6Pia2CvXDIcWwq4tZvLIOj5gFOEqr0cDmTYyp/ajqG8jJV/kOhL6aOhZqS0OhOqmWWR0tkk+rIO1tc2N5MrwR3MOoS3XkrcBDTPs8K9TJJ754Wn6YOt4U1IfyFYevOxirdx9uXTqoQb36cb7NUk9cWVwfG3eFLejUqH/XH1+lgcZxGp1hwrMp4KkF8CiWrjcQzyVeUqI7l+Uvt94vO/q4TDVkmqwNgYMmKyUzESFLyCpa/1R1NW09TpL1j8OmeACVKhOhqmCpu9HvOSQIyIscUR00wdTCmYK+PQmKBkv00Thc/HsrDLjUrrd6V/22TeO/ff4AwVKEMadk+luUn/hySy6JSIW3L/B9KzDkS2cRDTcY0m96fjNtHglAMKwN4hQ9tbGlyuY7BaBdViOactVsh6iV9Q== iam@lowiehuyghe.com
EOF
else
  echo "authorized_keys already exists"
fi

# echo "Show all running services"
# sudo systemctl list-unit-files --type=service --state=enabled
# echo "Show startup time"
# systemd-analyze critical-chain
# systemd-analyze blame
