# Guide d'Installation

Ce guide vous accompagnera à travers le processus complet d'installation et de configuration initiale de votre NIDS basé sur Suricata.

## Méthodes d'installation

### 1. Installation automatisée (recommandée)

```bash
./setup.sh
```

Cette commande lance l'assistant d'installation qui vous guidera à travers toutes les étapes nécessaires.

### 2. Installation manuelle

Si vous préférez installer les composants individuellement:

```bash
# Installation de Suricata
./install-suricata.sh

# Configuration
./configure-suricata.sh

# Première mise à jour des règles
./update-rules.sh
```

## Options d'installation avancées

Vous pouvez passer des paramètres au script d'installation:

```bash
./setup.sh --no-prompt        # Installation sans questions
./setup.sh --minimal          # Installation minimale
./setup.sh --interface=eth0   # Spécifier l'interface à surveiller
```

## Vérification de l'installation

Après l'installation, vérifiez que tout fonctionne correctement:

```bash
./system-status.sh
./test-nids.sh
```

## Résolution des problèmes courants

### Suricata ne démarre pas

Vérifiez les journaux:
```bash
sudo journalctl -u suricata
```

### Erreurs de configuration

Validez votre configuration:
```bash
suricata -T -c /etc/suricata/suricata.yaml
```

## Configuration post-installation recommandée

1. Configurez des alertes par email
2. Intégrez avec votre système de journalisation
3. Établissez une rotation des logs
4. Planifiez des mises à jour automatiques des règles
