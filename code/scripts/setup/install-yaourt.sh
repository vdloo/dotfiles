#!/bin/bash
sudo pacman -Syy --noconfirm base-devel wget

# download and install package-query-git from pkgbuild
rm -Rf /tmp/package-query-git
mkdir -p /tmp/package-query-git && cd /tmp/package-query-git && \
  (wget -q https://aur.archlinux.org/cgit/aur.git/plain/PKGBUILD?h=package-query-git -O PKGBUILD; \
    makepkg -s --noconfirm && \
    sudo pacman -U --noconfirm package-query-git*.pkg.tar.xz)

# download and install yaourt from git
rm -Rf /tmp/yaourt
mkdir -p /tmp/yaourt && cd /tmp/yaourt && \
  (wget --no-check-certificate https://github.com/archlinuxfr/yaourt/archive/master.tar.gz
    (tar -xzvf master.tar.gz && \
      cd yaourt-master/package && \
      makepkg && \
      sudo pacman -U --noconfirm yaourt*.pkg.tar.xz))
