-- ========================
-- DCL.sql - Data Control Language
-- Gestion des permissions
-- ========================

-- Créer un utilisateur lecteur
DO $$
BEGIN
    IF NOT EXISTS (SELECT FROM pg_roles WHERE rolname = 'lecteur') THEN
        CREATE ROLE lecteur LOGIN PASSWORD 'lecteur123';
    END IF;
END
$$;

-- Donner accès en lecture seule sur toutes les tables
GRANT CONNECT ON DATABASE ecole TO lecteur;
GRANT USAGE ON SCHEMA public TO lecteur;
GRANT SELECT ON etudiants    TO lecteur;
GRANT SELECT ON cours        TO lecteur;
GRANT SELECT ON inscriptions TO lecteur;
