#!/bin/bash

CONTAINER="cpu-timeout-demo"
FAILURE_FILE="/tmp/${CONTAINER}-failure-count"
MAX_FAILURES=3

status=$(sudo docker inspect -f '{{.State.Status}}' "$CONTAINER" 2>/dev/null)
health=$(sudo docker inspect -f '{{.State.Health.Status}}' "$CONTAINER" 2>/dev/null)
restart=$(sudo docker inspect -f '{{.RestartCount}}' "$CONTAINER" 2>/dev/null)

echo "===== Docker Self-Healing ====="
echo "container: $CONTAINER"
echo "status:    $status"
echo "health:    $health"
echo "restart:   $restart"

if [ "$status" != "running" ]; then
    echo "ALERT: container is not running"

    sudo docker start "$CONTAINER"

    echo "ACTION: container started"
    rm -f "$FAILURE_FILE"
    exit 0
fi

if [ "$health" = "unhealthy" ]; then

    if [ -f "$FAILURE_FILE" ]; then
        failure_count=$(cat "$FAILURE_FILE")
    else
        failure_count=0
    fi

    failure_count=$((failure_count + 1))
    echo "$failure_count" > "$FAILURE_FILE"

    echo "FAILURE_COUNT: $failure_count/$MAX_FAILURES"

    if [ "$failure_count" -ge "$MAX_FAILURES" ]; then
        echo "ALERT: unhealthy threshold reached"
        echo "ACTION: restarting container"

        sudo docker restart "$CONTAINER"

        rm -f "$FAILURE_FILE"

        echo "ACTION: restart completed"
        exit 0
    fi

    echo "WARNING: unhealthy, waiting for next check"
    exit 1
fi

echo "OK: service is healthy"
rm -f "$FAILURE_FILE"
exit 0
