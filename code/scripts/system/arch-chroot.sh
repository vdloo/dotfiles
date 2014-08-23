#!/bin/bash
MIR="http://arch.apt-get.eu/iso/2014.08.01/"
cd /tmp
TARURL="${MIR}$(curl -s $MIR | grep -E 'archlinux-bootstrap.*x86_64.tar.gz\"' | grep -oP '(?<=href=")[^"]*(?=")')"
wget "$TARURL"
tar xvf archlinux-bootstrap-2014.08.01-x86_64.tar.gz
cp root.x86_64/etc/pacman.d/mirrorlist{,.bak}
sed -i '/# Netherlands/,/# [A-Z]/ s/#\(S.*\)/\1/' root.x86_64/etc/pacman.d/mirrorlist
root.x86_64/bin/arch-chroot root.x86_64/
