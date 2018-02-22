#!/bin/bash
TARGET1=10.1.1.9
TARGET2=192.168.1.9
TIME=${1:-10}
OPTS=""


export TARGET1 TARGET2 OPTS

./first.sh $TIME &
./second.sh $TIME  & 


sleep 1
./cpu_utilization.sh cpu.txt

for jobs in `jobs -p`; do
	wait $jobs
done

tail -1 second
tail -1 first
cat cpu.txt

rm second first cpu.txt
