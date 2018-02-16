#!/bin/bash -x

INSTANCES=20
PORT=2048
NC=ncat
SSL=--ssl

# killall iperf instances
killall $NC 2>/dev/null

for i in `seq $INSTANCES`;
do
	$NC $SSL -k -l $(( $PORT + $i ))  2>&1 >/dev/null &
done
$NC -k -l $(( $PORT ))  2>&1 >/dev/null
