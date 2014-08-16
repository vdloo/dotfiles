#!/bin/bash
# sets up a box with some preferred configurations

# updates system and installs packages, 
# then runs retrieve.sh script to clone
# public repos (and private if specified).

# example ./bootstrap.sh -p 1234 -u username -h example.com -n vagrant

if [ "$(id -u)" != "0" ]; then
	echo "Run this script as root"
else 
	unset USER
	unset REMOTEHOST
	unset PORT
	unset NONROOT
	PORT=22
	USER=$(whoami)
	REMOTEHOST=0

	while getopts "p:u:s:n:" opt; do
		case "$opt" in
			p)
				PORT="$OPTARG" ;;
			u)
				USER="$OPTARG" ;;
			s)
				REMOTEHOST="$OPTARG" ;;
			n)
				NONROOT="$OPTARG" ;;
		esac
	done

	if [ "$REMOTEHOST" != 0 ]; then
		# if executed during vagrant provisioning, copy scripts to home
		if [ -d "/vagrant" ]; then
			cp /vagrant/* /home/vagrant/
		fi;

		# update box and install specified programs
		[ -f "setup.sh" ] && ./setup.sh

		if [ "$REMOTEHOST" == "-p" ]; then
			echo "run retrieve.sh after logging in to continue provisioning from private repos"
		else
			# copy public key and clone into dotfiles,
			# then run relevant scripts
			su $NONROOT -c "./dotfiles/scripts/retrieve.sh -u $USER -p $PORT -s $REMOTEHOST"
		fi;
	else
		echo 'ERROR: no remote host specified. example: sudo ./bootstrap -s s1.example.com';
	fi
fi;
