#!/bin/bash -x
iperf -c 192.168.1.8  -P 8 2>&1 > first
