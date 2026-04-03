CREATE TABLE etudiants (
    id SERIAL PRIMARY KEY,
    nom TEXT NOT NULL,
    age INT,
    email TEXT UNIQUE,
    date_creation TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE logs (
    id SERIAL PRIMARY KEY,
    action TEXT,
    date_action TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Ajout tables nécessaires pour le TP
CREATE TABLE cours (
    id SERIAL PRIMARY KEY,
    nom TEXT UNIQUE
);

CREATE TABLE inscriptions (
    id SERIAL PRIMARY KEY,
    etudiant_id INT REFERENCES etudiants(id),
    cours_id INT REFERENCES cours(id)
);
