#!/bin/bash 

IPERF=/usr/bin/iperf
IPERF3=/usr/bin/iperf3
TARGET=localhost
NUMA="numactl -l"

#DEBUG=0

if [ -n "$DEBUG" ] ; then
	echo "DEBUG ENABLED"
	set -x
fi


echo Multiple Stream
for i in 1 2 8 32; do
	echo -n $i " Stream(s): "
	./cpu_utilization.sh cpu_$i & 
	if [ -n "$DEBUG" ] ; then
		$IPERF3 -c $TARGET -P $i
	else
		RESULT=$($NUMA $IPERF3 -c $TARGET -P $i  2> /dev/null | tail -4 | head -1 );
		echo $RESULT | awk -F"GBytes" '{print $2}' | awk '{printf $1 " " $2}'
	fi
	CPU_UTILIZATION=$(cat cpu_$i);
	echo " (CPU utilization: " $CPU_UTILIZATION  ")"
done

echo Multiples Thread
for i in 1 3 4 8; do
	echo -n $i " Thread(s): "
	./cpu_utilization.sh cpu_$i & 
	if [ -n "$DEBUG" ] ; then
		$IPERF -c $TARGET -P $i;
	else
		RESULT=$($NUMA $IPERF -c $TARGET -P $i 2> /dev/null | tail -1);
		echo -n $RESULT | awk -F'GBytes' '{printf $2}'
	fi
	CPU_UTILIZATION=$(cat cpu_$i);
	echo " (CPU utilization: " $CPU_UTILIZATION  ")"
		
done
