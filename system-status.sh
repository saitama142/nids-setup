#!/bin/bash

echo "=== System Status ==="

# Amélioration de la vérification du statut
echo "NIDS Process Status:"
if pgrep -f suricata >/dev/null && systemctl is-active --quiet suricata; then
    echo "✓ Suricata is running"
    pgrep -f suricata | while read -r pid; do
        ps -p "$pid" -o pid,ppid,%cpu,%mem,cmd
    done
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
