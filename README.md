# totoromusicplayer

## Setup
```
# Setup sd
# Create "ssh"-file in boot
# Change "config.txt" in boot !!! WATCH OUT WITH OVERCLOCK U1 NEEDED!
disable_splash=1
boot_delay=0
force_turbo=1
dtoverlay=sdhost,overclock_50=100
dtoverlay=pi3-disable-wifi
dtoverlay=pi3-disable-bt

# Rapi config for keyboard-layout
# Also disable serial
sudo raspi-config

# Support git
sudo apt-get install -y git

# generate ssh
ssh-keygen
# add public key to repo

# clone repo
git clone git@github.com:LowieHuyghe/totoromusicplayer.git

# twice
./src/install/i2samp.sh

# install
./src/install.sh
```
