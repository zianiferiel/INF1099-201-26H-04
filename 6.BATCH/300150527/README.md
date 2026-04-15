# ✈️ Projet PostgreSQL – Automatisation complète avec PowerShell, Docker & Podman

## 📌 Description générale

Ce projet consiste à créer et automatiser une base de données PostgreSQL représentant un système aéroportuaire complet.
L’automatisation est réalisée à l’aide d’un script PowerShell capable d’exécuter les fichiers SQL, gérer les erreurs, et générer un journal (log) détaillé.

---

## 🧰 Technologies utilisées

* PostgreSQL
* Docker (via Podman)
* PowerShell
* SQL (DDL, DML, DCL, DQL)

---

## ⚙️ Étape 1 : Initialisation de Podman

```powershell
podman machine init
podman machine start
podman info
```
---------------------
<img width="1366" height="728" alt="1" src="https://github.com/user-attachments/assets/1c1d1b71-9cf9-4f34-b411-6edaffca9cd1" />

-------------------------

✔ Machine démarrée en mode rootless
✔ API Docker compatible

---

## 🐳 Étape 2 : Lancement du conteneur PostgreSQL

```powershell
docker container run -d --name postgres-lab -e POSTGRES_PASSWORD=postgres -e POSTGRES_DB=ecole -p 5432:5432 postgres
```
-------------------------
<img width="1366" height="459" alt="2" src="https://github.com/user-attachments/assets/74bd954f-454b-41ec-a7de-72acf03d70dd" />

----------------------------

Vérification :

```powershell
docker container ls
```
-------------------------
<img width="1366" height="119" alt="3" src="https://github.com/user-attachments/assets/e5410125-ad3e-4199-8215-6c140c676257" />

----------------------------

✔ Conteneur actif
✔ Port exposé

---

## 📁 Étape 3 : Création des fichiers

```powershell
New-Item DDL.sql
New-Item DML.sql
New-Item DCL.sql
New-Item DQL.sql
New-Item load-db.ps1
```
------------------------
<img width="1366" height="726" alt="4" src="https://github.com/user-attachments/assets/9de6d152-bd1e-4e85-9682-587acd37b5f8" />

---------------------------
<img width="700" height="212" alt="5" src="https://github.com/user-attachments/assets/23323423-786d-4d97-8957-534502d39468" />

--------------------------

## 🏗️ Étape 4 : DDL (Structure)

<img width="1366" height="728" alt="5 1" src="https://github.com/user-attachments/assets/8ff0188a-50d4-436e-8da8-9594f6657aeb" />


✔ Clés primaires et étrangères définies
✔ Relations entre les tables

---

## 📥 Étape 5 : DML (Insertion des données)

Insertion de données réalistes :

------------------
<img width="1365" height="724" alt="5 2" src="https://github.com/user-attachments/assets/8a7a92de-1cfa-443f-b054-da8a3781fda9" />

--------------

## 🔐 Étape 6 : DCL (Gestion des accès)

<img width="1366" height="725" alt="5 3" src="https://github.com/user-attachments/assets/31653a49-0bbb-4a7c-9297-fd4ce4fa6696" />


✔ Gestion correcte des erreurs

---

## 🔎 Étape 7 : DQL (Requêtes)

-----------------------
<img width="1366" height="729" alt="5 4" src="https://github.com/user-attachments/assets/6618e774-44f9-4fc6-8892-9e859df197a7" />

---------
✔ Jointures fonctionnelles
✔ Résultats corrects

---

## Étape 8 : Automatisation avec PowerShell et exécution des scripts SQL

## 📌 Description

Dans cette étape, nous avons automatisé l’exécution de la base de données PostgreSQL à l’aide d’un script PowerShell (`load-db.ps1`).
Ce script permet d’exécuter automatiquement les fichiers SQL (DDL, DML, DCL, DQL) dans un conteneur Docker.

---

## 📁 Création du script PowerShell

```powershell id="w8z2jr"
New-Item load-db.ps1
```

Ouverture :

```powershell id="y2kns0"
notepad load-db.ps1
```

--------------------------
<img width="717" height="227" alt="6" src="https://github.com/user-attachments/assets/c71f1ee6-85e6-4bc9-8f36-f72e96cff5f5" />

---

## ⚙️ Fonctionnement du script

Le script réalise les actions suivantes :

* Vérifie que le conteneur Docker est actif
* Exécute les fichiers SQL dans cet ordre :

  * DDL.sql → création des tables
  * DML.sql → insertion des données
  * DCL.sql → gestion des droits
  * DQL.sql → exécution des requêtes

---

## ▶️ Exécution du script

```powershell id="w1y8bq"
.\load-db.ps1
```

-----------------------
<img width="1366" height="726" alt="7" src="https://github.com/user-attachments/assets/e4ec5973-7488-4719-86e2-f1bcc12d37c9" />

---

## 🏗️ Exécution du DDL

Résultat observé :

```text id="9o3l4s"
NOTICE: table "..." does not exist, skipping
DROP TABLE
CREATE TABLE
```

✔ Les anciennes tables sont supprimées
✔ Les nouvelles tables sont créées correctement

---

## 📥 Exécution du DML

```text id="6j0t8h"
INSERT 0 5
```

✔ Les données sont insérées avec succès

---

## 🔐 Exécution du DCL

```text id="9c3f7d"
CREATE ROLE
GRANT
```

✔ Création du rôle `agent_consultation`
✔ Attribution des permissions

---

## 🔎 Exécution du DQL

Résultats affichés :

### 🔹 Compagnies aériennes

```text id="5r2n9w"
Air Canada
Air France
Lufthansa
Emirates
Qatar Airways
```

---

### 🔹 Avions et capacités

```text id="7z1m4k"
Boeing 737
Airbus A320
Airbus A380
Boeing 787
```

---

### 🔹 Vols

```text id="b4x8pq"
AC101 → Toronto → Montreal
AF202 → Paris → Rome
LH303 → Berlin → Madrid
EK404 → Dubai → Doha
QR505 → Doha → London
```

---

### 🔹 Passagers

```text id="l2v9js"
Ali Ahmed
Sara Ben
John Doe
Anna Smith
Omar Khan
```

---

### 🔹 Nombre de passagers

```text id="p8d1fm"
COUNT = 5
```

---

### 🔹 Tri des vols

```text id="u6k3la"
ORDER BY date_depart DESC
```

✔ Tri correct des résultats

---

### 🔹 Incidents

```text id="y0f5dz"
Delay
Technical issue
Weather
Late boarding
Fuel issue
```

---

### 🔹 Services au sol

```text id="h1n8tx"
Nettoyage
Carburant
Bagages
Catering
Maintenance
```

---

## ✅ Résultat final

```text id="e9r4qs"
Chargement terminé.
```

✔ Toutes les étapes ont été exécutées avec succès
✔ Base de données opérationnelle
✔ Données visibles et cohérentes
 ------------------------
 <img width="1366" height="726" alt="8" src="https://github.com/user-attachments/assets/993a9744-9324-40ae-a6a6-b8c0db980bca" />

 ------------------------
 <img width="1366" height="727" alt="9" src="https://github.com/user-attachments/assets/d85b5ae3-b098-4b9c-80cd-bbf183470d10" />

---------------------------

## 🎯 Objectif de cette étape

* Automatiser l’exécution des scripts SQL
* Tester la création et l’insertion des données
* Vérifier les résultats des requêtes
* Valider le bon fonctionnement global

---
