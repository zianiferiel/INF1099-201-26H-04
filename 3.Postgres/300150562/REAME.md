# README - PostgreSQL avec Docker et utilisation de la base appdb

## 1. Prérequis
- **Docker** installé sur votre machine.
- Connaissance basique de la ligne de commande.
- (Optionnel) `psql` pour se connecter à PostgreSQL.

## 2. Lancer PostgreSQL avec Docker
1. Récupérer l’image PostgreSQL 16 :  
```bash
docker pull postgres:16
2.Créer et lancer un conteneur PostgreSQL :
docker run --name postgres -e POSTGRES_PASSWORD=postgres -d -p 5432:5432 postgres:16

Schema | Name           | Type  | Owner
-------+----------------+-------+-------
public | actor          | table | postgres
public | address        | table | postgres
public | category       | table | postgres
public | film           | table | postgres
public | payment        | table | postgres
...
<img width="462" height="371" alt="image" src="https://github.com/user-attachments/assets/b19cb57c-9b88-4e92-825f-9ca013d25bae" />

(21 tables)

