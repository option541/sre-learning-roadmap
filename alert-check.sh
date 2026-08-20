#!/bin/bash

URL="http://localhost:8080"
STATE_FILE="/home/zihang/sre-learning/failure-count"
THRESHOLD=3

COUNT=$(cat "$STATE_FILE")

STATUS=$(curl -o /dev/null -s -w "%{http_code}" "$URL")
CURL_EXIT_CODE=$?

echo "=============================="
echo "Time: $(date)"
echo "URL: $URL"
echo "HTTP Status: $STATUS"
echo "Curl Exit Code: $CURL_EXIT_CODE"
echo "Previous Failure Count: $COUNT"

if [ "$CURL_EXIT_CODE" -ne 0 ] || [ "$STATUS" != "200" ]
then
    COUNT=$((COUNT + 1))

    echo "$COUNT" > "$STATE_FILE"

    echo "Current Failure Count: $COUNT"

    if [ "$COUNT" -ge "$THRESHOLD" ]
    then
        echo "ALERT: Service Down"
        exit 1
    else
        echo "Warning: Service Failure Detected"
        exit 0
    fi
else
    COUNT=0

    echo "$COUNT" > "$STATE_FILE"

    echo "Current Failure Count: $COUNT"
    echo "Service Healthy"

    exit 0
fi
