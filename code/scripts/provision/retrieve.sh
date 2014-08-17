#!/bin/bash

# Clone public dotfiles and symlink them to ~, then
# run repostrap. If remote host specified, also clone
# dotfiles from that source via ssh and run repostrap
# example ./retrieve.sh -p 1234 -u username -h example.com

unset USER
unset REMOTEHOST
unset PORT
PORT=22
USER=$(logname)
REMOTEHOST="UNDEFINED"

while getopts "p:u:s:" opt; do
	case "$opt" in
		p)
			PORT="$OPTARG" ;;
		u)
			USER="$OPTARG" ;;
		s)
			REMOTEHOST="$OPTARG" ;;
	esac
done

./repostrap.sh
if [ -d "~/dotfiles" ]; then
	# generate ssh keypair
	[ ! -f ~/.ssh/id_rsa ] \
		&& ssh-keygen -b 4096 -f ~/.ssh/id_rsa -t rsa -N ''
	# add remote host public key to known hosts
	RPUBK=$(ssh-keyscan -p $PORT $REMOTEHOST)
	touch ~/.ssh/known_hosts
	grep -q -F "$RPUBK" ~/.ssh/known_hosts \
		|| echo "$RPUBK" | sed '1 ! d' >> ~/.ssh/known_hosts
	# add public key to remote host for auto login
	ssh-copy-id $USER@$REMOTEHOST -p $PORT

#	git clone ssh://$USER@$REMOTEHOST:$PORT/~/repo/dotfiles.git 
fi;
