# 🎓 Plateforme Éducative pour Enfants — Base de données PostgreSQL
> **Modélisation, implémentation et optimisation d'une base de données relationnelle**

**Auteure :** Ramatoulaye Diallo — `300153476`
**Cours :** INF1099-201-26H-04 | 6.BATCH
**Établissement :** Collège Boréal
**Date :** Mars 2026

---

## 📋 Table des matières

1. [Description du projet](#-description-du-projet)
2. [Structure du dépôt](#-structure-du-dépôt)
3. [Modélisation — 3e Forme Normale](#-modélisation--3e-forme-normale)
4. [Contenu des fichiers SQL](#-contenu-des-fichiers-sql)
5. [Contrôle d'accès](#-contrôle-daccès--dcl)
6. [Optimisation](#-optimisation)
7. [Instructions d'exécution](#-instructions-dexécution)
8. [Résultats d'exécution](#-résultats-dexécution)
9. [Notes techniques](#-notes-techniques)

---

## 🎯 Description du projet

Ce projet implémente une base de données relationnelle complète pour une **plateforme éducative en ligne destinée aux enfants**. Elle couvre l'ensemble du cycle pédagogique : inscription aux cours, remise de devoirs, notation, récompenses, concours et assistance par intelligence artificielle.

### Fonctionnalités couvertes

| Domaine | Tables impliquées |
|---------|-------------------|
| Gestion des utilisateurs | `Parent`, `Enfant`, `Professeur` |
| Contenu pédagogique | `Cours`, `Session_Cours`, `Devoir`, `Ressource` |
| Suivi académique | `Inscription`, `Soumission_Devoir`, `Note` |
| Gamification | `Recompense`, `Attribution_Recompense` |
| Compétitions | `Concours`, `Participation_Concours` |
| Assistant IA | `Session_ChatIA`, `Message_ChatIA` |

### Choix technologique — PostgreSQL

PostgreSQL a été sélectionné pour les raisons suivantes :

- **Relations fortes** entre entités (Parent → Enfant → Inscription → Note)
- **Transactions ACID** garantissant l'intégrité des données critiques
- **Contraintes avancées** : `CHECK`, `UNIQUE` composites, `FK` avec `CASCADE`
- **Fonctions analytiques** : `RANK()`, `AVG() OVER()`, `PARTITION BY`
- **Déploiement via Podman** dans un conteneur isolé

> *« PostgreSQL a été choisi plutôt que MySQL car le projet nécessite des transactions complexes et des relations fortes entre les données. MongoDB n'a pas été retenu car toutes les entités sont structurées et relationnelles. »*

---

## 📁 Structure du dépôt

```
300153476/
│
├── images/
│   └── diagramme_ER.png          ← Diagramme Entité-Relation (3FN)
│
├── DDL.sql                        ← Création des tables, contraintes, index
├── DCL.sql                        ← Rôles, utilisateurs et permissions
├── DML.sql                        ← Données de test (INSERT, UPDATE, DELETE)
├── DQL.sql                        ← Requêtes SELECT (7 blocs progressifs)
├── OPTIMISATION.sql               ← Plan d'optimisation complet
├── load-db.ps1                    ← Script PowerShell d'automatisation
└── README.md                      ← Ce fichier
```

---

## 🗃️ Modélisation — 3e Forme Normale

La base de données respecte la **3e Forme Normale (3FN)** :

- ✅ **1FN** — Valeurs atomiques, pas de groupes répétés
- ✅ **2FN** — Chaque attribut dépend entièrement de la clé primaire
- ✅ **3FN** — Aucune dépendance transitive entre attributs non-clés

### 16 tables organisées par niveau de dépendance

```
NIVEAU 1 — Entités indépendantes
├── Parent          (id_parent, Nom, Prenom, Telephone, Email)
├── Professeur      (id_prof, Nom, Prenom, Telephone, Email, Specialite)
├── Recompense      (id_recompense, Nom_recompense, Description, Points)
└── Concours        (id_concours, Titre_concours, Date_concours, Description, Prix)

NIVEAU 2 — 1 clé étrangère
├── Enfant          (id_enfant, Nom, Prenom, Age, Niveau, #id_parent)
└── Cours           (id_cours, Titre_cours, Langue, Niveau, #id_prof)

NIVEAU 3 — 2 clés étrangères ou plus
├── Session_Cours           (#id_cours)
├── Inscription             (#id_enfant, #id_cours)     ← UNIQUE(id_enfant, id_cours)
├── Devoir                  (#id_cours)
├── Ressource               (#id_cours)
├── Attribution_Recompense  (#id_enfant, #id_recompense)
├── Participation_Concours  (#id_enfant, #id_concours)  ← UNIQUE(id_enfant, id_concours)
└── Session_ChatIA          (#id_enfant)

NIVEAU 4 — Dépendances profondes
├── Soumission_Devoir       (#id_devoir, #id_enfant)
└── Message_ChatIA          (#id_session_chat)

NIVEAU 5 — Dépendance maximale
└── Note                    (#id_soumission)            ← UNIQUE (1 note / soumission)
```

### Diagramme ER

> Disponible dans le dossier [`images/`](images/)

![Diagramme ER](images/diagramme_ER.png)

---

## 📄 Contenu des fichiers SQL

### `DDL.sql` — Data Definition Language
> Définit la **structure** de la base de données

```sql
-- Exemple : table Inscription avec contraintes complètes
CREATE TABLE Inscription (
    id_inscription      SERIAL PRIMARY KEY,
    Date_inscription    DATE         NOT NULL DEFAULT CURRENT_DATE,
    Statut_inscription  VARCHAR(50)  NOT NULL DEFAULT 'actif'
                        CHECK (Statut_inscription IN ('actif','suspendu','complété','annulé')),
    id_enfant           INT          NOT NULL,
    id_cours            INT          NOT NULL,
    CONSTRAINT fk_inscription_enfant
        FOREIGN KEY (id_enfant) REFERENCES Enfant(id_enfant) ON DELETE CASCADE,
    CONSTRAINT fk_inscription_cours
        FOREIGN KEY (id_cours)  REFERENCES Cours(id_cours)   ON DELETE CASCADE,
    CONSTRAINT uq_inscription_enfant_cours
        UNIQUE (id_enfant, id_cours)
);
```

**Ce que contient DDL.sql :**

- Section `0` — `DROP TABLE IF EXISTS` dans l'ordre inverse des FK
- Sections `1` à `5` — Création des 16 tables par niveau de dépendance
- Contraintes `CHECK` sur : âge (3-18 ans), note (0-100), statuts, modes de session
- `COMMENT ON TABLE` et `COMMENT ON COLUMN` sur chaque objet important
- Section `6` — **14 index B-tree** sur toutes les FK pour optimiser les jointures

---

### `DCL.sql` — Data Control Language
> Définit les **accès et permissions**

```sql
-- Exemple : création d'un rôle et attribution des permissions
CREATE ROLE professeur_role NOLOGIN;
COMMENT ON ROLE professeur_role IS 'Enseignant — gere les cours, devoirs et notes';

GRANT SELECT, INSERT, UPDATE, DELETE ON Cours, Devoir, Note TO professeur_role;
GRANT SELECT ON Parent, Enfant, Inscription TO professeur_role;
```

**5 rôles créés :**

| Rôle | Connexion | Permissions |
|------|-----------|-------------|
| `admin_plateforme` | ❌ groupe | `ALL PRIVILEGES` tables + séquences |
| `professeur_role` | ❌ groupe | CRUD pédagogique + SELECT élèves |
| `parent_role` | ❌ groupe | SELECT tout + UPDATE ses coordonnées |
| `enfant_role` | ❌ groupe | SELECT cours + INSERT soumissions/chat |
| `lecture_seule` | ❌ groupe | SELECT uniquement (audit) |

**5 utilisateurs créés :**

| Utilisateur | Rôle rattaché | Limite connexions |
|-------------|---------------|:-----------------:|
| `admin_diallo` | `admin_plateforme` | 5 |
| `prof_martin` | `professeur_role` | 10 |
| `parent_tremblay` | `parent_role` | 3 |
| `enfant_emma` | `enfant_role` | 2 |
| `auditeur_sys` | `lecture_seule` | 2 |

---

### `DML.sql` — Data Manipulation Language
> **Manipule les données** dans les tables

**Données insérées (INSERT) :**

| Table | Lignes |
|-------|:------:|
| Parent | 8 |
| Professeur | 6 |
| Recompense | 8 |
| Concours | 5 |
| Enfant | 12 |
| Cours | 12 |
| Session_Cours | 15 |
| Inscription | 28 |
| Devoir | 12 |
| Ressource | 14 |
| Soumission_Devoir | 21 |
| Note | 21 |
| Attribution_Recompense | 10 |
| Participation_Concours | 15 |
| Session_ChatIA | 15 |
| Message_ChatIA | 20 |

**Mises à jour (UPDATE) — 8 au total :**

```sql
UPDATE Parent      SET Telephone = '819-555-9999'         WHERE id_parent = 1;
UPDATE Inscription SET Statut_inscription = 'complété'    WHERE id_enfant = 3 AND id_cours = 2;
UPDATE Note        SET Valeur = 90.00                     WHERE id_note = 4;
UPDATE Professeur  SET Specialite = 'Mathématiques et statistiques' WHERE id_prof = 1;
UPDATE Devoir      SET Date_limite = '2026-04-30'         WHERE id_devoir = 10;
-- ... 3 autres UPDATE
```

**Suppressions (DELETE) — 3 au total :**

```sql
DELETE FROM Inscription    WHERE id_enfant = 12 AND Statut_inscription = 'suspendu'; -- 1 supprimé
DELETE FROM Ressource      WHERE id_ressource = 4;                                    -- 1 supprimé
DELETE FROM Session_ChatIA WHERE Duree < 5;                                           -- 0 (normal)
```

---

### `DQL.sql` — Data Query Language
> **Interroge** la base de données — 7 blocs progressifs

| Bloc | Type | Exemples |
|------|------|----------|
| **1** | SELECT simples | Liste enfants, cours + professeur, devoirs par urgence |
| **2** | Filtres WHERE | Secondaire ≥13 ans, cours anglais, notes <80, sessions >30 min |
| **3** | Agrégations | Moyenne par cours, cours >3 inscrits, points récompenses cumulés |
| **4** | Jointures multiples | Tableau enfant→cours→devoir→note, historique ChatIA complet |
| **5** | Sous-requêtes | Au-dessus de la moyenne, cours sans inscrits, meilleure note/cours |
| **6** | Vues | `v_bulletin_enfants`, `v_stats_enfants`, `v_tableau_bord_prof` |
| **7** | Fenêtres analytiques | `RANK()`, moyenne cumulative `OVER()`, podium concours |

```sql
-- Exemple bloc 7 : classement des enfants avec RANK()
SELECT  e.Prenom || ' ' || e.Nom           AS Enfant,
        e.Niveau,
        ROUND(AVG(n.Valeur), 2)             AS Moyenne,
        RANK() OVER (ORDER BY AVG(n.Valeur) DESC)                        AS Rang_global,
        RANK() OVER (PARTITION BY e.Niveau ORDER BY AVG(n.Valeur) DESC)  AS Rang_niveau
FROM    Enfant e
JOIN    Soumission_Devoir sd ON e.id_enfant      = sd.id_enfant
JOIN    Note              n  ON sd.id_soumission = n.id_soumission
GROUP BY e.id_enfant, e.Nom, e.Prenom, e.Niveau
ORDER BY Rang_global;
```

---

### `OPTIMISATION.sql` — Plan d'optimisation complet

> Amélioration des performances selon 9 axes

| Section | Technique appliquée |
|---------|---------------------|
| 1 | `EXPLAIN` et `EXPLAIN ANALYZE` sur 3 requêtes critiques |
| 2 | **16 index simples** sur FK + colonnes WHERE/ORDER BY |
| 3 | **6 index composites** multi-colonnes (colonne sélective en premier) |
| 4 | **5 index partiels** (`WHERE statut='actif'`, `WHERE Valeur < 60`) |
| 5 | Vérification 3FN + colonne `total_points_cache` + trigger automatique |
| 6 | Partitionnement de `Message_ChatIA` par mois (RANGE sur Date_heure) |
| 7 | Recommandations `postgresql.conf` (shared_buffers, work_mem, etc.) |
| 8 | Surveillance avec `pg_stat_user_tables`, hit ratio, index inutilisés |
| 9 | `pg_prewarm` + recommandations Redis (cache applicatif externe) |

---

## 🔐 Contrôle d'accès — DCL

```
admin_plateforme  ──── ALL PRIVILEGES ─────────────── admin_diallo    (LOGIN)
professeur_role   ──── CRUD cours/devoirs/notes ────── prof_martin     (LOGIN)
parent_role       ──── SELECT + UPDATE coordonnées ─── parent_tremblay (LOGIN)
enfant_role       ──── SELECT + INSERT soumissions ──── enfant_emma    (LOGIN)
lecture_seule     ──── SELECT uniquement ─────────────  auditeur_sys   (LOGIN)
```

---

## 🚀 Optimisation

### Index inclus dans DDL.sql (14 au total)

```sql
CREATE INDEX idx_enfant_parent      ON Enfant(id_parent);
CREATE INDEX idx_cours_prof         ON Cours(id_prof);
CREATE INDEX idx_inscription_enfant ON Inscription(id_enfant);
CREATE INDEX idx_inscription_cours  ON Inscription(id_cours);
CREATE INDEX idx_soumission_enfant  ON Soumission_Devoir(id_enfant);
CREATE INDEX idx_soumission_devoir  ON Soumission_Devoir(id_devoir);
CREATE INDEX idx_note_soumission    ON Note(id_soumission);
CREATE INDEX idx_chat_enfant        ON Session_ChatIA(id_enfant);
CREATE INDEX idx_message_session    ON Message_ChatIA(id_session_chat);
-- ... 14 index au total
```

### Bonnes pratiques appliquées

| Pratique | Application dans ce projet |
|----------|---------------------------|
| Éviter `SELECT *` | Toutes les requêtes DQL listent les colonnes nécessaires |
| Index sur toutes les FK | 14 index couvrent chaque jointure |
| Contraintes `CHECK` | Validation en base (âge, note, statut, mode session) |
| Nommage des contraintes | Toutes les FK ont un nom `CONSTRAINT fk_...` |
| Vues pour requêtes répétitives | 3 vues évitent les jointures complexes répétées |
| `COALESCE` pour les NULL | Utilisé dans les vues pour éviter les NULL inattendus |

---

## ▶️ Instructions d'exécution

### Prérequis

- Podman installé et démarré (`podman machine start`)
- Conteneur PostgreSQL actif (`INF1099-postgres`)
- PowerShell (Admin recommandé)

### Exécution avec le script automatisé

```powershell
# Se placer dans le dossier du projet
cd C:\Users\diall\Developer\INF1099-201-26H-04\6.BATCH\300153476

# Exécuter le script batch complet
.\load-db.ps1
```

### Exécution manuelle (ordre obligatoire)

```powershell
# 1. Structure des tables
docker exec -i INF1099-postgres psql -U postgres -d plateforme < DDL.sql

# 2. Permissions et rôles
docker exec -i INF1099-postgres psql -U postgres -d plateforme < DCL.sql

# 3. Données de test
docker exec -i INF1099-postgres psql -U postgres -d plateforme < DML.sql

# 4. Requêtes de démonstration
docker exec -i INF1099-postgres psql -U postgres -d plateforme < DQL.sql

# 5. Plan d'optimisation (optionnel)
docker exec -i INF1099-postgres psql -U postgres -d plateforme < OPTIMISATION.sql
```

### Vérifications rapides après exécution

```sql
-- 16 tables doivent être présentes
SELECT tablename FROM pg_tables WHERE schemaname = 'public' ORDER BY tablename;

-- Vérifier les données clés
SELECT 'Enfants'     AS table_nom, COUNT(*) FROM Enfant       UNION ALL
SELECT 'Cours'                   , COUNT(*) FROM Cours        UNION ALL
SELECT 'Notes'                   , COUNT(*) FROM Note         UNION ALL
SELECT 'Messages IA'             , COUNT(*) FROM Message_ChatIA;

-- Vérifier les 10 rôles créés
SELECT rolname, rolcanlogin AS peut_se_connecter
FROM   pg_roles
WHERE  rolname IN (
    'admin_plateforme','professeur_role','parent_role',
    'enfant_role','lecture_seule',
    'admin_diallo','prof_martin','parent_tremblay',
    'enfant_emma','auditeur_sys'
)
ORDER BY rolcanlogin, rolname;

-- Tester une vue
SELECT * FROM v_stats_enfants ORDER BY Moyenne_generale DESC NULLS LAST;
```

---

## ✅ Résultats d'exécution

Exécution validée — **aucune erreur** avec `.\load-db.ps1`

### DDL.sql
```
16 × CREATE TABLE    ✅
14 × CREATE INDEX    ✅
DROP TABLE IF EXISTS propre au re-run  ✅
```

### DML.sql
```
16 × INSERT (234 lignes au total)              ✅
 8 × UPDATE (1 ligne chacun)                   ✅
 3 × DELETE (2 effectifs, 1 × DELETE 0 normal) ✅
```

### DCL.sql
```
 5 × CREATE ROLE (groupes NOLOGIN)   ✅
12 × GRANT (permissions par rôle)    ✅
 5 × CREATE USER + GRANT ROLE        ✅
 3 × ALTER DEFAULT PRIVILEGES        ✅
Vérification finale : 10 rôles affichés  ✅
```

### DQL.sql
```
25+ requêtes SELECT exécutées  ✅
 3 × CREATE VIEW                ✅
Résultats cohérents avec les données insérées  ✅
```

**Extrait des résultats DQL :**

```
     enfant      | niveau     | moyenne | rang_global | rang_niveau
-----------------+------------+---------+-------------+------------
 Emma Tremblay   | primaire   |   91.67 |           1 |           1
 Léa Dupont      | secondaire |   91.00 |           2 |           1
 Kevin Nguyen    | secondaire |   90.50 |           3 |           2
 Noah Tremblay   | primaire   |   90.00 |           4 |           2
 Linh Nguyen     | secondaire |   89.00 |           5 |           3
```

---

## 📝 Notes techniques

### Encodage — caractères accentués dans PowerShell

Les accents français (`é`, `è`, `ç`) peuvent apparaître comme `?` dans le terminal PowerShell. Il s'agit d'un **problème d'affichage uniquement** — les données sont correctement stockées en UTF-8 dans PostgreSQL.

Pour corriger l'affichage :
```powershell
[Console]::OutputEncoding = [System.Text.Encoding]::UTF8
chcp 65001
```

### `DELETE 0` — comportement attendu

`DELETE FROM Session_ChatIA WHERE Duree < 5` retourne `DELETE 0` car aucune session de moins de 5 minutes n'existe dans les données insérées. C'est un comportement normal et attendu — pas une erreur.

### `NOTICE` lors des DROP

Les messages `NOTICE: table "xxx" does not exist, skipping` au premier lancement sont normaux — ils confirment que `DROP IF EXISTS` fonctionne correctement, même si les tables n'existaient pas encore.

---

## 📚 Références

- [PostgreSQL 16 — Documentation officielle](https://www.postgresql.org/docs/16/)
- [Podman Documentation](https://podman.io/docs)
- [Normalisation — 1FN, 2FN, 3FN](https://www.postgresql.org/docs/current/ddl.html)

---

*Projet réalisé dans le cadre du cours INF1099 — Collège Boréal, 2026*
*Auteure : Ramatoulaye Diallo — 300153476*
