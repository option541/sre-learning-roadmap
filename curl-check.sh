#!/bin/bash

if [ "$#" -ne 1 ]
then
    echo "Usage: $0 <URL>"
    exit 2
fi

URL="$1"
LOG_FILE="/home/zihang/sre-learning/health-check.log"

echo "========== HTTP Health Check =========="
echo ""

echo "Time:"
date

echo ""

echo "URL:"
echo "$URL"

echo ""

STATUS=$(/usr/bin/curl -o /dev/null -s -w "%{http_code}" "$URL")
CURL_EXIT_CODE=$?

echo "HTTP Status: $STATUS"
echo "Curl Exit Code: $CURL_EXIT_CODE"

echo ""

echo "Result:"

TIMESTAMP=$(date '+%Y-%m-%d %H:%M:%S')

if [ "$CURL_EXIT_CODE" -ne 0 ]
then
    echo "Connection Failure"

    echo "$TIMESTAMP URL=$URL HTTP_STATUS=$STATUS CURL_EXIT=$CURL_EXIT_CODE RESULT=CONNECTION_FAILURE" >> "$LOG_FILE"

    exit 1
fi

if [ "$STATUS" = "200" ]
then
    echo "Healthy"

    echo "$TIMESTAMP URL=$URL HTTP_STATUS=$STATUS CURL_EXIT=$CURL_EXIT_CODE RESULT=HEALTHY" >> "$LOG_FILE"

    exit 0
fi

echo "HTTP/Application Failure"

echo "$TIMESTAMP URL=$URL HTTP_STATUS=$STATUS CURL_EXIT=$CURL_EXIT_CODE RESULT=HTTP_FAILURE" >> "$LOG_FILE"

exit 1
