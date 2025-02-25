#!/bin/bash

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

echo "NIDS testing completed. Check the logs for alerts."
