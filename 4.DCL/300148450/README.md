# 🗄️ TP PostgreSQL — Gestion des accès (DCL)

## 👤 Informations de l’étudiant
- **Nom :** Adjaoud Hocine  
- **Numéro étudiant :** 300148450  

---

## 📌 Description du laboratoire

Ce laboratoire vise à explorer le **Data Control Language (DCL)** dans PostgreSQL.  
Il permet de comprendre comment gérer les accès et sécuriser les données en attribuant des permissions spécifiques aux utilisateurs.

L’approche adoptée consiste à créer des rôles distincts, leur assigner des privilèges adaptés, puis vérifier leur comportement dans un environnement contrôlé.

---

## 🎯 Objectifs pédagogiques

- Comprendre le rôle du DCL dans un système de gestion de base de données  
- Créer des utilisateurs avec différents niveaux d’accès  
- Attribuer et retirer des privilèges  
- Tester les permissions selon les rôles  
- Comprendre la hiérarchie des droits dans PostgreSQL  

---

## ⚙️ Environnement technique

- **SGBD :** PostgreSQL  
- **Accès :** Terminal via `psql`  
- **Conteneurisation :** Docker  
- **Base de données :** `cours`  
- **Schéma :** `tp_dcl`  

---

## 🧩 Structure de la base

```
Cluster PostgreSQL
└── Base : cours
    └── Schéma : tp_dcl
        ├── Table : etudiants
        └── Séquence : etudiants_id_seq
```

---

## 🏗️ Mise en place

### 🔹 Création de la base et du schéma

```sql
CREATE DATABASE cours;
\c cours
CREATE SCHEMA tp_dcl;
```

### 🔹 Création de la table

```sql
CREATE TABLE tp_dcl.etudiants (
    id SERIAL PRIMARY KEY,
    nom TEXT,
    moyenne NUMERIC
);
```

---

## 👥 Gestion des utilisateurs

Deux profils ont été définis afin de simuler un environnement réel :

- **etudiant** → accès en lecture uniquement  
- **professeur** → accès complet (lecture et modification)

```sql
CREATE USER etudiant WITH PASSWORD 'etudiant123';
CREATE USER professeur WITH PASSWORD 'prof123';
```

---

## 🔐 Attribution des permissions

Les droits ont été accordés en respectant la hiérarchie PostgreSQL :

### 🔹 Accès à la base
```sql
GRANT CONNECT ON DATABASE cours TO etudiant, professeur;
```

### 🔹 Accès au schéma
```sql
GRANT USAGE ON SCHEMA tp_dcl TO etudiant, professeur;
```

### 🔹 Accès à la table

```sql
-- Étudiant : lecture seule
GRANT SELECT ON tp_dcl.etudiants TO etudiant;

-- Professeur : accès complet
GRANT SELECT, INSERT, UPDATE, DELETE ON tp_dcl.etudiants TO professeur;

-- Accès à la séquence
GRANT USAGE, SELECT, UPDATE ON SEQUENCE tp_dcl.etudiants_id_seq TO professeur;
```

---

## 🧪 Vérification des permissions

### 🔹 Test avec l’utilisateur *etudiant*

```sql
SELECT * FROM tp_dcl.etudiants;  -- ✅ Autorisé

INSERT INTO tp_dcl.etudiants(nom, moyenne)
VALUES ('Patrick', 85);          -- ❌ Refusé
```

👉 Résultat : accès limité à la lecture uniquement.

---

### 🔹 Test avec l’utilisateur *professeur*

```sql
INSERT INTO tp_dcl.etudiants(nom, moyenne)
VALUES ('Khaled', 90);           -- ✅ OK

UPDATE tp_dcl.etudiants
SET moyenne = 95
WHERE nom = 'Khaled';            -- ✅ OK

SELECT * FROM tp_dcl.etudiants;  -- ✅ OK
```

👉 Résultat : contrôle complet des données.

---

## 🚫 Révocation des privilèges

```sql
REVOKE SELECT ON tp_dcl.etudiants FROM etudiant;
```

Après cette opération :

```sql
SELECT * FROM tp_dcl.etudiants;  -- ❌ Refusé
```

👉 Cela confirme que les droits peuvent être modifiés dynamiquement.

---

## ⚠️ Suppression des utilisateurs

```sql
DROP USER etudiant;
DROP USER professeur;
```

❗ PostgreSQL empêche la suppression si l’utilisateur possède encore des privilèges.

---

## 🧠 Analyse et compréhension

Ce TP met en évidence un principe fondamental :

> Pour accéder à une table dans PostgreSQL, un utilisateur doit disposer de **trois niveaux de permissions** :

1. `CONNECT` sur la base  
2. `USAGE` sur le schéma  
3. Droits spécifiques sur la table (`SELECT`, `INSERT`, etc.)

---

## 📊 DCL vs autres langages SQL

| Type | Rôle | Exemples |
|------|------|---------|
| DDL  | Structure | CREATE, ALTER |
| DML  | Manipulation | INSERT, UPDATE |
| DQL  | Lecture | SELECT |
| **DCL** | Sécurité | GRANT, REVOKE |
| TCL  | Transactions | COMMIT, ROLLBACK |

---

## 🧾 Conclusion

Ce laboratoire démontre l’importance de la gestion des accès dans une base de données relationnelle.

La séparation des rôles permet de :
- sécuriser les données  
- limiter les erreurs humaines  
- contrôler précisément les actions des utilisateurs  

Une bonne maîtrise du DCL est essentielle pour tout administrateur ou développeur travaillant avec PostgreSQL.

---

## 🚀 Perspectives

Pour aller plus loin, il serait pertinent d’utiliser :
- des **rôles PostgreSQL** (GROUP ROLE)  
- des politiques de sécurité avancées  
- des vues pour restreindre encore plus l’accès aux données  

---

## 📎 Remarque

Ce travail a été réalisé dans le cadre d’un exercice pratique visant à appliquer les concepts fondamentaux du contrôle d’accès dans PostgreSQL.
