#!/bin/bash -x

TIME=${1:-10}
numactl -l iperf -c 10.1.1.8 -t $TIME -P 8 2>&1 > second
