#!/bin/bash

echo "=== System Status ==="

# Check NIDS processes with multiple methods
echo "NIDS Process Status:"
SURICATA_RUNNING=false

# Method 1: Check process
if pgrep -x suricata > /dev/null || pgrep -f "suricata -D" > /dev/null; then
    SURICATA_RUNNING=true
fi

# Method 2: Check systemctl
if systemctl is-active --quiet suricata; then
    SURICATA_RUNNING=true
fi

if [ "$SURICATA_RUNNING" = true ]; then
    echo "✓ Suricata is running"
    sudo systemctl status suricata --no-pager | head -3
else
    echo "✗ Suricata is not running"
fi

# Check disk space
echo -e "\nDisk Space Usage:"
df -h /

# Check memory usage
echo -e "\nMemory Usage:"
free -h

# Check load average
echo -e "\nSystem Load:"
uptime

# Check network interfaces
echo -e "\nNetwork Interfaces:"
ip addr show
