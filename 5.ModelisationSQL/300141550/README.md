# 📦 Projet : Base de Données – Boutique de Maillots (PostgreSQL)

---

## 👤 Auteur
**Corneil Ekofo Wema**

---

## 🎯 Objectif général

Ce projet vise à concevoir une base de données relationnelle pour une **boutique de maillots** permettant de gérer :

- les clients et leurs informations  
- les commandes et leurs détails  
- les paiements  
- les livraisons  
- les produits (maillots) et leurs catégories  

### 🎯 Objectifs techniques :

- ✔️ Fiabilité  
- ✔️ Performance  
- ✔️ Évolutivité  
- ✔️ Bonne structuration  

---

## 🧠 Étapes de modélisation

### 1️⃣ Analyse des besoins

- Identification des entités (Client, Commande, Maillot…)  
- Définition des relations  
- Compréhension du système  

👉 Une bonne analyse évite les erreurs de conception.

---

### 2️⃣ Modélisation conceptuelle

- Diagramme **Entité-Relation (ER)**  
- Identification :
  - CLIENT  
  - ADRESSE  
  - COMMANDE  
  - MAILLOT  
  - PAIEMENT  
  - LIVRAISON  
  - LIVREUR  

---

### 3️⃣ Modélisation logique

- Transformation en tables  
- Définition :
  - **Clés primaires (PK)**  
  - **Clés étrangères (FK)**  
- Normalisation (1FN, 2FN, 3FN)

👉 Objectif : réduire la redondance.

---

### 4️⃣ Modélisation physique

- Utilisation de **PostgreSQL**  
- Types de données :
  - `VARCHAR`
  - `INT`
  - `DATE`
  - `DECIMAL`  

---

### 5️⃣ Implémentation

- 📄 DDL → Création des tables  
- ✏️ DML → Insertion des données  
- 🔍 DQL → Requêtes SELECT  
- 🔐 DCL → Gestion des accès  

---

## 🧱 Structure de la base de données

| Table | Rôle |
|------|------|
| CLIENT | Informations clients |
| ADRESSE | Adresses |
| COMMANDE | Commandes |
| LIGNE_COMMANDE | Détails |
| MAILLOT | Produits |
| CATEGORIE_MAILLOT | Catégories |
| PAIEMENT | Paiements |
| LIVRAISON | Suivi |
| LIVREUR | Livreurs |

---

## 🔗 Relations principales

- Un client → plusieurs adresses  
- Un client → plusieurs commandes  
- Une commande → plusieurs lignes  
- Un maillot → plusieurs commandes  
- Une commande → un paiement  
- Une commande → une livraison  
- Un livreur → plusieurs livraisons  

---

## 🤝 Importance de la communication

Une bonne communication permet :

- éviter les erreurs  
- clarifier les besoins  
- améliorer la cohérence  

---

## ⚙️ Choix du SGBD

### 🐘 PostgreSQL

**Pourquoi ?**

- ✔️ Gestion avancée des relations  
- ✔️ Transactions fiables (ACID)  
- ✔️ Haute performance  

---

## 🧱 Réduction de la redondance

Techniques utilisées :

- Normalisation  
- Clés étrangères  
- Séparation des tables  

### 🎯 Objectifs :

- éviter la duplication  
- garantir l’intégrité  
- améliorer les performances  

---

## 📊 Choix du diagramme

### Diagramme ER (Entité-Relation)

✔️ Clair  
✔️ Facile à comprendre  
✔️ Adapté au SQL  

---

## 🔄 Approche itérative

- Amélioration progressive  
- Correction des erreurs  
- Optimisation  

👉 Une base de données évolue toujours.

---

## 🧠 Pensée critique

- Analyse des performances  
- Choix des relations  
- Anticipation des besoins  

---

## ⚖️ Justification des choix

PostgreSQL est choisi car :

- données fortement liées  
- besoin de cohérence  
- transactions sécurisées  

---

## 📌 Plan d’optimisation

### 1️⃣ Analyse

- `EXPLAIN`
- requêtes lentes  

---

### 2️⃣ Indexation

- clés primaires  
- clés étrangères  
- colonnes de recherche  

⚠️ Trop d’index = ralentissement des insertions  

---

### 3️⃣ Optimisation des requêtes

- éviter `SELECT *`  
- limiter les jointures  
- simplifier les requêtes  

---

### 4️⃣ Normalisation

- réduction des doublons  
- meilleure organisation  

---

### 5️⃣ Optimisation système

- mémoire  
- stockage  
- configuration PostgreSQL  

---

### 6️⃣ Surveillance

- monitoring  
- analyse continue  
- performance  

---

## 🎯 Résumé stratégique

Une base performante =

- bonne modélisation  
- structure claire  
- requêtes optimisées  
- surveillance continue  

---

## ✅ Conclusion

Ce projet démontre :

- l’importance de la modélisation  
- la nécessité d’une structure claire  
- le rôle de l’optimisation  

👉 Application complète des concepts SQL avec PostgreSQL.
