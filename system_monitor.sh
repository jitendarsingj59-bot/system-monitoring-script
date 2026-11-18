
#!/bin/bash

# ==========================================
# Project: System Monitoring and Alerting
# DevOps Capstone Project 1
# Author: Jeet
# ==========================================

# Threshold Configuration
DISK_THRESHOLD=80
MEMORY_THRESHOLD=80
CPU_THRESHOLD=80

# Log File
LOG_FILE="logs/system_monitor.log"

# Create logs directory
mkdir -p logs

# Logging Function
log_message() {
    echo "$(date '+%Y-%m-%d %H:%M:%S') - $1" | tee -a "$LOG_FILE"
}

echo "=========================================="
echo "       SYSTEM MONITORING TOOL"
echo "=========================================="

log_message "System monitoring started."

# ==========================================
# 1. DISK USAGE MONITORING
# ==========================================

echo ""
echo "Checking Disk Usage..."

df -hP -x tmpfs -x devtmpfs -x efivarfs | awk -v threshold="$DISK_THRESHOLD" '
NR > 1 {
    usage = $5
    gsub(/%/, "", usage)

    if (usage >= threshold) {
        print "WARNING: High disk usage on " $6 ": " usage "%"
    }
    else {
        print "Disk usage normal on " $6 ": " usage "%"
    }
}'

# Log disk usage and alerts

df -P -x tmpfs -x devtmpfs -x efivarfs | awk -v threshold="$DISK_THRESHOLD" '
NR > 1 {
    usage = $5
    gsub(/%/, "", usage)

    if (usage >= threshold) {
        print "ALERT: High disk usage on " $6 ": " usage "%"
    }
    else {
        print "Disk usage normal on " $6 ": " usage "%"
    }
}' | while read -r message; do
    log_message "$message"
done

echo "Disk monitoring completed."

# ==========================================
# 2. MEMORY USAGE MONITORING
# ==========================================

echo ""
echo "Checking Memory Usage..."

MEMORY_USAGE=$(free | awk '/Mem:/ {
    printf "%.0f", ($3/$2)*100
}')

echo "Memory Usage: ${MEMORY_USAGE}%"

if [ "$MEMORY_USAGE" -ge "$MEMORY_THRESHOLD" ]; then
    echo "WARNING: High memory usage!"
    log_message "ALERT: High memory usage: ${MEMORY_USAGE}%"
else
    echo "Memory usage normal."
    log_message "Memory usage normal: ${MEMORY_USAGE}%"
fi

echo "Memory monitoring completed."

# ==========================================
# 3. CPU MONITORING
# ==========================================

echo ""
echo "Checking CPU Information..."

CPU_USAGE=$(mpstat 1 1 | awk '/Average:/ && $2 == "all" {
    printf "%.1f", 100 - $NF
}')

echo "CPU Usage: ${CPU_USAGE}%"

if awk -v cpu="$CPU_USAGE" -v threshold="$CPU_THRESHOLD" \
    'BEGIN {exit !(cpu >= threshold)}'; then

    echo "WARNING: High CPU usage!"
    log_message "ALERT: High CPU usage: ${CPU_USAGE}%"
else
    echo "CPU usage normal."
    log_message "CPU usage normal: ${CPU_USAGE}%"
fi

# ==========================================
# 4. TOP CPU-CONSUMING PROCESSES
# ==========================================

echo ""
echo "Top 5 CPU-consuming Processes..."

ps -eo pid,comm,%cpu,%mem --sort=-%cpu | head -n 6

# ==========================================
# 5. TOP MEMORY-CONSUMING PROCESSES
# ==========================================

echo ""
echo "Top 5 Memory-consuming Processes..."

ps -eo pid,comm,%cpu,%mem --sort=-%mem | head -n 6

# ==========================================
# 6. MONITORING COMPLETED
# ==========================================

echo ""
echo "=========================================="
echo "       MONITORING COMPLETED"
echo "=========================================="

log_message "System monitoring completed."

