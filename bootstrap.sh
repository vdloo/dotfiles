#!/bin/bash
# sets up a box with some preferred configurations

# updates system and installs packages, 
# then runs retrieve.sh script to clone
# public repos (and private if specified).

# example ./bootstrap.sh -p 1234 -u username -h example.com -n vagrant

PROVISIONURL="https://raw.githubusercontent.com/vdloo/dotfiles/master/code/scripts/provision"

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

		# download scripts from GitHub
		RETRURL="${PROVISIONURL}/retrieve.sh"
		[ ! -f "retrieve.sh" ] \
			&& wget -A.sh "$RETRURL" \
			&& chmod u+x retrieve.sh \
			&& chown $NONROOT retrieve.sh
		REPOURL="${PROVISIONURL}/repostrap.sh"
		[ ! -f "repostrap.sh" ] \
			&& wget -A.sh "$REPOURL" \
			&& chmod u+x repostrap.sh \
			&& chown $NONROOT repostrap.sh

		# if remote host specified also provision from private repos through ssh
		if [ "$REMOTEHOST" == "-p" ]; then
			su $NONROOT -c "./retrieve.sh"
			echo "run retrieve.sh after logging in to continue provisioning from private repos"
		else
			su $NONROOT -c "./retrieve.sh -u $USER -p $PORT -s $REMOTEHOST"
		fi;

		# cleanup provision scripts
		[ -f "Vagrantfile" ]  && rm Vagrantfile
		[ -f "retrieve.sh" ]  && rm retrieve.sh
		[ -f "repostrap.sh" ] && rm repostrap.sh
	else
		echo 'ERROR: no remote host specified. example: sudo ./bootstrap -s s1.example.com';
	fi
fi;
