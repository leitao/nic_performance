#!/bin/bash

TARGET=$1
USER=brenohl
SSH="ssh $USER@$TARGET"
SSLPORT=2049
PORT=2051

# killall iperf instances
$SSH killall ncat 2>/dev/null

$SSH ncat --ssl -l $SSLPORT 2>&1 >/dev/null
$SSH killall ncat 2>/dev/null

$SSH ncat -l $PORT 2>&1 >/dev/null


$SSH killall ncat 2>/dev/null
