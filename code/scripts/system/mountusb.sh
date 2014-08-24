#!/bin/bash
USBDEVICE=$(echo "/dev/$(dmesg | grep Attached | tail -n 1 | awk '$0=$2' FS=[ RS=] | tail -n 1)1")
CURRENTLYMOUNTED=$(df -h /mnt/usb | awk 'FNR == 2 {print $1}')
CURRENTLYLOCATION=$(df -h /mnt/usb | awk 'FNR == 2 {print $6}')
ROOTSLASH=$(echo "/")
if [ $USBDEVICE = $CURRENTLYMOUNTED ];
then
	echo "$USBDEVICE is already mounted on /mnt/usb";
else
	if [ $CURRENTLYLOCATION != $ROOTSLASH ];then
		echo "$CURRENTLYMOUNTED is currently mounted on /mnt/usb, dismounting now..";
		umount /mnt/usb;
		if [ $(echo $?) -lt 1 ];then
			echo "dismounted $CURRENTLYMOUNTED successfully";
		else
			read -p "can not dismount $CURRENTLYMOUNTED, force dismount? (y/n)";
			[ "$REPLY" == "y" ] || umount -f -l /mnt/usb;
			#sudo fuser -km /mnt/usb;
		fi;
	fi;
	echo "mounting $USBDEVICE"
	mount -t auto $USBDEVICE /mnt/usb;
fi;

