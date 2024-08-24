#!/bin/bash
#ifconfig eth0 | grep 'inet ' | awk '{ print $2 }'

IP=$(ifconfig eth0 | grep 'inet ' | awk '{ print $2 }')
echo "{\"ip\": \"$IP\"}"