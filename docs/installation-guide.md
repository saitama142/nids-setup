# Installation Guide

This guide will walk you through the complete installation and initial configuration process for your Suricata-based NIDS.

## Installation Methods

### 1. Automated Installation (Recommended)

```bash
./setup.sh
```

This command launches the installation wizard that will guide you through all necessary steps.

### 2. Manual Installation

If you prefer to install components individually:

```bash
# Suricata installation
./install-suricata.sh

# Configuration
./configure-suricata.sh

# Initial rules update
./update-rules.sh
```

## Advanced Installation Options

You can pass parameters to the installation script:

```bash
./setup.sh --no-prompt        # Non-interactive installation
./setup.sh --minimal          # Minimal installation
./setup.sh --interface=eth0   # Specify monitoring interface
```

## Installation Verification

After installation, verify everything works correctly:

```bash
./system-status.sh
./test-nids.sh
```

## Troubleshooting Common Issues

### Suricata Fails to Start

Check logs:
```bash
sudo journalctl -u suricata
```

### Configuration Errors

Validate your configuration:
```bash
suricata -T -c /etc/suricata/suricata.yaml
```

## Recommended Post-Installation Configuration

1. Configure email alerts
2. Integrate with your logging system
3. Set up log rotation
4. Schedule automatic rule updates
