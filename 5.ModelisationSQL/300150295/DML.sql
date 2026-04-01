-- ============================================================
--  DML.sql — Insertion des données BetFormula
--  TP Modélisation SQL | INF1099 | Étudiant : 300150295
-- ============================================================

INSERT INTO Ville (nom_ville, code_postal) VALUES
('Monaco',     '98000'),
('Montréal',   'H3A 0G4'),
('Silverstone', 'NN12 8TJ');

INSERT INTO Sponsor (nom_sponsor) VALUES
('Red Bull'),
('Mercedes'),
('Ferrari');

INSERT INTO Equipe (nom_equipe, id_sponsor) VALUES
('Red Bull Racing', 1),
('Mercedes AMG',    2),
('Scuderia Ferrari',3);

INSERT INTO Pilote (nom_pilote, id_equipe) VALUES
('Max Verstappen', 1),
('Lewis Hamilton',  2),
('Charles Leclerc', 3);

INSERT INTO Utilisateur (nom, email, id_ville) VALUES
('Alice Tremblay', 'alice@betformula.com', 2),
('Bob Martin',     'bob@betformula.com',   1),
('Charlie Dupont', 'charlie@betformula.com',3);

INSERT INTO Circuit (nom_circuit, id_ville) VALUES
('Circuit de Monaco',      1),
('Circuit Gilles Villeneuve', 2),
('Circuit de Silverstone', 3);

INSERT INTO Evenement (nom_evenement, date_evenement, id_circuit) VALUES
('Grand Prix de Monaco',   '2025-05-25', 1),
('Grand Prix du Canada',   '2025-06-15', 2),
('Grand Prix de Grande-Bretagne', '2025-07-06', 3);

INSERT INTO Course (nom_course, date_course, id_evenement) VALUES
('Course Monaco 2025',      '2025-05-25', 1),
('Course Canada 2025',      '2025-06-15', 2),
('Course Silverstone 2025', '2025-07-06', 3);

INSERT INTO Pari (id_user, id_course, id_pilote, montant, resultat) VALUES
(1, 1, 1, 50.00,  'gagne'),
(2, 1, 2, 100.00, 'perdu'),
(3, 2, 3, 75.00,  'en attente'),
(1, 3, 1, 200.00, 'en attente');
