-- ============================================================
-- DDL.sql - Definition des tables
-- Cours : INF1099 | Domaine : AeroVoyage (Compagnie Aerienne)
-- SGBD : PostgreSQL
-- ============================================================

-- Supprimer les tables si elles existent deja (ordre inverse des FK)
DROP TABLE IF EXISTS BAGAGE;
DROP TABLE IF EXISTS BILLET;
DROP TABLE IF EXISTS PAIEMENT;
DROP TABLE IF EXISTS RESERVATION;
DROP TABLE IF EXISTS ADRESSE;
DROP TABLE IF EXISTS VOL;
DROP TABLE IF EXISTS PORTE;
DROP TABLE IF EXISTS AVION;
DROP TABLE IF EXISTS AEROPORT;
DROP TABLE IF EXISTS COMPAGNIE;
DROP TABLE IF EXISTS PASSAGER;

CREATE TABLE PASSAGER (
    id               SERIAL       PRIMARY KEY,
    nom              VARCHAR(100) NOT NULL,
    prenom           VARCHAR(100) NOT NULL,
    telephone        VARCHAR(20),
    email            VARCHAR(150) NOT NULL UNIQUE,
    numero_passeport VARCHAR(20)  NOT NULL UNIQUE
);

CREATE TABLE ADRESSE (
    id           SERIAL       PRIMARY KEY,
    passager_id  INT          NOT NULL REFERENCES PASSAGER(id),
    numero_rue   VARCHAR(10),
    rue          VARCHAR(150),
    ville        VARCHAR(100),
    province     VARCHAR(100),
    code_postal  VARCHAR(10),
    pays         VARCHAR(100)
);

CREATE TABLE COMPAGNIE (
    id             SERIAL       PRIMARY KEY,
    nom_compagnie  VARCHAR(150) NOT NULL,
    code_iata      VARCHAR(3)   NOT NULL UNIQUE,
    telephone      VARCHAR(20)
);

CREATE TABLE AEROPORT (
    id             SERIAL       PRIMARY KEY,
    nom_aeroport   VARCHAR(200) NOT NULL,
    code_iata      VARCHAR(3)   NOT NULL UNIQUE,
    ville          VARCHAR(100),
    pays           VARCHAR(100)
);

CREATE TABLE PORTE (
    id           SERIAL      PRIMARY KEY,
    aeroport_id  INT         NOT NULL REFERENCES AEROPORT(id),
    numero_porte VARCHAR(10) NOT NULL,
    terminal     VARCHAR(10)
);

CREATE TABLE AVION (
    id              SERIAL       PRIMARY KEY,
    compagnie_id    INT          NOT NULL REFERENCES COMPAGNIE(id),
    modele          VARCHAR(100) NOT NULL,
    capacite        INT          NOT NULL,
    immatriculation VARCHAR(20)  NOT NULL UNIQUE
);

CREATE TABLE VOL (
    id                  SERIAL       PRIMARY KEY,
    numero_vol          VARCHAR(20)  NOT NULL UNIQUE,
    date_vol            DATE         NOT NULL,
    heure_depart        VARCHAR(5)   NOT NULL,
    heure_arrivee       VARCHAR(5)   NOT NULL,
    statut_vol          VARCHAR(30)  NOT NULL DEFAULT 'Planifie',
    avion_id            INT          NOT NULL REFERENCES AVION(id),
    aeroport_depart_id  INT          NOT NULL REFERENCES AEROPORT(id),
    aeroport_arrivee_id INT          NOT NULL REFERENCES AEROPORT(id),
    porte_depart_id     INT          REFERENCES PORTE(id)
);

CREATE TABLE RESERVATION (
    id                 SERIAL      PRIMARY KEY,
    passager_id        INT         NOT NULL REFERENCES PASSAGER(id),
    date_reservation   DATE        NOT NULL,
    statut_reservation VARCHAR(30) NOT NULL DEFAULT 'Confirmee'
);

CREATE TABLE PAIEMENT (
    id              SERIAL         PRIMARY KEY,
    reservation_id  INT            NOT NULL REFERENCES RESERVATION(id),
    date_paiement   DATE           NOT NULL,
    montant         DECIMAL(10,2)  NOT NULL,
    mode_paiement   VARCHAR(50),
    statut_paiement VARCHAR(30)    NOT NULL DEFAULT 'En attente'
);

CREATE TABLE BILLET (
    id             SERIAL       PRIMARY KEY,
    reservation_id INT          NOT NULL REFERENCES RESERVATION(id),
    vol_id         INT          NOT NULL REFERENCES VOL(id),
    numero_billet  VARCHAR(20)  NOT NULL UNIQUE,
    classe         VARCHAR(20)  NOT NULL DEFAULT 'Economique',
    siege          VARCHAR(5)
);

CREATE TABLE BAGAGE (
    id            SERIAL        PRIMARY KEY,
    billet_id     INT           NOT NULL REFERENCES BILLET(id),
    numero_bagage VARCHAR(20)   NOT NULL UNIQUE,
    poids_kg      DECIMAL(5,2)  NOT NULL,
    type_bagage   VARCHAR(30)   NOT NULL DEFAULT 'Cabine'
);
