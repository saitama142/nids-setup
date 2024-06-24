# Configuring Snort

## Configuration Steps

1. **Set the Network Interface**:
   - Edit `/etc/snort/snort.conf` to set the network interface Snort should listen on.
   - Example: `ipvar HOME_NET [192.168.0.0/16]`

2. **Download Community Rules**:
   - Download and extract community rules to `/etc/snort/rules`.

3. **Create Local Rules**:
   - Add custom rules in `/etc/snort/rules/local.rules`.

4. **Test Configuration**:
   - Run `snort -T -c /etc/snort/snort.conf -i <interface>` to test the configuration.

5. **Enable and Start Snort Service**:
   - Enable: `sudo systemctl enable snort`
   - Start: `sudo systemctl start snort`
