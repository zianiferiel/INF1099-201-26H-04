-- =============================================================
--  DML.sql — Plateforme éducative pour enfants
--  Auteure   : Ramatoulaye Diallo — 300153476
--  Cours     : INF1099
--  SGBD      : PostgreSQL
--  Rôle      : Manipulation des données (INSERT, UPDATE, DELETE)
--  Date      : 2026-03-18
-- =============================================================
-- DML = Data Manipulation Language
--   INSERT  → ajouter des données
--   UPDATE  → modifier des données existantes
--   DELETE  → supprimer des données
-- =============================================================


-- =============================================================
-- SECTION 1 — INSERT
-- Ordre obligatoire : entités indépendantes → dépendantes
-- =============================================================


-- -------------------------------------------------------------
-- 1.1 Parent (aucune FK)
-- -------------------------------------------------------------
INSERT INTO Parent (Nom, Prenom, Telephone, Email) VALUES
    ('Tremblay',  'Sophie',   '819-555-0101', 'sophie.tremblay@email.com'),
    ('Dupont',    'Jean',     '613-555-0202', 'jean.dupont@email.com'),
    ('Hassan',    'Fatima',   '705-555-0303', 'fatima.hassan@email.com'),
    ('Nguyen',    'Minh',     '416-555-0404', 'minh.nguyen@email.com'),
    ('Diallo',    'Aminata',  '514-555-0505', 'aminata.diallo@email.com'),
    ('Martin',    'Claire',   '450-555-0606', 'claire.martin@email.com'),
    ('Bouchard',  'Luc',      '418-555-0707', 'luc.bouchard@email.com'),
    ('Okonkwo',   'Chidi',    '289-555-0808', 'chidi.okonkwo@email.com');


-- -------------------------------------------------------------
-- 1.2 Professeur (aucune FK)
-- -------------------------------------------------------------
INSERT INTO Professeur (Nom, Prenom, Telephone, Email, Specialite) VALUES
    ('Lemieux',   'Marc',     '819-666-0101', 'marc.lemieux@ecole.ca',    'Mathématiques'),
    ('Bernard',   'Julie',    '613-666-0202', 'julie.bernard@ecole.ca',   'Français'),
    ('Côté',      'Patrick',  '705-666-0303', 'patrick.cote@ecole.ca',    'Sciences'),
    ('Lavoie',    'Nadia',    '416-666-0404', 'nadia.lavoie@ecole.ca',    'Anglais'),
    ('Fortin',    'Samuel',   '514-666-0505', 'samuel.fortin@ecole.ca',   'Programmation'),
    ('Gagnon',    'Isabelle', '450-666-0606', 'isabelle.gagnon@ecole.ca', 'Histoire');


-- -------------------------------------------------------------
-- 1.3 Récompense (aucune FK)
-- -------------------------------------------------------------
INSERT INTO Recompense (Nom_recompense, Description, Points) VALUES
    ('Étoile d''or',       'Excellent travail sur un devoir',            100),
    ('Super lecteur',      'A lu 5 livres dans le mois',                  75),
    ('Mathmagicien',       'Score parfait en mathématiques',             150),
    ('Curieux scientifique','Participation active en sciences',            80),
    ('Champion du mois',   'Meilleur résultat global du mois',           200),
    ('Premier pas',        'Première soumission de devoir complétée',     50),
    ('Persévérance',       'Amélioration notable entre deux évaluations',120),
    ('Génie du code',      'Complète tous les exercices de programmation',160);


-- -------------------------------------------------------------
-- 1.4 Concours (aucune FK)
-- -------------------------------------------------------------
INSERT INTO Concours (Titre_concours, Date_concours, Description, Prix) VALUES
    ('Olympiade des maths',      '2026-04-15', 'Compétition de mathématiques niveaux primaire et secondaire', 'Trophée + bourse 200$'),
    ('Dictée nationale',         '2026-05-10', 'Concours de dictée pour enfants de 8 à 14 ans',              'Médaille + certificat'),
    ('Science en action',        '2026-06-20', 'Présentation de projets scientifiques originaux',            'Kit science + diplôme'),
    ('Hackathon junior',         '2026-07-05', 'Concours de programmation pour jeunes développeurs',         'Ordinateur portable'),
    ('Grand défi lecture',       '2026-04-23', 'Lire le plus de livres en un mois (Journée mondiale du livre)','Bibliothèque personnelle');


-- -------------------------------------------------------------
-- 1.5 Enfant (FK → Parent)
-- -------------------------------------------------------------
INSERT INTO Enfant (Nom, Prenom, Age, Niveau, id_parent) VALUES
    ('Tremblay', 'Emma',     10, 'primaire',    1),
    ('Tremblay', 'Noah',      8, 'primaire',    1),
    ('Dupont',   'Léa',      13, 'secondaire',  2),
    ('Hassan',   'Youssef',  11, 'primaire',    3),
    ('Hassan',   'Salma',     9, 'primaire',    3),
    ('Nguyen',   'Linh',     14, 'secondaire',  4),
    ('Diallo',   'Ibrahima', 12, 'secondaire',  5),
    ('Martin',   'Chloé',     7, 'maternelle',  6),
    ('Bouchard', 'Félix',    15, 'secondaire',  7),
    ('Okonkwo',  'Adaeze',   10, 'primaire',    8),
    ('Nguyen',   'Kevin',    16, 'secondaire',  4),
    ('Diallo',   'Mariama',   6, 'maternelle',  5);


-- -------------------------------------------------------------
-- 1.6 Cours (FK → Professeur)
-- -------------------------------------------------------------
INSERT INTO Cours (Titre_cours, Langue, Niveau, id_prof) VALUES
    ('Arithmétique de base',        'Français',  'débutant',      1),
    ('Algèbre niveau secondaire',   'Français',  'intermédiaire', 1),
    ('Lecture et compréhension',    'Français',  'débutant',      2),
    ('Rédaction créative',          'Français',  'intermédiaire', 2),
    ('Introduction aux sciences',   'Français',  'débutant',      3),
    ('Chimie et physique junior',   'Français',  'intermédiaire', 3),
    ('English for beginners',       'Anglais',   'débutant',      4),
    ('English conversation',        'Anglais',   'intermédiaire', 4),
    ('Programmation Scratch',       'Français',  'débutant',      5),
    ('Python pour juniors',         'Français',  'intermédiaire', 5),
    ('Histoire du Canada',          'Français',  'intermédiaire', 6),
    ('Éveil culturel',              'Français',  'débutant',      6);


-- -------------------------------------------------------------
-- 1.7 Session_Cours (FK → Cours)
-- -------------------------------------------------------------
INSERT INTO Session_Cours (Date_session, Heure_session, Duree, Mode_session, id_cours) VALUES
    ('2026-04-01', '09:00', 60,  'en ligne',    1),
    ('2026-04-03', '14:00', 90,  'présentiel',  1),
    ('2026-04-02', '10:00', 60,  'en ligne',    2),
    ('2026-04-08', '09:00', 75,  'hybride',     3),
    ('2026-04-10', '13:30', 60,  'en ligne',    3),
    ('2026-04-05', '11:00', 90,  'présentiel',  4),
    ('2026-04-07', '09:00', 60,  'en ligne',    5),
    ('2026-04-09', '14:00', 75,  'présentiel',  5),
    ('2026-04-04', '10:30', 60,  'en ligne',    7),
    ('2026-04-06', '15:00', 90,  'en ligne',    9),
    ('2026-04-11', '09:00', 60,  'hybride',     10),
    ('2026-04-12', '11:00', 60,  'en ligne',    11),
    ('2026-04-14', '13:00', 75,  'présentiel',  6),
    ('2026-04-15', '10:00', 60,  'en ligne',    8),
    ('2026-04-16', '14:30', 90,  'en ligne',    12);


-- -------------------------------------------------------------
-- 1.8 Inscription (FK → Enfant, Cours)
-- -------------------------------------------------------------
INSERT INTO Inscription (Date_inscription, Statut_inscription, id_enfant, id_cours) VALUES
    ('2026-03-01', 'actif',    1,  1),   -- Emma → Arithmétique
    ('2026-03-01', 'actif',    1,  3),   -- Emma → Lecture
    ('2026-03-01', 'actif',    1,  9),   -- Emma → Scratch
    ('2026-03-02', 'actif',    2,  1),   -- Noah → Arithmétique
    ('2026-03-02', 'actif',    2,  3),   -- Noah → Lecture
    ('2026-03-03', 'actif',    3,  2),   -- Léa → Algèbre
    ('2026-03-03', 'actif',    3,  4),   -- Léa → Rédaction
    ('2026-03-03', 'actif',    3, 10),   -- Léa → Python
    ('2026-03-04', 'actif',    4,  1),   -- Youssef → Arithmétique
    ('2026-03-04', 'actif',    4,  5),   -- Youssef → Sciences
    ('2026-03-04', 'actif',    4,  7),   -- Youssef → English
    ('2026-03-05', 'actif',    5,  3),   -- Salma → Lecture
    ('2026-03-05', 'actif',    5, 12),   -- Salma → Éveil culturel
    ('2026-03-06', 'actif',    6,  2),   -- Linh → Algèbre
    ('2026-03-06', 'actif',    6,  8),   -- Linh → English conv.
    ('2026-03-06', 'actif',    6, 10),   -- Linh → Python
    ('2026-03-07', 'actif',    7,  2),   -- Ibrahima → Algèbre
    ('2026-03-07', 'actif',    7, 10),   -- Ibrahima → Python
    ('2026-03-07', 'actif',    7, 11),   -- Ibrahima → Histoire
    ('2026-03-08', 'actif',    8, 12),   -- Chloé → Éveil culturel
    ('2026-03-09', 'actif',    9,  2),   -- Félix → Algèbre
    ('2026-03-09', 'actif',    9,  6),   -- Félix → Chimie/physique
    ('2026-03-09', 'actif',    9, 10),   -- Félix → Python
    ('2026-03-10', 'actif',   10,  1),   -- Adaeze → Arithmétique
    ('2026-03-10', 'actif',   10,  5),   -- Adaeze → Sciences
    ('2026-03-11', 'actif',   11,  6),   -- Kevin → Chimie/physique
    ('2026-03-11', 'actif',   11, 10),   -- Kevin → Python
    ('2026-03-01', 'suspendu', 12, 12);  -- Mariama → Éveil culturel (suspendu)


-- -------------------------------------------------------------
-- 1.9 Devoir (FK → Cours)
-- -------------------------------------------------------------
INSERT INTO Devoir (Titre_devoir, Description, Date_limite, id_cours) VALUES
    ('Exercices additions/soustractions', 'Compléter les exercices p.12-15 du cahier',          '2026-04-20', 1),
    ('Problèmes algébriques',            'Résoudre 10 équations du premier degré',              '2026-04-22', 2),
    ('Résumé de lecture',                'Lire le chapitre 3 et écrire un résumé de 150 mots',  '2026-04-18', 3),
    ('Nouvelle courte',                  'Rédiger une nouvelle de 300 mots sur le thème liberté','2026-04-25', 4),
    ('Rapport expérience',               'Décrire l expérience du vinaigre et bicarbonate',     '2026-04-19', 5),
    ('Projet chimie',                    'Préparer une présentation sur les états de la matière','2026-04-28', 6),
    ('Vocabulary quiz',                  'Memorize 20 vocabulary words and use in sentences',   '2026-04-17', 7),
    ('My daily routine',                 'Write a short paragraph describing your daily routine','2026-04-24', 8),
    ('Animation Scratch',                'Créer une animation avec 3 sprites et 2 sons',        '2026-04-21', 9),
    ('Programme Python',                 'Créer un programme qui calcule la moyenne de 5 notes', '2026-04-23', 10),
    ('Chronologie historique',           'Créer une ligne du temps de 1500 à 1867 au Canada',   '2026-04-26', 11),
    ('Présentation culturelle',          'Préparer 5 diapositives sur une culture du monde',    '2026-04-27', 12);


-- -------------------------------------------------------------
-- 1.10 Ressource (FK → Cours)
-- -------------------------------------------------------------
INSERT INTO Ressource (Titre_ressource, Type_ressource, URL_ressource, id_cours) VALUES
    ('Vidéo addition illustrée',        'vidéo', 'https://edu.ca/videos/addition-illustree',       1),
    ('Fiche exercices p.12-15',         'pdf',   'https://edu.ca/docs/arithmetique-fiche1.pdf',    1),
    ('Guide algèbre débutant',          'pdf',   'https://edu.ca/docs/algebre-guide.pdf',          2),
    ('Simulateur équations',            'lien',  'https://geogebra.org/equations',                 2),
    ('Contes pour enfants audio',       'audio', 'https://edu.ca/audio/contes-enfants.mp3',        3),
    ('Méthode de résumé',               'pdf',   'https://edu.ca/docs/methode-resume.pdf',         3),
    ('Guide de rédaction créative',     'pdf',   'https://edu.ca/docs/redaction-guide.pdf',        4),
    ('Expériences faciles maison',      'vidéo', 'https://edu.ca/videos/experiences-maison',       5),
    ('États de la matière animé',       'vidéo', 'https://edu.ca/videos/etats-matiere',            6),
    ('Vocabulaire anglais PDF',         'pdf',   'https://edu.ca/docs/vocab-anglais-niveau1.pdf',  7),
    ('Tutoriel Scratch officiel',       'lien',  'https://scratch.mit.edu/projects/editor/',       9),
    ('Introduction Python Jupyter',     'lien',  'https://colab.research.google.com',              10),
    ('Atlas historique Canada',         'pdf',   'https://edu.ca/docs/atlas-canada.pdf',           11),
    ('Cultures du monde images',        'image', 'https://edu.ca/images/cultures-monde',           12);


-- -------------------------------------------------------------
-- 1.11 Soumission_Devoir (FK → Devoir, Enfant)
-- -------------------------------------------------------------
INSERT INTO Soumission_Devoir (Date_soumission, Fichier_ou_lien, Commentaire, id_devoir, id_enfant) VALUES
    ('2026-04-18 10:30:00', 'https://drive.google.com/file/emma-additions',       'Fait avec l aide de maman',     1,  1),
    ('2026-04-17 15:00:00', 'https://drive.google.com/file/emma-resume',          NULL,                            3,  1),
    ('2026-04-19 09:45:00', 'https://drive.google.com/file/emma-scratch',         'Mon premier projet Scratch!',   9,  1),
    ('2026-04-17 14:00:00', 'https://drive.google.com/file/noah-additions',       NULL,                            1,  2),
    ('2026-04-16 11:30:00', 'https://drive.google.com/file/lea-algebre',          'Exercices complétés',           2,  3),
    ('2026-04-24 08:00:00', 'https://drive.google.com/file/lea-nouvelle',         'Très inspirée',                 4,  3),
    ('2026-04-21 16:00:00', 'https://drive.google.com/file/lea-python',           NULL,                            10, 3),
    ('2026-04-17 10:00:00', 'https://drive.google.com/file/youssef-additions',    NULL,                            1,  4),
    ('2026-04-18 13:00:00', 'https://drive.google.com/file/youssef-sciences',     'J adore les expériences!',      5,  4),
    ('2026-04-16 09:00:00', 'https://drive.google.com/file/youssef-vocab',        NULL,                            7,  4),
    ('2026-04-17 17:00:00', 'https://drive.google.com/file/linh-algebre',         NULL,                            2,  6),
    ('2026-04-22 14:00:00', 'https://drive.google.com/file/linh-python',          'Programme bien fonctionnel',    10, 6),
    ('2026-04-18 11:00:00', 'https://drive.google.com/file/ibrahima-python',      NULL,                            10, 7),
    ('2026-04-25 10:00:00', 'https://drive.google.com/file/ibrahima-histoire',    'Très détaillé',                 11, 7),
    ('2026-04-20 15:00:00', 'https://drive.google.com/file/felix-algebre',        NULL,                            2,  9),
    ('2026-04-21 09:00:00', 'https://drive.google.com/file/felix-chimie',         'Présentation prête',            6,  9),
    ('2026-04-22 12:00:00', 'https://drive.google.com/file/felix-python',         'Beaucoup de débogage!',         10, 9),
    ('2026-04-17 08:30:00', 'https://drive.google.com/file/adaeze-additions',     NULL,                            1,  10),
    ('2026-04-18 14:00:00', 'https://drive.google.com/file/adaeze-sciences',      'Super intéressant',             5,  10),
    ('2026-04-21 10:00:00', 'https://drive.google.com/file/kevin-chimie',         NULL,                            6,  11),
    ('2026-04-22 16:00:00', 'https://drive.google.com/file/kevin-python',         'Programme avancé',              10, 11);


-- -------------------------------------------------------------
-- 1.12 Note (FK → Soumission_Devoir)
-- Un seul Note par Soumission
-- -------------------------------------------------------------
INSERT INTO Note (Valeur, Commentaire, Date_correction, id_soumission) VALUES
    (88.00, 'Bon travail, quelques petites erreurs de calcul',          '2026-04-20', 1),
    (92.00, 'Excellent résumé, bien structuré',                         '2026-04-19', 2),
    (95.00, 'Très créatif, bravo Emma!',                                '2026-04-22', 3),
    (75.00, 'Correct mais incomplet sur la page 14',                    '2026-04-20', 4),
    (90.00, 'Très bonne maîtrise de l algèbre',                         '2026-04-19', 5),
    (98.00, 'Nouvelle exceptionnelle, style remarquable',               '2026-04-25', 6),
    (85.00, 'Programme fonctionnel, code bien commenté',                '2026-04-23', 7),
    (80.00, 'Quelques erreurs mais effort visible',                     '2026-04-19', 8),
    (93.00, 'Rapport bien rédigé, expérience bien décrite',             '2026-04-20', 9),
    (70.00, 'Vocabulaire partiellement mémorisé',                       '2026-04-18', 10),
    (87.00, 'Bonne maîtrise des équations',                             '2026-04-20', 11),
    (91.00, 'Programme propre et efficace',                             '2026-04-24', 12),
    (78.00, 'Logique correcte, améliorer les commentaires',             '2026-04-20', 13),
    (96.00, 'Chronologie exemplaire, très bien documentée',             '2026-04-27', 14),
    (82.00, 'Bon travail, quelques imprécisions',                       '2026-04-22', 15),
    (89.00, 'Présentation très bien préparée',                          '2026-04-23', 16),
    (94.00, 'Code élégant, bonne gestion des erreurs',                  '2026-04-24', 17),
    (86.00, 'Calculs justes, bonne présentation',                       '2026-04-19', 18),
    (91.00, 'Rapport complet et bien organisé',                         '2026-04-20', 19),
    (84.00, 'Présentation solide, quelques fautes de frappe',           '2026-04-23', 20),
    (97.00, 'Programme avancé, très impressionnant',                    '2026-04-24', 21);


-- -------------------------------------------------------------
-- 1.13 Attribution_Recompense (FK → Enfant, Recompense)
-- -------------------------------------------------------------
INSERT INTO Attribution_Recompense (Date_attribution, Motif, id_enfant, id_recompense) VALUES
    ('2026-04-20', 'Note parfaite en Scratch',                    1, 1),
    ('2026-04-19', 'Première soumission complétée',               1, 6),
    ('2026-04-25', 'Meilleure nouvelle du groupe',                3, 1),
    ('2026-04-20', 'Score parfait en algèbre',                    3, 3),
    ('2026-04-27', 'Chronologie historique exceptionnelle',       7, 1),
    ('2026-04-19', 'Premier devoir soumis',                       4, 6),
    ('2026-04-24', 'Programme Python avancé',                     11, 8),
    ('2026-04-24', 'Programme Python avancé',                     9, 8),
    ('2026-04-20', 'Amélioration de 15 points entre les devoirs', 4, 7),
    ('2026-04-01', 'Bienvenue sur la plateforme',                 8, 6);


-- -------------------------------------------------------------
-- 1.14 Participation_Concours (FK → Enfant, Concours)
-- -------------------------------------------------------------
INSERT INTO Participation_Concours (Resultat, Score, Rang, id_enfant, id_concours) VALUES
    ('qualifié',     92.50, 2,  3,  1),  -- Léa → Olympiade maths, 2e place
    ('qualifié',     88.00, 4,  6,  1),  -- Linh → Olympiade maths, 4e place
    ('qualifié',     95.00, 1,  9,  1),  -- Félix → Olympiade maths, 1re place
    ('qualifié',     79.00, 6,  7,  1),  -- Ibrahima → Olympiade maths
    ('qualifié',     85.50, 1,  3,  2),  -- Léa → Dictée nationale, 1re place
    ('qualifié',     82.00, 3,  1,  2),  -- Emma → Dictée, 3e place
    ('qualifié',     77.50, 5,  4,  2),  -- Youssef → Dictée
    ('qualifié',     90.00, 1,  11, 4),  -- Kevin → Hackathon junior, 1re place
    ('qualifié',     87.00, 2,  9,  4),  -- Félix → Hackathon junior, 2e place
    ('qualifié',     83.00, 3,  7,  4),  -- Ibrahima → Hackathon junior, 3e place
    ('en attente',   NULL,  NULL, 1, 5), -- Emma → Grand défi lecture
    ('en attente',   NULL,  NULL, 4, 5), -- Youssef → Grand défi lecture
    ('en attente',   NULL,  NULL, 5, 5), -- Salma → Grand défi lecture
    ('qualifié',     88.00, 2,  10, 3),  -- Adaeze → Science en action
    ('qualifié',     91.00, 1,  4,  3);  -- Youssef → Science en action, 1re place


-- -------------------------------------------------------------
-- 1.15 Session_ChatIA (FK → Enfant)
-- -------------------------------------------------------------
INSERT INTO Session_ChatIA (Date_session, Sujet, Duree, id_enfant) VALUES
    ('2026-04-01', 'Aide pour les additions',               15,  1),
    ('2026-04-02', 'Comprendre les fractions',              20,  1),
    ('2026-04-03', 'Aide pour la rédaction',                25,  3),
    ('2026-04-04', 'Questions sur l algèbre',               30,  3),
    ('2026-04-05', 'Aide pour le vocabulaire anglais',      18,  4),
    ('2026-04-06', 'Explications sur les états de matière', 22,  4),
    ('2026-04-07', 'Débogage programme Scratch',            35,  1),
    ('2026-04-08', 'Questions sur Python',                  40,  6),
    ('2026-04-09', 'Histoire du Canada — révision',         28,  7),
    ('2026-04-10', 'Aide pour la dictée',                   20,  3),
    ('2026-04-11', 'Explications chimie',                   32,  9),
    ('2026-04-12', 'Python — fonctions avancées',           45, 11),
    ('2026-04-13', 'Préparation au concours de maths',      50,  6),
    ('2026-04-14', 'Aide pour la lecture',                  15,  2),
    ('2026-04-15', 'Questions générales sciences',          25, 10);


-- -------------------------------------------------------------
-- 1.16 Message_ChatIA (FK → Session_ChatIA)
-- -------------------------------------------------------------
INSERT INTO Message_ChatIA (Contenu_message, Role, Date_heure, id_session_chat) VALUES
    ('Comment fait-on une addition avec retenue?',
        'utilisateur', '2026-04-01 09:00:00', 1),
    ('Une addition avec retenue signifie que lorsque la somme dépasse 9 dans une colonne...',
        'assistant',   '2026-04-01 09:00:15', 1),
    ('Ah je comprends mieux! Et la soustraction?',
        'utilisateur', '2026-04-01 09:02:00', 1),
    ('Pour la soustraction, on procède de la même façon mais en sens inverse...',
        'assistant',   '2026-04-01 09:02:20', 1),
    ('C est quoi une fraction?',
        'utilisateur', '2026-04-02 10:00:00', 2),
    ('Une fraction représente une partie d un tout. Par exemple, 1/2 signifie une partie sur deux...',
        'assistant',   '2026-04-02 10:00:18', 2),
    ('Comment écrire une bonne introduction?',
        'utilisateur', '2026-04-03 14:00:00', 3),
    ('Une bonne introduction doit accrocher le lecteur, présenter le sujet et annoncer le plan...',
        'assistant',   '2026-04-03 14:00:22', 3),
    ('Qu est-ce qu une variable en algèbre?',
        'utilisateur', '2026-04-04 11:00:00', 4),
    ('Une variable est un symbole, souvent une lettre comme x ou y, qui représente une valeur inconnue...',
        'assistant',   '2026-04-04 11:00:19', 4),
    ('Comment dire "Je m appelle" en anglais?',
        'utilisateur', '2026-04-05 09:30:00', 5),
    ('En anglais, on dit "My name is" suivi de ton prénom. Par exemple: "My name is Youssef".',
        'assistant',   '2026-04-05 09:30:12', 5),
    ('Mon sprite ne bouge pas dans Scratch, pourquoi?',
        'utilisateur', '2026-04-07 16:00:00', 7),
    ('Vérifie d abord que ton sprite a bien un bloc "Quand le drapeau vert est cliqué" au début...',
        'assistant',   '2026-04-07 16:00:25', 7),
    ('Comment faire une boucle en Python?',
        'utilisateur', '2026-04-08 20:00:00', 8),
    ('En Python, on utilise for ou while. Exemple: for i in range(5): print(i)',
        'assistant',   '2026-04-08 20:00:17', 8),
    ('Qu est-ce que la Confédération canadienne?',
        'utilisateur', '2026-04-09 15:00:00', 9),
    ('La Confédération canadienne de 1867 est l acte fondateur du Canada moderne...',
        'assistant',   '2026-04-09 15:00:20', 9),
    ('Comment écrire "occurrence" correctement?',
        'utilisateur', '2026-04-10 14:00:00', 10),
    ('Le mot "occurrence" s écrit avec deux c et deux r: o-c-c-u-r-r-e-n-c-e.',
        'assistant',   '2026-04-10 14:00:10', 10);


-- =============================================================
-- SECTION 2 — UPDATE
-- Modification de données existantes
-- =============================================================

-- 2.1 Mise à jour du numéro de téléphone d'un parent
UPDATE Parent
SET    Telephone = '819-555-9999'
WHERE  id_parent = 1;

-- 2.2 Mise à jour du statut d'une inscription (complétée)
UPDATE Inscription
SET    Statut_inscription = 'complété'
WHERE  id_enfant = 3
  AND  id_cours  = 2;

-- 2.3 Correction d'une note (erreur de saisie corrigée)
UPDATE Note
SET    Valeur      = 90.00,
       Commentaire = 'Note corrigée après révision — très bon travail'
WHERE  id_note = 4;

-- 2.4 Mise à jour de la spécialité d'un professeur
UPDATE Professeur
SET    Specialite = 'Mathématiques et statistiques'
WHERE  id_prof = 1;

-- 2.5 Prolongation de la date limite d'un devoir
UPDATE Devoir
SET    Date_limite = '2026-04-30'
WHERE  id_devoir = 10;

-- 2.6 Mise à jour du rang après validation du concours
UPDATE Participation_Concours
SET    Rang      = 1,
       Resultat  = 'gagnant'
WHERE  id_enfant = 9
  AND  id_concours = 1;

-- 2.7 Mise à jour de l'email d'un enfant inscrit (son parent change)
UPDATE Parent
SET    Email = 'minh.nguyen.updated@email.com'
WHERE  id_parent = 4;

-- 2.8 Mise à jour de la description d'une récompense
UPDATE Recompense
SET    Description = 'Attribuée pour un devoir noté 95% ou plus',
       Points      = 125
WHERE  id_recompense = 1;


-- =============================================================
-- SECTION 3 — DELETE
-- Suppression ciblée de données
-- =============================================================

-- 3.1 Supprimer une inscription annulée
DELETE FROM Inscription
WHERE  id_enfant = 12
  AND  id_cours  = 12
  AND  Statut_inscription = 'suspendu';

-- 3.2 Supprimer une ressource obsolète
DELETE FROM Ressource
WHERE  id_ressource = 4
  AND  URL_ressource = 'https://geogebra.org/equations';

-- 3.3 Supprimer une session ChatIA très courte (moins de 5 minutes — test)
DELETE FROM Session_ChatIA
WHERE  Duree < 5;

-- 3.4 Supprimer un devoir dont la date limite est dépassée depuis > 30 jours
-- (exemple prudent : ciblage par ID spécifique)
-- DELETE FROM Devoir WHERE id_devoir = 99;  -- décommentez si nécessaire


-- =============================================================
-- FIN DU SCRIPT DML
-- =============================================================
