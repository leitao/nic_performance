#!/bin/bash

TARGET=$1
USER=brenohl
SSH="ssh $USER@$TARGET"

# killall iperf instances
$SSH killall iperf 2>&1 >/dev/null
$SSH killall iperf3 2>&1 >/dev/null

# restart instances
$SSH iperf -s -D 2>&1 >/dev/null
$SSH iperf3 -s 2>&1 >/dev/null
