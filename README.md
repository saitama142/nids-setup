# NIDS Setup Tool

Un outil simple pour installer et configurer un système de détection d'intrusion réseau (NIDS).

## Prérequis

- Ubuntu/Debian
- 512MB RAM minimum
- 5GB espace disque minimum
- Connexion internet
- Droits sudo

## Installation

```bash
git clone https://github.com/saitama142/nids-setup/
cd nids-setup
chmod +x setup.sh
./setup.sh
```

## Scripts disponibles

- `setup.sh` - Script principal d'installation
- `install-suricata.sh` - Installation de Suricata
- `configure-suricata.sh` - Configuration de Suricata
- `update-rules.sh` - Mise à jour des règles
- `view-stats.sh` - Affichage des statistiques
- `system-status.sh` - État du système
- `test-nids.sh` - Test de la configuration
- `backup-config.sh` - Sauvegarde de la configuration

## Utilisation

1. Exécutez `./setup.sh`
2. Suivez les instructions à l'écran
3. Utilisez le menu pour gérer votre NIDS

## Support

Pour toute question ou problème, créez une issue dans le dépôt.
