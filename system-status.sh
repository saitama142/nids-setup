#!/bin/bash

echo "=== System Status ==="
echo

# Check NIDS processes
echo "NIDS Process Status:"
if pgrep snort >/dev/null; then
    echo "✓ Snort is running"
else
    echo "✗ Snort is not running"
fi

if pgrep suricata >/dev/null; then
    echo "✓ Suricata is running"
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
