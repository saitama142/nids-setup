# 🛡️ NIDS Setup Tool

![Version](https://img.shields.io/badge/version-0.1.2-blue.svg)
![License](https://img.shields.io/badge/license-MIT-green.svg)
![Platform](https://img.shields.io/badge/platform-Linux-lightgrey.svg)

> A secure, lightweight tool for installing and configuring a Network Intrusion Detection System (NIDS) based on Suricata.

## ✨ Features

- 🚀 Automated Suricata installation
- ⚙️ Step-by-step guided configuration
- 🔄 Detection rules update
- 💾 Configuration backup and restore
- 🛡️ Security-focused design
- 🧪 Integrated functionality tests
- 🔒 Minimal dependencies

## 📋 Prerequisites

- 🐧 Ubuntu/Debian
- 🧠 512MB RAM minimum
- 💽 5GB disk space minimum
- 🌐 Internet connection
- 🔑 Sudo rights

## 🚀 Quick Installation

```bash
git clone https://github.com/saitama142/nids-setup/
cd nids-setup
chmod +x setup.sh
./setup.sh
```

## 📜 Core Scripts

| Script | Description | Security Level |
|--------|-------------|----------------|
| `setup.sh` | Main installation script | 🔐 Requires root |
| `install-suricata.sh` | Suricata installation | 🔐 Requires root |
| `configure-suricata.sh` | Suricata configuration | 🔐 Requires root |
| `update-rules.sh` | Rules update | 🔒 Runs as user |
| `system-status.sh` | System status | 🔒 Runs as user |
| `test-nids.sh` | Configuration testing | 🔒 Runs as user |
| `backup-config.sh` | Configuration backup | 🔐 Requires root |

## 🔐 Security Considerations

- All scripts perform basic sanity checks before execution
- Root privileges are only requested when absolutely necessary
- No persistent web services or open ports
- Minimal dependencies (only Suricata and basic system tools)
- All configuration files preserve original permissions

## 🔧 Usage

```bash
# Standard installation
sudo ./setup.sh

# Post-installation management
./system-status.sh    # Check system health
./update-rules.sh     # Update detection rules
./test-nids.sh        # Verify configuration

# Interactive mode
./setup.sh --interactive

## 📚 Documentation

Check the [docs](./docs) folder for detailed documentation:
- [Rules Update](./docs/update-rules.md)
- [Backup and Restore](./docs/backup-restore.md)
- [Troubleshooting](./docs/troubleshooting.md)

## 📄 License

This project is licensed under the MIT License. See the [LICENSE](LICENSE) file for details.
