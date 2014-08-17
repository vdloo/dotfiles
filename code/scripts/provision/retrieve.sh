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
#if [ -d "~/.dotfiles" ]; then
#	git clone ssh://$USER@$REMOTEHOST:$PORT/~/repo/dotfiles.git 
#fi;
