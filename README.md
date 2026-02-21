# infomaniak-api-dynamique-ip
Edit subdomaine name with IP dynamique in PHP

Ce script est concu pour automatiser la mise a jour de l'adresse IP d'un serveur dans la zone DNS d'Infomaniak.
Il est execute tous les soirs a une heure predefinie (voir crontab sur votre serveur).
Il utilise les informations d'un compte DynDNS pour se connecter a Infomaniak.
Le script utilise une API tierce pour recuperer l'adresse IP publique actuelle du serveur.
Ensuite le script met a jour l'IP dans la zone DNS d'Infomaniak avec l'adresse IP actuelle du serveur.

## Configuration

### Prerequis
PHP 5.6 ou superieur
Un compte Infomaniak avec un utilisateur DynDNS configure
Un domaine gere par Infomaniak

### Creation d'un utilisateur DynDNS
```text
Web & Domaine > Domaine > Choix du Domaine > Dynamic DNS
```

### Installation PHP
```bash
crontab -e
```

Ajouter la ligne suivante pour executer le script tous les soirs a 1h du matin:
```bash
0 1 * * * php /chemin/vers/le/script/index.php
```

### Configuration du script
Renommer le fichier `config.ini.dev` en `config.ini`:
```bash
mv config.ini.dev config.ini
```

Editer le fichier:
```bash
nano config.ini
```

## Alternative Linux sans PHP

Une version Bash est disponible dans `index.sh`.
Elle lit le meme `config.ini` et fait les memes appels DynDNS Infomaniak.

### Prerequis
- bash
- curl

### Lancer manuellement
```bash
chmod +x /chemin/vers/le/script/index.sh
/chemin/vers/le/script/index.sh
```

Optionnel: passer un chemin de config personnalise:
```bash
/chemin/vers/le/script/index.sh /chemin/vers/le/script/config.ini
```

### Cron Linux sans PHP
```bash
0 1 * * * /chemin/vers/le/script/index.sh >> /var/log/infomaniak-dyndns.log 2>&1
```
