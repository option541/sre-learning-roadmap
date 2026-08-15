#!/bin/bash

URL="http://localhost:8080/health"

echo "========== HTTP Health Check =========="
echo ""

echo "Time:"
date

echo ""

echo "Process Check:"
if ps aux | grep "[a]pp.py" > /dev/null
then
    echo "HTTP service process is running"
else
    echo "HTTP service process is NOT running"
fi

echo ""

echo "Port Check:"
if ss -lntp | grep -q ":8080"
then
    echo "8080 port is listening"
else
    echo "8080 port is NOT listening"
fi

echo ""

echo "HTTP Check:"
STATUS=$(curl -o /dev/null -s -w "%{http_code}" "$URL")

echo "HTTP Status: $STATUS"

echo ""

echo "Result:"

if [ "$STATUS" = "200" ]
then
    echo "Service Healthy"
else
    echo "Service Unhealthy"
fi

echo ""
echo "======================================"
