-- ============================================================
--  DDL.sql — Définition des tables BetFormula
--  TP Modélisation SQL | INF1099 | Étudiant : 300150295
-- ============================================================

CREATE TABLE Ville (
    id_ville     SERIAL PRIMARY KEY,
    nom_ville    VARCHAR(100) NOT NULL,
    code_postal  VARCHAR(10)  NOT NULL
);

CREATE TABLE Sponsor (
    id_sponsor   SERIAL PRIMARY KEY,
    nom_sponsor  VARCHAR(100) NOT NULL
);

CREATE TABLE Equipe (
    id_equipe    SERIAL PRIMARY KEY,
    nom_equipe   VARCHAR(100) NOT NULL,
    id_sponsor   INT REFERENCES Sponsor(id_sponsor)
);

CREATE TABLE Pilote (
    id_pilote    SERIAL PRIMARY KEY,
    nom_pilote   VARCHAR(100) NOT NULL,
    id_equipe    INT REFERENCES Equipe(id_equipe)
);

CREATE TABLE Utilisateur (
    id_user      SERIAL PRIMARY KEY,
    nom          VARCHAR(100) NOT NULL,
    email        VARCHAR(150) NOT NULL UNIQUE,
    id_ville     INT REFERENCES Ville(id_ville)
);

CREATE TABLE Circuit (
    id_circuit   SERIAL PRIMARY KEY,
    nom_circuit  VARCHAR(100) NOT NULL,
    id_ville     INT REFERENCES Ville(id_ville)
);

CREATE TABLE Evenement (
    id_evenement   SERIAL PRIMARY KEY,
    nom_evenement  VARCHAR(100) NOT NULL,
    date_evenement DATE         NOT NULL,
    id_circuit     INT REFERENCES Circuit(id_circuit)
);

CREATE TABLE Course (
    id_course    SERIAL PRIMARY KEY,
    nom_course   VARCHAR(100) NOT NULL,
    date_course  DATE         NOT NULL,
    id_evenement INT REFERENCES Evenement(id_evenement)
);

CREATE TABLE Pari (
    id_pari    SERIAL PRIMARY KEY,
    id_user    INT            REFERENCES Utilisateur(id_user),
    id_course  INT            REFERENCES Course(id_course),
    id_pilote  INT            REFERENCES Pilote(id_pilote),
    montant    NUMERIC(10,2)  NOT NULL,
    resultat   VARCHAR(20)    DEFAULT 'en attente'
);
