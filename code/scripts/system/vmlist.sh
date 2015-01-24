#!/bin/bash
# outputs a two pipe separated list of running virtualbox vms and their cpu time
PSAUXOUT=$(ps aux --sort=time | grep virtualbox | grep startvm)
if [[ "$(echo $PSAUXOUT | wc -c)" -gt "1" ]]; then
	RUNNINGVMS=$(echo "$PSAUXOUT" | awk '{print $13}' | awk 'BEGIN{FS=OFS="_"} {$(NF-2)=$(NF-1)=$(NF)=""; gsub("___","");  print}')
	UPTIMES=$(echo "$PSAUXOUT" | awk '{print $10}')
	i=0
	for vm in $RUNNINGVMS; do
		i=`expr $i + 1`
		echo -n "$vm $(echo $UPTIMES | awk -v nr=$i '{print $nr}' )"
		if [[ "$(echo "$PSAUXOUT" | wc -l)" == "$i" ]]; then
			echo -ne "\n"
		else
			echo -n " || "
		fi

	done
else
	echo "No running VirtualBox vms"
fi
