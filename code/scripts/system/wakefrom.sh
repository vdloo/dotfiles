#!/bin/bash
# example: wakefrom.sh -u user -s example.com -m 00:00:00:00:00:00 -P /volume1/@appstore/python/bin/

PORT=22
USER=$(whoami)
REMOTEHOST=0
MAC="00:00:00:00:00:00"
RPATH=""
while getopts "p:u:s:m:P:" opt; do
	case "$opt" in
		p)
			PORT="$OPTARG" ;;
		u)
			USER="$OPTARG" ;;
		s)
			REMOTEHOST="$OPTARG" ;;
		m)
			MAC="$OPTARG" ;;
		P)
			RPATH="$OPTARG" ;;
	esac
done

h1=$(echo $MAC | cut -d':' -f1)
h2=$(echo $MAC | cut -d':' -f2)
h3=$(echo $MAC | cut -d':' -f3)
h4=$(echo $MAC | cut -d':' -f4)
h5=$(echo $MAC | cut -d':' -f5)
h6=$(echo $MAC | cut -d':' -f6)
ssh -p $PORT $USER@$REMOTEHOST -x "${RPATH}python -c \"import socket; s=socket.socket(socket.AF_INET, socket.SOCK_DGRAM); s.setsockopt(socket.SOL_SOCKET, socket.SO_BROADCAST, 1); s.sendto('\xff'*6+'\x$h1\x$h2\x$h3\x$h4\x$h5\x$h6'*16, ('<broadcast>', 7));\""
