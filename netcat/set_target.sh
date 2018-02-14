#!/bin/bash

TARGET=$1
SSH="ssh $TARGET"
PORT=2048
NC=ncat

# killall iperf instances
$SSH killall $NC 2>/dev/null

$SSH nc -l $PORT 2>&1 >/dev/null


