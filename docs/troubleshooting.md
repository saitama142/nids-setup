# Troubleshooting Guide

This document covers the most common issues and their solutions when using our NIDS Setup tool.

## Installation Issues

### Error: Missing Dependencies

**Symptom**: The message "Unable to install required dependencies" appears.

**Solution**:
```bash
# Update repositories
sudo apt update

# Manually install dependencies
sudo apt install -y libpcre3 libpcre3-dbg libpcre3-dev build-essential libpcap-dev \
                   libnet1-dev libyaml-0-2 libyaml-dev pkg-config zlib1g zlib1g-dev \
                   libcap-ng-dev libcap-ng0 make libmagic-dev libjansson-dev        \
                   libnss3-dev libgeoip-dev liblua5.1-dev libhiredis-dev libevent-dev
```

### Error: Unsupported Suricata Version

**Symptom**: Installation fails with a version-related message.

**Solution**:
```bash
# Add official Suricata PPA
sudo add-apt-repository ppa:oisf/suricata-stable
sudo apt update
./install-suricata.sh
```

## Configuration Issues

### Error: Network Interface Not Recognized

**Symptom**: Message "The specified interface doesn't exist" during configuration.

**Solution**:
1. List available interfaces:
   ```bash
   ip a
   ```
2. Restart configuration with the correct interface:
   ```bash
   ./configure-suricata.sh --interface=CORRECT_INTERFACE
   ```

### Error: Corrupted Configuration File

**Symptom**: Error "Unable to parse /etc/suricata/suricata.yaml".

**Solution**:
```bash
# Restore from a backup
./backup-config.sh --restore=LATEST_BACKUP

# Or regenerate default configuration
./configure-suricata.sh --reset
```

## Performance Issues

### Alert: High CPU Usage

**Symptom**: Suricata is using too many CPU resources.

**Solution**:
1. Adjust performance settings:
   ```bash
   sudo nano /etc/suricata/suricata.yaml
   ```
2. Modify the following parameters:
   ```yaml
   max-pending-packets: 1024
   detect-engine:
     - profile: medium
     - sgh-mpm-context: auto
     - inspection-recursion-limit: 3000
   ```
3. Restart Suricata:
   ```bash
   sudo systemctl restart suricata
   ```

### Alert: Packet Drop Warnings

**Symptom**: Logs show "packet loss" or "drop" warnings.

**Solution**:
1. Increase buffer sizes:
   ```bash
   sudo sysctl -w net.core.rmem_max=33554432
   sudo sysctl -w net.core.rmem_default=33554432
   ```
2. Add to `/etc/sysctl.conf` to persist after reboot

## Rules Issues

### Error: Rules Update Failure

**Symptom**: Rules update script fails.

**Solution**:
```bash
# Check connectivity to rule sources
ping rules.emergingthreats.net

# Manual update with debug output
sudo suricata-update --verbose

# Check disk space
df -h /var
```

## Service Issues

### Error: Suricata Service Won't Start

**Symptom**: Service fails to start after configuration changes.

**Solution**:
```bash
# Check logs
sudo journalctl -u suricata

# Test configuration
sudo suricata -T -c /etc/suricata/suricata.yaml

# Check permissions
sudo chown -R suricata:suricata /var/log/suricata
```