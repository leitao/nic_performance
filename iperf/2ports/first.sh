#!/bin/bash -x
TIME=${1:-10}
numactl -l iperf -c $TARGET1 -t $TIME  -P 8 2>&1 > first
