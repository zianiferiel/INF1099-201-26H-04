# TP PostgreSQL — Procédures Stockées, Fonctions et Triggers

## 📁 Structure du projet

```
tp_postgres/
│
├── init/
│   ├── 01-ddl.sql            → Création des tables
│   ├── 02-dml.sql            → Données initiales
│   └── 03-programmation.sql  → Fonctions, procédures et triggers
│
├── tests/
│   └── test.sql              → Jeu de tests complet
│
└── README.md
```

---

## 🐳 Lancer PostgreSQL avec Docker

### 🪟 Windows (PowerShell)

```powershell
docker run -d `
  --name tp_postgres `
  -e POSTGRES_USER=etudiant `
  -e POSTGRES_PASSWORD=etudiant `
  -e POSTGRES_DB=tpdb `
  -p 5432:5432 `
  -v ${PWD}/init:/docker-entrypoint-initdb.d `
  postgres:15
```

### 🐧 Linux / macOS

```bash
docker run -d \
  --name tp_postgres \
  -e POSTGRES_USER=etudiant \
  -e POSTGRES_PASSWORD=etudiant \
  -e POSTGRES_DB=tpdb \
  -p 5432:5432 \
  -v ${PWD}/init:/docker-entrypoint-initdb.d \
  postgres:15
```

> 💡 Les fichiers SQL dans `init/` sont exécutés **automatiquement** au démarrage dans l'ordre alphabétique.

---

## 🔌 Se connecter à la base

```bash
docker exec -it tp_postgres psql -U etudiant -d tpdb
```

---

## ✅ Lancer les tests

### 🪟 Windows (PowerShell)

```powershell
Get-Content tests/test.sql | docker exec -i tp_postgres psql -U etudiant -d tpdb
```

### 🐧 Linux / macOS

```bash
docker exec -i tp_postgres psql -U etudiant -d tpdb < tests/test.sql
```

---

## 📋 Ce que contient `03-programmation.sql`

| Élément | Type | Description |
|---|---|---|
| `ajouter_etudiant` | PROCEDURE | Ajoute un étudiant avec validation âge/email et journalisation |
| `nombre_etudiants_par_age` | FUNCTION | Retourne le nombre d'étudiants dans une tranche d'âge |
| `inscrire_etudiant_cours` | PROCEDURE | Inscrit un étudiant à un cours avec vérifications |
| `valider_etudiant` | TRIGGER (BEFORE INSERT) | Bloque toute insertion invalide dans `etudiants` |
| `log_action` | TRIGGER (AFTER INSERT/UPDATE/DELETE) | Journalise toutes les modifications dans `logs` |

---

## 🗄️ Tables de la base

| Table | Description |
|---|---|
| `etudiants` | Données des étudiants |
| `cours` | Liste des cours disponibles |
| `inscriptions` | Liens entre étudiants et cours |
| `logs` | Journal automatique de toutes les actions |
