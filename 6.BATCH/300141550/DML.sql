INSERT INTO CLIENT (nom, prenom, email)
VALUES 
('Emeraude', 'Santu', 'emeraude@email.com'),
('Alice', 'Doe', 'alice@email.com');

INSERT INTO COMMANDE (id_client, date_commande, total_commande)
VALUES 
(1, CURRENT_DATE, 25.50),
(2, CURRENT_DATE, 40.00);
