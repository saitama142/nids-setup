# Configuring Suricata

## Configuration Steps

1. **Set the Network Interface**:
   - Edit `/etc/suricata/suricata.yaml` to set the network interface Suricata should listen on.
   - Example: `interface: eth0`

2. **Test Configuration**:
   - Run `suricata -T -c /etc/suricata/suricata.yaml -i <interface>````markdown
# Configuring Suricata

## Configuration Steps

1. **Set the Network Interface**:
   - Edit `/etc/suricata/suricata.yaml` to set the network interface Suricata should listen on.
   - Example: `interface: eth0`

2. **Test Configuration**:
   - Run `suricata -T -c /etc/suricata/suricata.yaml -i <interface>` to test the configuration.

3. **Enable and Start Suricata Service**:
   - Enable: `sudo systemctl enable suricata`
   - Start: `sudo systemctl start suricata`
