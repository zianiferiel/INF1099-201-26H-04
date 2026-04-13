-- ========================
-- DML.sql - Data Manipulation Language
-- Insertion des données
-- ========================

INSERT INTO etudiants (nom, prenom, email, age) VALUES
    ('Tremblay', 'Alice',   'alice@ecole.ca',   20),
    ('Gagnon',   'Bob',     'bob@ecole.ca',     22),
    ('Roy',      'Claire',  'claire@ecole.ca',  21),
    ('Côté',     'David',   'david@ecole.ca',   23),
    ('Bouchard', 'Emma',    'emma@ecole.ca',    19);

INSERT INTO cours (titre, description, credits) VALUES
    ('Bases de données',    'Introduction à SQL et PostgreSQL', 3),
    ('Réseaux',             'Protocoles et architecture réseau', 3),
    ('Programmation Web',   'HTML, CSS, JavaScript',            3);

INSERT INTO inscriptions (etudiant_id, cours_id) VALUES
    (1, 1),
    (2, 1),
    (3, 2),
    (4, 3),
    (5, 1);
