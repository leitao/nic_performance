#!/bin/bash

TARGET1=10.1.1.8
TARGET2=192.168.1.8
FILE=bigimage
NUMA="numactl -l"
PORT=2048
FILESIZE=$(stat -c%s "$FILE")
NC=ncat
INSTANCES=20


echo Target: $TARGET
echo File: $FILE
echo Size:  $FILESIZE
echo ---------------
#./set_target.sh $TARGET &

sleep 1

./cpu_utilization.sh utilization.txt & 
for i in `seq 1 2 $INSTANCES` ;
do
	echo "Starting instance: " $i
	dd if=/data/nvme1/$FILE bs=1024K count=512 2> /tmp/nc_1_$i | $NC $TARGET1 $(( $PORT + $i )) &
	dd if=/data/nvme2/$FILE bs=1024K count=512 2> /tmp/nc_2_$i | $NC $TARGET2 $(( $PORT + $i + 1 )) &
done
	dd if=/data/nvme1/$FILE bs=1024K count=512 2> /tmp/nc_1_0 | $NC $TARGET1 $PORT
	dd if=/data/nvme2/$FILE bs=1024K count=512 2> /tmp/nc_2_0 | $NC $TARGET2  $(( $PORT + 1))


sleep 2
TOTAL=0

for z in /tmp/nc_*; do
	MB=$( tail -1 $z | awk '{printf $(NF-1)}') 
	TOTAL=$(( $TOTAL + $MB ))
done
echo -n $(( $TOTAL * 8  / 1000 ))
echo Gbps

rm /tmp/nc_*
