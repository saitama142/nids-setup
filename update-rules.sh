#!/bin/bash

# Set variables
TEMP_DIR="/tmp/nids-rules"
LOG_FILE="/var/log/suricata/update.log"

# Make sure directory exists
mkdir -p "$TEMP_DIR"

# Trap pour capture l'interruption (CTRL+C)
trap 'echo "Update interrupted"; exit 1' INT TERM

# Function to update Suricata rules with timeout
update_suricata_rules() {
    echo "Updating Suricata rules..."
    echo "Cette opération peut prendre quelques minutes, veuillez patienter..."
    
    # Afficher un indicateur d'activité pendant l'exécution
    (
        while :; do
            for s in / - \\ \|; do
                echo -ne "\r$s Téléchargement des règles en cours... $s"
                sleep 0.5
            done
        done
    ) &
    SPINNER_PID=$!
    
    # Tuer le spinner à la sortie
    trap "kill $SPINNER_PID 2>/dev/null" EXIT
    
    # Exécuter avec timeout
    if timeout 300 sudo suricata-update --no-reload 2>/dev/null; then
        echo -e "\rRègles mises à jour avec succès!            "
        sudo systemctl restart suricata
    else
        echo -e "\rÉchec de la mise à jour des règles. Vérifier $LOG_FILE"
    fi
    
    # Tuer le spinner
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
