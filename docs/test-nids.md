# Testing the NIDS

## Testing Steps

1. **Send Test Traffic**:
   - Use tools like `hping3` to send test packets.
   - Example: `sudo hping3 -c 1 -S 192.168.0.1 -p 80`

2. **Check Logs**:
   - Snort: `/var/log/snort/alert`
   - Suricata: `/var/log/suricata/fast.log`
