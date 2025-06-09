
#!/bin/bash

# Notification configuration
NOTIFY_LOG="/var/log/nids-notifications.log"

# Setup notification methods
setup_notifications() {
    echo "Configuring alert notifications..."
    
    # Create notification log
    sudo touch "$NOTIFY_LOG"
    sudo chmod 666 "$NOTIFY_LOG"
    
    # Prompt for notification method
    echo "Select notification method:"
    echo "1. Email"
    echo "2. Gotify"
    echo "3. Both"
    echo "4. None"
    
    read -p "Enter choice (1-4): " method
    
    case $method in
        1)
            configure_email
            ;;
        2) 
            configure_gotify
            ;;
        3)
            configure_email
            configure_gotify
            ;;
        4)
            echo "Notifications disabled"
            ;;
        *)
            echo "Invalid option"
            ;;
    esac
}

# Email configuration
configure_email() {
    echo "Configuring email alerts..."
    read -p "Enter recipient email: " email
    read -p "Enter SMTP server: " smtp
    read -p "Enter SMTP port: " port
    
    # Validate email format
    if [[ ! "$email" =~ ^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}$ ]]; then
        echo "Invalid email format"
        return 1
    fi
    
    # Save configuration
    echo "EMAIL_RECIPIENT=\"$email\"" | sudo tee -a /etc/nids-setup/notify.conf
    echo "SMTP_SERVER=\"$smtp\"" | sudo tee -a /etc/nids-setup/notify.conf
    echo "SMTP_PORT=\"$port\"" | sudo tee -a /etc/nids-setup/notify.conf
    
    echo "Email alerts configured"
}

# Gotify configuration
configure_gotify() {
    echo "Configuring Gotify alerts..."
    read -p "Enter Gotify server URL: " server
    read -p "Enter Application Token: " token
    
    # Validate URL format
    if [[ ! "$server" =~ ^https?:// ]]; then
        echo "Invalid URL format"
        return 1
    fi
    
    # Save configuration
    echo "GOTIFY_SERVER=\"$server\"" | sudo tee -a /etc/nids-setup/notify.conf
    echo "GOTIFY_TOKEN=\"$token\"" | sudo tee -a /etc/nids-setup/notify.conf
    
    echo "Gotify alerts configured"
}

# Main execution
if [ "$EUID" -ne 0 ]; then
    echo "Please run as root"
    exit 1
fi

mkdir -p /etc/nids-setup
setup_notifications
