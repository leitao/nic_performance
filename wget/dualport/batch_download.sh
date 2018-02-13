#!/bin/bash

TARGET1=10.1.1.9
TARGET2=192.168.1.9
FILE=vmlinux
PARTS=10
HTTP=http
OUTPUT="-O /dev/null"
FLAGS=" -b --no-check-certificate"

for i in `seq 2 $PARTS`; do
	wget $FLAGS $HTTP://$TARGET2/nvme1/$FILE.part_$i $OUTPUT
	wget $FLAGS $HTTP://$TARGET1/nvme2/$FILE.part_$i $OUTPUT
done
SPEED=$(wget --no-check-certificate $HTTP://$TARGET1/nvme1/$FILE.part_1 2>&1 | grep saved | awk -F'(' '{print $2}' | awk -F')' '{print $1}' | cut -d' ' -f1)

sleep 1

echo "Saving to disk:"
echo "---------------"

echo -n "Streams throughput: "
for z in wget-log*; do
	CURSP=$(cat $z | tail -2 | head -1 | awk -F'(' '{print $2}' | awk -F')' '{print $1}')
	echo -n "$CURSP | "
	MB=$(echo $CURSP | cut -d' ' -f2)
	CURSPE=$(echo $CURSP | cut -d' ' -f1)
	SPEED=$(echo $SPEED + $CURSPE| bc)
done
echo

echo Final Speed: $SPEED $MB

# removing the files downloaded
rm $FILE.part_*
rm wget-log*

