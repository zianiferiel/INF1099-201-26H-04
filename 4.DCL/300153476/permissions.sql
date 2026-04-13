
-- Création de la base
CREATE DATABASE ecole;

-- Connexion à la base ecole (TRÈS IMPORTANT)
\c ecole

CREATE SCHEMA eduhome;

CREATE TABLE eduhome.enfant (
    id_enfant SERIAL PRIMARY KEY,
    nom TEXT,
    id_parent INTEGER REFERENCES eduhome.parent(id_parent)
);

CREATE TABLE eduhome.note (
    id_note SERIAL PRIMARY KEY,
    valeur NUMERIC,
    commentaire TEXT,
    id_enfant INTEGER REFERENCES eduhome.enfant(id_enfant)
);

GRANT ALL PRIVILEGES ON ALL TABLES IN SCHEMA eduhome TO prof_test;
GRANT SELECT ON eduhome.note TO etudiant_test;