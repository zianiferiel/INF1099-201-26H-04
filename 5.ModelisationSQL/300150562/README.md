📦 Projet : Base de Données – Boutique de Maillots (PostgreSQL)
👤 Auteur

Corneil Ekofo Wema

🎯 Objectif général

Ce projet vise à concevoir une base de données relationnelle pour une boutique de maillots permettant de gérer :

les clients et leurs informations
les commandes et leurs détails
les paiements
les livraisons
les produits (maillots) et leurs catégories

L’objectif est d’appliquer les concepts de modélisation SQL afin de construire un système :

fiable
performant
évolutif
structuré
🧠 Étapes de modélisation
1️⃣ Analyse des besoins

Cette étape a permis de :

identifier les entités principales (Client, Commande, Maillot…)
définir les relations entre elles
comprendre le fonctionnement d’une boutique en ligne

👉 Une bonne analyse garantit une base de données cohérente.

2️⃣ Modélisation conceptuelle
Utilisation d’un diagramme Entité-Relation (ER)
Identification des entités :
CLIENT
ADRESSE
COMMANDE
MAILLOT
PAIEMENT
LIVRAISON
LIVREUR

👉 Cette étape donne une vision globale du système.

3️⃣ Modélisation logique
Transformation en tables relationnelles
Définition des :
clés primaires (PK)
clés étrangères (FK)
Application de la normalisation (jusqu’à 3FN)

👉 Objectif : éviter la redondance et assurer l’intégrité des données.

4️⃣ Modélisation physique
Utilisation de PostgreSQL
Définition des types de données (VARCHAR, INT, DATE, DECIMAL)
Mise en place des contraintes et relations
5️⃣ Implémentation
Création des tables (DDL)
Insertion des données (DML)
Requêtes d’analyse (DQL)
Gestion des permissions (DCL)
🧱 Structure de la base de données
Tables principales :
Table	Rôle
CLIENT	Stocke les informations clients
ADRESSE	Adresses de livraison
COMMANDE	Commandes des clients
LIGNE_COMMANDE	Détails des commandes
MAILLOT	Produits
CATEGORIE_MAILLOT	Catégories de produits
PAIEMENT	Transactions
LIVRAISON	Suivi des commandes
LIVREUR	Gestion des livreurs
🔗 Relations principales
Un client peut avoir plusieurs adresses
Un client peut passer plusieurs commandes
Une commande contient plusieurs lignes
Un maillot peut apparaître dans plusieurs commandes
Une commande possède un paiement
Une commande possède une livraison
Un livreur effectue plusieurs livraisons
🤝 Importance de la communication

Une bonne communication permet :

de comprendre les besoins réels
d’éviter les erreurs de conception
de garantir un modèle cohérent
de faciliter la maintenance

👉 Les erreurs viennent souvent d’un manque de clarification.

⚙️ Choix du SGBD

Le système utilise PostgreSQL.

Justification :
Gestion avancée des relations
Support des transactions (ACID)
Performance élevée
Fiabilité
🧱 Réduction de la redondance

Techniques utilisées :

Normalisation (1FN, 2FN, 3FN)
Utilisation de clés étrangères
Séparation des entités
Objectifs :
éviter la duplication
garantir la cohérence
améliorer les performances
📊 Choix du diagramme

Le diagramme Entité-Relation (ER) a été utilisé.

Pourquoi ?
représentation claire
adapté aux bases relationnelles
facile à transformer en SQL
🔄 Approche itérative

Le modèle a été amélioré progressivement :

correction des relations
ajout de contraintes
optimisation de la structure

👉 Une base de données évolue avec le temps.

🧠 Pensée critique

La conception a nécessité :

analyse des performances
choix des bonnes relations
anticipation de l’évolution
⚖️ Justification des choix

Le choix de PostgreSQL est basé sur :

la complexité des relations
le besoin de transactions fiables
la cohérence des données
📌 Plan d’optimisation
1️⃣ Analyse des performances
utilisation de EXPLAIN
identification des requêtes lentes
2️⃣ Indexation
index sur les clés primaires
index sur les clés étrangères
index sur les colonnes utilisées dans les recherches

⚠️ Attention : trop d’index ralentit les insertions.

3️⃣ Optimisation des requêtes
éviter SELECT *
limiter les jointures inutiles
optimiser les filtres
4️⃣ Normalisation
réduction des données dupliquées
meilleure organisation
5️⃣ Optimisation physique
configuration PostgreSQL
gestion de la mémoire
stockage efficace
6️⃣ Surveillance
suivi des performances
analyse des requêtes
monitoring du système
🎯 Résumé stratégique

Une base de données performante repose sur :

une bonne modélisation
des relations bien définies
une structure normalisée
des requêtes optimisées
une surveillance continue
✅ Conclusion

Ce projet démontre :

l’importance de la modélisation
la nécessité d’une bonne structure
le rôle clé de l’optimisation

Il met en pratique les concepts fondamentaux des bases de données relationnelles avec PostgreSQL.

