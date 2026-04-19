-- ============================================================
-- DCL - Data Control Language
-- Centre Sportif — Gestion de Terrains & Réservations
-- #300150293
-- Prérequis : DDL.sql et DML.sql doivent avoir été exécutés
-- À exécuter en tant que superutilisateur (postgres)
-- ============================================================
 
-- ------------------------------------------------------------
-- CREATE USER — Création des utilisateurs
-- ------------------------------------------------------------
 
CREATE USER employe_user     WITH PASSWORD 'emp123';
CREATE USER gestionnaire_user WITH PASSWORD 'gest123';
 
-- ------------------------------------------------------------
-- GRANT — Attribution des droits
-- ------------------------------------------------------------
 
-- Connexion à la base
GRANT CONNECT ON DATABASE centre_sportif TO employe_user, gestionnaire_user;
 
-- Accès au schéma
GRANT USAGE ON SCHEMA centre_sportif TO employe_user, gestionnaire_user;
 
-- Employé : lecture seule
GRANT SELECT ON ALL TABLES IN SCHEMA centre_sportif TO employe_user;
 
-- Gestionnaire : lecture + écriture complète
GRANT SELECT, INSERT, UPDATE, DELETE ON ALL TABLES IN SCHEMA centre_sportif TO gestionnaire_user;
GRANT USAGE, SELECT, UPDATE ON ALL SEQUENCES IN SCHEMA centre_sportif TO gestionnaire_user;
 
-- ------------------------------------------------------------
-- TEST employe_user
-- Se connecter dans un nouveau terminal :
--   psql -U employe_user -d centre_sportif
-- ------------------------------------------------------------
 
-- SELECT * FROM centre_sportif.Reservation;                            -- ✅ OK
-- INSERT INTO centre_sportif.Terrain (id_centre, nom_terrain,
--   type_surface, taille, tarif_horaire, statut)
--   VALUES (1, 'Test', 'Gazon', '20x10', 40.00, 'Disponible');        -- ❌ permission denied
 
-- ------------------------------------------------------------
-- TEST gestionnaire_user
-- Se connecter dans un nouveau terminal :
--   psql -U gestionnaire_user -d centre_sportif
-- ------------------------------------------------------------
 
-- INSERT INTO centre_sportif.Promotion (code, type_remise, valeur,
--   date_debut, date_fin, actif)
--   VALUES ('SUMMER25', 'Pourcentage', 25.00,
--   '2024-06-01', '2024-08-31', TRUE);                                -- ✅ OK
-- UPDATE centre_sportif.Terrain
--   SET tarif_horaire = 90.00 WHERE id_terrain = 1;                   -- ✅ OK
-- SELECT * FROM centre_sportif.Terrain;                               -- ✅ OK
 
-- ------------------------------------------------------------
-- REVOKE — Retrait des droits de l'employé
-- À exécuter en tant que postgres
-- ------------------------------------------------------------
 
REVOKE SELECT ON ALL TABLES IN SCHEMA centre_sportif FROM employe_user;
 
-- Vérifier (connecté en employe_user) :
-- SELECT * FROM centre_sportif.Reservation; -- ❌ permission denied
 
-- ------------------------------------------------------------
-- DROP USER — Suppression des utilisateurs
-- ⚠️ Génère une erreur intentionnelle : les privilèges sont
--    encore actifs sur la base, le schéma et les tables.
-- ------------------------------------------------------------
 
DROP USER employe_user;
DROP USER gestionnaire_user;