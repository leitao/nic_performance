#!/bin/bash -x
TIME=${1:-10}
iperf -c 192.168.1.8 -t $TIME  -P 8 2>&1 > first
