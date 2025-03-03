# Rules Update

Regular updates to detection rules are essential for an effective NIDS.

## Automatic Update

The `update-rules.sh` script updates Suricata detection rules.

### Features

- Optimized for resource-constrained systems
- Uses `nice` to reduce system impact
- Fallback options if the first attempt fails

### Usage

```bash
./update-rules.sh            # Standard update
./update-rules.sh --force    # Force update even if not due
./update-rules.sh --quiet    # Silent operation
```

### Scheduling Updates

It's recommended to schedule regular updates using cron:

```bash
# Example: Update rules daily at 3:30 AM
30 3 * * * /path/to/update-rules.sh --quiet
```

### Update Sources

The script pulls rules from multiple sources:

1. Emerging Threats Open ruleset
2. Suricata's official rules
3. Community-contributed rules

### Manual Rule Management

You can manage rules manually in the `/etc/suricata/rules` directory:

```bash
# Disable a specific rule file
sudo mv /etc/suricata/rules/http-events.rules /etc/suricata/rules/http-events.rules.disabled

# After any manual changes, reload Suricata
sudo systemctl reload suricata
```

### Troubleshooting Updates

If updates fail, check:

1. Internet connectivity
2. Disk space
3. Update logs at `/var/log/suricata/update.log`
