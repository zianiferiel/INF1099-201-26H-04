# 🔐 TP PostgreSQL — Gestion des utilisateurs et permissions (DCL)

## 📋 Objectifs

- Créer des utilisateurs
- Gérer leurs droits (lecture/écriture)
- Tester les permissions
- Comprendre l'importance des droits sur la base, le schéma et les tables

---

## 🖥️ Environnement

| Élément | Version |
|---|---|
| Système d'exploitation | Windows |
| PostgreSQL | 16.13 |
| Conteneur Docker | postgres |

---

## 1️⃣ Préparation — Connexion et création de la base

### Entrer dans le conteneur et se connecter

```powershell
docker container exec --interactive --tty postgres bash
```

```bash
psql -U postgres
```

### Capture d'écran — Connexion en tant que superutilisateur

![Connexion psql superutilisateur](./images/Screenshot%202026-03-27%20181325.png)

---

### Créer la base, le schéma et la table

```sql
CREATE DATABASE cours;
\c cours
CREATE SCHEMA tp_dcl;
CREATE TABLE tp_dcl.etudiants (
    id SERIAL PRIMARY KEY,
    nom TEXT,
    moyenne NUMERIC
);
```

### Capture d'écran — Création de la base, schéma et table

![Création base cours, schéma tp_dcl et table etudiants](./images/Screenshot%202026-03-27%20181548.png)

---

## 2️⃣ Créer des utilisateurs

```sql
-- Étudiant simple (lecture)
CREATE USER etudiant WITH PASSWORD 'etudiant123';

-- Professeur (lecture/écriture)
CREATE USER professeur WITH PASSWORD 'prof123';
```

### Capture d'écran — Création des utilisateurs

![CREATE ROLE etudiant et professeur](./images/Screenshot%202026-03-27%20181648.png)

---

## 3️⃣ Donner des droits (GRANT)

```sql
-- Connexion à la base
GRANT CONNECT ON DATABASE cours TO etudiant, professeur;

-- Accès au schéma
GRANT USAGE ON SCHEMA tp_dcl TO etudiant, professeur;

-- Étudiant : lecture seule
GRANT SELECT ON tp_dcl.etudiants TO etudiant;

-- Professeur : lecture + écriture
GRANT SELECT, INSERT, UPDATE, DELETE ON tp_dcl.etudiants TO professeur;

-- Droits sur la séquence
GRANT USAGE, SELECT, UPDATE ON SEQUENCE tp_dcl.etudiants_id_seq TO professeur;
```

### Capture d'écran — Attribution des droits

![GRANT des permissions aux utilisateurs](./images/Screenshot%202026-03-27%20181747.png)

---

## 4️⃣ Vérifier les droits

### Test avec l'utilisateur étudiant

```bash
psql -U etudiant -d cours
```

```sql
SELECT * FROM tp_dcl.etudiants;  -- ✅ OK
INSERT INTO tp_dcl.etudiants(nom, moyenne) VALUES ('Patrick', 85); -- ❌ ERREUR
```

### Capture d'écran — SELECT autorisé, INSERT refusé

![SELECT OK et INSERT permission denied pour etudiant](./images/Screenshot%202026-03-27%20181858.png)

---

### Test avec l'utilisateur professeur

```bash
psql -U professeur -d cours
```

```sql
INSERT INTO tp_dcl.etudiants(nom, moyenne) VALUES ('Khaled', 90); -- ✅ OK
UPDATE tp_dcl.etudiants SET moyenne=95 WHERE nom='Khaled';        -- ✅ OK
```

### Capture d'écran — INSERT et UPDATE autorisés

![INSERT et UPDATE réussis pour professeur](./images/Screenshot%202026-03-27%20182015.png)

---

## 5️⃣ Retirer des droits (REVOKE)

```sql
-- Retirer le droit lecture à l'étudiant
REVOKE SELECT ON tp_dcl.etudiants FROM etudiant;

-- Vérifier : basculer sur l'utilisateur etudiant
\c - etudiant
SELECT * FROM tp_dcl.etudiants;  -- ❌ ERREUR
```

### Capture d'écran — REVOKE et permission denied

![REVOKE SELECT et erreur permission denied](./images/Screenshot%202026-03-27%20182134.png)

---

## 6️⃣ Supprimer les utilisateurs (DROP USER)

> ⚠️ PostgreSQL ne permet pas de supprimer un utilisateur si des droits existent encore. Il faut d'abord faire REVOKE ALL.

```sql
-- Tentative initiale (erreur attendue)
DROP USER etudiant;
DROP USER professeur;

-- Retirer tous les droits d'abord
\c cours
REVOKE ALL ON tp_dcl.etudiants FROM etudiant, professeur;
REVOKE ALL ON SEQUENCE tp_dcl.etudiants_id_seq FROM professeur;
REVOKE ALL ON SCHEMA tp_dcl FROM etudiant, professeur;
REVOKE ALL ON DATABASE cours FROM etudiant, professeur;

-- Supprimer les utilisateurs
\c postgres
DROP USER etudiant;
DROP USER professeur;
```

### Capture d'écran — Erreur DROP USER et résolution

![Erreur DROP USER et REVOKE ALL avant suppression](./images/Screenshot%202026-03-27%20182444.png)

---

## 🧠 À retenir

| Concept | Explication |
|---|---|
| `GRANT` | Donne des permissions à un utilisateur |
| `REVOKE` | Retire des permissions à un utilisateur |
| `CREATE USER` | Crée un nouvel utilisateur (rôle) |
| `DROP USER` | Supprime un utilisateur |
| Niveau Database | Contrôle la connexion |
| Niveau Schema | Contrôle l'accès aux objets |
| Niveau Table | Contrôle les droits CRUD |

> PostgreSQL sépare les droits en 3 niveaux : **Database → Schema → Table**. Il faut accorder les droits aux 3 niveaux pour qu'un utilisateur puisse accéder à une table.

---

## 📚 Références

- [Documentation PostgreSQL — GRANT](https://www.postgresql.org/docs/current/sql-grant.html)
- [Documentation PostgreSQL — CREATE USER](https://www.postgresql.org/docs/current/sql-createuser.html)
- [Documentation PostgreSQL — REVOKE](https://www.postgresql.org/docs/current/sql-revoke.html)
