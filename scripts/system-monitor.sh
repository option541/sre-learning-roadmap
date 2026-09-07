#!/bin/bash

CPU_WARNING=80
CPU_CRITICAL=95

LOAD_WARNING=0.8
LOAD_CRITICAL=1.0

MEM_WARNING=80
MEM_CRITICAL=90

DISK_WARNING=80
DISK_CRITICAL=90

overall_status=0

echo "===== System Monitor ====="

# =========================
# CPU
# =========================

cpu_usage=$(top -b -n 1 | awk '
/%Cpu/ {
    for (i=1; i<=NF; i++) {
        if ($i ~ /^id/) {
            printf "%.1f", 100 - $(i-1)
            exit
        }
    }
}')

echo
echo "CPU:"
echo "  usage: ${cpu_usage}%"

if awk "BEGIN {exit !($cpu_usage >= $CPU_CRITICAL)}"; then
    echo "  status: CRITICAL"
    overall_status=2
elif awk "BEGIN {exit !($cpu_usage >= $CPU_WARNING)}"; then
    echo "  status: WARNING"
    [ "$overall_status" -lt 1 ] && overall_status=1
else
    echo "  status: OK"
fi

# =========================
# Load
# =========================

load_1m=$(awk '{print $1}' /proc/loadavg)
cpu_cores=$(nproc)

load_per_cpu=$(awk \
    -v load_avg="$load_1m" \
    -v cores="$cpu_cores" \
    'BEGIN {printf "%.2f", load_avg / cores}')

echo
echo "Load:"
echo "  1m: $load_1m"
echo "  per CPU: $load_per_cpu"

if awk "BEGIN {exit !($load_per_cpu >= $LOAD_CRITICAL)}"; then
    echo "  status: CRITICAL"
    overall_status=2
elif awk "BEGIN {exit !($load_per_cpu >= $LOAD_WARNING)}"; then
    echo "  status: WARNING"
    [ "$overall_status" -lt 1 ] && overall_status=1
else
    echo "  status: OK"
fi

# =========================
# Memory
# =========================

mem_usage=$(free | awk '/Mem:/ {
    printf "%.1f", $3 / $2 * 100
}')

echo
echo "Memory:"
echo "  usage: ${mem_usage}%"

if awk "BEGIN {exit !($mem_usage >= $MEM_CRITICAL)}"; then
    echo "  status: CRITICAL"
    overall_status=2
elif awk "BEGIN {exit !($mem_usage >= $MEM_WARNING)}"; then
    echo "  status: WARNING"
    [ "$overall_status" -lt 1 ] && overall_status=1
else
    echo "  status: OK"
fi

# =========================
# Disk
# =========================

disk_usage=$(df / | awk 'NR==2 {gsub("%","",$5); print $5}')

echo
echo "Disk:"
echo "  usage: ${disk_usage}%"

if [ "$disk_usage" -ge "$DISK_CRITICAL" ]; then
    echo "  status: CRITICAL"
    overall_status=2
elif [ "$disk_usage" -ge "$DISK_WARNING" ]; then
    echo "  status: WARNING"
    [ "$overall_status" -lt 1 ] && overall_status=1
else
    echo "  status: OK"
fi

# =========================
# Overall
# =========================

echo
echo "Overall:"

case "$overall_status" in
    0)
        echo "  OK"
        ;;
    1)
        echo "  WARNING"
        ;;
    2)
        echo "  CRITICAL"
        ;;
esac

exit "$overall_status"
