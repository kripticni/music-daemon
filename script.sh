#!/usr/bin/env bash

set -e
trap 'echo "The last function call failed."' ERR  

if [ -f /usr/bin/pacman ]; then
    pkgManager="pacman -S"
elif [ -f /usr/bin/apt ]; then
    pkgManager="apt install"
elif [ -f /usr/bin/yum ]; then
    pkgManager="yum install"
elif [ -f /usr/bin/zypper ]; then
    pkgManager="zypper install"
else
    echo "None of the known package managers found."
    read -p "Please enter your package manager: " pkgManager
fi

yes | sudo $pkgManager mpd
yes | sudo $pkgManager ncmpcpp

mkdir $HOME/.mpd/
mkdir $HOME/.ncmpcpp/

mv mpd.conf $HOME/.mpd/
touch $HOME/.mpd/mpd.db $HOME/.mpd/mpd.pid $HOME/.mpd/mpd.log

mv config $HOME/.ncmpcpp/config

sudo systemctl start mpd
sudo systemctl --user start mpd.service

echo "Successfully setup, now removing this dir."
rm -r ../music-daemon/
