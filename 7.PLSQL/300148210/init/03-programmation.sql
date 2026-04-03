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
    -- Validation âge
    IF age < 18 THEN
        RAISE EXCEPTION 'Age invalide pour % (doit être >= 18)', nom;
    END IF;

    -- Validation email format
    IF email !~* '^[^@]+@[^@]+\.[^@]+$' THEN
        RAISE EXCEPTION 'Email invalide pour %', nom;
    END IF;

    -- Vérification unicité email
    IF EXISTS (SELECT 1 FROM etudiants WHERE email = email) THEN
        RAISE EXCEPTION 'Email déjà utilisé : %', email;
    END IF;

    -- Insertion
    INSERT INTO etudiants(nom, age, email)
    VALUES (nom, age, email);

    -- Log
    INSERT INTO logs(action)
    VALUES ('Ajout étudiant : ' || nom);

    -- Message succès
    RAISE NOTICE 'Succès : étudiant ajouté -> % (% ans)', nom, age;

EXCEPTION
    WHEN others THEN
        RAISE NOTICE 'Erreur ajout étudiant [%] : %', nom, SQLERRM;
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
    IF min_age > max_age THEN
        RAISE EXCEPTION 'Intervalle invalide (% > %)', min_age, max_age;
    END IF;

    SELECT COUNT(*) INTO total
    FROM etudiants
    WHERE age BETWEEN min_age AND max_age;

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
    etudiant_id INT;
    cours_id INT;
BEGIN
    -- Récupération étudiant
    SELECT id INTO etudiant_id 
    FROM etudiants 
    WHERE email = etudiant_email;

    IF etudiant_id IS NULL THEN
        RAISE EXCEPTION 'Etudiant non trouvé : %', etudiant_email;
    END IF;

    -- Récupération cours
    SELECT id INTO cours_id 
    FROM cours 
    WHERE nom = cours_nom;

    IF cours_id IS NULL THEN
        RAISE EXCEPTION 'Cours non trouvé : %', cours_nom;
    END IF;

    -- Vérifier inscription existante
    IF EXISTS (
        SELECT 1 
        FROM inscriptions 
        WHERE etudiant_id = etudiant_id 
        AND cours_id = cours_id
    ) THEN
        RAISE EXCEPTION 'Déjà inscrit à ce cours';
    END IF;

    -- Insertion
    INSERT INTO inscriptions(etudiant_id, cours_id)
    VALUES (etudiant_id, cours_id);

    -- Log
    INSERT INTO logs(action)
    VALUES ('Inscription : ' || etudiant_email || ' -> ' || cours_nom);

    RAISE NOTICE 'Inscription réussie : % -> %', etudiant_email, cours_nom;

EXCEPTION
    WHEN others THEN
        RAISE NOTICE 'Erreur inscription [% -> %] : %', etudiant_email, cours_nom, SQLERRM;
END;
$$;

-- ============================================================
-- 4️⃣ Trigger validation étudiant
-- ============================================================

CREATE OR REPLACE FUNCTION valider_etudiant()
RETURNS trigger AS $$
BEGIN
    IF NEW.age < 18 THEN
        RAISE EXCEPTION 'Age invalide (% ans) pour %', NEW.age, NEW.nom;
    END IF;

    IF NEW.email !~* '^[^@]+@[^@]+\.[^@]+$' THEN
        RAISE EXCEPTION 'Email invalide pour % : %', NEW.nom, NEW.email;
    END IF;

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trg_valider_etudiant
BEFORE INSERT ON etudiants
FOR EACH ROW
EXECUTE FUNCTION valider_etudiant();

-- ============================================================
-- 5️⃣ Trigger log avancé
-- ============================================================

CREATE OR REPLACE FUNCTION log_action()
RETURNS trigger AS $$
DECLARE
    info TEXT;
BEGIN
    IF TG_OP = 'INSERT' THEN
        info := 'INSERT ' || TG_TABLE_NAME || ' -> ' || COALESCE(NEW.nom::text, 'N/A');
        INSERT INTO logs(action) VALUES (info);
        RETURN NEW;

    ELSIF TG_OP = 'UPDATE' THEN
        info := 'UPDATE ' || TG_TABLE_NAME || ' : ' || 
                COALESCE(OLD.nom::text, 'N/A') || ' -> ' || COALESCE(NEW.nom::text, 'N/A');
        INSERT INTO logs(action) VALUES (info);
        RETURN NEW;

    ELSIF TG_OP = 'DELETE' THEN
        info := 'DELETE ' || TG_TABLE_NAME || ' -> ' || COALESCE(OLD.nom::text, 'N/A');
        INSERT INTO logs(action) VALUES (info);
        RETURN OLD;
    END IF;

    RETURN NULL;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trg_log_etudiant
AFTER INSERT OR UPDATE OR DELETE ON etudiants
FOR EACH ROW
EXECUTE FUNCTION log_action();

CREATE TRIGGER trg_log_inscription
AFTER INSERT OR UPDATE OR DELETE
