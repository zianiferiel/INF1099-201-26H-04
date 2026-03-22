-- =============================================================
--  DCL.sql — Plateforme éducative pour enfants
--  Auteure   : Ramatoulaye Diallo — 300153476
--  Cours     : INF1099
--  SGBD      : PostgreSQL
--  Role      : Controle des acces (DCL)
--  Date      : 2026-03-18
-- =============================================================
-- DCL = Data Control Language
--   CREATE ROLE  --> definir les profils d acces
--   GRANT        --> accorder des permissions
--   REVOKE       --> retirer des permissions
-- =============================================================


-- =============================================================
-- 0. NETTOYAGE — supprimer les utilisateurs avant les roles
--    Ordre obligatoire : users d abord, puis roles de groupe
-- =============================================================

-- 0.1 Supprimer les utilisateurs concrets (LOGIN) en premier
DROP USER IF EXISTS admin_diallo;
DROP USER IF EXISTS prof_martin;
DROP USER IF EXISTS parent_tremblay;
DROP USER IF EXISTS enfant_emma;
DROP USER IF EXISTS auditeur_sys;

-- 0.2 Supprimer les roles de groupe ensuite
DROP ROLE IF EXISTS admin_plateforme;
DROP ROLE IF EXISTS professeur_role;
DROP ROLE IF EXISTS parent_role;
DROP ROLE IF EXISTS enfant_role;
DROP ROLE IF EXISTS lecture_seule;


-- =============================================================
-- 1. CREATION DES ROLES (profils de securite)
-- =============================================================

-- 1.1 Role : admin_plateforme
CREATE ROLE admin_plateforme
    NOLOGIN
    CREATEROLE;

COMMENT ON ROLE admin_plateforme
    IS 'Administrateur complet de la plateforme educative';


-- 1.2 Role : professeur_role
CREATE ROLE professeur_role
    NOLOGIN;

COMMENT ON ROLE professeur_role
    IS 'Enseignant — gere les cours, devoirs et notes';


-- 1.3 Role : parent_role
CREATE ROLE parent_role
    NOLOGIN;

COMMENT ON ROLE parent_role
    IS 'Parent — consulte les informations de ses enfants';


-- 1.4 Role : enfant_role
CREATE ROLE enfant_role
    NOLOGIN;

COMMENT ON ROLE enfant_role
    IS 'Apprenant — soumet devoirs et utilise le chat IA';


-- 1.5 Role : lecture_seule
CREATE ROLE lecture_seule
    NOLOGIN;

COMMENT ON ROLE lecture_seule
    IS 'Acces lecture seule pour audit et rapports';


-- =============================================================
-- 2. PERMISSIONS — admin_plateforme
--    Tous les droits sur toutes les tables et sequences
-- =============================================================
GRANT ALL PRIVILEGES ON ALL TABLES    IN SCHEMA public TO admin_plateforme;
GRANT ALL PRIVILEGES ON ALL SEQUENCES IN SCHEMA public TO admin_plateforme;
GRANT ALL PRIVILEGES ON SCHEMA public                  TO admin_plateforme;


-- =============================================================
-- 3. PERMISSIONS — professeur_role
-- =============================================================

-- Lecture sur les tables liees aux eleves et parents
GRANT SELECT ON
    Parent,
    Enfant,
    Inscription,
    Participation_Concours,
    Attribution_Recompense
TO professeur_role;

-- Lecture + ecriture sur les tables pedagogiques
GRANT SELECT, INSERT, UPDATE, DELETE ON
    Cours,
    Session_Cours,
    Devoir,
    Ressource,
    Soumission_Devoir,
    Note
TO professeur_role;

-- Acces aux sequences pour les INSERT (SERIAL --> nextval)
GRANT USAGE, SELECT ON
    cours_id_cours_seq,
    session_cours_id_session_seq,
    devoir_id_devoir_seq,
    ressource_id_ressource_seq,
    note_id_note_seq
TO professeur_role;


-- =============================================================
-- 4. PERMISSIONS — parent_role
-- =============================================================

GRANT SELECT ON
    Parent,
    Enfant,
    Inscription,
    Cours,
    Session_Cours,
    Devoir,
    Soumission_Devoir,
    Note,
    Ressource,
    Attribution_Recompense,
    Recompense,
    Participation_Concours,
    Concours
TO parent_role;

-- Le parent peut mettre a jour ses propres coordonnees
GRANT UPDATE (Telephone, Email) ON Parent TO parent_role;


-- =============================================================
-- 5. PERMISSIONS — enfant_role
-- =============================================================

GRANT SELECT ON
    Cours,
    Session_Cours,
    Inscription,
    Devoir,
    Ressource,
    Recompense,
    Concours,
    Attribution_Recompense
TO enfant_role;

-- Ecriture : soumettre devoirs et utiliser le chat IA
GRANT SELECT, INSERT ON
    Soumission_Devoir,
    Session_ChatIA,
    Message_ChatIA,
    Participation_Concours
TO enfant_role;

-- Sequences necessaires pour les INSERT
GRANT USAGE, SELECT ON
    soumission_devoir_id_soumission_seq,
    session_chatia_id_session_chat_seq,
    message_chatia_id_message_seq,
    participation_concours_id_participation_seq
TO enfant_role;


-- =============================================================
-- 6. PERMISSIONS — lecture_seule
--    SELECT uniquement sur toutes les tables
-- =============================================================
GRANT SELECT ON ALL TABLES IN SCHEMA public TO lecture_seule;


-- =============================================================
-- 7. CREATION DES UTILISATEURS CONCRETS
--    Avec mot de passe + rattachement a un role
-- =============================================================

-- 7.1 Administrateur systeme
CREATE USER admin_diallo
    WITH PASSWORD 'Admin@Secure2026!'
    CONNECTION LIMIT 5;

GRANT admin_plateforme TO admin_diallo;

COMMENT ON ROLE admin_diallo
    IS 'Compte administrateur principal — Ramatoulaye Diallo';


-- 7.2 Exemple de professeur
CREATE USER prof_martin
    WITH PASSWORD 'Prof@Martin2026!'
    CONNECTION LIMIT 10;

GRANT professeur_role TO prof_martin;

COMMENT ON ROLE prof_martin
    IS 'Compte exemple — professeur Martin';


-- 7.3 Exemple de parent
CREATE USER parent_tremblay
    WITH PASSWORD 'Parent@Tremblay2026!'
    CONNECTION LIMIT 3;

GRANT parent_role TO parent_tremblay;

COMMENT ON ROLE parent_tremblay
    IS 'Compte exemple — parent Tremblay';


-- 7.4 Exemple d enfant
CREATE USER enfant_emma
    WITH PASSWORD 'Enfant@Emma2026!'
    CONNECTION LIMIT 2;

GRANT enfant_role TO enfant_emma;

COMMENT ON ROLE enfant_emma
    IS 'Compte exemple — enfant Emma';


-- 7.5 Auditeur (lecture seule)
CREATE USER auditeur_sys
    WITH PASSWORD 'Audit@Sys2026!'
    CONNECTION LIMIT 2;

GRANT lecture_seule TO auditeur_sys;

COMMENT ON ROLE auditeur_sys
    IS 'Compte audit — acces lecture seule sur toutes les tables';


-- =============================================================
-- 8. PERMISSIONS FUTURES
--    Applique automatiquement les droits aux nouvelles tables
-- =============================================================
ALTER DEFAULT PRIVILEGES IN SCHEMA public
    GRANT SELECT ON TABLES TO lecture_seule;

ALTER DEFAULT PRIVILEGES IN SCHEMA public
    GRANT SELECT ON TABLES TO parent_role;

ALTER DEFAULT PRIVILEGES IN SCHEMA public
    GRANT SELECT ON TABLES TO enfant_role;


-- =============================================================
-- 9. VERIFICATION — afficher les roles crees
-- =============================================================
SELECT rolname,
       rolcanlogin    AS peut_se_connecter,
       rolcreaterole  AS peut_creer_roles
FROM   pg_roles
WHERE  rolname IN (
    'admin_plateforme', 'professeur_role', 'parent_role',
    'enfant_role',      'lecture_seule',
    'admin_diallo',     'prof_martin',     'parent_tremblay',
    'enfant_emma',      'auditeur_sys'
)
ORDER BY rolcanlogin, rolname;


-- =============================================================
-- FIN DU SCRIPT DCL
-- =============================================================
