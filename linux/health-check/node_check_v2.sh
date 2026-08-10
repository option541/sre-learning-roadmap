#!/bin/bash

echo "========== Node Check =========="

echo ""

echo "Time:"
date

echo ""

echo "Hostname:"
hostname


echo ""

echo "Disk Usage:"

disk_usage=$(df -h / | awk 'NR==2 {print $5}')

echo "Root Disk Usage: $disk_usage"


disk_usage_num=${disk_usage%\%}


if [ $disk_usage_num -ge 80 ]
then
    echo "WARNING: Disk Usage High"
else
    echo "Disk Status: OK"
fi


echo ""

echo "Memory:"

memory_available=$(free -h | awk 'NR==2 {print $7}')

echo "Available Memory: $memory_available"


echo ""

echo "CPU Load:"

uptime


echo ""

echo "Top CPU Process:"

ps aux --sort=-%cpu | head -5


echo ""

echo "================================="
