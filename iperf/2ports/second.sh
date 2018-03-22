#!/bin/bash

TIME=${1:-10}

# on POWER9 NODE = 0
NODE=0

numactl -l -N $NODE iperf -c $TARGET2 $REVERSE -p 5010 -t $TIME -P $JOBS 2>&1 > second
