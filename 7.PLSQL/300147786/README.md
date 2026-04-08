# 🐘 PL/pgSQL — Procédures, Fonctions & Triggers

Démonstration de PL/pgSQL avec PostgreSQL via Podman : tables, données, procédures stockées, fonctions et triggers.

---

## 📁 Structure
📁 /
├── tests/
│   ├── 01-ddl.sql
│   ├── 02-dml.sql
│   └── 03-programmation.sql

---

## 🚀 Démarrage rapide

**Se connecter à la base :**

```powershell
podman exec -it tp_postgres psql -U etudiant -d tpdb
```

**Charger les scripts dans l'ordre :**

```sql
\i /tests/01-ddl.sql
\i /tests/02-dml.sql
\i /tests/03-programmation.sql
```

---

## ✅ Résultats

**DDL — Création des tables**

**DML — Insertion de 10 étudiants**
---

## 🔍 Vérifications

**Table `etudiants` — 10 enregistrements**

```sql
SELECT * FROM etudiants;
SELECT COUNT(*) FROM etudiants;  -- 10
```

**Table `logs` — Trigger actif à chaque INSERT**

```sql
SELECT * FROM logs;
```

Chaque insertion dans `etudiants` génère automatiquement une entrée dans `logs` grâce au trigger.

---

## 🔧 Technologies

![PostgreSQL](https://img.shields.io/badge/PostgreSQL-316192?style=for-the-badge&logo=postgresql&logoColor=white)
![Docker](https://img.shields.io/badge/Podman-892CA0?style=for-the-badge&logo=podman&logoColor=white)
![PowerShell](https://img.shields.io/badge/PowerShell-5391FE?style=for-the-badge&logo=powershell&logoColor=white)
