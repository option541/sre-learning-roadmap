#!/bin/bash

echo "========== HTTP Health Check =========="

echo ""

echo "Time:"

date

echo ""

echo "process check"

process=$(ps aux | grep "http.server 8080" | grep -v grep)

if [ -n "$process" ]
then
    echo "HTTP server process running"
else
    echo "HTTP server process not running"
fi

echo ""

echo "port check"

echo ""

port=8080

if ss -lntp | grep -q $port
then
    echo "8080 port listening"
else
    echo "8080 port not listening"
fi

echo ""

echo "HTTP Check:"

STATUS=$(curl -o /dev/null -s -w "%{http_code}" http://localhost:8080)

echo "HTTP Status: $STATUS"

echo ""

echo "Result:"

if [ -n "$process" ] && ss -lntp | grep -q 8080 && [ "$STATUS" = "200" ]
then
    echo "Service Healthy"
    exit 0
else
    echo "Service Unhealthy"
    exit 1
fi


echo ""
