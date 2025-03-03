# Backup and Restore

## How Backups Work

The `backup-config.sh` script creates comprehensive backups of your NIDS configuration:

- Creates a compressed tar archive of configuration files
- Stores backups in `/var/lib/nids-backup` (or `/tmp/nids-backup` if not accessible)
- Keeps the 5 most recent backups with timestamps
- Includes all custom rules and modifications
- Generates a backup log with configuration details

## Restoring Backups

To restore from a backup:

```bash
# List available backups
./backup-config.sh --list

# Restore from the most recent backup
./backup-config.sh --restore

# Restore from a specific backup
./backup-config.sh --restore=/var/lib/nids-backup/nids-backup-20220315-143022.tar.gz
```

The restore process:
1. Validates the backup archive integrity
2. Creates a backup of the current state before proceeding
3. Extracts configuration files to their original locations
4. Restarts services to apply the restored configuration
5. Performs a configuration test to verify restoration success

## Automated Backups

Consider scheduling regular backups:

```bash
# Example: Daily backup at 2:30 AM
30 2 * * * /path/to/backup-config.sh
```
