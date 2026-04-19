-- ============================================================
-- DCL - Data Control Language
-- Centre Sportif - Gestion de Terrains & Reservations
-- #300150293
-- Prerequis : DDL.sql et DML.sql doivent avoir ete executes
-- A executer en tant que superutilisateur (postgres)
-- ============================================================
 
-- ------------------------------------------------------------
-- Nettoyage - Supprimer les utilisateurs s'ils existent
-- ------------------------------------------------------------
DROP USER IF EXISTS employe_user;
DROP USER IF EXISTS gestionnaire_user;
 
-- ------------------------------------------------------------
-- CREATE USER - Creation des utilisateurs
-- ------------------------------------------------------------
 
-- Employe : lecture seule
CREATE USER employe_user     WITH PASSWORD 'emp123';
 
-- Gestionnaire : acces complet
CREATE USER gestionnaire_user WITH PASSWORD 'gest123';
 
-- ------------------------------------------------------------
-- GRANT - Attribution des droits
-- ------------------------------------------------------------
 
-- Connexion a la base
GRANT CONNECT ON DATABASE centre_sportif TO employe_user, gestionnaire_user;
 
-- Acces au schema
GRANT USAGE ON SCHEMA centre_sportif TO employe_user, gestionnaire_user;
 
-- Employe : lecture seule
GRANT SELECT ON ALL TABLES IN SCHEMA centre_sportif TO employe_user;
 
-- Gestionnaire : lecture + ecriture complete
GRANT SELECT, INSERT, UPDATE, DELETE ON ALL TABLES IN SCHEMA centre_sportif TO gestionnaire_user;
GRANT USAGE, SELECT, UPDATE ON ALL SEQUENCES IN SCHEMA centre_sportif TO gestionnaire_user;
 
-- ------------------------------------------------------------
-- REVOKE - Retrait des droits de l'employe
-- ------------------------------------------------------------
REVOKE SELECT ON ALL TABLES IN SCHEMA centre_sportif FROM employe_user;
 
-- ------------------------------------------------------------
-- DROP USER - Suppression des utilisateurs
-- Genere une erreur intentionnelle car les privileges
-- sont encore actifs sur la base et le schema
-- ------------------------------------------------------------
DROP USER employe_user;
DROP USER gestionnaire_user;