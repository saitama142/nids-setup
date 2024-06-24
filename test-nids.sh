#!/bin/bash

# Function to send test traffic
send_test_traffic() {
    echo "Sending test traffic..."
    sudo hping3 -c 1 -S $target_ip -p 80
}

# Function to check Snort logs
check_snort_logs() {
    echo "Checking Snort logs..."
    sudo tail -n 20 /var/log/snort/alert
}

# Function to check Suricata logs
check_suricata_logs() {
    echo "Checking Suricata logs..."
    sudo tail -n 20 /var/log/suricata/fast.log
}

echo "Testing the NIDS setup..."

# Ask the user for the target IP address
read -p "Enter the target IP address to send test traffic to: " target_ip

# Validate IP address format
if [[ ! $target_ip =~ ^[0-9]+\.[0-9]+\.[0-9]+\.[0-9]+$ ]]; then
    echo "Invalid IP address format. Please enter a valid IP address."
    exit 1
fi

# Ask the user which NIDS to test
echo "Please choose which NIDS to test:"
echo "1. Snort"
echo "2. Suricata"
read -p "Enter your choice (1 or 2): " nids_choice

case $nids_choice in
    1)
        echo "You have chosen to test Snort."
        send_test_traffic
        check_snort_logs
        ;;
    2)
        echo "You have chosen to test Suricata."
        send_test_traffic
        check_suricata_logs
        ;;
    *)
        echo "Invalid choice. Please run the script again and choose either 1 or 2."
        exit 1
        ;;
esac

echo "NIDS testing completed. Check the logs for alerts."
