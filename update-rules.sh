#!/bin/bash

# Set variables
TEMP_DIR="/tmp/nids-rules"
LOG_FILE="/var/log/suricata/update.log"

# Make sure directory exists
mkdir -p "$TEMP_DIR"

# Function to update Suricata rules with low resources
update_suricata_rules() {
    echo "Updating Suricata rules..."
    echo "Cette opération peut prendre quelques minutes, veuillez patienter..."
    
    # Display a spinner
    (
        while :; do
            for s in / - \\ \|; do
                echo -ne "\r$s Téléchargement des règles en cours... $s"
                sleep 1
            done
        done
    ) &
    SPINNER_PID=$!
    
    # Kill the spinner on exit
    trap "kill $SPINNER_PID 2>/dev/null" EXIT
    
    # Try with reduced memory usage by using nice and limiting rules
    if nice -n 19 sudo suricata-update --no-reload --quiet --no-merge --disable-conf /etc/suricata/disable.conf; then
        echo -e "\rRègles mises à jour avec succès!            "
    else
        # If first attempt fails, try with minimal ruleset
        echo -e "\r- Premier essai échoué, essai avec ensemble de règles minimal..."
        
        # Create a disable.conf file to disable most rules
        sudo tee /etc/suricata/disable.conf > /dev/null << EOF
# Disable most rules to save memory
re:malware
re:policy
re:trojan
re:user_agents
re:web-activex
re:web-client
re:web-specific-apps
EOF
        
        if nice -n 19 sudo suricata-update --no-reload --quiet --disable-conf /etc/suricata/disable.conf; then
            echo "Règles minimales mises à jour avec succès!"
        else
            echo "Échec de la mise à jour des règles."
        fi
    fi
    
    # Attempt to restart/reload Suricata
    echo "Redémarrage du service Suricata..."
    sudo systemctl restart suricata || sudo systemctl reload suricata || true
    
    # Kill the spinner
    kill $SPINNER_PID 2>/dev/null
    wait $SPINNER_PID 2>/dev/null
    
    echo "Mise à jour terminée."
}

# Main execution
if [ -f /etc/suricata/suricata.yaml ]; then
    update_suricata_rules
else
    echo "No supported NIDS installation detected"
    exit 1
fi

# Clean up
rm -rf "$TEMP_DIR"
