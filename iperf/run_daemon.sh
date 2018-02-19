#!/bin/bash

# killall iperf instances
killall iperf 2>&1 >/dev/null
killall iperf3 2>&1 >/dev/null

# restart instances
iperf -s -D 2>&1 >/dev/null
iperf3 -s -D 2>&1 >/dev/null
