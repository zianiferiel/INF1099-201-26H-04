## 📚 TP 2 – MySQL avec Docker / Podman

---

## 🎯 Objectif

Ce TP consiste à :

* Lancer un serveur MySQL avec Docker ou Podman
* Créer une base de données
* Créer un utilisateur
* Importer la base Sakila
* Vérifier les tables

---

## 🚀 Étapes

### 1. Lancer MySQL

```powershell
docker run -d --name INF1099-mysql -e MYSQL_ROOT_PASSWORD=rootpass -p 3306:3306 mysql:8.0
```

---

### 2. Créer la base de données

```powershell
docker exec INF1099-mysql mysql -u root -prootpass -e "CREATE DATABASE sakila;"
```

---

### 3. Créer l'utilisateur

```powershell
docker exec INF1099-mysql mysql -u root -prootpass -e "CREATE USER 'etudiants'@'%' IDENTIFIED BY 'etudiants_1';"
docker exec INF1099-mysql mysql -u root -prootpass -e "GRANT ALL PRIVILEGES ON *.* TO 'etudiants'@'%' WITH GRANT OPTION;"
docker exec INF1099-mysql mysql -u root -prootpass -e "FLUSH PRIVILEGES;"
```

---

### 4. Importer la base Sakila

```powershell
Get-Content "$env:USERPROFILE\Downloads\INF1099\sakila-db\sakila-schema.sql" |
docker exec -i INF1099-mysql mysql -u etudiants -petudiants_1 sakila

Get-Content "$env:USERPROFILE\Downloads\INF1099\sakila-db\sakila-data.sql" |
docker exec -i INF1099-mysql mysql -u etudiants -petudiants_1 sakila
```

---

### 5. Vérifier les tables

```powershell
docker exec INF1099-mysql mysql -u etudiants -petudiants_1 -e "USE sakila; SHOW TABLES;"
```

---

## ▶️ Exécution du script

```powershell
.\start-sakila-INF1099.ps1
```

---

## ✅ Résultat

La base de données Sakila est importée avec succès et contient plusieurs tables comme :

* actor
* film
* customer
* rental
* payment

---

## 👨‍🎓 Auteur

Projet réalisé dans le cadre du cours INF1099.
