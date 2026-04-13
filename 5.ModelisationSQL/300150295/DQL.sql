-- ============================================================
--  DQL.sql — Requêtes BetFormula
--  TP Modélisation SQL | INF1099 | Étudiant : 300150295
-- ============================================================

-- 1. Tous les utilisateurs et leur ville
SELECT u.nom, u.email, v.nom_ville
FROM Utilisateur u
JOIN Ville v ON u.id_ville = v.id_ville;

-- 2. Tous les paris avec utilisateur, course et pilote
SELECT u.nom AS utilisateur, c.nom_course, p.nom_pilote, pa.montant, pa.resultat
FROM Pari pa
JOIN Utilisateur u  ON pa.id_user   = u.id_user
JOIN Course c       ON pa.id_course = c.id_course
JOIN Pilote p       ON pa.id_pilote = p.id_pilote;

-- 3. Paris gagnés
SELECT u.nom, pa.montant
FROM Pari pa
JOIN Utilisateur u ON pa.id_user = u.id_user
WHERE pa.resultat = 'gagne';

-- 4. Total misé par utilisateur
SELECT u.nom, SUM(pa.montant) AS total_mise
FROM Pari pa
JOIN Utilisateur u ON pa.id_user = u.id_user
GROUP BY u.nom
ORDER BY total_mise DESC;

-- 5. Pilotes et leur équipe
SELECT p.nom_pilote, e.nom_equipe, s.nom_sponsor
FROM Pilote p
JOIN Equipe  e ON p.id_equipe  = e.id_equipe
JOIN Sponsor s ON e.id_sponsor = s.id_sponsor;
