#!/bin/bash  

# Arguments: 

TARGET1=10.1.1.9
TARGET2=192.168.1.9
FILE=vmlinux
PARTS=8
HTTP=http
OUTPUT="-O /dev/null"
FLAGS=" --no-check-certificate"
DIR1=nvme1
DIR2=nvme1
PORTS=2

while getopts ":21rbshp:" opt; do
  case $opt in
    b)
      FILE=bigimage
      ;;
    h)
      echo "Test time: HTTP"
      HTTP=http
      ;;
    s)
      echo "Test time: HTTPS"
      HTTP=https
      ;;
    p)
      PARTS=$OPTARG
      ;;
    r)
      DIR1=ramfs
      DIR2=ramfs
      ;;
    2)
      PORTS=2
      ;;
    1)
      PORTS=1
      ;;
    ?)
      echo "Invalid option: -$OPTARG" >&2
      exit
      ;;
  esac
done

echo "Benchmark start"
echo "HTTP method: " $HTTP
echo "Using " $PARTS " streams per port"
echo "File: " $FILE
echo "PORTS: " $PORTS

rm wget-log* 2> /dev/null
for i in `seq 2 $PARTS`; do
	wget $FLAGS $HTTP://$TARGET2/$DIR2/$FILE.part_$i $OUTPUT -o wget-log$i &
	if [ "$PORTS" -eq "2" ]; then
		wget $FLAGS $HTTP://$TARGET1/$DIR1/$FILE.part_$i $OUTPUT -o wget-log2$i &
	fi
done
wget --no-check-certificate $HTTP://$TARGET2/$DIR2/$FILE.part_1 $OUTPUT -o wget-log21
if [ "$PORTS" -eq "2" ]; then
	wget --no-check-certificate $HTTP://$TARGET1/$DIR1/$FILE.part_1 $OUTPUT -o wget-log1
fi

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
rm $FILE.part_* 2> /dev/null

