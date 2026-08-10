#!/bin/bash


echo "========== System Monitor =========="


echo ""

echo "Time:"
date


echo ""

echo "CPU Load:"
uptime


echo ""

echo "Memory:"
free -h


echo ""

echo "Top Process:"
ps aux --sort=-%cpu | head -5


echo ""

echo "===================================="
