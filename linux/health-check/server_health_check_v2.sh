#!/bin/bash


echo "========== SRE Health Check =========="


TIME=$(date)

HOST=$(hostname)


echo "Time:"
echo $TIME


echo ""

echo "Hostname:"
echo $HOST


echo ""

echo "Disk Usage:"
df -h /


echo ""

echo "Memory:"
free -h


echo ""

echo "CPU:"
uptime


echo "======================================"
