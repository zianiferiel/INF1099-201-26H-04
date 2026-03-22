# ⚽ Système de Gestion de Vente de Crampons de Football

> Projet de base de données — 11 tables · Modélisation · Normalisation 3NF · SQL

---

## Description

Ce projet modélise un système de gestion complet pour un magasin spécialisé dans la vente de crampons de football. Il couvre l'intégralité du cycle commercial : enregistrement des clients et de leurs adresses, gestion du catalogue par marque et catégorie, traitement des commandes, suivi des paiements, des livraisons, du stock et collecte des avis clients.

---

## Structure du projet

```
📁 gestion_crampons/
├── README.md              ← Vue d'ensemble + diagramme E/R
├── 1FN.md                 ← Première Forme Normale
├── 2FN.md                 ← Deuxième Forme Normale
├── 3FN.md                 ← Troisième Forme Normale
└── gestion_crampons.docx  ← Documentation complète + script SQL
```

---

## Les 11 tables

| # | Table | Rôle |
|---|-------|------|
| 1 | CLIENT | Acheteurs enregistrés |
| 2 | ADRESSE | Adresses postales des clients |
| 3 | MARQUE | Fabricants de crampons |
| 4 | CATEGORIE | Types de surface (FG, AG, SG…) |
| 5 | CRAMPON | Produits en vente |
| 6 | STOCK | Inventaire par crampon |
| 7 | COMMANDE | Achats passés |
| 8 | LIGNECOMMANDE | Détail des commandes |
| 9 | PAIEMENT | Règlement des commandes |
| 10 | LIVRAISON | Suivi d'expédition |
| 11 | AVIS | Évaluations clients |

---

## Modèle Relationnel

```
CLIENT        (id_client*, nom, prenom, email, telephone, date_inscription)
ADRESSE       (id_adresse*, type_adresse, rue, ville, code_postal, pays, #id_client)
MARQUE        (id_marque*, nom, pays_origine, site_web, description)
CATEGORIE     (id_categorie*, code, libelle, description)
CRAMPON       (id_crampon*, modele, pointure, couleur, prix, description, #id_marque, #id_categorie)
STOCK         (id_crampon*, quantite_disponible, seuil_alerte, date_maj)
COMMANDE      (id_commande*, date_commande, statut, montant_total, #id_client, #id_adresse)
LIGNECOMMANDE (id_ligne*, quantite, prix_unitaire, #id_commande, #id_crampon)
PAIEMENT      (id_paiement*, mode_paiement, statut_paiement, montant_paye, date_paiement, reference, #id_commande)
LIVRAISON     (id_livraison*, transporteur, numero_suivi, date_expedition, date_livraison_prevue, date_livraison_reelle, statut_livraison, #id_commande)
AVIS          (id_avis*, note, titre, commentaire, date_avis, verifie, #id_client, #id_crampon)
```

`*` = Clé primaire | `#` = Clé étrangère

---

## Diagramme Entité-Relation (E/R)

```mermaid
erDiagram
    CLIENT ||--o{ COMMANDE : "passe"
    CLIENT ||--o{ ADRESSE : "possede"
    CLIENT ||--o{ AVIS : "redige"
    COMMANDE }o--|| ADRESSE : "livree_a"
    COMMANDE ||--o{ LIGNECOMMANDE : "contient"
    COMMANDE ||--o| PAIEMENT : "regle"
    COMMANDE ||--o| LIVRAISON : "expediee_via"
    CRAMPON ||--o{ LIGNECOMMANDE : "concerne"
    CRAMPON ||--|| STOCK : "suit"
    CRAMPON }o--|| MARQUE : "fabriquee_par"
    CRAMPON }o--|| CATEGORIE : "appartient_a"
    CRAMPON ||--o{ AVIS : "evalue"

    CLIENT {
        int     id_client        PK
        string  nom
        string  prenom
        string  email
        string  telephone
        date    date_inscription
    }

    ADRESSE {
        int    id_adresse    PK
        int    id_client     FK
        string type_adresse
        string rue
        string ville
        string code_postal
        string pays
    }

    MARQUE {
        int    id_marque    PK
        string nom
        string pays_origine
        string site_web
        text   description
    }

    CATEGORIE {
        int    id_categorie PK
        string code
        string libelle
        text   description
    }

    CRAMPON {
        int     id_crampon   PK
        int     id_marque    FK
        int     id_categorie FK
        string  modele
        decimal pointure
        string  couleur
        decimal prix
        text    description
    }

    STOCK {
        int      id_crampon           PK
        int      quantite_disponible
        int      seuil_alerte
        datetime date_maj
    }

    COMMANDE {
        int     id_commande   PK
        int     id_client     FK
        int     id_adresse    FK
        date    date_commande
        string  statut
        decimal montant_total
    }

    LIGNECOMMANDE {
        int     id_ligne      PK
        int     id_commande   FK
        int     id_crampon    FK
        int     quantite
        decimal prix_unitaire
    }

    PAIEMENT {
        int      id_paiement     PK
        int      id_commande     FK
        string   mode_paiement
        string   statut_paiement
        decimal  montant_paye
        datetime date_paiement
        string   reference
    }

    LIVRAISON {
        int    id_livraison           PK
        int    id_commande            FK
        string transporteur
        string numero_suivi
        date   date_expedition
        date   date_livraison_prevue
        date   date_livraison_reelle
        string statut_livraison
    }

    AVIS {
        int     id_avis     PK
        int     id_client   FK
        int     id_crampon  FK
        tinyint note
        string  titre
        text    commentaire
        date    date_avis
        boolean verifie
    }
```
---
