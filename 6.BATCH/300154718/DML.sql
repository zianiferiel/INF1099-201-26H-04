-- ============================================================
-- DML.sql - Insertion des donnees
-- Cours : INF1099 | Domaine : AeroVoyage (Compagnie Aerienne)
-- SGBD : PostgreSQL
-- ============================================================

INSERT INTO PASSAGER (nom, prenom, telephone, email, numero_passeport) VALUES
('Tremblay',  'Marie',   '514-555-0101', 'marie.tremblay@email.com',  'CA123456'),
('Nguyen',    'Linh',    '438-555-0202', 'linh.nguyen@email.com',     'CA234567'),
('Okonkwo',   'Chidi',   '514-555-0303', 'chidi.okonkwo@email.com',   'CA345678'),
('Bouchard',  'Pierre',  '450-555-0404', 'pierre.bouchard@email.com', 'CA456789'),
('Martinez',  'Sofia',   '514-555-0505', 'sofia.martinez@email.com',  'CA567890');

INSERT INTO ADRESSE (passager_id, numero_rue, rue, ville, province, code_postal, pays) VALUES
(1, '120', 'Rue Sherbrooke',      'Montreal', 'Quebec', 'H3A 1B1', 'Canada'),
(2, '45',  'Boul. Saint-Laurent', 'Montreal', 'Quebec', 'H2W 1Y3', 'Canada'),
(3, '88',  'Ave. du Parc',        'Montreal', 'Quebec', 'H2V 4G3', 'Canada'),
(4, '200', 'Rue King',            'Quebec',   'Quebec', 'G1K 2N9', 'Canada'),
(5, '12',  'Rue Wellington',      'Verdun',   'Quebec', 'H4G 1T8', 'Canada');

INSERT INTO COMPAGNIE (nom_compagnie, code_iata, telephone) VALUES
('Air Canada',  'AC', '1-888-247-2262'),
('Air Transat', 'TS', '1-877-872-6728'),
('WestJet',     'WS', '1-888-937-8538');

INSERT INTO AEROPORT (nom_aeroport, code_iata, ville, pays) VALUES
('Aeroport international Pierre-Elliott-Trudeau', 'YUL', 'Montreal', 'Canada'),
('Aeroport international Lester B. Pearson',      'YYZ', 'Toronto',  'Canada'),
('Aeroport international Jean-Lesage',            'YQB', 'Quebec',   'Canada'),
('Aeroport Charles de Gaulle',                    'CDG', 'Paris',    'France');

INSERT INTO PORTE (aeroport_id, numero_porte, terminal) VALUES
(1, 'A12', 'A'),
(1, 'B03', 'B'),
(2, 'C21', 'C'),
(3, 'A01', 'A'),
(4, 'F44', 'F');

INSERT INTO AVION (compagnie_id, modele, capacite, immatriculation) VALUES
(1, 'Boeing 737-800',  189, 'C-FZUB'),
(1, 'Airbus A320',     150, 'C-FDCA'),
(2, 'Airbus A330-200', 345, 'C-GTSY');

INSERT INTO VOL (numero_vol, date_vol, heure_depart, heure_arrivee, statut_vol, avion_id, aeroport_depart_id, aeroport_arrivee_id, porte_depart_id) VALUES
('AC801', '2025-06-15', '07:30', '09:00', 'Planifie', 1, 1, 2, 1),
('AC802', '2025-06-15', '14:00', '15:30', 'Planifie', 2, 2, 1, 3),
('TS101', '2025-06-20', '22:00', '11:30', 'Planifie', 3, 1, 4, 2),
('AC205', '2025-06-18', '09:15', '10:30', 'Planifie', 1, 1, 3, 1);

INSERT INTO RESERVATION (passager_id, date_reservation, statut_reservation) VALUES
(1, '2025-05-01', 'Confirmee'),
(2, '2025-05-03', 'Confirmee'),
(3, '2025-05-10', 'Confirmee'),
(4, '2025-05-12', 'Annulee'),
(5, '2025-05-15', 'Confirmee');

INSERT INTO PAIEMENT (reservation_id, date_paiement, montant, mode_paiement, statut_paiement) VALUES
(1, '2025-05-01', 389.99,  'Carte de credit', 'Paye'),
(2, '2025-05-03', 415.00,  'Carte de debit',  'Paye'),
(3, '2025-05-10', 1250.50, 'Carte de credit', 'Paye'),
(4, '2025-05-12', 389.99,  'PayPal',          'Rembourse'),
(5, '2025-05-15', 520.00,  'Carte de credit', 'Paye');

INSERT INTO BILLET (reservation_id, vol_id, numero_billet, classe, siege) VALUES
(1, 1, 'BLT-001-2025', 'Economique', '14A'),
(2, 2, 'BLT-002-2025', 'Economique', '22C'),
(3, 3, 'BLT-003-2025', 'Affaires',   '3B'),
(4, 4, 'BLT-004-2025', 'Economique', '31F'),
(5, 1, 'BLT-005-2025', 'Premium',    '7A');

INSERT INTO BAGAGE (billet_id, numero_bagage, poids_kg, type_bagage) VALUES
(1, 'BAG-00101', 22.5, 'Enregistre'),
(1, 'BAG-00102',  7.0, 'Cabine'),
(2, 'BAG-00201', 19.0, 'Enregistre'),
(3, 'BAG-00301', 25.0, 'Enregistre'),
(3, 'BAG-00302', 10.0, 'Cabine'),
(5, 'BAG-00501', 20.0, 'Enregistre');
