-- ==================================================================================
-- 03-programmation.sql
-- TP PostgreSQL — Fonctions, Procédures Stockées et Triggers
-- Étudiante : Aroua Mohand Tahar
-- Matricule : 300150284
-- Prérequis : exécuter 01-ddl.sql puis 02-dml.sql
-- ==================================================================================

-- ============================================================
-- 1. Procédure : ajouter_etudiant
-- But : ajouter un étudiant après validation des données
-- ============================================================

CREATE OR REPLACE PROCEDURE ajouter_etudiant(
    p_nom TEXT,
    p_age INT,
    p_email TEXT
)
LANGUAGE plpgsql
AS $$
BEGIN
    IF p_age < 18 THEN
        RAISE EXCEPTION 'Ajout refusé : % a % ans, minimum requis = 18 ans.', p_nom, p_age;
    END IF;

    IF p_email !~* '^[^@]+@[^@]+\.[^@]+$' THEN
        RAISE EXCEPTION 'Ajout refusé : adresse courriel invalide pour % (%).', p_nom, p_email;
    END IF;

    INSERT INTO etudiants (nom, age, email)
    VALUES (p_nom, p_age, p_email);

    INSERT INTO logs(action)
    VALUES ('Ajout étudiant réussi : ' || p_nom || ' / ' || p_email);

    RAISE NOTICE 'Étudiant ajouté : % (% ans)', p_nom, p_age;

EXCEPTION
    WHEN unique_violation THEN
        RAISE NOTICE 'Impossible d''ajouter % : le courriel % existe déjà.', p_nom, p_email;
    WHEN others THEN
        RAISE NOTICE 'Erreur lors de l''ajout de % : %', p_nom, SQLERRM;
END;
$$;


-- ============================================================
-- 2. Fonction : nombre_etudiants_par_age
-- But : compter les étudiants dans une tranche d’âge
-- ============================================================

CREATE OR REPLACE FUNCTION nombre_etudiants_par_age(
    p_age_min INT,
    p_age_max INT
)
RETURNS INT
LANGUAGE plpgsql
AS $$
DECLARE
    v_total INT;
BEGIN
    IF p_age_min > p_age_max THEN
        RAISE EXCEPTION 'Intervalle invalide : % est supérieur à %.', p_age_min, p_age_max;
    END IF;

    SELECT COUNT(*)
    INTO v_total
    FROM etudiants
    WHERE age BETWEEN p_age_min AND p_age_max;

    RAISE NOTICE 'Nombre d''étudiants entre % et % ans : %', p_age_min, p_age_max, v_total;

    RETURN v_total;
END;
$$;


-- ============================================================
-- 3. Procédure : inscrire_etudiant_cours
-- But : inscrire un étudiant à un cours existant
-- ============================================================

CREATE OR REPLACE PROCEDURE inscrire_etudiant_cours(
    p_email_etudiant TEXT,
    p_nom_cours TEXT
)
LANGUAGE plpgsql
AS $$
DECLARE
    v_id_etudiant INT;
    v_id_cours INT;
BEGIN
    SELECT id
    INTO v_id_etudiant
    FROM etudiants
    WHERE email = p_email_etudiant;

    IF v_id_etudiant IS NULL THEN
        RAISE EXCEPTION 'Aucun étudiant trouvé avec le courriel %.', p_email_etudiant;
    END IF;

    SELECT id
    INTO v_id_cours
    FROM cours
    WHERE nom = p_nom_cours;

    IF v_id_cours IS NULL THEN
        RAISE EXCEPTION 'Le cours % n''existe pas.', p_nom_cours;
    END IF;

    IF EXISTS (
        SELECT 1
        FROM inscriptions
        WHERE etudiant_id = v_id_etudiant
          AND cours_id = v_id_cours
    ) THEN
        RAISE EXCEPTION 'Inscription déjà présente pour % dans le cours %.', p_email_etudiant, p_nom_cours;
    END IF;

    INSERT INTO inscriptions(etudiant_id, cours_id)
    VALUES (v_id_etudiant, v_id_cours);

    INSERT INTO logs(action)
    VALUES ('Nouvelle inscription : ' || p_email_etudiant || ' -> ' || p_nom_cours);

    RAISE NOTICE 'Inscription enregistrée : % -> %', p_email_etudiant, p_nom_cours;

EXCEPTION
    WHEN others THEN
        RAISE NOTICE 'Erreur pendant l''inscription : %', SQLERRM;
END;
$$;


-- ============================================================
-- 4. Trigger de validation sur la table etudiants
-- But : empêcher les insertions invalides directement en table
-- ============================================================

CREATE OR REPLACE FUNCTION verifier_donnees_etudiant()
RETURNS trigger
LANGUAGE plpgsql
AS $$
BEGIN
    IF NEW.age < 18 THEN
        RAISE EXCEPTION 'Trigger validation : âge invalide pour % (% ans).', NEW.nom, NEW.age;
    END IF;

    IF NEW.email !~* '^[^@]+@[^@]+\.[^@]+$' THEN
        RAISE EXCEPTION 'Trigger validation : email invalide pour % (%).', NEW.nom, NEW.email;
    END IF;

    RETURN NEW;
END;
$$;

CREATE TRIGGER trg_verifier_etudiant
BEFORE INSERT ON etudiants
FOR EACH ROW
EXECUTE FUNCTION verifier_donnees_etudiant();


-- ============================================================
-- 5. Trigger de journalisation
-- But : garder une trace des opérations sur etudiants et inscriptions
-- ============================================================

CREATE OR REPLACE FUNCTION journaliser_action()
RETURNS trigger
LANGUAGE plpgsql
AS $$
BEGIN
    IF TG_OP = 'DELETE' THEN
        INSERT INTO logs(action)
        VALUES ('Suppression dans ' || TG_TABLE_NAME || ' - id=' || OLD.id::TEXT);
        RETURN OLD;
    ELSE
        INSERT INTO logs(action)
        VALUES (TG_OP || ' dans ' || TG_TABLE_NAME || ' - id=' || NEW.id::TEXT);
        RETURN NEW;
    END IF;
END;
$$;

CREATE TRIGGER trg_logs_etudiants
AFTER INSERT OR UPDATE OR DELETE ON etudiants
FOR EACH ROW
EXECUTE FUNCTION journaliser_action();

CREATE TRIGGER trg_logs_inscriptions
AFTER INSERT OR UPDATE OR DELETE ON inscriptions
FOR EACH ROW
EXECUTE FUNCTION journaliser_action();
