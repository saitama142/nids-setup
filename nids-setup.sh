#!/bin/bash

echo "Welcome to the NIDS Setup Tool"
echo "This tool will help you set up a Network Intrusion Detection System (NIDS) using either Snort or Suricata."

# Ask the user which NIDS to install
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

# Ask the user if they want to configure the chosen NIDS
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

# Ask the user if they want to test the chosen NIDS
read -p "Do you want to test the chosen NIDS now? (y/n): " test_choice

if [[ $test_choice == "y" || $test_choice == "Y" ]]; then
    ./test-nids.sh
else
    echo "You can test the NIDS later by running the test-nids.sh script."
fi

echo "NIDS setup completed. Thank you for using the NIDS Setup Tool."
