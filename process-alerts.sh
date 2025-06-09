
#!/bin/bash
# Production-grade alert processor for NIDS

ALERT_LOG="/var/log/nids/alerts.log"
NOTIFY_CONF="/etc/nids-setup/notify.conf"

# Load configuration
[ -f "$NOTIFY_CONF" ] && source "$NOTIFY_CONF"

# Initialize logging
setup_logging() {
    mkdir -p "$(dirname "$ALERT_LOG")"
    exec >> "$ALERT_LOG" 2>&1
}

# Process incoming alert
process_alert() {
    local alert="$1"
    echo "$(date '+%Y-%m-%d %H:%M:%S') - $alert" >> "$ALERT_LOG"
    
    # Email notification
    if [ -n "$EMAIL_RECIPIENT" ]; then
        echo "$alert" | mail -s "NIDS Alert" "$EMAIL_RECIPIENT"
    fi
    
    # Gotify notification
    if [ -n "$GOTIFY_SERVER" ] && [ -n "$GOTIFY_TOKEN" ]; then
        curl -X POST "$GOTIFY_SERVER/message?token=$GOTIFY_TOKEN" \
            -F "title=NIDS Alert" \
            -F "message=$alert" \
            -F "priority=8"  # High priority
    fi
}

# Main execution
setup_logging
while read -r alert; do
    process_alert "$alert"
done
