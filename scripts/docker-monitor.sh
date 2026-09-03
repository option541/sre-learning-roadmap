#!/bin/bash

CONTAINER="cpu-timeout-demo"

status=$(sudo docker inspect -f '{{.State.Status}}' "$CONTAINER")
health=$(sudo docker inspect -f '{{.State.Health.Status}}' "$CONTAINER")
restart=$(sudo docker inspect -f '{{.RestartCount}}' "$CONTAINER")

echo "===== Docker Monitor ====="
echo "container: $CONTAINER"
echo "status:    $status"
echo "health:    $health"
echo "restart:   $restart"

if [ "$status" != "running" ]; then
    echo "ALERT: container is not running"
    exit 2
fi

if [ "$health" = "unhealthy" ]; then
    echo "ALERT: container is unhealthy"
    exit 1
fi

echo "OK: service is healthy"
exit 0
