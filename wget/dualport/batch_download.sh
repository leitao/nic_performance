#!/bin/bash  -x

TARGET1=10.1.1.9
TARGET2=192.168.1.9
FILE=vmlinux
PARTS=3
HTTP=http
OUTPUT="-O /dev/null"
FLAGS=" --no-check-certificate"
DIR1=nvme1
DIR2=nvme2

rm wget-log*
for i in `seq 2 $PARTS`; do
	wget $FLAGS $HTTP://$TARGET2/$DIR2/$FILE.part_$i $OUTPUT -o wget-log$i &
	wget $FLAGS $HTTP://$TARGET1/$DIR1/$FILE.part_$i $OUTPUT -o wget-log2$i &
done
wget --no-check-certificate $HTTP://$TARGET1/$DIR1/$FILE.part_1 $OUTPUT -o wget-log1

for job in `jobs -p` ; do
    echo "Waiting Job: " $job
    wait $job 
done


SPEED=0
echo -n "Streams throughput: "
for z in wget-log*; do
	CURSP=$(cat $z | tail -2 | head -1 | awk -F'(' '{print $2}' | awk -F')' '{print $1}')
	echo -n "$CURSP | "
	MB=$(echo $CURSP | cut -d' ' -f2)
	CURSPE=$(echo $CURSP | cut -d' ' -f1)
	SPEED=$(echo $SPEED + $CURSPE| bc)
done
echo
FSPEED=$(echo "scale=2 ; $SPEED * 8 / 1000" | bc)

echo Final Speed: $FSPEED Gbps 

# removing the files downloaded
rm $FILE.part_*

