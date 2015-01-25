#!/usr/bin/env bash
[ ! -d xbmc ] && git clone https://github.com/xbmc/xbmc || (cd xbmc; git fetch; git reset --hard origin/master)
cd xbmc
# libcec breaks compilation on Debian Jessie Sun Jan 25 10:38:28 CET 2015 
# because libcec support needs libcec-dev 2.2.0, currently this package
# is only available in [ experimental ] https://packages.debian.org/experimental/libcec-dev
# add --enable-libcec=no as a flag for ./configure to disable peripherals
./bootstrap \
	&& ./configure \
		--disable-optical-drive \
		--disable-dvdcss \
	&& make clean \
	&& make -j 4 \
	&& sudo make install
