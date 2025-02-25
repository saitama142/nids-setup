#!/bin/bash

set -e

# Color definitions
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

# Log file setup
SETUP_LOG="/var/log/nids-setup/setup.log"
INSTALL_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Function to print pretty messages
print_status() {
    echo -e "${BLUE}[*]${NC} $1"
}

print_success() {
    echo -e "${GREEN}[✓]${NC} $1"
}

print_error() {
    echo -e "${RED}[✗]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[!]${NC} $1"
}

# Setup logging
setup_logging() {
    sudo mkdir -p "$(dirname "$SETUP_LOG")"
    sudo touch "$SETUP_LOG"
    sudo chmod 644 "$SETUP_LOG"
    exec 1> >(tee -a "$SETUP_LOG")
    exec 2> >(tee -a "$SETUP_LOG" >&2)
}

# Validate system requirements
check_system_requirements() {
    print_status "Checking system requirements..."
    
    # Check OS
    if ! grep -qE "Ubuntu|Debian" /etc/os-release; then
        print_error "This script requires Ubuntu or Debian"
        exit 1
    fi

    # Check RAM
    total_ram=$(free -m | awk '/^Mem:/{print $2}')
    if [ "$total_ram" -lt 2048 ]; then
        print_error "Minimum 2GB RAM required"
        exit 1
    fi

    # Check disk space
    free_space=$(df -m / | awk 'NR==2 {print $4}')
    if [ "$free_space" -lt 10240 ]; then
        print_error "Minimum 10GB free disk space required"
        exit 1
    fi

    # Check internet connectivity
    if ! ping -c 1 8.8.8.8 >/dev/null 2>&1; then
        print_error "Internet connection required"
        exit 1
    fi

    print_success "System requirements met"
}

# Check and install dependencies
install_dependencies() {
    print_status "Installing required dependencies..."
    
    sudo apt-get update
    sudo apt-get install -y \
        build-essential \
        curl \
        wget \
        git \
        net-tools \
        hping3 \
        tcpdump \
        dialog

    print_success "Dependencies installed"
}

# Main setup function
main() {
    clear
    cat << "EOF"
 _   _ ___ ____  ____    ____       _               
| \ | |_ _|  _ \/ ___|  / ___|  ___| |_ _   _ _ __  
|  \| || || | | \___ \  \___ \ / _ \ __| | | | '_ \ 
| |\  || || |_| |___) |  ___) |  __/ |_| |_| | |_) |
|_| \_|___|____/|____/  |____/ \___|\__|\__,_| .__/ 
                                             |_|    
EOF
    echo

    # Initialize logging
    setup_logging

    # Run system checks
    check_system_requirements
    install_dependencies

    # Make scripts executable
    chmod +x "$INSTALL_DIR"/*.sh
    
    # Start the main NIDS setup script
    if [ -f "$INSTALL_DIR/nids-setup.sh" ]; then
        "$INSTALL_DIR/nids-setup.sh"
    else
        print_error "Main setup script not found!"
        exit 1
    fi
}

# Run main function
main "$@"
