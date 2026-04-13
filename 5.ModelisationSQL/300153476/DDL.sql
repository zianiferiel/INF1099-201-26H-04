-- =============================================================
--  DDL.sql — Plateforme éducative pour enfants
--  Auteure   : Ramatoulaye Diallo — 300153476
--  Cours     : INF1099
--  SGBD      : PostgreSQL
--  Modèle    : 3e Forme Normale (3FN)
--  Date      : 2026-03-18
-- =============================================================

-- -------------------------------------------------------------
-- 0. Nettoyage (ordre inverse des dépendances FK)
-- -------------------------------------------------------------
DROP TABLE IF EXISTS Message_ChatIA          CASCADE;
DROP TABLE IF EXISTS Session_ChatIA          CASCADE;
DROP TABLE IF EXISTS Participation_Concours  CASCADE;
DROP TABLE IF EXISTS Concours                CASCADE;
DROP TABLE IF EXISTS Attribution_Recompense  CASCADE;
DROP TABLE IF EXISTS Recompense              CASCADE;
DROP TABLE IF EXISTS Note                    CASCADE;
DROP TABLE IF EXISTS Soumission_Devoir       CASCADE;
DROP TABLE IF EXISTS Devoir                  CASCADE;
DROP TABLE IF EXISTS Ressource               CASCADE;
DROP TABLE IF EXISTS Inscription             CASCADE;
DROP TABLE IF EXISTS Session_Cours           CASCADE;
DROP TABLE IF EXISTS Cours                   CASCADE;
DROP TABLE IF EXISTS Professeur              CASCADE;
DROP TABLE IF EXISTS Enfant                  CASCADE;
DROP TABLE IF EXISTS Parent                  CASCADE;


-- =============================================================
-- 1. ENTITÉS INDÉPENDANTES (aucune FK)
-- =============================================================

-- -------------------------------------------------------------
-- 1.1 Parent
-- -------------------------------------------------------------
CREATE TABLE Parent (
    id_parent   SERIAL          PRIMARY KEY,
    Nom         VARCHAR(100)    NOT NULL,
    Prenom      VARCHAR(100)    NOT NULL,
    Telephone   VARCHAR(20)     UNIQUE,
    Email       VARCHAR(150)    NOT NULL UNIQUE
);

COMMENT ON TABLE  Parent           IS 'Responsable légal des enfants inscrits';
COMMENT ON COLUMN Parent.Email     IS 'Adresse courriel unique — utilisée pour la connexion';
COMMENT ON COLUMN Parent.Telephone IS 'Numéro de téléphone unique par parent';


-- -------------------------------------------------------------
-- 1.2 Professeur
-- -------------------------------------------------------------
CREATE TABLE Professeur (
    id_prof     SERIAL          PRIMARY KEY,
    Nom         VARCHAR(100)    NOT NULL,
    Prenom      VARCHAR(100)    NOT NULL,
    Telephone   VARCHAR(20)     UNIQUE,
    Email       VARCHAR(150)    NOT NULL UNIQUE,
    Specialite  VARCHAR(150)    NOT NULL
);

COMMENT ON TABLE  Professeur             IS 'Enseignant responsable d un ou plusieurs cours';
COMMENT ON COLUMN Professeur.Specialite  IS 'Ex. : mathématiques, français, sciences';


-- -------------------------------------------------------------
-- 1.3 Récompense
-- -------------------------------------------------------------
CREATE TABLE Recompense (
    id_recompense   SERIAL          PRIMARY KEY,
    Nom_recompense  VARCHAR(150)    NOT NULL,
    Description     TEXT,
    Points          INT             NOT NULL DEFAULT 0 CHECK (Points >= 0)
);

COMMENT ON TABLE  Recompense        IS 'Badge ou trophée attribuable à un enfant';
COMMENT ON COLUMN Recompense.Points IS 'Valeur en points de la récompense (>= 0)';


-- -------------------------------------------------------------
-- 1.4 Concours
-- -------------------------------------------------------------
CREATE TABLE Concours (
    id_concours     SERIAL          PRIMARY KEY,
    Titre_concours  VARCHAR(200)    NOT NULL,
    Date_concours   DATE            NOT NULL,
    Description     TEXT,
    Prix            VARCHAR(200)
);

COMMENT ON TABLE Concours IS 'Compétition ouverte aux enfants inscrits sur la plateforme';


-- =============================================================
-- 2. ENTITÉS DÉPENDANTES — 1 NIVEAU
-- =============================================================

-- -------------------------------------------------------------
-- 2.1 Enfant  (FK → Parent)
-- -------------------------------------------------------------
CREATE TABLE Enfant (
    id_enfant   SERIAL          PRIMARY KEY,
    Nom         VARCHAR(100)    NOT NULL,
    Prenom      VARCHAR(100)    NOT NULL,
    Age         SMALLINT        NOT NULL CHECK (Age BETWEEN 3 AND 18),
    Niveau      VARCHAR(50)     NOT NULL,
    id_parent   INT             NOT NULL,

    CONSTRAINT fk_enfant_parent
        FOREIGN KEY (id_parent)
        REFERENCES Parent(id_parent)
        ON UPDATE CASCADE
        ON DELETE RESTRICT
);

COMMENT ON TABLE  Enfant          IS 'Apprenant rattaché à un parent responsable';
COMMENT ON COLUMN Enfant.Age      IS 'Âge de l enfant (entre 3 et 18 ans)';
COMMENT ON COLUMN Enfant.Niveau   IS 'Ex. : maternelle, primaire, secondaire';


-- -------------------------------------------------------------
-- 2.2 Cours  (FK → Professeur)
-- -------------------------------------------------------------
CREATE TABLE Cours (
    id_cours    SERIAL          PRIMARY KEY,
    Titre_cours VARCHAR(200)    NOT NULL,
    Langue      VARCHAR(50)     NOT NULL DEFAULT 'Français',
    Niveau      VARCHAR(50)     NOT NULL,
    id_prof     INT             NOT NULL,

    CONSTRAINT fk_cours_professeur
        FOREIGN KEY (id_prof)
        REFERENCES Professeur(id_prof)
        ON UPDATE CASCADE
        ON DELETE RESTRICT
);

COMMENT ON TABLE  Cours         IS 'Matière enseignée par un professeur';
COMMENT ON COLUMN Cours.Langue  IS 'Langue d enseignement (ex. : Français, Anglais)';
COMMENT ON COLUMN Cours.Niveau  IS 'Niveau cible (ex. : débutant, intermédiaire, avancé)';


-- =============================================================
-- 3. ENTITÉS DÉPENDANTES — 2 NIVEAUX
-- =============================================================

-- -------------------------------------------------------------
-- 3.1 Session_Cours  (FK → Cours)
-- -------------------------------------------------------------
CREATE TABLE Session_Cours (
    id_session      SERIAL          PRIMARY KEY,
    Date_session    DATE            NOT NULL,
    Heure_session   TIME            NOT NULL,
    Duree           SMALLINT        NOT NULL CHECK (Duree > 0),
    Mode_session    VARCHAR(50)     NOT NULL
                        CHECK (Mode_session IN ('en ligne', 'présentiel', 'hybride')),
    id_cours        INT             NOT NULL,

    CONSTRAINT fk_session_cours
        FOREIGN KEY (id_cours)
        REFERENCES Cours(id_cours)
        ON UPDATE CASCADE
        ON DELETE CASCADE
);

COMMENT ON TABLE  Session_Cours             IS 'Occurrence planifiée d un cours';
COMMENT ON COLUMN Session_Cours.Duree       IS 'Durée en minutes';
COMMENT ON COLUMN Session_Cours.Mode_session IS 'en ligne | présentiel | hybride';


-- -------------------------------------------------------------
-- 3.2 Inscription  (FK → Enfant, Cours)
-- -------------------------------------------------------------
CREATE TABLE Inscription (
    id_inscription      SERIAL          PRIMARY KEY,
    Date_inscription    DATE            NOT NULL DEFAULT CURRENT_DATE,
    Statut_inscription  VARCHAR(50)     NOT NULL DEFAULT 'actif'
                            CHECK (Statut_inscription IN ('actif', 'suspendu', 'complété', 'annulé')),
    id_enfant           INT             NOT NULL,
    id_cours            INT             NOT NULL,

    CONSTRAINT fk_inscription_enfant
        FOREIGN KEY (id_enfant)
        REFERENCES Enfant(id_enfant)
        ON UPDATE CASCADE
        ON DELETE CASCADE,

    CONSTRAINT fk_inscription_cours
        FOREIGN KEY (id_cours)
        REFERENCES Cours(id_cours)
        ON UPDATE CASCADE
        ON DELETE CASCADE,

    -- Un enfant ne peut s'inscrire qu'une seule fois au même cours
    CONSTRAINT uq_inscription_enfant_cours
        UNIQUE (id_enfant, id_cours)
);

COMMENT ON TABLE  Inscription                   IS 'Enregistrement d un enfant dans un cours';
COMMENT ON COLUMN Inscription.Statut_inscription IS 'actif | suspendu | complété | annulé';


-- -------------------------------------------------------------
-- 3.3 Devoir  (FK → Cours)
-- -------------------------------------------------------------
CREATE TABLE Devoir (
    id_devoir       SERIAL          PRIMARY KEY,
    Titre_devoir    VARCHAR(200)    NOT NULL,
    Description     TEXT,
    Date_limite     DATE            NOT NULL,
    id_cours        INT             NOT NULL,

    CONSTRAINT fk_devoir_cours
        FOREIGN KEY (id_cours)
        REFERENCES Cours(id_cours)
        ON UPDATE CASCADE
        ON DELETE CASCADE
);

COMMENT ON TABLE Devoir IS 'Travail à remettre dans le cadre d un cours';


-- -------------------------------------------------------------
-- 3.4 Ressource  (FK → Cours)
-- -------------------------------------------------------------
CREATE TABLE Ressource (
    id_ressource    SERIAL          PRIMARY KEY,
    Titre_ressource VARCHAR(200)    NOT NULL,
    Type_ressource  VARCHAR(80)     NOT NULL
                        CHECK (Type_ressource IN ('vidéo', 'pdf', 'lien', 'image', 'audio', 'autre')),
    URL_ressource   TEXT            NOT NULL,
    id_cours        INT             NOT NULL,

    CONSTRAINT fk_ressource_cours
        FOREIGN KEY (id_cours)
        REFERENCES Cours(id_cours)
        ON UPDATE CASCADE
        ON DELETE CASCADE
);

COMMENT ON TABLE  Ressource                IS 'Matériel pédagogique associé à un cours';
COMMENT ON COLUMN Ressource.Type_ressource IS 'vidéo | pdf | lien | image | audio | autre';


-- -------------------------------------------------------------
-- 3.5 Attribution_Recompense  (FK → Enfant, Recompense)
-- -------------------------------------------------------------
CREATE TABLE Attribution_Recompense (
    id_attribution  SERIAL          PRIMARY KEY,
    Date_attribution DATE           NOT NULL DEFAULT CURRENT_DATE,
    Motif           TEXT,
    id_enfant       INT             NOT NULL,
    id_recompense   INT             NOT NULL,

    CONSTRAINT fk_attr_enfant
        FOREIGN KEY (id_enfant)
        REFERENCES Enfant(id_enfant)
        ON UPDATE CASCADE
        ON DELETE CASCADE,

    CONSTRAINT fk_attr_recompense
        FOREIGN KEY (id_recompense)
        REFERENCES Recompense(id_recompense)
        ON UPDATE CASCADE
        ON DELETE RESTRICT
);

COMMENT ON TABLE Attribution_Recompense IS 'Lien entre un enfant et une récompense obtenue';


-- -------------------------------------------------------------
-- 3.6 Participation_Concours  (FK → Enfant, Concours)
-- -------------------------------------------------------------
CREATE TABLE Participation_Concours (
    id_participation    SERIAL          PRIMARY KEY,
    Resultat            VARCHAR(100),
    Score               NUMERIC(6,2)    CHECK (Score >= 0),
    Rang                SMALLINT        CHECK (Rang > 0),
    id_enfant           INT             NOT NULL,
    id_concours         INT             NOT NULL,

    CONSTRAINT fk_parti_enfant
        FOREIGN KEY (id_enfant)
        REFERENCES Enfant(id_enfant)
        ON UPDATE CASCADE
        ON DELETE CASCADE,

    CONSTRAINT fk_parti_concours
        FOREIGN KEY (id_concours)
        REFERENCES Concours(id_concours)
        ON UPDATE CASCADE
        ON DELETE CASCADE,

    -- Un enfant participe une seule fois à un concours donné
    CONSTRAINT uq_participation
        UNIQUE (id_enfant, id_concours)
);

COMMENT ON TABLE Participation_Concours IS 'Inscription et résultat d un enfant à un concours';


-- -------------------------------------------------------------
-- 3.7 Session_ChatIA  (FK → Enfant)
-- -------------------------------------------------------------
CREATE TABLE Session_ChatIA (
    id_session_chat SERIAL          PRIMARY KEY,
    Date_session    DATE            NOT NULL DEFAULT CURRENT_DATE,
    Sujet           VARCHAR(255),
    Duree           SMALLINT        CHECK (Duree > 0),
    id_enfant       INT             NOT NULL,

    CONSTRAINT fk_chat_enfant
        FOREIGN KEY (id_enfant)
        REFERENCES Enfant(id_enfant)
        ON UPDATE CASCADE
        ON DELETE CASCADE
);

COMMENT ON TABLE  Session_ChatIA        IS 'Séance de conversation avec l IA pour un enfant';
COMMENT ON COLUMN Session_ChatIA.Duree  IS 'Durée en minutes de la session';


-- =============================================================
-- 4. ENTITÉS DÉPENDANTES — 3 NIVEAUX
-- =============================================================

-- -------------------------------------------------------------
-- 4.1 Soumission_Devoir  (FK → Devoir, Enfant)
-- -------------------------------------------------------------
CREATE TABLE Soumission_Devoir (
    id_soumission       SERIAL          PRIMARY KEY,
    Date_soumission     TIMESTAMP       NOT NULL DEFAULT CURRENT_TIMESTAMP,
    Fichier_ou_lien     TEXT            NOT NULL,
    Commentaire         TEXT,
    id_devoir           INT             NOT NULL,
    id_enfant           INT             NOT NULL,

    CONSTRAINT fk_soumission_devoir
        FOREIGN KEY (id_devoir)
        REFERENCES Devoir(id_devoir)
        ON UPDATE CASCADE
        ON DELETE CASCADE,

    CONSTRAINT fk_soumission_enfant
        FOREIGN KEY (id_enfant)
        REFERENCES Enfant(id_enfant)
        ON UPDATE CASCADE
        ON DELETE CASCADE
);

COMMENT ON TABLE  Soumission_Devoir                 IS 'Travail rendu par un enfant pour un devoir';
COMMENT ON COLUMN Soumission_Devoir.Fichier_ou_lien IS 'URL ou chemin vers le fichier soumis';


-- -------------------------------------------------------------
-- 4.2 Message_ChatIA  (FK → Session_ChatIA)
-- -------------------------------------------------------------
CREATE TABLE Message_ChatIA (
    id_message      SERIAL          PRIMARY KEY,
    Contenu_message TEXT            NOT NULL,
    Role            VARCHAR(20)     NOT NULL
                        CHECK (Role IN ('utilisateur', 'assistant')),
    Date_heure      TIMESTAMP       NOT NULL DEFAULT CURRENT_TIMESTAMP,
    id_session_chat INT             NOT NULL,

    CONSTRAINT fk_message_session
        FOREIGN KEY (id_session_chat)
        REFERENCES Session_ChatIA(id_session_chat)
        ON UPDATE CASCADE
        ON DELETE CASCADE
);

COMMENT ON TABLE  Message_ChatIA       IS 'Message échangé dans une session IA';
COMMENT ON COLUMN Message_ChatIA.Role  IS 'utilisateur (enfant) | assistant (IA)';


-- =============================================================
-- 5. ENTITÉ DÉPENDANTE — 4 NIVEAUX
-- =============================================================

-- -------------------------------------------------------------
-- 5.1 Note  (FK → Soumission_Devoir)
-- -------------------------------------------------------------
CREATE TABLE Note (
    id_note         SERIAL          PRIMARY KEY,
    Valeur          NUMERIC(5,2)    NOT NULL CHECK (Valeur BETWEEN 0 AND 100),
    Commentaire     TEXT,
    Date_correction DATE            NOT NULL DEFAULT CURRENT_DATE,
    id_soumission   INT             NOT NULL UNIQUE,   -- 1 note par soumission

    CONSTRAINT fk_note_soumission
        FOREIGN KEY (id_soumission)
        REFERENCES Soumission_Devoir(id_soumission)
        ON UPDATE CASCADE
        ON DELETE CASCADE
);

COMMENT ON TABLE  Note           IS 'Évaluation donnée par le professeur à une soumission';
COMMENT ON COLUMN Note.Valeur    IS 'Note sur 100';
COMMENT ON COLUMN Note.id_soumission IS 'Clé unique : une seule note par soumission';


-- =============================================================
-- 6. INDEX (performances des jointures les plus fréquentes)
-- =============================================================
CREATE INDEX idx_enfant_parent         ON Enfant(id_parent);
CREATE INDEX idx_cours_prof            ON Cours(id_prof);
CREATE INDEX idx_session_cours         ON Session_Cours(id_cours);
CREATE INDEX idx_inscription_enfant    ON Inscription(id_enfant);
CREATE INDEX idx_inscription_cours     ON Inscription(id_cours);
CREATE INDEX idx_devoir_cours          ON Devoir(id_cours);
CREATE INDEX idx_soumission_devoir     ON Soumission_Devoir(id_devoir);
CREATE INDEX idx_soumission_enfant     ON Soumission_Devoir(id_enfant);
CREATE INDEX idx_note_soumission       ON Note(id_soumission);
CREATE INDEX idx_ressource_cours       ON Ressource(id_cours);
CREATE INDEX idx_attr_enfant           ON Attribution_Recompense(id_enfant);
CREATE INDEX idx_parti_enfant          ON Participation_Concours(id_enfant);
CREATE INDEX idx_chat_enfant           ON Session_ChatIA(id_enfant);
CREATE INDEX idx_message_session       ON Message_ChatIA(id_session_chat);


-- =============================================================
-- FIN DU SCRIPT DDL
-- =============================================================
