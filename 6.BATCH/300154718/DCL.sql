-- ============================================================
-- DCL.sql - Gestion des droits
-- Cours : INF1099 | Domaine : AeroVoyage (Compagnie Aerienne)
-- SGBD : PostgreSQL
-- ============================================================

-- Supprimer les roles si ils existent deja
DROP ROLE IF EXISTS passager_role;
DROP ROLE IF EXISTS agent_role;
DROP ROLE IF EXISTS administrateur;

-- Creation des roles
CREATE ROLE passager_role LOGIN PASSWORD 'pass_passager';
CREATE ROLE agent_role    LOGIN PASSWORD 'pass_agent';
CREATE ROLE administrateur LOGIN PASSWORD 'pass_admin';

-- Role passager_role : consultation seulement
GRANT SELECT ON VOL       TO passager_role;
GRANT SELECT ON AEROPORT  TO passager_role;
GRANT SELECT ON PORTE     TO passager_role;
GRANT SELECT ON COMPAGNIE TO passager_role;
GRANT SELECT ON BILLET    TO passager_role;
GRANT SELECT ON BAGAGE    TO passager_role;

-- Role agent_role : gestion des reservations
GRANT SELECT, INSERT, UPDATE ON RESERVATION TO agent_role;
GRANT SELECT, INSERT, UPDATE ON PAIEMENT    TO agent_role;
GRANT SELECT, INSERT, UPDATE ON BILLET      TO agent_role;
GRANT SELECT, INSERT, UPDATE ON BAGAGE      TO agent_role;
GRANT SELECT                 ON PASSAGER    TO agent_role;
GRANT SELECT                 ON VOL         TO agent_role;

-- Role administrateur : acces complet
GRANT ALL PRIVILEGES ON PASSAGER    TO administrateur;
GRANT ALL PRIVILEGES ON ADRESSE     TO administrateur;
GRANT ALL PRIVILEGES ON COMPAGNIE   TO administrateur;
GRANT ALL PRIVILEGES ON AEROPORT    TO administrateur;
GRANT ALL PRIVILEGES ON PORTE       TO administrateur;
GRANT ALL PRIVILEGES ON AVION       TO administrateur;
GRANT ALL PRIVILEGES ON VOL         TO administrateur;
GRANT ALL PRIVILEGES ON RESERVATION TO administrateur;
GRANT ALL PRIVILEGES ON PAIEMENT    TO administrateur;
GRANT ALL PRIVILEGES ON BILLET      TO administrateur;
GRANT ALL PRIVILEGES ON BAGAGE      TO administrateur;
