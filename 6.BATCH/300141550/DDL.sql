CREATE TABLE CLIENT (
    id_client SERIAL PRIMARY KEY,
    nom VARCHAR(50),
    prenom VARCHAR(50),
    email VARCHAR(100) UNIQUE
);

CREATE TABLE COMMANDE (
    id_commande SERIAL PRIMARY KEY,
    id_client INT,
    date_commande DATE,
    total_commande DECIMAL(10,2),
    FOREIGN KEY (id_client) REFERENCES CLIENT(id_client)
);
