#!/bin/bash
TARGET1=10.1.1.8
TARGET2=192.168.1.8
TIME=10
OPTS=""
JOBS=8

while getopts ":rp:t:" opt; do
  case $opt in
    p)
      JOBS=$OPTARG
      ;;
    r)
      REVERSE=-R
      ;;
    t)
      TIME=$OPTARG
      ;;
    ?)
      echo "Invalid option: -$OPTARG" >&2
      exit
      ;;
  esac
done

export TARGET1 TARGET2 OPTS JOBS

echo "Iperf test starting...."
echo "Streams/port : " $JOBS
echo "Time         : " $TIME
echo "Reverse      : " $REVERSE

./first.sh $TIME &
./second.sh $TIME  & 

for jobs in `jobs -p`; do
	wait $jobs
done

tail -1 second
tail -1 first

