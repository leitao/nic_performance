#!/bin/bash 

IPERF=/usr/bin/iperf
IPERF3=/usr/bin/iperf3
TARGET=localhost


echo Multiples Thread
for i in 1 2 4 8 16 32; do
	echo -n $i " Thread(s): "
	RESULT=$($IPERF -c $TARGET -P $i 2> /dev/null | tail -1);
	echo $RESULT | awk -F'GBytes' '{print $2}'
done

echo Multiple Stream
for i in 1 2 4 8 16 32; do
	echo -n $i " Stream (s): "
	RESULT=$($IPERF3 -c $TARGET -P $i  2> /dev/null | tail -4 | head -1 );
	echo $RESULT | awk -F"GBytes" '{print $2}' | awk '{print $1 " " $2}'
done
