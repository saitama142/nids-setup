#!/bin/bash

# Set backup directory
BACKUP_DIR="/home/coder/nids-backup"
DATE=$(date +%Y%m%d_%H%M%S)

# Create backup directory
mkdir -p "$BACKUP_DIR"

# Function to backup Suricata configuration
backup_suricata() {
    echo "Backing up Suricata configuration..."
    sudo tar czf "$BACKUP_DIR/suricata_config_$DATE.tar.gz" \
        /etc/suricata \
        /var/log/suricata
    echo "Backup saved to: $BACKUP_DIR/suricata_config_$DATE.tar.gz"
}

# Function to backup Snort configuration
backup_snort() {
    echo "Backing up Snort configuration..."
    sudo tar czf "$BACKUP_DIR/snort_config_$DATE.tar.gz" \
        /etc/snort \
        /var/log/snort
    echo "Backup saved to: $BACKUP_DIR/snort_config_$DATE.tar.gz"
}

# Detect and backup NIDS configuration
if [ -d "/etc/suricata" ]; then
    backup_suricata
elif [ -d "/etc/snort" ]; then
    backup_snort
else
    echo "No NIDS configuration found to backup"
    exit 1
fi

# Cleanup old backups (keep last 5)
cd "$BACKUP_DIR" && ls -t *.tar.gz | tail -n +6 | xargs -r rm

echo "Backup completed successfully"
