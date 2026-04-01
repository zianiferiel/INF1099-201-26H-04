-- ============================================================
--  DCL.sql — Gestion des droits BetFormula
--  TP Modélisation SQL | INF1099 | Étudiant : 300150295
-- ============================================================

-- Créer les rôles
CREATE ROLE parieur;
CREATE ROLE administrateur;

-- Parieur : lecture seulement
GRANT SELECT ON Utilisateur, Course, Pilote, Pari, Evenement, Circuit TO parieur;

-- Administrateur : tous les droits
GRANT ALL PRIVILEGES ON ALL TABLES IN SCHEMA public TO administrateur;

-- Révoquer droits sensibles au parieur
REVOKE DELETE ON Pari FROM parieur;
REVOKE UPDATE ON Pari FROM parieur;
