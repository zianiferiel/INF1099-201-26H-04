# ⚽👟 Gestion de la vente de crampons — Base de données

## Auteur

Projet réalisé par **Freedy Ebah**

---

## Description du projet

Ce projet modélise un système de gestion complet pour la vente de crampons de football. Il permet de gérer les clients, leurs adresses, les produits (crampons) organisés par marque et catégorie, les commandes, les paiements, les livraisons, le suivi du stock et les avis clients.

Le système est conçu dans un objectif pédagogique (cours de base de données). Il se concentre sur la structure des données, les relations entre entités et la normalisation jusqu'en 3FN.

---

## Objectifs

- Enregistrer les clients et leurs adresses postales
- Organiser le catalogue de crampons par marque et type de surface
- Gérer les commandes passées par les clients avec le détail des produits commandés
- Assurer le suivi des paiements et des livraisons
- Maintenir un stock avec seuil d'alerte par crampon
- Collecter les avis clients sur les produits achetés

---

## Structure du projet

```
crampon_project/
├── README.md       ← Ce fichier
├── DDL.sql         ← Création des tables (structure)
├── DML.sql         ← Insertion, modification et suppression de données
├── DQL.sql         ← Requêtes de consultation (SELECT)
└── DCL.sql         ← Gestion des accès et permissions
```

---

## Modélisation

### Entités et attributs (3FN)

| Entité | Attributs |
|---|---|
| Client | id_client (PK), nom, prenom, email, telephone, date_inscription |
| Adresse | id_adresse (PK), type_adresse, rue, ville, code_postal, pays, id_client (FK) |
| Marque | id_marque (PK), nom, pays_origine, site_web, description |
| Categorie | id_categorie (PK), code, libelle, description |
| Crampon | id_crampon (PK), modele, pointure, couleur, prix, description, id_marque (FK), id_categorie (FK) |
| Stock | id_crampon (PK/FK), quantite_disponible, seuil_alerte, date_maj |
| Commande | id_commande (PK), date_commande, statut, montant_total, id_client (FK), id_adresse (FK) |
| LigneCommande | id_ligne (PK), quantite, prix_unitaire, id_commande (FK), id_crampon (FK) |
| Paiement | id_paiement (PK), mode_paiement, statut_paiement, montant_paye, date_paiement, reference, id_commande (FK) |
| Livraison | id_livraison (PK), transporteur, numero_suivi, date_expedition, date_livraison_prevue, date_livraison_reelle, statut_livraison, id_commande (FK) |
| Avis | id_avis (PK), note, titre, commentaire, date_avis, verifie, id_client (FK), id_crampon (FK) |

### Relations

| Relation | Cardinalité | Description |
|---|---|---|
| Client → Commande | 1,N | Un client peut passer plusieurs commandes |
| Client → Adresse | 1,N | Un client peut avoir plusieurs adresses |
| Commande → Adresse | 0,1 | Une commande peut être liée à une adresse de livraison |
| Marque → Crampon | 1,N | Une marque fabrique plusieurs crampons |
| Categorie → Crampon | 1,N | Une catégorie regroupe plusieurs crampons |
| Crampon → Stock | 1,1 | Chaque crampon possède exactement un stock |
| Commande → LigneCommande | 1,N | Une commande contient plusieurs lignes |
| Crampon → LigneCommande | 0,N | Un crampon peut apparaître dans plusieurs commandes |
| Commande → Paiement | 1,1 | Une commande est associée à un seul paiement |
| Commande → Livraison | 0,1 | Une commande confirmée génère une livraison |
| Client → Avis | 0,N | Un client peut rédiger plusieurs avis |
| Crampon → Avis | 0,N | Un crampon peut recevoir plusieurs avis |

---

## Normalisation

### 1FN — Première forme normale

Toutes les valeurs sont atomiques. Chaque colonne contient une seule valeur par ligne. Aucun groupe répétitif.

✅ Respectée par : CLIENT, ADRESSE, MARQUE, CATEGORIE, CRAMPON, STOCK, COMMANDE, LIGNECOMMANDE, PAIEMENT, LIVRAISON, AVIS

### 2FN — Deuxième forme normale

Tous les attributs non-clés dépendent entièrement de la clé primaire. Toutes les tables utilisent une clé primaire simple (SERIAL), ce qui garantit automatiquement la 2FN.

✅ Respectée par toutes les tables — aucune dépendance partielle possible.

### 3FN — Troisième forme normale

Aucun attribut non-clé ne dépend d'un autre attribut non-clé.

✅ Respectée :

- `Client(id_client, nom, prenom, email, telephone, date_inscription)` — tous dépendent de id_client
- `Crampon(id_crampon, modele, pointure, couleur, prix, id_marque, id_categorie)` — la marque et la catégorie sont isolées dans leurs propres tables
- `Commande(id_commande, date_commande, statut, montant_total, id_client, id_adresse)` — le paiement et la livraison sont dans leurs propres tables
- `LigneCommande(id_ligne, quantite, prix_unitaire, id_commande, id_crampon)` — prix_unitaire est l'historique du prix au moment de l'achat
- `Paiement(id_paiement, mode_paiement, statut_paiement, montant_paye, date_paiement, reference, id_commande)` — tous dépendent de id_paiement
- `Livraison(id_livraison, transporteur, numero_suivi, ..., id_commande)` — tous dépendent de id_livraison
- `Avis(id_avis, note, titre, commentaire, date_avis, verifie, id_client, id_crampon)` — tous dépendent de id_avis

---

## Choix technologique

**SGBD choisi : PostgreSQL**

| Critère | Justification |
|---|---|
| Données relationnelles | Les 11 entités ont des relations fortes (FK, jointures multiples) |
| Transactions ACID | Intégrité des commandes, paiements et stocks garantie |
| Contraintes avancées | CHECK, UNIQUE, ENUM via CHECK, ON DELETE CASCADE supportés nativement |
| Séquences (SERIAL) | Gestion automatique des clés primaires auto-incrémentées |
| Performance | Index B-tree efficaces pour les jointures fréquentes |

---

## Fichiers SQL

### DDL.sql — Définition de la structure

- Création des 11 tables avec contraintes (PK, FK, CHECK, UNIQUE)
- Gestion de l'ordre de suppression (DROP TABLE IF EXISTS dans l'ordre inverse des dépendances)
- Définition de 11 index pour optimiser les performances des jointures fréquentes

### DML.sql — Manipulation des données

- **INSERT** : 5 marques, 5 catégories, 5 clients, 6 adresses, 10 crampons, stocks initiaux, 5 commandes, 7 lignes de commande, 4 paiements, 3 livraisons, 4 avis
- **UPDATE** : mise à jour de statut, prix promotionnel, stock, email client, validation de paiement
- **DELETE** : suppression d'une commande annulée (cascade sur les lignes), suppression d'avis non vérifiés

### DQL.sql — Requêtes de consultation

1. Liste complète des clients
2. Catalogue avec marque, catégorie et état du stock
3. Commandes avec nom du client et ville de livraison
4. Détail complet d'une commande
5. Montant total par commande
6. Suivi complet commande + paiement + livraison
7. Crampons en alerte ou en rupture de stock
8. Nombre de commandes par client
9. Crampons les plus vendus
10. Chiffre d'affaires par marque
11. Historique des commandes d'un client
12. Note moyenne et nombre d'avis par crampon

### DCL.sql — Contrôle des accès

| Rôle | Privilèges |
|---|---|
| admin_crampon | ALL PRIVILEGES sur les 11 tables + séquences |
| vendeur_crampon | SELECT partout, INSERT/UPDATE sur commandes, lignes, paiements, livraisons et stock |
| lecteur_crampon | SELECT uniquement sur toutes les tables |

---

## Optimisations appliquées

- **11 index** sur les clés étrangères fréquemment utilisées dans les JOIN
- **Contraintes CHECK** pour valider les données à l'insertion (prix > 0, pointure entre 30-50, statut valide, note entre 1 et 5)
- **ON DELETE CASCADE** sur LigneCommande, Livraison et Paiement pour maintenir l'intégrité référentielle
- **ON DELETE RESTRICT** sur Commande pour protéger l'historique client
- **DEFAULT CURRENT_DATE** sur date_commande et date_avis pour simplifier les insertions
- **Séparation Stock / Crampon** pour éviter les mises à jour répétées dans la table principale
- **prix_unitaire dans LigneCommande** pour conserver l'historique des prix au moment de l'achat
