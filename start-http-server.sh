#!/bin/bash

PORT=8080
LOG_FILE="$HOME/sre-learning/http-server.log"
PID_FILE="$HOME/sre-learning/http-server.pid"

echo "Starting HTTP server on port $PORT..."

if ss -lnt | grep -q ":$PORT "
then
    echo "ERROR: Port $PORT is already in use"
    echo "Existing process:"
    ss -lntp | grep ":$PORT "
    exit 1
fi

python3 -m http.server "$PORT" >> "$LOG_FILE" 2>&1 &

PID=$!

sleep 1

if ps -p "$PID" > /dev/null
then
    echo "$PID" > "$PID_FILE"
    echo "HTTP server started successfully"
    echo "PID: $PID"
else
    echo "ERROR: HTTP server failed to start"
    echo "Check log: $LOG_FILE"
    exit 1
fi
