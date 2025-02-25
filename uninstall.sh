#!/bin/bash

echo "NIDS Uninstallation Script"
echo "Warning: This will remove the NIDS and all its configuration files"
read -p "Do you want to continue? (y/N): " confirm

if [[ ! $confirm =~ ^[Yy]$ ]]; then
    echo "Uninstallation cancelled"
    exit 0
fi

# Backup configuration before removal
./backup-config.sh

# Remove Suricata if installed
if command -v suricata >/dev/null; then
    echo "Removing Suricata..."
    sudo systemctl stop suricata
    sudo apt-get remove --purge -y suricata*
    sudo rm -rf /etc/suricata /var/log/suricata
fi

# Remove Snort if installed
if command -v snort >/dev/null; then
    echo "Removing Snort..."
    sudo systemctl stop snort
    sudo apt-get remove --purge -y snort*
    sudo rm -rf /etc/snort /var/log/snort
fi

echo "NIDS uninstallation completed"
