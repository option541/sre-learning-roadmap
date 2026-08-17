#!/bin/bash

if [ "$#" -ne 1 ]
then
    echo "Usage: $0 <URL>"
    exit 2
fi
URL="$1"

echo "========== HTTP Health Check =========="
echo ""

echo "Time:"
date

echo ""

echo "URL:"
echo "$URL"

echo ""

STATUS=$(curl -o /dev/null -s -w "%{http_code}" "$URL")
CURL_EXIT_CODE=$?

echo "HTTP Status: $STATUS"
echo "Curl Exit Code: $CURL_EXIT_CODE"

echo ""

echo "Result:"

if [ "$CURL_EXIT_CODE" -ne 0 ]
then
    echo "Connection Failure"
    exit 1
fi

if [ "$STATUS" = "200" ]
then
    echo "Healthy"
    exit 0
fi

echo "HTTP/Application Failure"
exit 1
