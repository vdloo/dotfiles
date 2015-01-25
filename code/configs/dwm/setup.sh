#!/usr/bin/env bash


# Remember to install xinerama deps on fresh machines
# sudo apt-get install libx11-dev libxinerama-dev

#type -p git 1> /dev/null && (
#	 [ ! -d dwm ] && git clone http://git.suckless.org/dwm || (cd dwm; git fetch; git reset --hard origin/master)
#)
[ -d dwm ] && rm -Rf dwm
apt-get source dwm && mv dwm-6.0 dwm
rm -R *.tar.gz *.dsc

cat config.h > dwm/config.h
cd dwm

# http://dwm.suckless.org/patches/fibonacci
wget -nc http://dwm.suckless.org/patches/dwm-5.8.2-fibonacci.diff
patch < dwm-5.8.2-fibonacci.diff -f

# http://dwm.suckless.org/patches/gapless_grid 
wget -nc http://dwm.suckless.org/patches/gaplessgrid.c

make clean
sudo make install
cd ..
