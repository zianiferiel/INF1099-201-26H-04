# 🔐 TP4 : Contrôle d'Accès (DCL) - Projet EduHome
**Étudiant :** Ramatoulaye Diallo 
**ID :** 300153476  
**Cours :** INF1099 - Administration de bases de données  
**Session :** Hiver 2026

---

## 📝 Présentation du Laboratoire
Ce travail pratique porte sur le **DCL (Data Control Language)**. L'objectif est d'apprendre à gérer la sécurité d'une base de données PostgreSQL en créant des utilisateurs et en leur attribuant des permissions spécifiques (Privilèges) sur le projet **EduHome**.

## 🏗️ Structure de la Base de Données
Toutes les opérations ont été effectuées dans la base de données `ecole` sous le schéma `eduhome`.

### Tables créées (Modèle 3FN) :
* **eduhome.parent** : Stocke les informations des tuteurs.
* **eduhome.enfant** : Stocke les informations des élèves.
* **eduhome.note** : Gère les évaluations et commentaires.

---

## 🚀 Étapes de Réalisation (DCL)

### 1. Création des Utilisateurs
Nous avons créé deux rôles distincts pour simuler une gestion scolaire réelle :
```sql
CREATE USER prof_test WITH PASSWORD 'prof123';
CREATE USER etudiant_test WITH PASSWORD 'etudiant123';
```
## 📊 Preuves de Fonctionnement

### ✅ Test 1 : Succès du Professeur
Le professeur est autorisé à insérer des données dans la table des notes.
![Capture Succès Prof](./images/prof_success.png)
*Légende : Insertion d'une note de 95 réussie par prof_test*

### ❌ Test 2 : Blocage de l'Étudiant (Sécurité)
L'étudiant tente de modifier une note, mais PostgreSQL bloque l'action grâce au DCL.
![Capture Erreur Étudiant](./images/etudiant_error.png)
*Légende : Message d'erreur "Permission denied for table note"*
