#!/bin/bash

# Detect NIDS installation
NIDS="none"
if [ -f /etc/suricata/suricata.yaml ]; then
    NIDS="suricata"
    STATS_FILE="/var/log/suricata/stats.log"
    ALERT_FILE="/var/log/suricata/fast.log"
else
    echo "No supported NIDS installation detected"
    exit 1
fi

# Check if NIDS is running
NIDS_RUNNING=false
if pgrep -x suricata > /dev/null || pgrep -f "suricata -D" > /dev/null || systemctl is-active --quiet suricata; then
    NIDS_RUNNING=true
    NIDS_STATUS="active"
else
    NIDS_STATUS="inactive"
fi

# Function to display stats
display_stats() {
    echo "=== NIDS Statistics ==="
    echo "NIDS Type: ${NIDS^}"
    echo "Status: ${NIDS_STATUS}"
    
    if [ "$NIDS_RUNNING" = true ]; then
        # Show process info
        ps -ef | grep -v grep | grep suricata | awk '{print $1" "$2" "$3" "$4" "$8" "$9" "$10}'
        
        # Show alert count
        echo -e "\nAlert Statistics (last 24h):"
        if [ -f "$ALERT_FILE" ]; then
            sudo grep -c "Classification" "$ALERT_FILE" || echo "0"
        else
            echo "0"
        fi
        
        # Show performance stats
        echo -e "\nPerformance Statistics:"
        if [ -f "$STATS_FILE" ]; then
            grep "Total" "$STATS_FILE" | tail -20
        else 
            echo "No statistics file found"
        fi
    else
        echo "Warning: NIDS service is not running"
    fi
}

display_stats
