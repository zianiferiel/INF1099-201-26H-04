\# PostgreSQL Sakila Database (Podman + pgAdmin4)



\## Étudiant

Nom : Rahmani Chakib  

Numéro étudiant : 300150399  

Cours : INF1099  



---



\# Objectif du TP



Ce laboratoire a pour objectif de :



\- Installer PostgreSQL dans un conteneur avec Podman

\- Charger la base de données Sakila dans PostgreSQL

\- Vérifier les données avec psql

\- Se connecter à PostgreSQL via pgAdmin 4

\- Exécuter des requêtes SQL pour valider l'importation des données



---



\# Environnement utilisé



\- Windows 11

\- PowerShell

\- Podman

\- PostgreSQL 16 (conteneur)

\- pgAdmin 4



---



\# 1. Lancement de PostgreSQL avec Podman



Commande utilisée :





podman run -d

--name postgres

-e POSTGRES\_USER=postgres

-e POSTGRES\_PASSWORD=postgres

-e POSTGRES\_DB=appdb

-p 5432:5432

-v postgres\_data:/var/lib/postgresql/data

postgres:16





Vérification :





podman ps





---



\# 2. Importation de la base Sakila



Téléchargement du schéma :





Invoke-WebRequest https://raw.githubusercontent.com/jOOQ/sakila/master/postgres-sakila-db/postgres-sakila-schema.sql

&nbsp;-OutFile postgres-sakila-schema.sql





Téléchargement des données :





Invoke-WebRequest https://raw.githubusercontent.com/jOOQ/sakila/master/postgres-sakila-db/postgres-sakila-insert-data.sql

&nbsp;-OutFile postgres-sakila-insert-data.sql





Copie dans le conteneur :





podman cp postgres-sakila-schema.sql postgres:/schema.sql

podman cp postgres-sakila-insert-data.sql postgres:/data.sql





Importation :





podman exec -it postgres psql -U postgres -d appdb -f /schema.sql

podman exec -it postgres psql -U postgres -d appdb -f /data.sql





---



\# 3. Vérification avec psql



Liste des tables :





podman exec -it postgres psql -U postgres -d appdb -c "\\dt"





Vérification du nombre de films :





podman exec -it postgres psql -U postgres -d appdb -c "SELECT COUNT(\*) FROM film;"





Résultat attendu : \*\*1000 films\*\*



Capture :



!\[Vérification nombre de films](images/2.png)



---



\# 4. Exemple de requête (films contenant "Star")



Requête exécutée :





SELECT title FROM film WHERE title ILIKE '%Star%';





Résultat :



\- STAR OPERATION

\- TURN STAR



Capture :



!\[Requête Star](images/1.png)



---



\# 5. Vérification dans pgAdmin



Connexion au serveur PostgreSQL :



Host : localhost  

Port : 5432  

User : postgres  

Password : postgres  

Database : appdb  



Requête exécutée :





SELECT \* FROM film;





Capture :



!\[Résultat pgAdmin](images/3.png)



---



\# Conclusion



Ce laboratoire a permis de :



\- Déployer PostgreSQL avec Podman

\- Importer la base de données Sakila

\- Vérifier les tables et les données avec psql

\- Se connecter via pgAdmin

\- Exécuter des requêtes SQL pour valider l'importation



La base \*\*Sakila contient 1000 films\*\*, confirmant que l'importation a été réalisée avec succès.

