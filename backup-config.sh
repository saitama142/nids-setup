#!/bin/bash

BACKUP_DIR="/var/backups/nids"
DATE=$(date +%Y%m%d_%H%M%S)

sudo mkdir -p "$BACKUP_DIR"

backup_suricata() {
    echo "Backing up Suricata configuration..."
    sudo tar -czf "$BACKUP_DIR/suricata_backup_$DATE.tar.gz" /etc/suricata/
    echo "Backup saved to: $BACKUP_DIR/suricata_backup_$DATE.tar.gz"
}

# Backup only Suricata configuration
if [ -f /etc/suricata/suricata.yaml ]; then
    backup_suricata
else
    echo "No Suricata installation detected"
    exit 1
fi
