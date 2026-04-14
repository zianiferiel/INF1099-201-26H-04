📦 🐘 TP PostgreSQL – Gestion des utilisateurs et permissions (DCL)

🎯 Objectif du TP



Ce TP a pour objectif de comprendre la gestion des utilisateurs et des permissions dans PostgreSQL à l’aide des commandes DCL (Data Control Language).



Nous avons appris à :



👤 créer des utilisateurs

🔐 attribuer des permissions

🧪 tester les accès

🚫 retirer des permissions

🗑️ supprimer des utilisateurs

🏋️ Présentation – BorealFit



BorealFit est une plateforme de réservation de séances de sport destinée aux étudiants.



Elle permet de :



créer un compte utilisateur

consulter les activités sportives

réserver des séances

gérer les paiements

participer à des séances avec des coachs

🛠 Technologies utilisées

💻 PowerShell

🐳 Docker / Podman

🐘 PostgreSQL 16

⌨️ psql

1️⃣ Connexion à PostgreSQL

docker container exec --interactive --tty postgres bash

psql -U postgres



📸 Capture :



!\[Connexion psql](images/step2-connexion-psql.png)

2️⃣ Création de la base de données

CREATE DATABASE borealfit;

\\c borealfit



📸 Capture :



!\[Base borealfit](images/step3-base-borealfit.png)

3️⃣ Création du schéma

CREATE SCHEMA tp\_dcl;



📸 Capture :



!\[Schema](images/step4-schema-tp-dcl.png)

4️⃣ Création de la table reservation

CREATE TABLE tp\_dcl.reservation (

&#x20;   id SERIAL PRIMARY KEY,

&#x20;   utilisateur\_id INT,

&#x20;   date\_reservation DATE,

&#x20;   statut\_reservation VARCHAR(50)

);



Vérification :



\\dt tp\_dcl.\*



📸 Capture :



!\[Table reservation](images/step5-table-reservation.png)

5️⃣ Création des utilisateurs

CREATE USER client\_borealfit WITH PASSWORD 'client123';

CREATE USER gestionnaire\_borealfit WITH PASSWORD 'gest123';



📸 Capture :



!\[Users](images/step6-utilisateurs-crees.png)

6️⃣ Attribution des permissions

GRANT CONNECT ON DATABASE borealfit TO client\_borealfit, gestionnaire\_borealfit;

GRANT USAGE ON SCHEMA tp\_dcl TO client\_borealfit, gestionnaire\_borealfit;



📸 Capture :



!\[Permissions base](images/step7-permissions.png)

7️⃣ Permissions sur la table

GRANT SELECT ON tp\_dcl.reservation TO client\_borealfit;

GRANT SELECT, INSERT, UPDATE, DELETE ON tp\_dcl.reservation TO gestionnaire\_borealfit;

GRANT USAGE, SELECT, UPDATE ON SEQUENCE tp\_dcl.reservation\_id\_seq TO gestionnaire\_borealfit;



📸 Capture :



!\[Permissions table](images/step8-grant.png)

8️⃣ Test avec client\_borealfit

SELECT \* FROM tp\_dcl.reservation;



INSERT INTO tp\_dcl.reservation(utilisateur\_id, date\_reservation, statut\_reservation)

VALUES (1, '2026-04-14', 'confirmée');



📸 Capture :



!\[Test client](images/step9-client-refuse.png)

9️⃣ Test avec gestionnaire\_borealfit

INSERT INTO tp\_dcl.reservation(utilisateur\_id, date\_reservation, statut\_reservation)

VALUES (1, '2026-04-14', 'confirmée');



UPDATE tp\_dcl.reservation

SET statut\_reservation = 'terminée'

WHERE id = 1;



SELECT \* FROM tp\_dcl.reservation;



📸 Capture :



!\[Test gestionnaire](images/step10-gestionnaire.png)

🔟 Retirer une permission

REVOKE SELECT ON tp\_dcl.reservation FROM client\_borealfit;



📸 Capture :



!\[Revoke](images/step11-revoke.png)

1️⃣1️⃣ Test après retrait

SELECT \* FROM tp\_dcl.reservation;



📸 Capture :



!\[Client bloque](images/step12-refuse.png)

1️⃣2️⃣ Suppression des permissions

REVOKE CONNECT ON DATABASE borealfit FROM client\_borealfit, gestionnaire\_borealfit;

REVOKE USAGE ON SCHEMA tp\_dcl FROM client\_borealfit, gestionnaire\_borealfit;

REVOKE SELECT, INSERT, UPDATE, DELETE ON tp\_dcl.reservation FROM gestionnaire\_borealfit;

REVOKE USAGE, SELECT, UPDATE ON SEQUENCE tp\_dcl.reservation\_id\_seq FROM gestionnaire\_borealfit;



📸 Capture :



!\[Revoke all](images/step13-revoke-all.png)

1️⃣3️⃣ Suppression des utilisateurs

DROP USER client\_borealfit;

DROP USER gestionnaire\_borealfit;



📸 Capture :



!\[Drop users](images/step14-drop.png)

🧾 Conclusion



Dans ce TP, nous avons appris à gérer les utilisateurs et les permissions dans PostgreSQL.



Les commandes principales utilisées :



CREATE USER

GRANT

REVOKE

DROP USER



✔ Le système fonctionne correctement

✔ Les permissions sont bien contrôlées



👤 Auteur



Nom : Kahil Amine

Numéro étudiant : 300151292

🎓 INF1099 – Collège Boréal

📅 2026

