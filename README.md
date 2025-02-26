# 🛡️ NIDS Setup Tool

![Version](https://img.shields.io/badge/version-0.1.2-blue.svg)
![License](https://img.shields.io/badge/license-MIT-green.svg)
![Platform](https://img.shields.io/badge/platform-Linux-lightgrey.svg)

> A simple yet powerful tool for installing and configuring a Network Intrusion Detection System (NIDS) based on Suricata.

## ✨ Features

- 🚀 Automated Suricata installation
- ⚙️ Step-by-step guided configuration
- 🔄 Detection rules update
- 💾 Configuration backup and restore
- 📊 System monitoring and statistics
- 🧪 Integrated functionality tests

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

## 📜 Available Scripts

| Script | Description |
|--------|-------------|
| `setup.sh` | Main installation script |
| `install-suricata.sh` | Suricata installation |
| `configure-suricata.sh` | Suricata configuration |
| `update-rules.sh` | Rules update |
| `view-stats.sh` | Statistics display |
| `system-status.sh` | System status |
| `test-nids.sh` | Configuration testing |
| `backup-config.sh` | Configuration backup |

## 🔧 Usage

1. Run `./setup.sh`
2. Follow on-screen instructions
3. Use the interactive menu to manage your NIDS

<details>
<summary>📸 Screenshots</summary>
<p align="center">
  <i>Screenshots will be added soon</i>
</p>
</details>

## 📚 Documentation

Check the [docs](./docs) folder for detailed documentation:
- [Advanced Configuration](./docs/advanced-configuration.md)
- [Rules Update](./docs/update-rules.md)
- [Backup and Restore](./docs/backup-restore.md)
- [Troubleshooting](./docs/troubleshooting.md)

## 📄 License

This project is licensed under the MIT License. See the [LICENSE](LICENSE) file for details.
