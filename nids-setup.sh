#!/bin/bash

# Configuration
LOG_FILE="/var/log/nids-setup.log"
CONFIG_DIR="/etc/nids-setup"

# Setup logging
setup_logging() {
    if [[ ! -d $(dirname $LOG_FILE) ]]; then
        sudo mkdir -p $(dirname $LOG_FILE)
    fi
    exec 1> >(tee -a $LOG_FILE)
    exec 2> >(tee -a $LOG_FILE >&2)
}

# Validate system requirements
check_requirements() {
    echo "Checking system requirements..."
    
    # Check OS
    if [[ ! -f /etc/os-release ]]; then
        echo "Error: Unsupported operating system"
        exit 1
    }
    
    # Check root/sudo
    if [[ $EUID -ne 0 && ! -x "$(command -v sudo)" ]]; then
        echo "Error: This script requires root privileges or sudo access"
        exit 1
    }
    
    # Check available disk space
    MIN_SPACE=1000000  # 1GB in KB
    available_space=$(df -k /var | awk 'NR==2 {print $4}')
    if [[ $available_space -lt $MIN_SPACE ]]; then
        echo "Error: Insufficient disk space"
        exit 1
    }
}

# Main menu function
show_menu() {
    clear
    echo "=== NIDS Setup Tool ==="
    echo "1. Install/Configure NIDS"
    echo "2. Update Rules"
    echo "3. View Statistics"
    echo "4. Backup Configuration"
    echo "5. System Status"
    echo "6. Exit"
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
            echo "Installing NIDS..."
            echo "Please choose which NIDS you want to install:"
            echo "1. Snort"
            echo "2. Suricata"
            read -p "Enter your choice (1 or 2): " nids_choice

            case $nids_choice in
                1)
                    echo "You have chosen to install Snort."
                    ./install-snort.sh
                    ;;
                2)
                    echo "You have chosen to install Suricata."
                    ./install-suricata.sh
                    ;;
                *)
                    echo "Invalid choice. Please run the script again and choose either 1 or 2."
                    exit 1
                    ;;
            esac

            read -p "Do you want to configure the chosen NIDS now? (y/n): " configure_choice

            if [[ $configure_choice == "y" || $configure_choice == "Y" ]]; then
                case $nids_choice in
                    1)
                        ./configure-snort.sh
                        ;;
                    2)
                        ./configure-suricata.sh
                        ;;
                esac
            else
                echo "You can configure the NIDS later by running the respective configure script."
            fi

            read -p "Do you want to test the chosen NIDS now? (y/n): " test_choice

            if [[ $test_choice == "y" || $test_choice == "Y" ]]; then
                ./test-nids.sh
            else
                echo "You can test the NIDS later by running the test-nids.sh script."
            fi

            echo "NIDS setup completed. Thank you for using the NIDS Setup Tool."
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
