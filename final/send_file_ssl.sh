#!/bin/bash 

TARGET=${1:-localhost}    
FILE=${2:0}
NUMA="numactl -l"
SSLPORT=2049
PORT=2051
FILESIZE=$(stat -c%s "$FILE")


echo Target: $TARGET
echo File: $FILE
echo Size:  $FILESIZE
echo ---------------
./set_target.sh $TARGET &

sleep 1

echo "With SSL"
./cpu_utilization.sh utilization.txt & 
OUTPUT=$( { dd if=$FILE bs=1024K count=512 | ncat --ssl $TARGET $SSLPORT; } 2>&1 )
echo -n "Throughput: "
echo -n $OUTPUT | awk '{printf $(NF-1) $NF}'
echo -n " - CPU Utilization: "
cat utilization.txt
rm utilization.txt

echo "Without SSL"
sleep 1
./cpu_utilization.sh utilization.txt & 
OUTPUT=$( { dd if=$FILE bs=1024K count=512 | ncat $TARGET $PORT; } 2>&1 )
echo -n "Throughput: "
echo -n $OUTPUT | awk '{printf $(NF-1) $NF}'
echo -n " - CPU Utilization: "
cat utilization.txt

exec 2>/dev/null
rm utilization.txt

killall set_target.sh 
