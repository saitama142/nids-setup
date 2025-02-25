#!/bin/bash

echo "=== System Status ==="

# Check NIDS processes more accurately
echo "NIDS Process Status:"
if systemctl is-active --quiet suricata && pgrep suricata >/dev/null; then
    echo "✓ Suricata is running"
    systemctl status suricata --no-pager | grep 'Active:'
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
