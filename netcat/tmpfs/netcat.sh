#!/bin/bash

TARGET1=10.1.1.8
TARGET2=192.168.1.8
FILE=bigimage
NUMA="numactl -l"
PORT=2048
NC=ncat
INSTANCES=20


echo Target: $TARGET
echo File: $FILE
echo ---------------
#./set_target.sh $TARGET &

sleep 1

for i in `seq 1 2 $INSTANCES` ;
do
	echo "Starting instance: " $i
	dd if=/data/ram/$FILE bs=1024K 2> /tmp/nc_1_$i | $NC $TARGET1 $(( $PORT + $i )) &
	dd if=/data/ram/$FILE bs=1024K 2> /tmp/nc_2_$i | $NC $TARGET2 $(( $PORT + $i + 1 )) &
done
	dd if=/data/ram/$FILE bs=1024K 2> /tmp/nc_1_0 | $NC $TARGET1 $PORT
	dd if=/data/ram/$FILE bs=1024K 2> /tmp/nc_2_0 | $NC $TARGET2  $(( $PORT + 1))


sleep 2
TOTAL=0

for z in /tmp/nc_*; do
	MB=$( tail -1 $z | awk '{printf $(NF-1)}') 
	TOTAL=$(( $TOTAL + $MB ))
done
echo -n $(( $TOTAL * 8  / 1000 ))
echo Gbps

rm /tmp/nc_*
