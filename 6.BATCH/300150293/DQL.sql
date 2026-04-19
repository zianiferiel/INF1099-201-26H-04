-- ============================================================
-- DQL - Data Query Language
-- Centre Sportif - Gestion de Terrains & Reservations
-- #300150293
-- Prerequis : DDL.sql et DML.sql doivent avoir ete executes
-- ============================================================
 
-- ------------------------------------------------------------
-- SELECT - Requetes de lecture
-- ------------------------------------------------------------
 
-- 1. Liste de tous les clients
SELECT * FROM centre_sportif.Client;
 
-- 2. Liste de tous les terrains avec leur centre
SELECT
    t.id_terrain,
    t.nom_terrain,
    t.type_surface,
    t.taille,
    t.tarif_horaire,
    t.eclairage,
    t.statut,
    c.nom_centre,
    c.ville
FROM centre_sportif.Terrain t
JOIN centre_sportif.Centre c ON t.id_centre = c.id_centre;
 
-- 3. Liste des reservations avec client, terrain et creneau
SELECT
    r.id_reservation,
    c.nom              AS Client,
    t.nom_terrain      AS Terrain,
    cr.date_creneau,
    cr.heure_debut,
    cr.heure_fin,
    r.statut_reservation,
    r.montant_total
FROM centre_sportif.Reservation r
JOIN centre_sportif.Client  c  ON r.id_client   = c.id_client
JOIN centre_sportif.Creneau cr ON r.id_creneau  = cr.id_creneau
JOIN centre_sportif.Terrain t  ON cr.id_terrain = t.id_terrain;
 
-- 4. Liste des paiements avec le client associe
SELECT
    p.id_paiement,
    c.nom             AS Client,
    p.date_paiement,
    p.montant,
    p.mode_paiement,
    p.statut_paiement,
    p.reference_transaction
FROM centre_sportif.Paiement p
JOIN centre_sportif.Reservation r ON p.id_reservation = r.id_reservation
JOIN centre_sportif.Client      c ON r.id_client       = c.id_client;
 
-- 5. Liste des creneaux disponibles
SELECT
    cr.id_creneau,
    t.nom_terrain,
    cr.date_creneau,
    cr.heure_debut,
    cr.heure_fin,
    cr.statut
FROM centre_sportif.Creneau cr
JOIN centre_sportif.Terrain t ON cr.id_terrain = t.id_terrain
WHERE cr.statut = 'Disponible';
 
-- 6. Liste des equipes avec leur createur
SELECT
    e.id_equipe,
    e.nom_equipe,
    e.niveau,
    e.date_creation,
    c.nom    AS Proprietaire,
    c.prenom AS Prenom
FROM centre_sportif.Equipe e
JOIN centre_sportif.Client c ON e.id_client = c.id_client;
 
-- 7. Liste des joueurs par equipe
SELECT
    e.nom_equipe,
    j.nom        AS Joueur,
    j.prenom,
    ej.role,
    ej.date_ajout
FROM centre_sportif.Equipe_Joueur ej
JOIN centre_sportif.Equipe  e ON ej.id_equipe = e.id_equipe
JOIN centre_sportif.Joueur  j ON ej.id_joueur = j.id_joueur
ORDER BY e.nom_equipe;
 
-- 8. Liste des matchs avec les equipes et scores
SELECT
    m.id_match,
    el.nom_equipe  AS Equipe_Locale,
    ev.nom_equipe  AS Equipe_Visiteuse,
    m.score_local,
    m.score_visiteur,
    m.statut_match
FROM centre_sportif.Match m
JOIN centre_sportif.Equipe el ON m.id_equipe_local    = el.id_equipe
JOIN centre_sportif.Equipe ev ON m.id_equipe_visiteur = ev.id_equipe;
 
-- 9. Liste des avis avec client et terrain
SELECT
    a.id_avis,
    c.nom          AS Client,
    t.nom_terrain  AS Terrain,
    a.note,
    a.commentaire,
    a.date_avis
FROM centre_sportif.Avis a
JOIN centre_sportif.Client  c ON a.id_client  = c.id_client
JOIN centre_sportif.Terrain t ON a.id_terrain = t.id_terrain
ORDER BY a.note DESC;
 
-- 10. Moyenne des notes par terrain
SELECT
    t.nom_terrain,
    ROUND(AVG(a.note), 2) AS Note_Moyenne,
    COUNT(a.id_avis)      AS Nombre_Avis
FROM centre_sportif.Avis a
JOIN centre_sportif.Terrain t ON a.id_terrain = t.id_terrain
GROUP BY t.nom_terrain
ORDER BY Note_Moyenne DESC;
 
-- 11. Revenus totaux par terrain
SELECT
    t.nom_terrain,
    SUM(r.montant_total) AS Revenus_Total
FROM centre_sportif.Reservation r
JOIN centre_sportif.Creneau cr ON r.id_creneau  = cr.id_creneau
JOIN centre_sportif.Terrain t  ON cr.id_terrain = t.id_terrain
GROUP BY t.nom_terrain
ORDER BY Revenus_Total DESC;
 
-- 12. Promotions actives
SELECT
    id_promotion,
    code,
    type_remise,
    valeur,
    date_debut,
    date_fin
FROM centre_sportif.Promotion
WHERE actif = TRUE;