#!/bin/bash

# Set variables
SNORT_RULES_URL="https://www.snort.org/rules/snortrules-snapshot-29200.tar.gz"
SURICATA_RULES_URL="https://rules.emergingthreats.net/open/suricata-5.0/emerging.rules.tar.gz"
TEMP_DIR="/tmp/nids-rules"
RULES_DIR="/etc/suricata/rules"

update_snort_rules() {
    echo "Updating Snort rules..."
    mkdir -p $TEMP_DIR
    wget -O $TEMP_DIR/snort-rules.tar.gz $SNORT_RULES_URL
    sudo tar xzf $TEMP_DIR/snort-rules.tar.gz -C /etc/snort/rules/
    sudo systemctl restart snort
}

update_suricata_rules() {
    echo "Updating Suricata rules..."
    mkdir -p $TEMP_DIR
    wget -O $TEMP_DIR/suricata-rules.tar.gz $SURICATA_RULES_URL
    sudo tar xzf $TEMP_DIR/suricata-rules.tar.gz -C /etc/suricata/rules/
    if ! sudo suricata-update; then
        echo "Warning: Some rules may have been disabled due to missing variables"
    fi
    if systemctl is-active --quiet suricata; then
        sudo systemctl reload suricata || sudo systemctl restart suricata
    fi
}

# Main
if [[ -f /etc/snort/snort.conf ]]; then
    update_snort_rules
elif [[ -f /etc/suricata/suricata.yaml ]]; then
    update_suricata_rules
else
    echo "No NIDS installation detected"
    exit 1
fi

rm -rf $TEMP_DIR
