-- ============================================================
-- DQL.sql - Requetes de consultation
-- Cours : INF1099 | Domaine : AeroVoyage (Compagnie Aerienne)
-- SGBD : PostgreSQL
-- ============================================================

-- Requete 1 : Tous les passagers avec leur ville
SELECT
    p.id,
    p.nom,
    p.prenom,
    p.email,
    a.ville,
    a.province,
    a.pays
FROM PASSAGER p
JOIN ADRESSE a ON a.passager_id = p.id;

-- Requete 2 : Tous les billets avec passager, vol et compagnie
SELECT
    b.numero_billet,
    CONCAT(p.prenom, ' ', p.nom) AS passager,
    v.numero_vol,
    v.date_vol,
    b.classe,
    b.siege,
    c.nom_compagnie
FROM BILLET b
JOIN RESERVATION r ON r.id  = b.reservation_id
JOIN PASSAGER p    ON p.id  = r.passager_id
JOIN VOL v         ON v.id  = b.vol_id
JOIN AVION av      ON av.id = v.avion_id
JOIN COMPAGNIE c   ON c.id  = av.compagnie_id;

-- Requete 3 : Reservations confirmees uniquement
SELECT
    r.id AS id_reservation,
    CONCAT(p.prenom, ' ', p.nom) AS passager,
    r.date_reservation,
    r.statut_reservation
FROM RESERVATION r
JOIN PASSAGER p ON p.id = r.passager_id
WHERE r.statut_reservation = 'Confirmee';

-- Requete 4 : Total paye par passager
SELECT
    CONCAT(p.prenom, ' ', p.nom) AS passager,
    SUM(pa.montant)              AS total_paye,
    COUNT(pa.id)                 AS nb_paiements
FROM PAIEMENT pa
JOIN RESERVATION r ON r.id = pa.reservation_id
JOIN PASSAGER p    ON p.id = r.passager_id
WHERE pa.statut_paiement = 'Paye'
GROUP BY p.id, p.nom, p.prenom
ORDER BY total_paye DESC;

-- Requete 5 : Vols avec aeroports et porte
SELECT
    v.numero_vol,
    v.date_vol,
    v.heure_depart,
    v.heure_arrivee,
    v.statut_vol,
    dep.nom_aeroport AS depart,
    dep.code_iata    AS code_dep,
    arr.nom_aeroport AS arrivee,
    arr.code_iata    AS code_arr,
    pt.numero_porte  AS porte,
    pt.terminal
FROM VOL v
JOIN AEROPORT dep ON dep.id = v.aeroport_depart_id
JOIN AEROPORT arr ON arr.id = v.aeroport_arrivee_id
LEFT JOIN PORTE pt ON pt.id = v.porte_depart_id;
