SELECT * FROM CLIENT;

SELECT c.nom, co.total_commande
FROM CLIENT c
JOIN COMMANDE co ON c.id_client = co.id_client;
