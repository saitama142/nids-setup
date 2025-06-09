#!/bin/bash

# Configuration
LOG_FILE="/var/log/nids-setup.log"
CONFIG_DIR="/etc/nids-setup"

# Setup logging
setup_logging() {
    if [ ! -d "$(dirname $LOG_FILE)" ]; then
        sudo mkdir -p "$(dirname $LOG_FILE)"
    fi
    exec 1> >(tee -a "$LOG_FILE")
    exec 2> >(tee -a "$LOG_FILE" >&2)
}

# Validate system requirements
check_requirements() {
    echo "Checking system requirements..."
    
    if [ ! -f /etc/os-release ]; then
        echo "Error: Unsupported operating system"
        exit 1
    fi
    
    if [ $EUID -ne 0 ] && [ ! -x "$(command -v sudo)" ]; then
        echo "Error: This script requires root privileges or sudo access"
        exit 1
    fi
    
    MIN_SPACE=1000000  # 1GB in KB
    available_space=$(df -k /var | awk 'NR==2 {print $4}')
    if [ "$available_space" -lt "$MIN_SPACE" ]; then
        echo "Error: Insufficient disk space"
        exit 1
    fi
}

# Main menu function
show_menu() {
    clear
    echo "=== NIDS Setup Tool ==="
    echo "1. Install/Configure Suricata"
    echo "2. Update Rules"
    echo "3. View Statistics"
    echo "4. Backup Configuration"
    echo "5. System Status"
    echo "6. Exit"
}

# NIDS installation function
install_nids() {
    echo "Installing Suricata..."
    ./install-suricata.sh

    read -p "Do you want to configure Suricata now? (y/n): " configure_choice
    if [[ "$configure_choice" =~ ^[Yy]$ ]]; then
        ./configure-suricata.sh
    fi

    read -p "Do you want to test Suricata now? (y/n): " test_choice
    if [[ "$test_choice" =~ ^[Yy]$ ]]; then
        ./test-nids.sh
    fi

    read -p "Configure alert notifications? (y/n): " notify_choice
    if [[ "$notify_choice" =~ ^[Yy]$ ]]; then
        ./configure-notifications.sh
    fi

    echo "Suricata setup completed. Thank you for using the NIDS Setup Tool."
}

# Initialize
setup_logging
check_requirements

# Main loop
while true; do
    show_menu
    read -p "Select an option (1-6): " choice
    
    case $choice in
        1)
            install_nids
            ;;
        2)
            ./update-rules.sh
            ;;
        3)
            ./view-stats.sh
            ;;
        4)
            ./backup-config.sh
            ;;
        5)
            ./system-status.sh
            ;;
        6)
            echo "Exiting..."
            exit 0
            ;;
        *)
            echo "Invalid option"
            ;;
    esac
    
    read -p "Press Enter to continue..."
done
