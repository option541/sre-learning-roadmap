status_service() {

    echo "Service Status"
    echo "=============="

    if ss -lnt | grep -q ":$PORT "
    then
        echo "Port: LISTENING"

        ACTUAL_PID=$(ss -lntp | grep ":$PORT " | grep -o 'pid=[0-9]*' | head -n 1 | cut -d= -f2)

        if [ -n "$ACTUAL_PID" ]
        then
            echo "Actual PID: $ACTUAL_PID"
        else
            echo "Actual PID: UNKNOWN"
        fi

    else
        echo "Port: DOWN"
        ACTUAL_PID=""
    fi

    if [ -f "$PID_FILE" ]
    then
        PID=$(cat "$PID_FILE")
        echo "PID File: $PID"

        if ps -p "$PID" > /dev/null
        then
            echo "PID File Process: RUNNING"
        else
            echo "PID File Process: NOT RUNNING"
        fi
    else
        echo "PID File: NOT FOUND"
    fi

    echo ""

    HTTP_STATUS=$(curl -o /dev/null -s -w "%{http_code}" \
        "http://localhost:$PORT")

    echo "HTTP Status: $HTTP_STATUS"
}
