# 🛡️ NIDS Setup Tool

![Version](https://img.shields.io/badge/version-1.0.0-blue.svg)
![License](https://img.shields.io/badge/license-MIT-green.svg)
![Platform](https://img.shields.io/badge/platform-Linux-lightgrey.svg)

> Un outil simple et puissant pour installer et configurer un système de détection d'intrusion réseau (NIDS) basé sur Suricata.

<p align="center">
  <img src="https://raw.githubusercontent.com/OISF/suricata/master/doc/images/suricata.png" alt="Suricata Logo" width="300">
</p>

## ✨ Fonctionnalités

- 🚀 Installation automatisée de Suricata
- ⚙️ Configuration guidée pas à pas
- 🔄 Mise à jour des règles de détection
- 💾 Sauvegarde et restauration de configuration
- 📊 Surveillance du système et statistiques
- 🧪 Tests de fonctionnement intégrés

## 📋 Prérequis

- 🐧 Ubuntu/Debian
- 🧠 512MB RAM minimum
- 💽 5GB espace disque minimum
- 🌐 Connexion internet
- 🔑 Droits sudo

## 🚀 Installation rapide

```bash
git clone https://github.com/saitama142/nids-setup/
cd nids-setup
chmod +x setup.sh
./setup.sh
```

## 📜 Scripts disponibles

| Script | Description |
|--------|-------------|
| `setup.sh` | Script principal d'installation |
| `install-suricata.sh` | Installation de Suricata |
| `configure-suricata.sh` | Configuration de Suricata |
| `update-rules.sh` | Mise à jour des règles |
| `view-stats.sh` | Affichage des statistiques |
| `system-status.sh` | État du système |
| `test-nids.sh` | Test de la configuration |
| `backup-config.sh` | Sauvegarde de la configuration |

## 🔧 Utilisation

1. Exécutez `./setup.sh`
2. Suivez les instructions à l'écran
3. Utilisez le menu interactif pour gérer votre NIDS

<details>
<summary>📸 Captures d'écran</summary>
<p align="center">
  <i>Les captures d'écran seront ajoutées prochainement</i>
</p>
</details>

## 📚 Documentation

Consultez le dossier [docs](./docs) pour une documentation détaillée:
- [Guide d'installation](./docs/installation-guide.md)
- [Configuration avancée](./docs/advanced-configuration.md)
- [Mise à jour des règles](./docs/update-rules.md)
- [Sauvegarde et restauration](./docs/backup-restore.md)
- [Dépannage](./docs/troubleshooting.md)

## 🆘 Support

Pour toute question ou problème, créez une issue dans le dépôt ou contactez-nous à support@example.com.

## 📄 Licence

Ce projet est sous licence MIT. Voir le fichier [LICENSE](LICENSE) pour plus de détails.
