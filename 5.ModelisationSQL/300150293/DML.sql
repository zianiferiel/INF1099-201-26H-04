

-- ============================================================
-- DML - Data Manipulation Language
-- Centre Sportif — Gestion de Terrains & Réservations
-- #300150293
-- Prérequis : DDL.sql doit avoir été exécuté
-- ============================================================
 
-- ------------------------------------------------------------
-- INSERT — Insertion des données
-- ------------------------------------------------------------
 
-- Centres sportifs
INSERT INTO centre_sportif.Centre (nom_centre, adresse, ville, telephone, email) VALUES
    ('Centre Sportif Laval', '100 Boul. des Sports', 'Laval',    '450-111-2222', 'laval@sport.com'),
    ('Arena Montreal Est',   '55 Rue Sherbrooke E',  'Montreal', '514-333-4444', 'mtl@sport.com');
 
-- Employés
INSERT INTO centre_sportif.Employe (id_centre, nom, prenom, role, telephone, email) VALUES
    (1, 'Bergeron', 'Julie', 'Receptionniste', '450-555-0001', 'julie@sport.com'),
    (2, 'Leblanc',  'Marc',  'Gerant',         '514-555-0002', 'marc@sport.com');
 
-- Disponibilités
INSERT INTO centre_sportif.Disponibilite (id_centre, jour_semaine, heure_ouverture, heure_fermeture) VALUES
    (1, 'Lundi',  '08:00', '22:00'),
    (1, 'Samedi', '09:00', '21:00'),
    (2, 'Lundi',  '07:00', '23:00');
 
-- Terrains
INSERT INTO centre_sportif.Terrain (id_centre, nom_terrain, type_surface, taille, tarif_horaire, eclairage, statut) VALUES
    (1, 'Terrain A1', 'Gazon synthetique', '40x20', 80.00, TRUE,  'Disponible'),
    (1, 'Terrain A2', 'Beton',             '30x15', 50.00, FALSE, 'Disponible'),
    (2, 'Terrain B1', 'Parquet',           '28x15', 70.00, TRUE,  'Disponible');
 
-- Clients
INSERT INTO centre_sportif.Client (nom, prenom, telephone, email, date_inscription, statut) VALUES
    ('Dupont', 'Karim', '514-222-3333', 'karim@email.com', '2024-01-15', 'Actif'),
    ('Ndiaye', 'Fatou', '438-444-5555', 'fatou@email.com', '2024-02-20', 'Actif');
 
-- Créneaux
INSERT INTO centre_sportif.Creneau (id_terrain, date_creneau, heure_debut, heure_fin, statut) VALUES
    (1, '2024-04-10', '18:00', '19:00', 'Disponible'),
    (1, '2024-04-10', '19:00', '20:00', 'Disponible'),
    (2, '2024-04-11', '10:00', '11:00', 'Disponible');
 
-- Réservations
INSERT INTO centre_sportif.Reservation (id_client, id_creneau, date_reservation, statut_reservation, nb_joueurs, montant_total) VALUES
    (1, 1, '2024-04-08 14:30:00', 'Confirmee', 10, 80.00),
    (2, 3, '2024-04-09 10:00:00', 'Confirmee',  6, 50.00);
 
-- Paiements
INSERT INTO centre_sportif.Paiement (id_reservation, date_paiement, montant, mode_paiement, statut_paiement, reference_transaction) VALUES
    (1, '2024-04-08 14:35:00', 80.00, 'Carte credit', 'Paye', 'TXN-001-2024'),
    (2, '2024-04-09 10:05:00', 50.00, 'Comptant',     'Paye', 'TXN-002-2024');
 
-- Promotions
INSERT INTO centre_sportif.Promotion (code, type_remise, valeur, date_debut, date_fin, actif) VALUES
    ('PROMO10',   'Pourcentage', 10.00, '2024-04-01', '2024-04-30', TRUE),
    ('BIENVENUE', 'Montant fixe', 15.00, '2024-01-01', '2024-12-31', TRUE);
 
-- Réservation - Promotion
INSERT INTO centre_sportif.Reservation_Promotion (id_reservation, id_promotion) VALUES
    (1, 1);
 
-- Équipes
INSERT INTO centre_sportif.Equipe (id_client, nom_equipe, niveau, date_creation) VALUES
    (1, 'Les Aigles', 'Intermediaire', '2024-03-01'),
    (2, 'Star FC',    'Debutant',      '2024-03-10');
 
-- Joueurs
INSERT INTO centre_sportif.Joueur (nom, prenom, telephone, email) VALUES
    ('Benali', 'Omar',  '514-700-0001', 'omar@email.com'),
    ('Cote',   'Emile', '514-700-0002', 'emile@email.com'),
    ('Traore', 'Awa',   '514-700-0003', 'awa@email.com');
 
-- Équipe - Joueurs
INSERT INTO centre_sportif.Equipe_Joueur (id_equipe, id_joueur, role, date_ajout) VALUES
    (1, 1, 'Capitaine', '2024-03-01'),
    (1, 2, 'Joueur',    '2024-03-01'),
    (2, 3, 'Capitaine', '2024-03-10');
 
-- Match
INSERT INTO centre_sportif.Match (id_reservation, id_equipe_local, id_equipe_visiteur, score_local, score_visiteur, statut_match) VALUES
    (1, 1, 2, 3, 1, 'Termine');
 
-- Avis
INSERT INTO centre_sportif.Avis (id_client, id_terrain, note, commentaire, date_avis) VALUES
    (1, 1, 5, 'Excellent terrain, bien entretenu et eclaire.', '2024-04-11'),
    (2, 2, 3, 'Terrain correct mais manque eclairage.',        '2024-04-12');
 
-- ------------------------------------------------------------
-- UPDATE — Modification des données
-- ------------------------------------------------------------
 
-- Mettre à jour le statut du créneau 1
UPDATE centre_sportif.Creneau
SET statut = 'Reserve'
WHERE id_creneau = 1;
 
-- Mettre à jour le tarif du terrain 1
UPDATE centre_sportif.Terrain
SET tarif_horaire = 90.00
WHERE id_terrain = 1;
 
-- ------------------------------------------------------------
-- DELETE — Suppression des données
-- ------------------------------------------------------------
 
-- Supprimer l'avis 2
DELETE FROM centre_sportif.Avis
WHERE id_avis = 2;