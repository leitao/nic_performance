#!/bin/bash

# killall iperf instances
killall iperf 2>&1 >/dev/null
killall iperf3 2>&1 >/dev/null

#legacy
iperf3 -s -D 2>&1 >/dev/null

# for 192 connection
numactl -l -N 0 iperf -s -p 5001 -D 2>&1 >/dev/null

# for 10. connection
numactl -l -N 0 iperf -s -p 5010 -D 2>&1 >/dev/null
