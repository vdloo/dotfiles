#!/bin/bash

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

# generate ssh private key
[ ! -f ~/.ssh/id_rsa ] \
	&& ssh-keygen -b 4096 -f ~/.ssh/id_rsa -t rsa -N ''
# add public key to remote host for auto login
ssh-copy-id "$USER@$REMOTEHOST -p $PORT"
