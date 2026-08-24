#!/bin/bash

URL="${1:-http://localhost:8080}"
PORT=8080
THRESHOLD=3

echo "======================================"
echo "        SRE Self-Healing"
echo "======================================"
echo "Time: $(date)"
echo "URL: $URL"
echo ""

STATUS=$(curl -o /dev/null -s -w "%{http_code}" "$URL")
CURL_EXIT_CODE=$?

echo "HTTP Status: $STATUS"
echo "Curl Exit Code: $CURL_EXIT_CODE"

if [ "$CURL_EXIT_CODE" -eq 0 ] && [ "$STATUS" = "200" ]
then
    echo ""
    echo "Service Healthy"
    exit 0
fi

echo ""
echo "Service Failure Detected"
echo "Attempting recovery..."

echo ""

echo "Checking process..."

PROCESS=$(ps aux | grep "http.server $PORT" | grep -v grep)

if [ -n "$PROCESS" ]
then
    echo "Process exists"
else
    echo "Process not running"
fi

echo ""
echo "Restarting service..."

nohup python3 -m http.server "$PORT" > /tmp/http-server.log 2>&1 &

sleep 2

echo ""
echo "Recovery Check..."

STATUS=$(curl -o /dev/null -s -w "%{http_code}" "$URL")
CURL_EXIT_CODE=$?

echo "HTTP Status: $STATUS"
echo "Curl Exit Code: $CURL_EXIT_CODE"

if [ "$CURL_EXIT_CODE" -eq 0 ] && [ "$STATUS" = "200" ]
then
    echo ""
    echo "RECOVERY SUCCESS"
    exit 0
else
    echo ""
    echo "RECOVERY FAILED"
    exit 1
fi
