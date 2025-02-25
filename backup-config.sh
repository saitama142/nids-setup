#!/bin/bash

BACKUP_DIR="/var/backups/nids"
DATE=$(date +%Y%m%d_%H%M%S)

# Create backup directory if it doesn't exist
sudo mkdir -p "$BACKUP_DIR"

# Function to backup Snort configuration
backup_snort() {
    echo "Backing up Snort configuration..."
    sudo tar -czf "$BACKUP_DIR/snort_backup_$DATE.tar.gz" /etc/snort/
    echo "Backup saved to: $BACKUP_DIR/snort_backup_$DATE.tar.gz"
}

# Function to backup Suricata configuration
backup_suricata() {
    echo "Backing up Suricata configuration..."
    sudo tar -czf "$BACKUP_DIR/suricata_backup_$DATE.tar.gz" /etc/suricata/
    echo "Backup saved to: $BACKUP_DIR/suricata_backup_$DATE.tar.gz"
}

# Check which NIDS is installed and backup accordingly
if [ -f /etc/snort/snort.conf ]; then
    backup_snort
elif [ -f /etc/suricata/suricata.yaml ]; then
    backup_suricata
else
    echo "No NIDS installation detected"
    exit 1
fi
