-- ============================================================
-- DDL - Data Definition Language
-- Centre Sportif - Gestion de Terrains & Reservations
-- #300150293
-- ============================================================
 
-- Connexion a PostgreSQL et creation de la base
-- psql -U postgres
-- CREATE DATABASE centre_sportif;
-- \c centre_sportif
 
-- ------------------------------------------------------------
-- Creation du schema
-- ------------------------------------------------------------
DROP SCHEMA IF EXISTS centre_sportif CASCADE;
CREATE SCHEMA centre_sportif;
 
-- ------------------------------------------------------------
-- Table : Client
-- ------------------------------------------------------------
CREATE TABLE centre_sportif.Client (
    id_client        SERIAL PRIMARY KEY,
    nom              TEXT NOT NULL,
    prenom           TEXT NOT NULL,
    telephone        TEXT,
    email            TEXT,
    date_inscription DATE,
    statut           TEXT
);
 
-- ------------------------------------------------------------
-- Table : Centre
-- ------------------------------------------------------------
CREATE TABLE centre_sportif.Centre (
    id_centre  SERIAL PRIMARY KEY,
    nom_centre TEXT NOT NULL,
    adresse    TEXT NOT NULL,
    ville      TEXT NOT NULL,
    telephone  TEXT,
    email      TEXT
);
 
-- ------------------------------------------------------------
-- Table : Employe
-- ------------------------------------------------------------
CREATE TABLE centre_sportif.Employe (
    id_employe SERIAL PRIMARY KEY,
    id_centre  INT  NOT NULL REFERENCES centre_sportif.Centre(id_centre),
    nom        TEXT NOT NULL,
    prenom     TEXT NOT NULL,
    role       TEXT,
    telephone  TEXT,
    email      TEXT
);
 
-- ------------------------------------------------------------
-- Table : Disponibilite
-- ------------------------------------------------------------
CREATE TABLE centre_sportif.Disponibilite (
    id_disponibilite SERIAL PRIMARY KEY,
    id_centre        INT  NOT NULL REFERENCES centre_sportif.Centre(id_centre),
    jour_semaine     TEXT NOT NULL,
    heure_ouverture  TIME NOT NULL,
    heure_fermeture  TIME NOT NULL
);
 
-- ------------------------------------------------------------
-- Table : Terrain
-- ------------------------------------------------------------
CREATE TABLE centre_sportif.Terrain (
    id_terrain    SERIAL PRIMARY KEY,
    id_centre     INT           NOT NULL REFERENCES centre_sportif.Centre(id_centre),
    nom_terrain   TEXT          NOT NULL,
    type_surface  TEXT,
    taille        TEXT,
    tarif_horaire NUMERIC(10,2) NOT NULL,
    eclairage     BOOLEAN DEFAULT FALSE,
    statut        TEXT NOT NULL
);
 
-- ------------------------------------------------------------
-- Table : Creneau
-- ------------------------------------------------------------
CREATE TABLE centre_sportif.Creneau (
    id_creneau   SERIAL PRIMARY KEY,
    id_terrain   INT  NOT NULL REFERENCES centre_sportif.Terrain(id_terrain),
    date_creneau DATE NOT NULL,
    heure_debut  TIME NOT NULL,
    heure_fin    TIME NOT NULL,
    statut       TEXT NOT NULL
);
 
-- ------------------------------------------------------------
-- Table : Reservation
-- ------------------------------------------------------------
CREATE TABLE centre_sportif.Reservation (
    id_reservation     SERIAL PRIMARY KEY,
    id_client          INT           NOT NULL REFERENCES centre_sportif.Client(id_client),
    id_creneau         INT           NOT NULL REFERENCES centre_sportif.Creneau(id_creneau),
    date_reservation   TIMESTAMP     NOT NULL,
    statut_reservation TEXT          NOT NULL,
    nb_joueurs         INT,
    montant_total      NUMERIC(10,2)
);
 
-- ------------------------------------------------------------
-- Table : Paiement
-- ------------------------------------------------------------
CREATE TABLE centre_sportif.Paiement (
    id_paiement           SERIAL PRIMARY KEY,
    id_reservation        INT           NOT NULL REFERENCES centre_sportif.Reservation(id_reservation),
    date_paiement         TIMESTAMP     NOT NULL,
    montant               NUMERIC(10,2) NOT NULL,
    mode_paiement         TEXT          NOT NULL,
    statut_paiement       TEXT          NOT NULL,
    reference_transaction TEXT
);
 
-- ------------------------------------------------------------
-- Table : Promotion
-- ------------------------------------------------------------
CREATE TABLE centre_sportif.Promotion (
    id_promotion SERIAL PRIMARY KEY,
    code         TEXT          NOT NULL UNIQUE,
    type_remise  TEXT          NOT NULL,
    valeur       NUMERIC(10,2) NOT NULL,
    date_debut   DATE          NOT NULL,
    date_fin     DATE          NOT NULL,
    actif        BOOLEAN DEFAULT TRUE
);
 
-- ------------------------------------------------------------
-- Table : Reservation_Promotion
-- ------------------------------------------------------------
CREATE TABLE centre_sportif.Reservation_Promotion (
    id_reservation INT NOT NULL REFERENCES centre_sportif.Reservation(id_reservation),
    id_promotion   INT NOT NULL REFERENCES centre_sportif.Promotion(id_promotion),
    PRIMARY KEY (id_reservation, id_promotion)
);
 
-- ------------------------------------------------------------
-- Table : Equipe
-- ------------------------------------------------------------
CREATE TABLE centre_sportif.Equipe (
    id_equipe     SERIAL PRIMARY KEY,
    id_client     INT  NOT NULL REFERENCES centre_sportif.Client(id_client),
    nom_equipe    TEXT NOT NULL,
    niveau        TEXT,
    date_creation DATE
);
 
-- ------------------------------------------------------------
-- Table : Joueur
-- ------------------------------------------------------------
CREATE TABLE centre_sportif.Joueur (
    id_joueur SERIAL PRIMARY KEY,
    nom       TEXT NOT NULL,
    prenom    TEXT NOT NULL,
    telephone TEXT,
    email     TEXT
);
 
-- ------------------------------------------------------------
-- Table : Equipe_Joueur
-- ------------------------------------------------------------
CREATE TABLE centre_sportif.Equipe_Joueur (
    id_equipe  INT  NOT NULL REFERENCES centre_sportif.Equipe(id_equipe),
    id_joueur  INT  NOT NULL REFERENCES centre_sportif.Joueur(id_joueur),
    role       TEXT,
    date_ajout DATE,
    PRIMARY KEY (id_equipe, id_joueur)
);
 
-- ------------------------------------------------------------
-- Table : Match
-- ------------------------------------------------------------
CREATE TABLE centre_sportif.Match (
    id_match           SERIAL PRIMARY KEY,
    id_reservation     INT  NOT NULL REFERENCES centre_sportif.Reservation(id_reservation),
    id_equipe_local    INT  NOT NULL REFERENCES centre_sportif.Equipe(id_equipe),
    id_equipe_visiteur INT  NOT NULL REFERENCES centre_sportif.Equipe(id_equipe),
    score_local        INT  DEFAULT 0,
    score_visiteur     INT  DEFAULT 0,
    statut_match       TEXT NOT NULL
);
 
-- ------------------------------------------------------------
-- Table : Avis
-- ------------------------------------------------------------
CREATE TABLE centre_sportif.Avis (
    id_avis     SERIAL PRIMARY KEY,
    id_client   INT  NOT NULL REFERENCES centre_sportif.Client(id_client),
    id_terrain  INT  NOT NULL REFERENCES centre_sportif.Terrain(id_terrain),
    note        INT  CHECK (note BETWEEN 1 AND 5),
    commentaire TEXT,
    date_avis   DATE NOT NULL
);