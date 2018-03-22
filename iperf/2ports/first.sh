#!/bin/bash
TIME=${1:-10}

# on POWER9 NODE = 0
NODE=0

numactl -l  -N  $NODE iperf $REVERSE -c $TARGET1 -t $TIME  -P $JOBS 2>&1 > first
