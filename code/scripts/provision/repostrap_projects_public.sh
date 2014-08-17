#!/bin/sh
cd ~
mkdir -p "code/configs" ; cd "code/configs" && (
	[ ! -d "vagrantfiles" ] \
		&& git clone https://github.com/vdloo/vagrantfiles \
			|| (	cd vagrantfiles \
					&& git pull
			)
)
cd ~
mkdir -p "code/configs" ; cd "code/configs" && (
	[ ! -d "dockerfiles" ] \
		&& git clone https://github.com/vdloo/dockerfiles \
			|| (	cd dockerfiles \
					&& git pull
			)
)
cd ~
mkdir -p "code/projects" ; cd "code/projects" && (
	[ ! -d "daust" ] \
		&& git clone https://github.com/vdloo/daust \
			|| (	cd daust \
					&& git pull
			)
)
cd ~
mkdir -p "code/projects" ; cd "code/projects" && (
	[ ! -d "SICP" ] \ 
		&& git clone https://github.com/vdloo/SICP \
			|| (	cd SICP \
					&& git pull
			)
)
