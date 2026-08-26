#!/bin/bash

URL="${1:-http://localhost:8080}"
FAILURE_FILE="failure-count"
ALERT_STATE_FILE="alert-state"
THRESHOLD=3

echo "=============================="
echo "Time: $(date)"
echo "URL: $URL"

STATUS=$(curl -o /dev/null -s -w "%{http_code}" "$URL")
CURL_EXIT_CODE=$?

COUNT=$(cat "$FAILURE_FILE" 2>/dev/null || echo 0)
ALERT_STATE=$(cat "$ALERT_STATE_FILE" 2>/dev/null || echo "OK")

echo "HTTP Status: $STATUS"
echo "Curl Exit Code: $CURL_EXIT_CODE"
echo "Previous Failure Count: $COUNT"
echo "Alert State: $ALERT_STATE"

echo ""

if [ "$CURL_EXIT_CODE" -eq 0 ] && [ "$STATUS" = "200" ]
then

    COUNT=0
    echo "$COUNT" > "$FAILURE_FILE"

    if [ "$ALERT_STATE" = "ALERT" ]
    then
        echo "RECOVERY: Service Recovered"
        echo "OK" > "$ALERT_STATE_FILE"
    else
        echo "Service Healthy"
    fi

    exit 0

else

    COUNT=$((COUNT + 1))
    echo "$COUNT" > "$FAILURE_FILE"

    if [ "$COUNT" -ge "$THRESHOLD" ]
    then

        if [ "$ALERT_STATE" = "OK" ]
        then
            echo "ALERT: Service Down"
            echo "ALERT" > "$ALERT_STATE_FILE"
        else
            echo "Alert already active - no duplicate alert"
        fi

    else
        echo "Warning: Service Failure Detected"
    fi

    exit 1

fi
