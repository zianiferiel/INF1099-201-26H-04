#  TP Modélisation SQL — Gestion des Participations à des Événements

> Base de données relationnelle pour gérer les inscriptions de personnes à des événements, suivre leur présence et analyser les résultats.

![PostgreSQL](https://img.shields.io/badge/PostgreSQL-18-336791?style=for-the-badge&logo=postgresql&logoColor=white)
![SQL](https://img.shields.io/badge/SQL-DDL%20%7C%20DML%20%7C%20Vues%20%7C%20Index-orange?style=for-the-badge)
![Status](https://img.shields.io/badge/Status-Complété-brightgreen?style=for-the-badge)

---


##  Aperçu du projet

Ce projet modélise la gestion complète d'événements : qui s'inscrit, qui vient, quelle note ils donnent.

| Catégorie | Détails |
|-----------|---------|
|  SGBD | PostgreSQL 18 |
|  Tables | 3 tables (`Personne`, `Evenement`, `Participation`) |
|  Vues | 1 vue récapitulative |
|  Index | 5 index pour optimiser les performances |

---

##  Diagramme ER

Voici la structure complète de la base de données :

```
┌─────────────────┐          ┌──────────────────────────┐          ┌──────────────────┐
│    Personne      │          │      Participation        │          │    Evenement     │
├─────────────────┤          ├──────────────────────────┤          ├──────────────────┤
│  id_personne  │──────────│  id_participation       │──────────│  id_evenement  │
│    nom          │  (1,N)   │ # id_personne             │  (N,1)   │    titre         │
│    prenom       │          │ # id_evenement            │          │    date_debut    │
│    email        │          │    statut_participation   │          │                  │
└─────────────────┘          │    note                   │          └──────────────────┘
                             └──────────────────────────┘
```

### Explication simple

| Table | Rôle |
|-------|------|
| **Personne** | Stocke les participants (nom, prénom, email) |
| **Evenement** | Stocke les événements (titre, date) |
| **Participation** | Relie une personne à un événement + son statut et sa note |

>  **Résumé :** Une personne peut participer à plusieurs événements. Un événement peut avoir plusieurs participants. La table `Participation` fait le lien entre les deux.

---

##  Description des tables

###  Table `Personne`

Contient les informations sur chaque participant.

| Colonne | Type | Description |
|---------|------|-------------|
| `id_personne`  | SERIAL | Identifiant unique |
| `nom` | TEXT | Nom de famille |
| `prenom` | TEXT | Prénom |
| `email` | TEXT | Adresse email (unique) |

---

###  Table `Evenement`

Contient les informations sur chaque événement.

| Colonne | Type | Description |
|---------|------|-------------|
| `id_evenement`  | SERIAL | Identifiant unique |
| `titre` | TEXT | Nom de l'événement |
| `date_debut` | DATE | Date de l'événement |

---

### 🔗 Table `Participation`

Fait le lien entre une personne et un événement. C'est la table centrale du projet.

| Colonne | Type | Description |
|---------|------|-------------|
| `id_participation`  | SERIAL | Identifiant unique |
| `id_personne` # | INT | Référence vers `Personne` |
| `id_evenement` # | INT | Référence vers `Evenement` |
| `statut_participation` | TEXT | `'présent'`, `'absent'`, ou `'inscrit'` |
| `note` | NUMERIC | Note donnée par le participant (sur 20) |

---

##  Démarrage rapide

```bash
# 1. Se connecter à PostgreSQL
psql -U postgres

# 2. Se connecter à la base de données
\c participation_db

# 3. Vérifier les tables
\dt
```

### Données présentes dans la base

| Personne | Événement | Statut | Note |
|----------|-----------|--------|------|
| Marie Dupont | Atelier SQL Avancé | présent | 16.5 |
| Marie Dupont | Formation PostgreSQL Performance | inscrit | — |
| Lucas Martin | Atelier SQL Avancé | inscrit | — |
| Lucas Martin | Conférence Big Data & IA | absent | — |
| Sophie Bernard | Conférence Big Data & IA | présent | 18.0 |
| Thomas Petit | Workshop Modélisation ER | présent | 14.0 |

---

##  Vues SQL

### `vue_recap_participation`

Cette vue donne un résumé rapide de chaque événement : combien de personnes inscrites, combien étaient présentes, et la note moyenne.

```sql
CREATE VIEW vue_recap_participation AS
SELECT
    e.titre                                                               AS evenement,
    COUNT(pa.id_participation)                                            AS total_inscrits,
    SUM(CASE WHEN pa.statut_participation = 'présent' THEN 1 ELSE 0 END) AS presents,
    ROUND(AVG(pa.note), 2)                                                AS moyenne_note
FROM Evenement e
LEFT JOIN Participation pa ON e.id_evenement = pa.id_evenement
GROUP BY e.id_evenement, e.titre
ORDER BY total_inscrits DESC;
```

####  Résultat obtenu

```
            evenement             | total_inscrits | presents | moyenne_note
----------------------------------+----------------+----------+--------------
 Conférence Big Data & IA         |              2 |        1 |        18.00
 Atelier SQL Avancé               |              2 |        1 |        16.50
 Workshop Modélisation ER         |              1 |        1 |        14.00
 Formation PostgreSQL Performance |              1 |        0 |
```

>  **`LEFT JOIN`** : affiche aussi les événements sans note (valeur NULL si aucune note saisie).

---

##  Index & Optimisation

Les index accélèrent les recherches. Sans index, PostgreSQL lit toutes les lignes une par une (*Seq Scan*). Avec un index, il va directement au bon endroit (*Index Scan*).

### Index créés

```sql
-- Accélérer les recherches par personne dans Participation
CREATE INDEX idx_participation_personne ON Participation(id_personne);

-- Accélérer les jointures entre Participation et Evenement
CREATE INDEX idx_participation_evenement ON Participation(id_evenement);

-- Accélérer les recherches par date dans Evenement
CREATE INDEX idx_evenement_date ON Evenement(date_debut);

-- Accélérer les recherches par email dans Personne
CREATE INDEX idx_personne_email ON Personne(email);

-- Index composite : optimise les requêtes filtrant sur personne ET événement ensemble
CREATE INDEX idx_participation_personne_evenement ON Participation(id_personne, id_evenement);
```

### Analyse des performances avec `EXPLAIN ANALYZE`

```sql
EXPLAIN ANALYZE
SELECT e.titre, COUNT(pa.id_participation) AS nb_participants
FROM Evenement e
LEFT JOIN Participation pa ON e.id_evenement = pa.id_evenement
GROUP BY e.id_evenement, e.titre;
```

####  Résultat

```
 HashAggregate  (actual time=0.097..0.104 rows=4 loops=1)
   ->  Hash Right Join
         ->  Seq Scan on participation  (rows=6)
         ->  Seq Scan on evenement      (rows=4)
 Planning Time:  0.380 ms
 Execution Time: 0.201 ms
```

>  **Pourquoi `Seq Scan` même avec des index ?**
> La base est très petite (4 événements, 6 participations). PostgreSQL décide automatiquement que lire toute la table est plus rapide. Les index deviennent vraiment utiles avec des milliers de lignes.

---

##  Requêtes avancées

### 1. Liste complète des participants par événement

```sql
SELECT
    e.titre,
    p.nom,
    p.prenom,
    pa.statut_participation
FROM Participation pa
JOIN Personne  p ON pa.id_personne  = p.id_personne
JOIN Evenement e ON pa.id_evenement = e.id_evenement
ORDER BY e.titre, p.nom;
```

**Résultat :**
```
              titre               |   nom   | prenom | statut_participation
----------------------------------+---------+--------+----------------------
 Atelier SQL Avancé               | Dupont  | Marie  | présent
 Atelier SQL Avancé               | Martin  | Lucas  | inscrit
 Conférence Big Data & IA         | Bernard | Sophie | présent
 Conférence Big Data & IA         | Martin  | Lucas  | absent
 Formation PostgreSQL Performance | Dupont  | Marie  | inscrit
 Workshop Modélisation ER         | Petit   | Thomas | présent
```

---

### 2. Note moyenne par événement

```sql
SELECT
    e.titre,
    ROUND(AVG(pa.note), 2) AS moyenne_note
FROM Participation pa
JOIN Evenement e ON pa.id_evenement = e.id_evenement
GROUP BY e.titre;
```

**Résultat :**
```
              titre               | moyenne_note
----------------------------------+--------------
 Atelier SQL Avancé               |        16.50
 Conférence Big Data & IA         |        18.00
 Formation PostgreSQL Performance |      (NULL)
 Workshop Modélisation ER         |        14.00
```

---

### 3. Nombre de participants par statut pour chaque événement

```sql
SELECT
    e.titre,
    pa.statut_participation,
    COUNT(*) AS nb
FROM Participation pa
JOIN Evenement e ON pa.id_evenement = e.id_evenement
GROUP BY e.titre, pa.statut_participation
ORDER BY e.titre;
```

**Résultat :**
```
              titre               | statut_participation | nb
----------------------------------+----------------------+----
 Atelier SQL Avancé               | inscrit              |  1
 Atelier SQL Avancé               | présent              |  1
 Conférence Big Data & IA         | absent               |  1
 Conférence Big Data & IA         | présent              |  1
 Formation PostgreSQL Performance | inscrit              |  1
 Workshop Modélisation ER         | présent              |  1
```

---

### 4. Événements avec un taux de présence ≥ 80% (HAVING)

```sql
SELECT
    e.titre,
    COUNT(pa.id_participation) AS total_inscrits,
    SUM(CASE WHEN pa.statut_participation = 'présent' THEN 1 ELSE 0 END) AS presents,
    ROUND(
        SUM(CASE WHEN pa.statut_participation = 'présent' THEN 1 ELSE 0 END)::numeric
        / COUNT(pa.id_participation) * 100, 2
    ) AS taux_presence
FROM Evenement e
JOIN Participation pa ON e.id_evenement = pa.id_evenement
GROUP BY e.titre
HAVING ROUND(
    SUM(CASE WHEN pa.statut_participation = 'présent' THEN 1 ELSE 0 END)::numeric
    / COUNT(pa.id_participation) * 100, 2
) >= 80
ORDER BY taux_presence DESC;
```

**Résultat :**
```
          titre           | total_inscrits | presents | taux_presence
--------------------------+----------------+----------+---------------
 Workshop Modélisation ER |              1 |        1 |        100.00
```

>  **`HAVING`** fonctionne comme un `WHERE` mais s'applique **après** le `GROUP BY`.

---

### 5. Personne la plus active

```sql
SELECT
    p.nom,
    p.prenom,
    COUNT(pa.id_evenement) AS nb_evenements
FROM Participation pa
JOIN Personne p ON pa.id_personne = p.id_personne
GROUP BY p.nom, p.prenom
ORDER BY nb_evenements DESC
LIMIT 1;
```

**Résultat :**
```
  nom   | prenom | nb_evenements
--------+--------+---------------
 Dupont | Marie  |             2
```

>  **Marie Dupont** est la participante la plus active avec 2 événements.

---

##  Légende

| Symbole | Signification |
|---------|---------------|
|  | Clé Primaire (PRIMARY KEY) |
| # | Clé Étrangère (FOREIGN KEY) |
| `JOIN` | Relie deux tables entre elles |
| `GROUP BY` | Regroupe les lignes pour faire des calculs (COUNT, AVG…) |
| `HAVING` | Filtre les résultats après un GROUP BY |
| `LEFT JOIN` | Inclut les lignes sans correspondance (valeur NULL) |
| `EXPLAIN ANALYZE` | Analyse le plan et le temps d'exécution d'une requête |

---

<div align="center">
  <sub>TP Modélisation SQL · Gestion des Participations · PostgreSQL 18 · 2024</sub>
</div>
