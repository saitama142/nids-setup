

#!/bin/bash
# Production NIDS startup script

# Create required directories
mkdir -p /var/{log,run}/suricata /var/log/nids

# Start alert processor
nohup /workspace/nids-setup/process-alerts.sh > /var/log/nids/processor.log 2>&1 &

# Start Suricata
suricata -c /etc/suricata/suricata.yaml \
  --pidfile /var/run/suricata.pid \
  --unix-socket=/var/run/suricata/alerts.sock \
  > /var/log/suricata/startup.log 2>&1

# Monitor processes
while sleep 60; do
  if ! pgrep -f "process-alerts.sh" >/dev/null; then
    echo "Alert processor died, restarting..." >> /var/log/nids/processor.log
    nohup /workspace/nids-setup/process-alerts.sh > /var/log/nids/processor.log 2>&1 &
  fi
  if ! pgrep -x "suricata" >/dev/null; then
    echo "Suricata died, restarting..." >> /var/log/suricata/startup.log
    suricata -c /etc/suricata/suricata.yaml \
      --pidfile /var/run/suricata.pid \
      --unix-socket=/var/run/suricata/alerts.sock \
      >> /var/log/suricata/startup.log 2>&1
  fi
done

