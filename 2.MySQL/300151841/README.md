# 🐬 TP INF1099 — MySQL avec Podman

> **INF1099 — Bases de données** · Massinissa Mameri · Hiver 2026

---

## 📋 Table des matières

- [Objectif](#-objectif)
- [Environnement utilisé](#️-environnement-utilisé)
- [Étapes réalisées](#-étapes-réalisées)
  - [Étape 1 — Installation et configuration de Podman](#1️⃣-étape-1--installation-et-configuration-de-podman)
  - [Étape 2 — Création du dossier de travail](#2️⃣-étape-2--création-du-dossier-de-travail)
  - [Étape 3 — Préparation de la base Sakila](#3️⃣-étape-3--préparation-de-la-base-sakila)
  - [Étape 4 — Alias Docker vers Podman](#4️⃣-étape-4--alias-docker-vers-podman)
  - [Étape 5 — Lancement du conteneur MySQL](#5️⃣-étape-5--lancement-du-conteneur-mysql)
  - [Étape 6 — Création de la base Sakila](#6️⃣-étape-6--création-de-la-base-sakila)
  - [Étape 7 — Création de l'utilisateur](#7️⃣-étape-7--création-de-lutilisateur)
  - [Étape 8 — Importation de Sakila](#8️⃣-étape-8--importation-de-sakila)
  - [Étape 9 — Vérification finale](#9️⃣-étape-9--vérification-finale)
- [Conclusion](#-conclusion)
- [Captures d'écran](#-captures-décran)

---

## 🎯 Objectif

Ce TP consiste à mettre en place un environnement MySQL complet sous Windows via Podman :

| # | Objectif |
|---|----------|
| ✅ | Installer et configurer Podman avec WSL2 |
| ✅ | Lancer un conteneur MySQL |
| ✅ | Créer la base de données Sakila |
| ✅ | Créer un utilisateur MySQL |
| ✅ | Importer les données Sakila |
| ✅ | Vérifier la présence des tables |

---

## 🛠️ Environnement utilisé

| Composant | Version / Détail |
|-----------|-----------------|
| 💻 OS | Windows 10/11 (64 bits) |
| ⚙️ Shell | PowerShell (Administrateur) |
| 🐳 Podman | 5.7.1 |
| 🐧 WSL2 | Activé |
| 🐬 MySQL | 8.0 (conteneur) |
| 🗄️ Base de données | Sakila (officielle MySQL) |

---

## 📦 Étapes réalisées

---

### 1️⃣ Étape 1 — Installation et configuration de Podman

Vérification de la version et initialisation de la machine Podman :

```powershell
podman --version
podman machine init
podman machine start
podman machine list
```

---

### 2️⃣ Étape 2 — Création du dossier de travail

```powershell
$projectDir = "$env:USERPROFILE\Downloads\INF1099"
New-Item -ItemType Directory -Path $projectDir -Force
```

---

### 3️⃣ Étape 3 — Préparation de la base Sakila

Extraction de l'archive téléchargée :

```powershell
Expand-Archive -Path "$projectDir\sakila-db.zip" -DestinationPath $projectDir -Force
```

Fichiers obtenus après extraction :

```
sakila-db/
├── sakila-schema.sql   # Structure des tables
└── sakila-data.sql     # Données à importer
```

---

### 4️⃣ Étape 4 — Alias Docker vers Podman

```powershell
Set-Alias docker podman
```

> Cet alias permet d'utiliser la commande `docker` comme raccourci vers `podman`.

---

### 5️⃣ Étape 5 — Lancement du conteneur MySQL

```powershell
docker run -d --name INF1099-mysql `
  -e MYSQL_ROOT_PASSWORD=rootpass `
  -p 3306:3306 `
  mysql:8.0
```

Vérification que le conteneur est actif :

```powershell
docker ps
```

---

### 6️⃣ Étape 6 — Création de la base Sakila

```powershell
docker exec -it INF1099-mysql mysql -u root -prootpass -e "CREATE DATABASE sakila;"
```

Vérification :

```powershell
docker exec -it INF1099-mysql mysql -u root -prootpass -e "SHOW DATABASES;"
```

---

### 7️⃣ Étape 7 — Création de l'utilisateur

Création de l'utilisateur `etudiants` :

```powershell
docker exec -it INF1099-mysql mysql -u root -prootpass -e \
  "CREATE USER 'etudiants'@'%' IDENTIFIED BY 'etudiants_1';"
```

Attribution des permissions sur la base Sakila :

```powershell
docker exec -it INF1099-mysql mysql -u root -prootpass -e \
  "GRANT ALL PRIVILEGES ON sakila.* TO 'etudiants'@'%'; FLUSH PRIVILEGES;"
```

---

### 8️⃣ Étape 8 — Importation de Sakila

**Import du schéma (structure des tables) :**

```powershell
Get-Content "$projectDir\sakila-db\sakila-schema.sql" |
  docker exec -i INF1099-mysql mysql -u etudiants -petudiants_1 sakila
```

**Import des données :**

```powershell
Get-Content "$projectDir\sakila-db\sakila-data.sql" |
  docker exec -i INF1099-mysql mysql -u etudiants -petudiants_1 sakila
```

---

### 9️⃣ Étape 9 — Vérification finale

```powershell
docker exec -it INF1099-mysql mysql -u etudiants -petudiants_1 -e "USE sakila; SHOW TABLES;"
```

> ✅ Les tables `actor`, `film`, `customer`, `category`, etc. sont présentes.

---

## ✅ Conclusion

| Résultat | Statut |
|----------|--------|
| Conteneur MySQL fonctionnel avec Podman | ✔️ |
| Base Sakila importée avec succès | ✔️ |
| Environnement prêt pour les exercices SQL | ✔️ |

---

## 📸 Captures d'écran

---

**Capture 1 —**

![Capture 1](https://github.com/user-attachments/assets/fc263246-769a-4789-9b6c-d008eea9fac5)

---

**Capture 2 — Machine Podman active**

<img width="938" height="178" alt="Machine Podman en cours d'exécution" src="https://github.com/user-attachments/assets/8c71d200-5d06-45ef-a583-27013c5e6c2d" />

---

**Capture 3 — Conteneur MySQL actif**

<img width="941" height="171" alt="Conteneur MySQL actif" src="https://github.com/user-attachments/assets/c3cedcf5-6ca1-4d6f-b1d0-ba17cd4cd873" />

---

**Capture 4 — Bases de données MySQL**

<img width="940" height="663" alt="Bases de données MySQL" src="https://github.com/user-attachments/assets/bbba65d9-8128-414e-8220-9c0524821760" />

---

**Capture 5 — Tables Sakila**

<img width="929" height="456" alt="Tables Sakila (preuve finale)" src="https://github.com/user-attachments/assets/63dc9525-a725-419b-81a3-7ae91b27ab8c" />

---

**Capture 6 — Connexion Workbench**

<img width="1207" height="1020" alt="connexion sur workbench" src="https://github.com/user-attachments/assets/e21cce2a-4482-454c-ab6f-79d995f8f911" />

---

*Cours INF1099 — Bases de données · Massinissa Mameri · Hiver 2026*
