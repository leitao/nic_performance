#!/bin/bash

TARGET=$1
USER=brenohl
SSH="ssh $USER@$TARGET"
PORT=2048

# killall iperf instances
$SSH killall nc 2>/dev/null

$SSH nc -l $PORT 2>&1 >/dev/null


