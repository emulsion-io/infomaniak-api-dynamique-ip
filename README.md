# infomaniak-api-dynamique-ip
Edit subdomaine name with IP dynamique in PHP

Ce script est conçu pour automatiser la mise à jour de l'adresse IP d'un serveur dans la zone DNS d'Infomaniak.  
Il est exécuté tous les soirs à une heure prédéfinie (voir crontab sur votre serveur).  
Il utilise les informations d'un compte DynDNS  pour se connecter à Infomaniak.  
Le script utilise une API Tier pour récupérer l'adresse IP public actuelle du serveur.  
Ensuite le script met à jour l'adresse IP dans la zone DNS d'Infomaniak avec l'adresse IP actuelle du serveur.

## Configuration

### Prérequis
PHP 5.6 ou supérieur  
Un compte Infomaniak avec un utilisateur DynDNS configuré  
Un domaine géré par Infomaniak

### Installation
```bash
crontab -e
```

Ajouter la ligne suivante pour exécuter le script tous les soirs à 1h du matin
```bash
0 1 * * * php /chemin/vers/le/script/index.php
```
Remplacer le chemin par le chemin vers le script sur votre serveur.

### Configuration du script
renommer le fichier config.ini.dev en config.ini
```bash
mv config.ini.dev config.php
```

Editer le fichier config.php
```bash
nano config.ini
```
Modifier selon vos besoins.