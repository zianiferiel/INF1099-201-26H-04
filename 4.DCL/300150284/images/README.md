# 📝 TP PostgreSQL – DCL (Gestion des utilisateurs et permissions)

## 👤 Nom

Aroua Mohand Tahar

## 🎯 Objectif

Ce TP a pour objectif de :

* Créer des utilisateurs dans PostgreSQL
* Gérer leurs permissions (lecture / écriture)
* Tester les droits
* Comprendre le fonctionnement du DCL

---

## 📚 Définition

Le **DCL (Data Control Language)** permet de gérer les droits d’accès dans une base de données.

Commandes principales :

* `CREATE USER` : créer un utilisateur
* `GRANT` : donner des permissions
* `REVOKE` : retirer des permissions
* `DROP USER` : supprimer un utilisateur

---

## ⚙️ Étapes réalisées

### 1️⃣ Connexion au conteneur et à PostgreSQL

```bash
docker container exec -it postgres bash
psql -U postgres
```

---

### 2️⃣ Création de la base et du schéma

```sql
CREATE DATABASE cours;
\c cours

CREATE SCHEMA tp_dcl;
```

---

### 3️⃣ Création de la table

```sql
CREATE TABLE tp_dcl.etudiants (
    id SERIAL PRIMARY KEY,
    nom TEXT,
    moyenne NUMERIC
);
```

---

### 4️⃣ Création des utilisateurs

```sql
CREATE USER etudiant WITH PASSWORD 'etudiant123';
CREATE USER professeur WITH PASSWORD 'prof123';
```

---

### 5️⃣ Attribution des droits

#### Accès à la base

```sql
GRANT CONNECT ON DATABASE cours TO etudiant, professeur;
```

#### Accès au schéma

```sql
GRANT USAGE ON SCHEMA tp_dcl TO etudiant, professeur;
```

#### Permissions sur la table

```sql
GRANT SELECT ON tp_dcl.etudiants TO etudiant;

GRANT SELECT, INSERT, UPDATE, DELETE 
ON tp_dcl.etudiants TO professeur;
```

#### Permissions sur la séquence

```sql
GRANT USAGE, SELECT, UPDATE 
ON SEQUENCE tp_dcl.etudiants_id_seq TO professeur;
```

---

### 6️⃣ Test des permissions

#### Utilisateur etudiant

```sql
SELECT * FROM tp_dcl.etudiants;   -- OK
INSERT INTO tp_dcl.etudiants VALUES ('Patrick', 85); -- ERREUR
```

#### Utilisateur professeur

```sql
INSERT INTO tp_dcl.etudiants(nom, moyenne) VALUES ('Khaled', 90); -- OK
UPDATE tp_dcl.etudiants SET moyenne=95 WHERE nom='Khaled'; -- OK
```

---

### 7️⃣ Retrait des permissions

```sql
REVOKE SELECT ON tp_dcl.etudiants FROM etudiant;
```

Test :

```sql
SELECT * FROM tp_dcl.etudiants; -- ERREUR
```

---

### 8️⃣ Suppression des utilisateurs

Avant suppression, retirer les droits :

```sql
REVOKE ALL ON tp_dcl.etudiants FROM etudiant;
REVOKE ALL ON tp_dcl.etudiants FROM professeur;

REVOKE ALL ON SEQUENCE tp_dcl.etudiants_id_seq FROM professeur;

REVOKE ALL ON SCHEMA tp_dcl FROM etudiant;
REVOKE ALL ON SCHEMA tp_dcl FROM professeur;

REVOKE CONNECT ON DATABASE cours FROM etudiant;
REVOKE CONNECT ON DATABASE cours FROM professeur;
```

Puis suppression :

```sql
DROP USER etudiant;
DROP USER professeur;
```

---

## 🧠 Conclusion

Ce TP m’a permis de comprendre que :

* Les permissions doivent être gérées à plusieurs niveaux (base, schéma, table)
* `GRANT` permet d’attribuer des droits
* `REVOKE` permet de les retirer
* Un utilisateur ne peut pas être supprimé s’il a encore des permissions

---

## ✅ Résultat

✔ Gestion complète des utilisateurs
✔ Contrôle des accès réussi
✔ Tests fonctionnels validés

---

## 💡 Remarque

Ce TP montre l’importance de la sécurité dans une base de données et le contrôle des accès selon les rôles des utilisateurs.

