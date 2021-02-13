# totoromusicplayer

## Setup
```
# Rapi config for keyboard-layout
# Also disable serial
sudo raspi-config
# Support git
sudo apt-get install -y git
# generate ssh
ssh-keygen
# make sure you can connect to pi
sudo systemctl start ssh
# add public key to repo
# clone repo
git clone git@github.com:LowieHuyghe/totoromusicplayer.git
# twice
./bin/install/i2samp.sh
# install
./install.sh

# /boot/config.txt
disable_splash=1
boot_delay=0
```
