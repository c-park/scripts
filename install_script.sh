#!/bin/bash

# Ubuntu (GNOME) 18.04 setup script.

# Must have Gdebi!:

dpkg -l | grep -qw gdebi || sudo apt-get install -yyq gdebi

# First, let's install a bunch of software:

sudo add-apt-repository universe
sudo apt update -y
sudo apt upgrade -y

sudo apt install wget -y

sudo apt install neofetch openssh-server openssh-client  \
net-tools htop git xclip ssh \
vlc gthumb gnome-shell-extensions gnome-tweaks chrome-gnome-shell -yy

# Install VS Code
wget -q https://packages.microsoft.com/keys/microsoft.asc -O- | sudo apt-key add -
sudo add-apt-repository "deb [arch=amd64] https://packages.microsoft.com/repos/vscode stable main"
sudo apt update
sudo apt install code

# Generate SSH Key

ssh-keygen -t rsa -b 4096 -C "cadeparkison@gmail.com"

# Add SSH key to ssh-agent
eval "$(ssh-agent -s)"
ssh-add ~/.ssh/id_rsa


# Install all local .deb packages, if available:

if [ -d "/home/$USER/Downloads/Packages" ]; then
    echo "Installing local .deb packages..."
    pushd /home/$USER/Downloads/Packages
    for FILE in ./*
   do
       sudo gdebi -n "$FILE"
   done
    popd
else
    echo $'\n'$"WARNING! There's no ~/Downloads/Packages directory."
    echo "Local .deb packages can't be automatically installed."
    sleep 5 # The script pauses so this message can be read.
fi

# Add me to any groups I might need to be a part of:

# Remove undesirable packages:

# sudo apt purge gstreamer1.0-fluendo-mp3 deja-dup shotwell -yy

# Remove snaps and get packages from apt:

sudo snap remove gnome-characters gnome-calculator gnome-system-monitor
sudo apt install gnome-characters gnome-calculator gnome-system-monitor -yy

# Purge Firefox, install Google Chrome:

sudo apt purge firefox -yy
sudo apt purge firefox-locale-en -yy
if [ -d "/home/$USER/.mozilla" ]; then
    rm -rf /home/$USER/.mozilla
fi
if [ -d "/home/$USER/.cache/mozilla" ]; then
    rm -rf /home/$USER/.cache/mozilla
fi
mkdir /tmp/gc-install-tmp
pushd /tmp/gc-install-tmp
wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb
sudo gdebi -n google-chrome-stable_current_amd64.deb
popd
rm -rf /tmp/gc-install-tmp

# Install Timeshift:

sudo apt-add-repository -y ppa:teejee2008/ppa -y
sudo apt install timeshift

# set Qt variable in /etc/environment:

# sudo bash -c "echo 'QT_QPA_PLATFORMTHEME=gtk2' >> /etc/environment"

# Gotta reboot now:

echo $'\n'$"*** All done! Please reboot now. ***"
exit
