-- ========================
-- DQL.sql - Data Query Language
-- Requêtes SELECT
-- ========================

-- Liste de tous les étudiants
SELECT * FROM etudiants;

-- Liste de tous les cours
SELECT * FROM cours;

-- Jointure : étudiants inscrits avec leur cours
SELECT
    e.nom,
    e.prenom,
    c.titre AS cours
FROM inscriptions i
JOIN etudiants e ON e.id = i.etudiant_id
JOIN cours     c ON c.id = i.cours_id
ORDER BY e.nom;
