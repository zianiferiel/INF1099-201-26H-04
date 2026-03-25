# ✈️ TP PostgreSQL — Base de données Airline

<div align="center">

![PostgreSQL](https://img.shields.io/badge/PostgreSQL-16-336791?style=for-the-badge&logo=postgresql&logoColor=white)
![Docker](https://img.shields.io/badge/Docker-Container-2496ED?style=for-the-badge&logo=docker&logoColor=white)
![pgAdmin](https://img.shields.io/badge/pgAdmin-4-336791?style=for-the-badge&logo=postgresql&logoColor=white)

*Déploiement d'une base de données relationnelle pour une compagnie aérienne via Docker*

</div>

---

## 📌 Description

Ce travail consiste à installer **PostgreSQL** dans un conteneur **Docker**, créer une base de données pour une compagnie aérienne, ajouter les tables, insérer des données et tester des requêtes SQL. L'outil **pgAdmin** est utilisé pour visualiser les données.

---

## 🚀 1. Lancement du conteneur PostgreSQL

```bash
docker container run -d `
  --name postgres-airline `
  -e POSTGRES_USER=postgres `
  -e POSTGRES_PASSWORD=postgres `
  -e POSTGRES_DB=airline_db `
  -p 5432:5432 `
  -v postgres_airline_data:/var/lib/postgresql/data `
  postgres:16
```
 ![wait](https://github.com/user-attachments/assets/f3fef0c9-0a50-4cc4-a4ba-da758a8115d8)



---

## 🔍 2. Vérification de Docker

```bash
docker version
```

> 📸 **Capture :** Docker en fonctionnement
![wait](https://github.com/user-attachments/assets/f09000b8-61c9-4038-aab1-822217943d80)
---

## 🔗 3. Connexion à PostgreSQL

```bash
docker exec -it postgres-airline psql -U postgres -d airline_db
```

> 📸 **Capture :** connexion réussie avec `airline_db=#`
>![wait](https://github.com/user-attachments/assets/bf4d91dd-ff1c-460d-9908-0b472b13eeca)


---

## 🏗️ 4. Création des tables

Création des tables pour le système de gestion d'une compagnie aérienne :

| # | Table | Description |
|---|-------|-------------|
| 1 | `passager` | Informations sur les passagers |
| 2 | `adresse` | Adresses associées aux passagers |
| 3 | `reservation` | Réservations effectuées |
| 4 | `paiement` | Détails des paiements |
| 5 | `billet` | Billets émis |
| 6 | `bagage` | Bagages enregistrés |
| 7 | `compagnie` | Compagnies aériennes |
| 8 | `avion` | Flotte d'avions |
| 9 | `vol` | Vols planifiés |
| 10 | `aeroport` | Aéroports de départ/arrivée |
| 11 | `porte` | Portes d'embarquement |

> 📸 **Capture :** résultat de la commande `\dt`
<![wait](https://github.com/user-attachments/assets/972d7b8c-f34f-482c-ae25-c50954601bbd)

---

## 📊 5. Structure d'une table

```sql
\d passager
```

> 📸 **Capture :** structure de la table `passager`
![wait](https://github.com/user-attachments/assets/75a08299-5fc6-4033-9536-e1080dcc6e75)

---

## 📥 6. Insertion des données

```sql
INSERT INTO passager (nom, prenom, telephone, email, numero_passeport)
VALUES ('Tidjet', 'Stephane', '4370001111', 'stephane@email.com', 'P12345678');
```

> 📸 **Capture :** données insérées avec `SELECT * FROM passager;`
<![wait](https://github.com/user-attachments/assets/17848717-e9df-48e8-8b81-56ea19c490ef)

---

## 📋 7. Vérification des données

```sql
SELECT * FROM vol;
```

> 📸 **Capture :** données des vols
<![wait](https://github.com/user-attachments/assets/cc1c66a0-40ce-4d67-87f2-6c147b2bdc2f)

---

## 🔗 8. Requête JOIN

```sql
SELECT 
    p.nom,
    p.prenom,
    b.numero_billet,
    v.numero_vol
FROM billet b
JOIN reservation r ON b.reservation_id = r.id
JOIN passager p ON r.passager_id = p.id
JOIN vol v ON b.vol_id = v.id;
```

> 📸 **Capture :** résultat de la requête JOIN
![wait](https://github.com/user-attachments/assets/ca0f7ef7-2032-46e1-bbf3-3c7fe2cde988)

---

## 🖥️ 9. Connexion avec pgAdmin

| Paramètre | Valeur |
|-----------|--------|
| **Host** | `localhost` |
| **Port** | `5432` |
| **Username** | `postgres` |
| **Password** | `postgres` |
| **Database** | `airline_db` |

> 📸 **Capture :** connexion réussie

---

## 📂 10. Visualisation des tables dans pgAdmin

**Navigation :**

```
Databases → airline_db → Schemas → public → Tables
```

> 📸 **Capture :** liste des tables
<![wait](https://github.com/user-attachments/assets/3f5972e2-6fec-4bfc-b5b7-777d0887b5ca)


 

## ✅ Conclusion

Ce TP m'a permis de comprendre comment :

- 🐳 Installer **PostgreSQL** avec **Docker**
- 🗄️ Créer une **base de données relationnelle**
- 🏗️ Ajouter des **tables avec des relations**
- 📥 **Insérer des données** et exécuter des **requêtes SQL**
- 🖥️ Utiliser **pgAdmin** pour visualiser et gérer les données facilement

---

<div align="center">

*Réalisé dans le cadre d'un TP sur la gestion de bases de données avec PostgreSQL et Docker*

</div>
