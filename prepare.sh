#!/bin/bash

iptables -F

echo "NUMA node on POWER9"
cat /sys/class/net/enP48p1s0f0/device/numa_node
cat /sys/class/net/enP48p1s0f1/device/numa_node

echo "NUMA node on POWER8:"
cat /sys/class/net/eth2/device/numa_node
cat /sys/class/net/eth4/device/numa_node

echo "Setting cpu governor to performance:"
cpupower frequency-set --governor performance

echo "Setting sysctl parameters"
sysctl -w net.core.rmem_max=268435456
sysctl -w net.core.wmem_max=268435456

sysctl -w net.ipv4.tcp_rmem="4096 87380 134217728"
sysctl -w net.ipv4.tcp_wmem="4096 65536 134217728"


sysctl -w net.core.netdev_max_backlog=250000

# don't cache ssthresh from previous connection
sysctl -w net.ipv4.tcp_no_metrics_save=1

sysctl -w net.ipv4.tcp_congestion_control=htcp

# If you are using Jumbo Frames, also set this
sysctl -w net.ipv4.tcp_mtu_probing=1

# recommended for CentOS7/Debian8 hosts
sysctl -w net.core.default_qdisc=fq


sysctl -w net.core.somaxconn=8192

# turn off smt
sudo ppc64_cpu --smt=off

# turn off irqbalance
sudo systemctl stop irqbalance



## Turn on large receive offload

sudo ethtool -K eth4 lro off
sudo ethtool -K eth2 lro off
sudo ethtool -K enP48p1s0f0 lro off
sudo ethtool -K enP48p1s0f1 lro off

