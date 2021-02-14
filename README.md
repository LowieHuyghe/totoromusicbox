# totoromusicplayer

## Setup
```
# Rapi config for keyboard-layout
# Also disable serial
sudo raspi-config

# Support git
sudo apt-get install -y git

# make sure you can connect to pi
sudo systemctl start ssh

# generate ssh
ssh-keygen
# add public key to repo

# clone repo
git clone git@github.com:LowieHuyghe/totoromusicplayer.git

# twice
./src/install/i2samp.sh

# install
./src/install.sh

# /boot/config.txt
disable_splash=1
boot_delay=0
dtoverlay=pi3-disable-wifi
dtoverlay=pi3-disable-bt
```
