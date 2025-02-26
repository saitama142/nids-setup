# Guide de dépannage

Ce document couvre les problèmes les plus courants et leurs solutions lors de l'utilisation de notre outil NIDS Setup.

## Problèmes d'installation

### Erreur: Dépendances manquantes

**Symptôme**: Le message "Impossible d'installer les dépendances requises" s'affiche.

**Solution**:
```bash
# Mise à jour des référentiels
sudo apt update

# Installation manuelle des dépendances
sudo apt install -y libpcre3 libpcre3-dbg libpcre3-dev build-essential libpcap-dev \
                   libnet1-dev libyaml-0-2 libyaml-dev pkg-config zlib1g zlib1g-dev \
                   libcap-ng-dev libcap-ng0 make libmagic-dev libjansson-dev        \
                   libnss3-dev libgeoip-dev liblua5.1-dev libhiredis-dev libevent-dev
```

### Erreur: Version de Suricata non supportée

**Symptôme**: L'installation échoue avec un message concernant la version.

**Solution**:
```bash
# Ajout du PPA officiel de Suricata
sudo add-apt-repository ppa:oisf/suricata-stable
sudo apt update
./install-suricata.sh
```

## Problèmes de configuration

### Erreur: Interface réseau non reconnue

**Symptôme**: Message "L'interface spécifiée n'existe pas" lors de la configuration.

**Solution**:
1. Listez les interfaces disponibles:
   ```bash
   ip a
   ```
2. Relancez la configuration avec la bonne interface:
   ```bash
   ./configure-suricata.sh --interface=INTERFACE_CORRECTE
   ```

### Erreur: Fichier de configuration corrompu

**Symptôme**: Erreur "Impossible d'analyser /etc/suricata/suricata.yaml".

**Solution**:
```bash
# Restaurer une configuration de sauvegarde
./backup-config.sh --restore=DERNIERE_SAUVEGARDE

# Ou régénérer la configuration par défaut
./configure-suricata.sh --reset
```

## Problèmes de performance

### Alerte: Utilisation CPU élevée

**Symptôme**: Suricata utilise trop de ressources CPU.

**Solution**:
1. Ajustez les paramètres de performances:
   ```bash
   sudo nano /etc/suricata/suricata.yaml
   ```
2