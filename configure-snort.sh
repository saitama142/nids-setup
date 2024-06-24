#!/bin/bash

# Configuration steps for Snort
echo "Configuring Snort..."

# Define the interface to listen on
read -p "Enter the network interface Snort should listen on (e.g., eth0): " interface

# Edit Snort configuration file
sudo sed -i "s/^\(ipvar HOME_NET \).*/\1[192.168.0.0\/16]/" /etc/snort/snort.conf
sudo sed -i "s/^\(var RULE_PATH \).*/\1\/etc\/snort\/rules/" /etc/snort/snort.conf
sudo sed -i "s/^\(var SO_RULE_PATH \).*/\1\/etc\/snort\/so_rules/" /etc/snort/snort.conf
sudo sed -i "s/^\(var PREPROC_RULE_PATH \).*/\1\/etc\/snort\/preproc_rules/" /etc/snort/snort.conf

# Download community rules
sudo wget https://www.snort.org/downloads/community/community-rules.tar.gz -O /tmp/community-rules.tar.gz
sudo tar -xzf /tmp/community-rules.tar.gz -C /etc/snort/rules

# Create local.rules
echo "alert icmp any any -> any any (msg:\"ICMP Packet\"; sid:10000001; rev:001;)" | sudo tee /etc/snort/rules/local.rules

# Test Snort configuration
sudo snort -T -c /etc/snort/snort.conf -i $interface

# Enable Snort as a service
sudo systemctl enable snort
sudo systemctl start snort

echo "Snort configured successfully!"
