#!/usr/bin/env sh

# example: ./latestsync.sh -h s2.example.com -u someusername -p 1337 -l ~/Videos

[ -z "$HOSTNAME" ] && TEMPSTOR="UNKNOWN_HOSTNAME" || TEMPSTOR="$HOSTNAME"

# Some defaults
#PYTHONPATH="/volume1/@appstore/python/bin/python2.7" 			# For older synology systems
PYTHONPATH="/usr/bin/python" 						# Python binary location on the remote machine
SCRIPTPATH="/volume1/RAID5/other/code/scripts/system/latestfilter.py" 	# Filter script location on the remote machine
ORIGDIR="/volume1/RAID5/series/"					# Dir of file collection on the remote machine
LOCALDIR="$HOME/Downloads/series"					# Dir for the synced data on the local machine
ALLOCATEDSPACE="300000000000" 						# Default value of how much bytes to sync 300G				

unset REMOTEHOST
PORT="22"
USER=$(whoami)

while getopts "y:s:o:d:l:a:h:p:u:t:" opt; do
	case "$opt" in
		y)
			PYTHONPATH="$OPTARG" ;;
		s)
			SCRIPTPATH="$OPTARG" ;;
		o)
			ORIGDIR="$OPTARG" ;;
		d)
			DESTDIR="$OPTARG" ;;
		l)
			LOCALDIR="$OPTARG" ;;
		a)
			ALLOCATEDSPACE="$OPTARG" ;;
		h)
			REMOTEHOST="$OPTARG" ;;
		p)
			PORT="$OPTARG" ;;
		u)
			USER="$OPTARG" ;;
		t)
			TEMPSTOR="$OPTARG" ;; 				# Temp directory name overwrite for $HOSTNAME
	esac
done

DESTDIR="/volume1/RAID5/other/latest/$TEMPSTOR"				# Symlink storage folder on the remote machine

if [ -z "$REMOTEHOST" ]; then
	echo "Specify a remote host with the -h flag"
else
	if ssh -p $PORT $USER@$REMOTEHOST -q "echo 2>&1"; then
		# if plock older than uptime, delete.
		plockdir="$HOME/.smallsync$(echo "$LOCALDIR" | md5sum | awk '{print $1}').plock"
		find $plockdir -type d -mmin +$(expr $(cat /proc/uptime | cut -d'.' -f1) / 60 + 1) -delete
		if mkdir $plockdir; then
			trap "rm -R $plockdir" INT TERM EXIT
			ssh -p $PORT $USER@$REMOTEHOST -q "$PYTHONPATH $SCRIPTPATH -f $ORIGDIR -t $DESTDIR -a $ALLOCATEDSPACE -v"
			rsync --rsync-path=/usr/syno/bin/rsync -L --rsh="ssh -p $PORT" -avz $USER@$REMOTEHOST:$DESTDIR $LOCALDIR --delete --progress
			rm -R $plockdir;
			trap - INT TERM EXIT
		else
			echo "sync already running in background (if not delete the .plock file manually)"
		fi;
	else
		echo "Failed to connect to the remote system over ssh."
	fi;
fi;
