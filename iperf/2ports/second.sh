#!/bin/bash -x

TIME=${1:-10}
numactl -l iperf -c $TARGET2 -t $TIME -P 8 2>&1 > second
