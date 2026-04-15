-- ==================================================================================
-- 03-programmation.sql
-- TP PostgreSQL : Fonctions, Procédures Stockées et Triggers
-- ==================================================================================


-- ============================================================
-- 1️⃣ Procédure : ajouter_etudiant
-- ============================================================
-- Objectif : Ajouter un étudiant avec validations et journalisation
-- Paramètres :
--   nom   TEXT  → Nom complet de l'étudiant
--   age   INT   → Âge de l'étudiant (doit être >= 18)
--   email TEXT  → Adresse courriel valide et unique
-- Retour : aucun (PROCEDURE)
-- ============================================================

CREATE OR REPLACE PROCEDURE ajouter_etudiant(nom TEXT, age INT, email TEXT)
LANGUAGE plpgsql
AS $$
BEGIN
    -- Validation 1 : l'âge doit être >= 18
    IF age < 18 THEN
        RAISE EXCEPTION 'Âge invalide pour % : % ans — minimum requis : 18 ans', nom, age;
    END IF;

    -- Validation 2 : l'email doit respecter le format standard
    IF email !~* '^[^@]+@[^@]+\.[^@]+$' THEN
        RAISE EXCEPTION 'Adresse courriel invalide pour % : "%"', nom, email;
    END IF;

    -- Insertion de l'étudiant dans la table
    INSERT INTO etudiants(nom, age, email)
    VALUES (nom, age, email);

    -- Journalisation de l'action dans la table logs
    INSERT INTO logs(action)
    VALUES ('Ajout étudiant : ' || nom || ' (' || email || ')');

    -- Confirmation de succès
    RAISE NOTICE 'Succès : étudiant "%" ajouté avec l''adresse "%"', nom, email;

EXCEPTION
    WHEN unique_violation THEN
        -- Cas spécifique : email déjà utilisé
        RAISE NOTICE 'Erreur : l''adresse "%" est déjà enregistrée dans la base.', email;
    WHEN others THEN
        -- Tous les autres cas d'erreur
        RAISE NOTICE 'Erreur lors de l''ajout de "%" : %', nom, SQLERRM;
END;
$$;


-- ============================================================
-- 2️⃣ Fonction : nombre_etudiants_par_age
-- ============================================================
-- Objectif : Retourner le nombre d'étudiants dans une tranche d'âge donnée
-- Paramètres :
--   min_age INT → Âge minimum (inclus)
--   max_age INT → Âge maximum (inclus)
-- Retour : INT → nombre d'étudiants dans la tranche
-- Exemple : SELECT nombre_etudiants_par_age(18, 25);
-- ============================================================

CREATE OR REPLACE FUNCTION nombre_etudiants_par_age(min_age INT, max_age INT)
RETURNS INT
LANGUAGE plpgsql
AS $$
DECLARE
    total INT;
BEGIN
    -- Validation : la tranche doit être logique
    IF min_age > max_age THEN
        RAISE EXCEPTION 'Plage d''âge invalide : min (%) ne peut pas être supérieur à max (%)', min_age, max_age;
    END IF;

    -- Compter les étudiants dans la tranche d'âge
    SELECT COUNT(*) INTO total
    FROM etudiants
    WHERE age BETWEEN min_age AND max_age;

    -- Message informatif pour le débogage
    RAISE NOTICE 'Nombre d''étudiants entre % et % ans : %', min_age, max_age, total;

    RETURN total;
END;
$$;


-- ============================================================
-- 3️⃣ Procédure : inscrire_etudiant_cours
-- ============================================================
-- Objectif : Inscrire un étudiant existant à un cours existant
-- Paramètres :
--   etudiant_email TEXT → Courriel identifiant l'étudiant
--   cours_nom      TEXT → Nom du cours
-- Retour : aucun (PROCEDURE)
-- ============================================================

CREATE OR REPLACE PROCEDURE inscrire_etudiant_cours(etudiant_email TEXT, cours_nom TEXT)
LANGUAGE plpgsql
AS $$
DECLARE
    etudiant_id INT;
    cours_id    INT;
BEGIN
    -- Étape 1 : récupérer l'ID de l'étudiant et vérifier son existence
    SELECT id INTO etudiant_id
    FROM etudiants
    WHERE email = etudiant_email;

    IF etudiant_id IS NULL THEN
        RAISE EXCEPTION 'Étudiant introuvable avec le courriel : "%"', etudiant_email;
    END IF;

    -- Étape 2 : récupérer l'ID du cours et vérifier son existence
    SELECT id INTO cours_id
    FROM cours
    WHERE nom = cours_nom;

    IF cours_id IS NULL THEN
        RAISE EXCEPTION 'Cours introuvable : "%"', cours_nom;
    END IF;

    -- Étape 3 : vérifier que l'inscription n'existe pas déjà
    IF EXISTS (
        SELECT 1
        FROM inscriptions
        WHERE inscriptions.etudiant_id = etudiant_id
          AND inscriptions.cours_id    = cours_id
    ) THEN
        RAISE EXCEPTION 'L''étudiant "%" est déjà inscrit au cours "%"', etudiant_email, cours_nom;
    END IF;

    -- Étape 4 : créer l'inscription
    INSERT INTO inscriptions(etudiant_id, cours_id)
    VALUES (etudiant_id, cours_id);

    -- Journalisation
    INSERT INTO logs(action)
    VALUES ('Inscription : étudiant "' || etudiant_email || '" → cours "' || cours_nom || '"');

    -- Confirmation
    RAISE NOTICE 'Inscription réussie : "%" inscrit au cours "%"', etudiant_email, cours_nom;

EXCEPTION
    WHEN others THEN
        RAISE NOTICE 'Erreur lors de l''inscription : %', SQLERRM;
END;
$$;


-- ============================================================
-- 4️⃣ Trigger : validation avant insertion d'un étudiant
-- ============================================================
-- Objectif : Valider âge et email AVANT toute insertion dans etudiants
-- Déclencheur : BEFORE INSERT ON etudiants
-- ============================================================

CREATE OR REPLACE FUNCTION valider_etudiant()
RETURNS trigger AS $$
BEGIN
    -- Validation de l'âge
    IF NEW.age < 18 THEN
        RAISE EXCEPTION
            'Insertion refusée — âge invalide pour "%" : % ans (minimum : 18 ans)',
            NEW.nom, NEW.age;
    END IF;

    -- Validation du format du courriel
    IF NEW.email !~* '^[^@]+@[^@]+\.[^@]+$' THEN
        RAISE EXCEPTION
            'Insertion refusée — courriel invalide pour "%" : "%"',
            NEW.nom, NEW.email;
    END IF;

    -- Si tout est valide, on laisse passer la ligne
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Association du trigger à la table etudiants
CREATE TRIGGER trg_valider_etudiant
BEFORE INSERT ON etudiants
FOR EACH ROW
EXECUTE FUNCTION valider_etudiant();


-- ============================================================
-- 5️⃣ Trigger : log automatique sur etudiants et inscriptions
-- ============================================================
-- Objectif : Journaliser toutes les modifications (INSERT, UPDATE, DELETE)
-- Utilise TG_OP (type d'opération), NEW et OLD pour des logs détaillés
-- ============================================================

CREATE OR REPLACE FUNCTION log_action()
RETURNS trigger AS $$
DECLARE
    detail TEXT;
BEGIN
    -- Construction d'un message de log selon l'opération
    IF TG_OP = 'INSERT' THEN
        detail := 'INSERT sur ' || TG_TABLE_NAME || ' — nouveau : ' || COALESCE(NEW.nom::TEXT, NEW.id::TEXT);

    ELSIF TG_OP = 'UPDATE' THEN
        detail := 'UPDATE sur ' || TG_TABLE_NAME
               || ' — avant : ' || COALESCE(OLD.nom::TEXT, OLD.id::TEXT)
               || ' / après : ' || COALESCE(NEW.nom::TEXT, NEW.id::TEXT);

    ELSIF TG_OP = 'DELETE' THEN
        detail := 'DELETE sur ' || TG_TABLE_NAME || ' — supprimé : ' || COALESCE(OLD.nom::TEXT, OLD.id::TEXT);
        -- Pour un DELETE, on retourne OLD car NEW n'existe pas
        INSERT INTO logs(action) VALUES (detail);
        RETURN OLD;
    END IF;

    -- Enregistrement dans la table logs
    INSERT INTO logs(action) VALUES (detail);

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Trigger sur la table etudiants
CREATE TRIGGER trg_log_etudiant
AFTER INSERT OR UPDATE OR DELETE ON etudiants
FOR EACH ROW
EXECUTE FUNCTION log_action();

-- Trigger sur la table inscriptions
-- Note : la table inscriptions n'a pas de colonne "nom", on utilise id
CREATE TRIGGER trg_log_inscription
AFTER INSERT OR UPDATE OR DELETE ON inscriptions
FOR EACH ROW
EXECUTE FUNCTION log_action();
