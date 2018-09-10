#!/bin/sh

echo $(ping -c1 $NODEJS_IP | sed -nE 's/^PING[^(]+\(([^)]+)\).*/\1/p') nodejs >> /etc/hosts
