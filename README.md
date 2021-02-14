# totoromusicplayer

## Setup
```
# Setup sd
# Create "ssh"-file in boot

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
cd totoromusicplayer

# twice
./src/install/i2samp.sh

# install
./src/install.sh
```
