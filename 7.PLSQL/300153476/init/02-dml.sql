-- ==================================================================================
-- 02-dml.sql
-- Insertion des données initiales
-- ==================================================================================

-- Données de test : étudiants
INSERT INTO etudiants (nom, age, email)
VALUES
    ('Test',   20, 'test@email.com'),
    ('Marie',  23, 'marie@email.com'),
    ('Carlos', 19, 'carlos@email.com');

-- Données de test : cours
INSERT INTO cours (nom)
VALUES
    ('Base de données'),
    ('Programmation Python'),
    ('Réseaux informatiques');
