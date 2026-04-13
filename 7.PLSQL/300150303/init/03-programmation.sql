-- ==================================================================================
-- 03-programmation.sql
-- TP PostgreSQL : Fonctions, Procédures Stockées et Triggers
-- ==================================================================================


-- ============================================================
-- 1️⃣ Procédure : ajouter_etudiant
-- ============================================================

CREATE OR REPLACE PROCEDURE ajouter_etudiant(nom TEXT, age INT, email TEXT)
LANGUAGE plpgsql
AS $$
BEGIN
    -- Vérifier que l'âge est >= 18
    IF age < 18 THEN
        RAISE EXCEPTION 'Age invalide pour % : % ans (minimum 18 ans requis)', nom, age;
    END IF;

    -- Vérifier que l'email est valide
    IF email !~* '^[^@]+@[^@]+\.[^@]+$' THEN
        RAISE EXCEPTION 'Email invalide pour % : %', nom, email;
    END IF;

    -- Insertion de l'étudiant
    INSERT INTO etudiants(nom, age, email)
    VALUES (nom, age, email);

    -- Journalisation
    INSERT INTO logs(action)
    VALUES ('Ajout étudiant : ' || nom || ' (age: ' || age || ', email: ' || email || ')');

    -- Confirmation
    RAISE NOTICE 'Étudiant ajouté avec succès : % (%, %)', nom, age, email;

EXCEPTION
    WHEN unique_violation THEN
        RAISE NOTICE 'Erreur : l''email % est déjà utilisé par un autre étudiant.', email;
    WHEN others THEN
        RAISE NOTICE 'Erreur lors de l''ajout de % : %', nom, SQLERRM;
END;
$$;


-- ============================================================
-- 2️⃣ Fonction : nombre_etudiants_par_age
-- ============================================================

CREATE OR REPLACE FUNCTION nombre_etudiants_par_age(min_age INT, max_age INT)
RETURNS INT
LANGUAGE plpgsql
AS $$
DECLARE
    total INT;
BEGIN
    -- Validation des paramètres
    IF min_age < 0 OR max_age < 0 THEN
        RAISE EXCEPTION 'Les âges doivent être positifs (min: %, max: %)', min_age, max_age;
    END IF;

    IF min_age > max_age THEN
        RAISE EXCEPTION 'L''âge minimum (%) ne peut pas être supérieur à l''âge maximum (%)', min_age, max_age;
    END IF;

    SELECT COUNT(*) INTO total
    FROM etudiants
    WHERE age BETWEEN min_age AND max_age;

    RAISE NOTICE 'Nombre d''étudiants entre % et % ans : %', min_age, max_age, total;

    RETURN total;
END;
$$;


-- ============================================================
-- 3️⃣ Procédure : inscrire_etudiant_cours
-- ============================================================

CREATE OR REPLACE PROCEDURE inscrire_etudiant_cours(etudiant_email TEXT, cours_nom TEXT)
LANGUAGE plpgsql
AS $$
DECLARE
    v_etudiant_id INT;
    v_cours_id INT;
BEGIN
    -- Récupérer id étudiant et vérifier existence
    SELECT id INTO v_etudiant_id FROM etudiants WHERE email = etudiant_email;
    IF v_etudiant_id IS NULL THEN
        RAISE EXCEPTION 'Étudiant non trouvé avec l''email : %', etudiant_email;
    END IF;

    -- Récupérer id cours et vérifier existence
    SELECT id INTO v_cours_id FROM cours WHERE nom = cours_nom;
    IF v_cours_id IS NULL THEN
        RAISE EXCEPTION 'Cours non trouvé : %', cours_nom;
    END IF;

    -- Vérifier que l'inscription n'existe pas déjà
    IF EXISTS(
        SELECT 1 FROM inscriptions
        WHERE etudiant_id = v_etudiant_id AND cours_id = v_cours_id
    ) THEN
        RAISE EXCEPTION 'L''étudiant % est déjà inscrit au cours %', etudiant_email, cours_nom;
    END IF;

    -- Insertion dans inscriptions
    INSERT INTO inscriptions(etudiant_id, cours_id)
    VALUES (v_etudiant_id, v_cours_id);

    -- Journalisation
    INSERT INTO logs(action)
    VALUES ('Inscription : ' || etudiant_email || ' -> cours : ' || cours_nom);

    RAISE NOTICE 'Inscription réussie : % inscrit au cours %', etudiant_email, cours_nom;

EXCEPTION
    WHEN others THEN
        RAISE NOTICE 'Erreur inscription : %', SQLERRM;
END;
$$;


-- ============================================================
-- 4️⃣ Trigger : validation avant insertion d'un étudiant
-- ============================================================

CREATE OR REPLACE FUNCTION valider_etudiant()
RETURNS trigger AS $$
BEGIN
    -- Validation de l'âge
    IF NEW.age < 18 THEN
        RAISE EXCEPTION 'Trigger - Age invalide pour % : % ans (minimum 18 ans)', NEW.nom, NEW.age;
    END IF;

    -- Validation du format email
    IF NEW.email !~* '^[^@]+@[^@]+\.[^@]+$' THEN
        RAISE EXCEPTION 'Trigger - Email invalide pour % : %', NEW.nom, NEW.email;
    END IF;

    RAISE NOTICE 'Trigger validation OK pour : %', NEW.nom;

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trg_valider_etudiant
BEFORE INSERT ON etudiants
FOR EACH ROW
EXECUTE FUNCTION valider_etudiant();


-- ============================================================
-- 5️⃣ Trigger : log automatique sur etudiants et inscriptions
-- ============================================================

CREATE OR REPLACE FUNCTION log_action()
RETURNS trigger AS $$
DECLARE
    details TEXT;
BEGIN
    IF TG_OP = 'INSERT' THEN
        details := 'Nouveau : ' || NEW.nom;
    ELSIF TG_OP = 'UPDATE' THEN
        details := 'Modifié : ' || OLD.nom || ' -> ' || NEW.nom;
    ELSIF TG_OP = 'DELETE' THEN
        details := 'Supprimé : ' || OLD.nom;
        INSERT INTO logs(action)
        VALUES (TG_OP || ' sur ' || TG_TABLE_NAME || ' | ' || details);
        RETURN OLD;
    END IF;

    INSERT INTO logs(action)
    VALUES (TG_OP || ' sur ' || TG_TABLE_NAME || ' | ' || details);

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trg_log_etudiant
AFTER INSERT OR UPDATE OR DELETE ON etudiants
FOR EACH ROW
EXECUTE FUNCTION log_action();

CREATE TRIGGER trg_log_inscription
AFTER INSERT OR UPDATE OR DELETE ON inscriptions
FOR EACH ROW
EXECUTE FUNCTION log_action();
