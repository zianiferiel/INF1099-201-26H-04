# 🐘 INF1099 — PostgreSQL avec Docker & pgAdmin

> 🎓 Collège Boréal
> 👤 **Auteur : Salim Amir**
> 📅 2026

---

# 🎯 Objectifs

Ce projet permet de :

* 🐳 Déployer PostgreSQL avec Docker / Podman
* 🗄 Créer et gérer une base de données
* 📥 Importer la base **Sakila**
* 🖥 Se connecter avec **pgAdmin 4**
* 📊 Exécuter des requêtes SQL
* ⚡ Utiliser les commandes `psql`

---

# 🧰 Prérequis

* Windows 10/11
* PowerShell
* Docker ou Podman
* Connexion Internet

---

# 🐳 1️⃣ Lancer PostgreSQL

```powershell
docker container run -d `
  --name postgres `
  -e POSTGRES_USER=postgres `
  -e POSTGRES_PASSWORD=postgres `
  -e POSTGRES_DB=appdb `
  -p 5432:5432 `
  -v postgres_data:/var/lib/postgresql/data `
  postgres:16
```

---

# ✅ Vérification

```powershell
docker container ls
docker container logs postgres
```

---

# 📥 2️⃣ Télécharger Sakila

```powershell
Invoke-WebRequest `
https://raw.githubusercontent.com/jOOQ/sakila/master/postgres-sakila-db/postgres-sakila-schema.sql `
-OutFile postgres-sakila-schema.sql

Invoke-WebRequest `
https://raw.githubusercontent.com/jOOQ/sakila/master/postgres-sakila-db/postgres-sakila-insert-data.sql `
-OutFile postgres-sakila-insert-data.sql
```

---

# 📂 3️⃣ Copier dans le conteneur

```powershell
docker container cp postgres-sakila-schema.sql postgres:/schema.sql
docker container cp postgres-sakila-insert-data.sql postgres:/data.sql
```

---

# ⚙️ 4️⃣ Importer Sakila

```powershell
docker container exec -it postgres psql -U postgres -d appdb -f /schema.sql
```

```powershell
docker container exec -it postgres psql -U postgres -d appdb -f /data.sql
```

---

# 🔍 5️⃣ Vérification

```powershell
docker container exec -it postgres psql -U postgres -d appdb
```

Dans PostgreSQL :

```sql
\dt
SELECT COUNT(*) FROM film;
SELECT COUNT(*) FROM actor;
```

---

# 🖥 6️⃣ Installer pgAdmin

```powershell
choco install pgadmin4 -y
```

Lancer :

```powershell
pgadmin4
```

---

# 🔗 7️⃣ Connexion pgAdmin

* Host : `localhost`
* Port : `5432`
* User : `postgres`
* Password : `postgres`
* Database : `appdb`

---

# 📊 8️⃣ Requêtes SQL

### 🔹 Requête 1

```sql
SELECT title 
FROM film 
WHERE title ILIKE '%Star%';
```

### 🔹 Requête 2

```sql
SELECT COUNT(*) 
FROM actor;
```

---

# ⚡ 9️⃣ Commandes utiles (psql)

```sql
\dt       -- tables
\d film   -- structure table
\l        -- bases de données
\du       -- utilisateurs
\conninfo -- info connexion
\q        -- quitter
```

---

# 🔄 Réinitialisation

```powershell
docker container rm -f postgres
docker volume rm postgres_data
docker volume ls
```

---

# 🎉 Résultat final

✅ PostgreSQL fonctionnel
✅ Base Sakila importée
✅ pgAdmin connecté
✅ Requêtes SQL exécutées

---

# 👨‍💻 Auteur

**Salim Amir**
INF1099 — Collège Boréal
2026

---
