#!/bin/bash
TARGET1=10.1.1.8
TARGET2=192.168.1.8
TIME=8

./first.sh &
./second.sh & 

sleep 1
./cpu_utilization.sh cpu.txt

sleep $TIME

tail -1 second
tail -1 first
cat cpu.txt

rm second first cpu.txt
