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
[ ! -f ~/.ssh/ssh_host_rsa_key ] \
	&& ssh-keygen -t rsa -f /etc/ssh/ssh_host_rsa_key
[ ! -f ~/.ssh/ssh_host_dsa_key ] \
	&& ssh-keygen -t dsa -f /etc/ssh/ssh_host_dsa_key
# add remote host public key to known hosts
RPUBK=$(ssh-keyscan -p $PORT $REMOTEHOST)
touch ~/.ssh/known_hosts
grep -q -F "$RPUBK" ~/.ssh/known_hosts \
	|| echo "$RPUBK" | sed '1 ! d' >> ~/.ssh/known_hosts
# add public key to remote host for auto login
ssh-copy-id $USER@$REMOTEHOST -p $PORT
