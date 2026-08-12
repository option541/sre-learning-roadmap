#!/bin/bash

URL="http://localhost:8080"

STATUS=$(curl -o /dev/null -s -w "%{http_code}" $URL)

echo "HTTP Status: $STATUS"

if [ "$STATUS" = "200" ]; then
    echo "Service Healthy"
else
    echo "Service Unhealthy"
fi
