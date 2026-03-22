-- =============================================================
--  DQL.sql — Plateforme éducative pour enfants
--  Auteure   : Ramatoulaye Diallo — 300153476
--  Cours     : INF1099
--  SGBD      : PostgreSQL
--  Rôle      : Interrogation des données (SELECT)
--  Date      : 2026-03-18
-- =============================================================
-- DQL = Data Query Language
--   SELECT   → lire et filtrer les données
--   JOIN     → combiner plusieurs tables
--   GROUP BY → regrouper et agréger
--   HAVING   → filtrer sur les agrégats
--   ORDER BY → trier les résultats
--   Sous-requêtes, vues, fonctions de fenêtre
-- =============================================================


-- =============================================================
-- BLOC 1 — REQUÊTES SIMPLES (SELECT de base)
-- =============================================================

-- 1.1 Liste complète de tous les enfants inscrits sur la plateforme
SELECT  id_enfant,
        Prenom || ' ' || Nom   AS Nom_complet,
        Age,
        Niveau
FROM    Enfant
ORDER BY Nom, Prenom;


-- 1.2 Tous les cours disponibles avec le nom du professeur responsable
SELECT  c.id_cours,
        c.Titre_cours,
        c.Langue,
        c.Niveau,
        p.Prenom || ' ' || p.Nom  AS Professeur
FROM    Cours      c
JOIN    Professeur p ON c.id_prof = p.id_prof
ORDER BY c.Niveau, c.Titre_cours;


-- 1.3 Tous les devoirs avec leur date limite, triés du plus urgent au plus tardif
SELECT  d.id_devoir,
        d.Titre_devoir,
        c.Titre_cours,
        d.Date_limite
FROM    Devoir d
JOIN    Cours  c ON d.id_cours = c.id_cours
ORDER BY d.Date_limite ASC;


-- 1.4 Liste des parents avec le nombre d'enfants inscrits
SELECT  p.id_parent,
        p.Prenom || ' ' || p.Nom  AS Parent,
        p.Email,
        COUNT(e.id_enfant)         AS Nb_enfants
FROM    Parent p
LEFT JOIN Enfant e ON p.id_parent = e.id_parent
GROUP BY p.id_parent, p.Nom, p.Prenom, p.Email
ORDER BY Nb_enfants DESC;


-- 1.5 Ressources disponibles par cours (type et lien)
SELECT  c.Titre_cours,
        r.Type_ressource,
        r.Titre_ressource,
        r.URL_ressource
FROM    Ressource r
JOIN    Cours     c ON r.id_cours = c.id_cours
ORDER BY c.Titre_cours, r.Type_ressource;


-- =============================================================
-- BLOC 2 — REQUÊTES AVEC FILTRES (WHERE et conditions)
-- =============================================================

-- 2.1 Enfants de niveau secondaire ages de 13 ans et plus
SELECT  Prenom || ' ' || Nom  AS Nom_complet,
        Age,
        Niveau
FROM    Enfant
WHERE   Niveau = 'secondaire'
  AND   Age   >= 13
ORDER BY Age DESC;


-- 2.2 Cours enseignes en anglais
SELECT  id_cours,
        Titre_cours,
        Niveau
FROM    Cours
WHERE   Langue = 'Anglais'
ORDER BY Niveau;


-- 2.3 Inscriptions actives seulement
SELECT  i.id_inscription,
        e.Prenom || ' ' || e.Nom  AS Enfant,
        c.Titre_cours,
        i.Date_inscription,
        i.Statut_inscription
FROM    Inscription i
JOIN    Enfant      e ON i.id_enfant = e.id_enfant
JOIN    Cours       c ON i.id_cours  = c.id_cours
WHERE   i.Statut_inscription = 'actif'
ORDER BY i.Date_inscription;


-- 2.4 Notes inferieures a 80 (enfants en difficulte)
SELECT  e.Prenom || ' ' || e.Nom  AS Enfant,
        d.Titre_devoir,
        c.Titre_cours,
        n.Valeur                   AS Note,
        n.Commentaire
FROM    Note              n
JOIN    Soumission_Devoir sd ON n.id_soumission  = sd.id_soumission
JOIN    Enfant            e  ON sd.id_enfant      = e.id_enfant
JOIN    Devoir            d  ON sd.id_devoir      = d.id_devoir
JOIN    Cours             c  ON d.id_cours        = c.id_cours
WHERE   n.Valeur < 80
ORDER BY n.Valeur ASC;


-- 2.5 Sessions ChatIA de plus de 30 minutes (utilisation intensive)
SELECT  s.id_session_chat,
        e.Prenom || ' ' || e.Nom  AS Enfant,
        s.Sujet,
        s.Duree                    AS Duree_minutes,
        s.Date_session
FROM    Session_ChatIA s
JOIN    Enfant         e ON s.id_enfant = e.id_enfant
WHERE   s.Duree > 30
ORDER BY s.Duree DESC;


-- 2.6 Devoirs dont la date limite est dans les 7 prochains jours
SELECT  d.Titre_devoir,
        c.Titre_cours,
        d.Date_limite,
        (d.Date_limite - CURRENT_DATE)  AS Jours_restants
FROM    Devoir d
JOIN    Cours  c ON d.id_cours = c.id_cours
WHERE   d.Date_limite BETWEEN CURRENT_DATE
                          AND CURRENT_DATE + INTERVAL '7 days'
ORDER BY d.Date_limite;


-- =============================================================
-- BLOC 3 — AGREGATIONS (GROUP BY, HAVING, fonctions)
-- =============================================================

-- 3.1 Moyenne des notes par cours
SELECT  c.Titre_cours,
        COUNT(n.id_note)           AS Nb_evaluations,
        ROUND(AVG(n.Valeur), 2)    AS Moyenne_generale,
        MIN(n.Valeur)              AS Note_min,
        MAX(n.Valeur)              AS Note_max
FROM    Cours             c
JOIN    Devoir            d  ON c.id_cours       = d.id_cours
JOIN    Soumission_Devoir sd ON d.id_devoir       = sd.id_devoir
JOIN    Note              n  ON sd.id_soumission  = n.id_soumission
GROUP BY c.id_cours, c.Titre_cours
ORDER BY Moyenne_generale DESC;


-- 3.2 Enfants avec la meilleure moyenne generale (toutes soumissions notees)
SELECT  e.Prenom || ' ' || e.Nom  AS Enfant,
        e.Niveau,
        COUNT(n.id_note)           AS Nb_devoirs_notes,
        ROUND(AVG(n.Valeur), 2)    AS Moyenne_personnelle
FROM    Enfant            e
JOIN    Soumission_Devoir sd ON e.id_enfant       = sd.id_enfant
JOIN    Note              n  ON sd.id_soumission  = n.id_soumission
GROUP BY e.id_enfant, e.Nom, e.Prenom, e.Niveau
ORDER BY Moyenne_personnelle DESC;


-- 3.3 Cours avec plus de 3 inscrits actifs
SELECT  c.Titre_cours,
        COUNT(i.id_inscription)  AS Nb_inscrits_actifs
FROM    Cours       c
JOIN    Inscription i ON c.id_cours = i.id_cours
WHERE   i.Statut_inscription = 'actif'
GROUP BY c.id_cours, c.Titre_cours
HAVING  COUNT(i.id_inscription) > 3
ORDER BY Nb_inscrits_actifs DESC;


-- 3.4 Nombre de sessions ChatIA et duree totale par enfant
SELECT  e.Prenom || ' ' || e.Nom  AS Enfant,
        COUNT(s.id_session_chat)   AS Nb_sessions,
        SUM(s.Duree)               AS Duree_totale_min,
        ROUND(AVG(s.Duree), 1)     AS Duree_moyenne_min
FROM    Enfant         e
JOIN    Session_ChatIA s ON e.id_enfant = s.id_enfant
GROUP BY e.id_enfant, e.Nom, e.Prenom
ORDER BY Duree_totale_min DESC;


-- 3.5 Nombre de recompenses par enfant et total de points cumules
SELECT  e.Prenom || ' ' || e.Nom   AS Enfant,
        COUNT(a.id_attribution)     AS Nb_recompenses,
        SUM(r.Points)               AS Points_cumules
FROM    Enfant                  e
JOIN    Attribution_Recompense  a ON e.id_enfant       = a.id_enfant
JOIN    Recompense              r ON a.id_recompense   = r.id_recompense
GROUP BY e.id_enfant, e.Nom, e.Prenom
ORDER BY Points_cumules DESC;


-- 3.6 Professeur avec le plus de cours actifs (au moins 1 inscrit)
SELECT  p.Prenom || ' ' || p.Nom  AS Professeur,
        p.Specialite,
        COUNT(DISTINCT c.id_cours)  AS Nb_cours_actifs
FROM    Professeur  p
JOIN    Cours       c ON p.id_prof   = c.id_prof
JOIN    Inscription i ON c.id_cours  = i.id_cours
WHERE   i.Statut_inscription = 'actif'
GROUP BY p.id_prof, p.Nom, p.Prenom, p.Specialite
ORDER BY Nb_cours_actifs DESC;


-- =============================================================
-- BLOC 4 — JOINTURES MULTIPLES (3 tables et plus)
-- =============================================================

-- 4.1 Tableau complet : enfant -> cours -> devoir -> note
SELECT  e.Prenom || ' ' || e.Nom   AS Enfant,
        c.Titre_cours,
        d.Titre_devoir,
        sd.Date_soumission,
        n.Valeur                    AS Note,
        n.Commentaire
FROM    Enfant            e
JOIN    Soumission_Devoir sd ON e.id_enfant       = sd.id_enfant
JOIN    Devoir            d  ON sd.id_devoir      = d.id_devoir
JOIN    Cours             c  ON d.id_cours        = c.id_cours
JOIN    Note              n  ON sd.id_soumission  = n.id_soumission
ORDER BY e.Nom, c.Titre_cours, d.Titre_devoir;


-- 4.2 Historique complet d'une session ChatIA avec tous ses messages
SELECT  e.Prenom || ' ' || e.Nom  AS Enfant,
        s.Date_session,
        s.Sujet,
        m.Role,
        m.Date_heure,
        LEFT(m.Contenu_message, 80) AS Apercu_message
FROM    Session_ChatIA  s
JOIN    Enfant          e ON s.id_enfant       = e.id_enfant
JOIN    Message_ChatIA  m ON s.id_session_chat = m.id_session_chat
ORDER BY s.id_session_chat, m.Date_heure;


-- 4.3 Resultats des concours : classement complet
SELECT  co.Titre_concours,
        co.Date_concours,
        e.Prenom || ' ' || e.Nom  AS Enfant,
        e.Niveau,
        pc.Score,
        pc.Rang,
        pc.Resultat
FROM    Concours              co
JOIN    Participation_Concours pc ON co.id_concours = pc.id_concours
JOIN    Enfant                 e  ON pc.id_enfant    = e.id_enfant
WHERE   pc.Rang IS NOT NULL
ORDER BY co.Date_concours, pc.Rang;


-- 4.4 Devoirs remis en retard (soumission apres date_limite)
SELECT  e.Prenom || ' ' || e.Nom    AS Enfant,
        d.Titre_devoir,
        d.Date_limite,
        sd.Date_soumission::DATE     AS Date_soumise,
        (sd.Date_soumission::DATE - d.Date_limite)  AS Jours_retard
FROM    Soumission_Devoir sd
JOIN    Enfant            e  ON sd.id_enfant = e.id_enfant
JOIN    Devoir            d  ON sd.id_devoir = d.id_devoir
WHERE   sd.Date_soumission::DATE > d.Date_limite
ORDER BY Jours_retard DESC;


-- 4.5 Enfants inscrits a la fois a Python et a Histoire du Canada
SELECT  e.Prenom || ' ' || e.Nom  AS Enfant,
        e.Age,
        e.Niveau
FROM    Enfant e
WHERE   EXISTS (
    SELECT 1
    FROM   Inscription i
    JOIN   Cours       c ON i.id_cours = c.id_cours
    WHERE  i.id_enfant     = e.id_enfant
      AND  c.Titre_cours   = 'Python pour juniors'
)
AND EXISTS (
    SELECT 1
    FROM   Inscription i
    JOIN   Cours       c ON i.id_cours = c.id_cours
    WHERE  i.id_enfant     = e.id_enfant
      AND  c.Titre_cours   = 'Histoire du Canada'
);


-- =============================================================
-- BLOC 5 — SOUS-REQUETES
-- =============================================================

-- 5.1 Enfants ayant une moyenne superieure a la moyenne globale
SELECT  e.Prenom || ' ' || e.Nom  AS Enfant,
        ROUND(AVG(n.Valeur), 2)    AS Moyenne_personnelle
FROM    Enfant            e
JOIN    Soumission_Devoir sd ON e.id_enfant       = sd.id_enfant
JOIN    Note              n  ON sd.id_soumission  = n.id_soumission
GROUP BY e.id_enfant, e.Nom, e.Prenom
HAVING  AVG(n.Valeur) > (
    SELECT AVG(Valeur) FROM Note
)
ORDER BY Moyenne_personnelle DESC;


-- 5.2 Cours sans aucune inscription
SELECT  id_cours,
        Titre_cours,
        Niveau,
        Langue
FROM    Cours
WHERE   id_cours NOT IN (
    SELECT DISTINCT id_cours FROM Inscription
)
ORDER BY Titre_cours;


-- 5.3 Enfant avec la meilleure note dans chaque cours
SELECT  c.Titre_cours,
        e.Prenom || ' ' || e.Nom  AS Meilleur_enfant,
        n.Valeur                   AS Meilleure_note
FROM    Cours             c
JOIN    Devoir            d  ON c.id_cours       = d.id_cours
JOIN    Soumission_Devoir sd ON d.id_devoir       = sd.id_devoir
JOIN    Note              n  ON sd.id_soumission  = n.id_soumission
JOIN    Enfant            e  ON sd.id_enfant      = e.id_enfant
WHERE   n.Valeur = (
    SELECT  MAX(n2.Valeur)
    FROM    Soumission_Devoir sd2
    JOIN    Note              n2 ON sd2.id_soumission = n2.id_soumission
    JOIN    Devoir            d2 ON sd2.id_devoir     = d2.id_devoir
    WHERE   d2.id_cours = c.id_cours
)
ORDER BY c.Titre_cours;


-- 5.4 Enfants n'ayant soumis aucun devoir
SELECT  e.id_enfant,
        e.Prenom || ' ' || e.Nom  AS Enfant,
        e.Niveau,
        e.Age
FROM    Enfant e
WHERE   e.id_enfant NOT IN (
    SELECT DISTINCT id_enfant FROM Soumission_Devoir
)
ORDER BY e.Nom;


-- 5.5 Recompenses jamais attribuees
SELECT  id_recompense,
        Nom_recompense,
        Points
FROM    Recompense
WHERE   id_recompense NOT IN (
    SELECT DISTINCT id_recompense FROM Attribution_Recompense
)
ORDER BY Points DESC;


-- =============================================================
-- BLOC 6 — VUES (VIEW)
-- Requetes sauvegardees et reutilisables
-- =============================================================

-- 6.1 Vue : bulletin complet de chaque enfant
CREATE OR REPLACE VIEW v_bulletin_enfants AS
SELECT  e.id_enfant,
        e.Prenom || ' ' || e.Nom           AS Enfant,
        e.Niveau,
        c.Titre_cours,
        d.Titre_devoir,
        n.Valeur                            AS Note,
        n.Date_correction,
        n.Commentaire
FROM    Enfant            e
JOIN    Soumission_Devoir sd ON e.id_enfant       = sd.id_enfant
JOIN    Note              n  ON sd.id_soumission  = n.id_soumission
JOIN    Devoir            d  ON sd.id_devoir      = d.id_devoir
JOIN    Cours             c  ON d.id_cours        = c.id_cours;

-- Utilisation :
SELECT * FROM v_bulletin_enfants WHERE Enfant = 'Emma Tremblay';


-- 6.2 Vue : resume statistique par enfant
CREATE OR REPLACE VIEW v_stats_enfants AS
SELECT  e.id_enfant,
        e.Prenom || ' ' || e.Nom           AS Enfant,
        e.Niveau,
        COUNT(DISTINCT i.id_cours)          AS Nb_cours_inscrits,
        COUNT(DISTINCT sd.id_soumission)    AS Nb_devoirs_soumis,
        ROUND(AVG(n.Valeur), 2)             AS Moyenne_generale,
        COALESCE(SUM(r.Points), 0)          AS Total_points_recompenses
FROM    Enfant                   e
LEFT JOIN Inscription            i  ON e.id_enfant      = i.id_enfant
LEFT JOIN Soumission_Devoir      sd ON e.id_enfant      = sd.id_enfant
LEFT JOIN Note                   n  ON sd.id_soumission = n.id_soumission
LEFT JOIN Attribution_Recompense ar ON e.id_enfant      = ar.id_enfant
LEFT JOIN Recompense             r  ON ar.id_recompense = r.id_recompense
GROUP BY e.id_enfant, e.Nom, e.Prenom, e.Niveau;

-- Utilisation :
SELECT * FROM v_stats_enfants ORDER BY Moyenne_generale DESC NULLS LAST;


-- 6.3 Vue : tableau de bord du professeur
CREATE OR REPLACE VIEW v_tableau_bord_prof AS
SELECT  p.Prenom || ' ' || p.Nom           AS Professeur,
        p.Specialite,
        c.Titre_cours,
        COUNT(DISTINCT i.id_enfant)         AS Nb_eleves,
        COUNT(DISTINCT d.id_devoir)         AS Nb_devoirs,
        ROUND(AVG(n.Valeur), 2)             AS Moyenne_cours
FROM    Professeur          p
JOIN    Cours               c  ON p.id_prof        = c.id_prof
LEFT JOIN Inscription       i  ON c.id_cours       = i.id_cours
LEFT JOIN Devoir            d  ON c.id_cours       = d.id_cours
LEFT JOIN Soumission_Devoir sd ON d.id_devoir      = sd.id_devoir
LEFT JOIN Note              n  ON sd.id_soumission = n.id_soumission
GROUP BY p.id_prof, p.Nom, p.Prenom, p.Specialite,
         c.id_cours, c.Titre_cours
ORDER BY Professeur, c.Titre_cours;

-- Utilisation :
SELECT * FROM v_tableau_bord_prof;


-- =============================================================
-- BLOC 7 — REQUETES AVANCEES (fonctions de fenetre)
-- =============================================================

-- 7.1 Classement des enfants par moyenne avec RANK()
SELECT  e.Prenom || ' ' || e.Nom         AS Enfant,
        e.Niveau,
        ROUND(AVG(n.Valeur), 2)           AS Moyenne,
        RANK() OVER (
            ORDER BY AVG(n.Valeur) DESC
        )                                 AS Rang_global,
        RANK() OVER (
            PARTITION BY e.Niveau
            ORDER BY AVG(n.Valeur) DESC
        )                                 AS Rang_dans_niveau
FROM    Enfant            e
JOIN    Soumission_Devoir sd ON e.id_enfant       = sd.id_enfant
JOIN    Note              n  ON sd.id_soumission  = n.id_soumission
GROUP BY e.id_enfant, e.Nom, e.Prenom, e.Niveau
ORDER BY Rang_global;


-- 7.2 Evolution des notes d'un enfant dans le temps (moyenne cumulative)
SELECT  e.Prenom || ' ' || e.Nom   AS Enfant,
        d.Titre_devoir,
        n.Date_correction,
        n.Valeur,
        ROUND(AVG(n.Valeur) OVER (
            PARTITION BY e.id_enfant
            ORDER BY n.Date_correction
            ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
        ), 2)                        AS Moyenne_cumulative
FROM    Enfant            e
JOIN    Soumission_Devoir sd ON e.id_enfant       = sd.id_enfant
JOIN    Note              n  ON sd.id_soumission  = n.id_soumission
JOIN    Devoir            d  ON sd.id_devoir      = d.id_devoir
WHERE   e.id_enfant = 3
ORDER BY n.Date_correction;


-- 7.3 Recapitulatif complet parent -> enfants -> statistiques
SELECT  par.Prenom || ' ' || par.Nom       AS Parent,
        par.Email,
        enf.Prenom || ' ' || enf.Nom        AS Enfant,
        enf.Age,
        enf.Niveau,
        COUNT(DISTINCT i.id_cours)           AS Cours_inscrits,
        ROUND(AVG(n.Valeur), 2)              AS Moyenne_enfant
FROM    Parent               par
JOIN    Enfant               enf ON par.id_parent      = enf.id_parent
LEFT JOIN Inscription        i   ON enf.id_enfant      = i.id_enfant
LEFT JOIN Soumission_Devoir  sd  ON enf.id_enfant      = sd.id_enfant
LEFT JOIN Note               n   ON sd.id_soumission   = n.id_soumission
GROUP BY par.id_parent, par.Nom, par.Prenom, par.Email,
         enf.id_enfant, enf.Nom, enf.Prenom, enf.Age, enf.Niveau
ORDER BY par.Nom, enf.Nom;


-- 7.4 Activite ChatIA par jour de la semaine
SELECT  TO_CHAR(s.Date_session, 'Day')    AS Jour_semaine,
        COUNT(s.id_session_chat)           AS Nb_sessions,
        SUM(s.Duree)                       AS Duree_totale_min,
        COUNT(m.id_message)                AS Nb_messages
FROM    Session_ChatIA   s
LEFT JOIN Message_ChatIA m ON s.id_session_chat = m.id_session_chat
GROUP BY TO_CHAR(s.Date_session, 'Day'),
         EXTRACT(DOW FROM s.Date_session)
ORDER BY EXTRACT(DOW FROM s.Date_session);


-- 7.5 Concours : podium complet avec medailles
SELECT  co.Titre_concours,
        CASE pc.Rang
            WHEN 1 THEN 'Or - 1re place'
            WHEN 2 THEN 'Argent - 2e place'
            WHEN 3 THEN 'Bronze - 3e place'
            ELSE        pc.Rang::TEXT || 'e place'
        END                               AS Medaille,
        e.Prenom || ' ' || e.Nom          AS Enfant,
        e.Niveau,
        pc.Score
FROM    Concours               co
JOIN    Participation_Concours pc ON co.id_concours = pc.id_concours
JOIN    Enfant                 e  ON pc.id_enfant    = e.id_enfant
WHERE   pc.Rang IS NOT NULL
ORDER BY co.Titre_concours, pc.Rang;


-- =============================================================
-- FIN DU SCRIPT DQL
-- =============================================================
