#!/bin/bash

# Load notification config if exists
[ -f /etc/nids-setup/notify.conf ] && source /etc/nids-setup/notify.conf

# Function to send test traffic
send_test_traffic() {
    echo "Sending test traffic..."
    sudo hping3 -c 1 -S $target_ip -p 80
}

# Function to check Suricata logs
check_suricata_logs() {
    echo "Checking Suricata logs..."
    sudo tail -n 20 /var/log/suricata/fast.log
}

# Function to test notifications
test_notifications() {
    if [ -f "/etc/nids-setup/notify.conf" ]; then
        echo "Testing notifications..."
        
        # Test email notification if configured
        if [ -n "$EMAIL_RECIPIENT" ]; then
            echo "Sending test email..."
            echo "Test alert from NIDS" | mail -s "NIDS Test Alert" "$EMAIL_RECIPIENT"
        fi
        
        # Test Gotify notification if configured
        if [ -n "$GOTIFY_SERVER" ] && [ -n "$GOTIFY_TOKEN" ]; then
            echo "Sending test Gotify notification..."
            curl -X POST "$GOTIFY_SERVER/message?token=$GOTIFY_TOKEN" \
                -F "title=NIDS Test Alert" \
                -F "message=Test notification from NIDS" \
                -F "priority=5"
        fi
    fi
}

echo "Testing the NIDS setup (Suricata)..."

# Ask the user for the target IP address
read -p "Enter the target IP address to send test traffic to: " target_ip

# Validate IP address format
if [[ ! $target_ip =~ ^[0-9]+\.[0-9]+\.[0-9]+\.[0-9]+$ ]]; then
    echo "Invalid IP address format. Please enter a valid IP address."
    exit 1
fi

send_test_traffic
check_suricata_logs
test_notifications

echo "NIDS testing completed. Check the logs and notifications for alerts."
