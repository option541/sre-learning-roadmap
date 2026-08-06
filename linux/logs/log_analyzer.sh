#!/bin/bash


LOG_FILE=$1


echo "======== Error API Report ========"

echo ""

echo "Total Errors:"

grep -vc "200" $LOG_FILE


echo ""

echo "Top Error APIs:"

grep -v "200" $LOG_FILE | awk '{print $4}' | sort | uniq -c | sort -nr
