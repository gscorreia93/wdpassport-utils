#!/bin/bash

dev=$(udisksctl status | grep "WD My Passport" | tail -c 9)

pushd ~/wdpassport-utils &> /dev/null

raw=$(sudo sg_raw -r 32 /dev/$dev c0 45 00 00 00 00 00 00 30 2>&1)
state=$(echo $raw | egrep -o "data:(\ [0-9]{2}){5}" | tail -c 2)

if [[ "$state" -eq 1 ]] ; then
	sudo sg_raw -s 40 -i password.bin /dev/$dev c1 e1 00 00 00 00 00 00 28 00
	echo WD Passport unlocked...
elif [[ "$state" -eq 2 ]] ; then
	echo WD Passport is already unlocked...
else
	echo Initializing please wait...
fi
	
popd &> /dev/null

