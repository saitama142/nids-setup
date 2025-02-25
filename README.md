# 🛡️ Interactive NIDS Setup Tool

An automated, interactive tool for setting up and managing Network Intrusion Detection Systems (Suricata only) with a beautiful CLI interface.

![Security Level: Enterprise Ready](https://img.shields.io/badge/Security-Enterprise%20Ready-blue)
![License: MIT](https://img.shields.io/badge/License-MIT-green)

## 🚀 Quick Start

```bash
git clone https://github.com/saitama142/nids-setup.git
cd nids-setup
chmod -R +x ./*.sh
./setup.sh
```

## ✨ Features

- 🎯 Interactive CLI with clear menus and progress indicators
- 🔄 Automatic dependency resolution
- 🛡️ Support for Suricata
- 📊 Real-time monitoring and statistics
- 🔒 Security-first approach with validation checks
- 🔄 Automated rules updates
- 💾 Configuration backup and restore

## 🔧 System Requirements

- Ubuntu 20.04+ or Debian 11+ (Other distributions may work but are not officially supported)
- Minimum 512MB RAM
- Minimum 5GB free disk space
- Root or sudo access
- Active internet connection

## 📋 Pre-Installation Checklist

The setup script will automatically check for:

- [ ] Operating system compatibility
- [ ] Required disk space
- [ ] System permissions
- [ ] Network connectivity
- [ ] Required dependencies
- [ ] Existing NIDS installations

## 🛠️ Components

1. **Installation Manager**
   - Automated dependency resolution
   - System compatibility checks
   - Clean rollback on failure

2. **Configuration Manager**
   - Interactive network interface selection
   - Rule management
   - Performance tuning

3. **Monitoring Dashboard**
   - Real-time alerts
   - System statistics
   - Log visualization

## 📚 Documentation

Detailed documentation is available in the `docs` directory:
- [Installation Guide](docs/installation.md)
- [Configuration Guide](docs/configuration.md)
- [Troubleshooting](docs/troubleshooting.md)
- [Best Practices](docs/best-practices.md)

## 🐛 Troubleshooting

If you encounter any issues:

1. Check the logs in `/var/log/nids-setup/`
2. Ensure all system requirements are met
3. Run `./setup.sh --diagnose` for a system check
4. Consult the [Troubleshooting Guide](docs/troubleshooting.md)

## 🤝 Contributing

Contributions are welcome! Please read our [Contributing Guidelines](CONTRIBUTING.md).

## 📜 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 🔒 Security

Found a security issue? Please report it privately via our [Security Policy](SECURITY.md).
