-- ==================================================================================
-- tests/test.sql
-- Jeu de tests complet pour valider les procédures, fonctions et triggers
-- ==================================================================================

\echo '============================================'
\echo '1. TEST : Insertion valide'
\echo '============================================'
CALL ajouter_etudiant('Ali', 22, 'ali@email.com');

\echo '============================================'
\echo '2. TEST : Insertion refusée — âge < 18'
\echo '============================================'
DO $$
BEGIN
    BEGIN
        CALL ajouter_etudiant('Bob', 15, 'bob@email.com');
    EXCEPTION
        WHEN others THEN
            RAISE NOTICE 'Erreur attendue OK : %', SQLERRM;
    END;
END;
$$;

\echo '============================================'
\echo '3. TEST : Insertion refusée — email invalide'
\echo '============================================'
DO $$
BEGIN
    BEGIN
        CALL ajouter_etudiant('Sara', 20, 'emailsansarobase');
    EXCEPTION
        WHEN others THEN
            RAISE NOTICE 'Erreur attendue OK : %', SQLERRM;
    END;
END;
$$;

\echo '============================================'
\echo '4. TEST : Email en double'
\echo '============================================'
DO $$
BEGIN
    BEGIN
        CALL ajouter_etudiant('Ali2', 25, 'ali@email.com');
    EXCEPTION
        WHEN others THEN
            RAISE NOTICE 'Erreur attendue OK : %', SQLERRM;
    END;
END;
$$;

\echo '============================================'
\echo '5. TEST : Fonction nombre_etudiants_par_age'
\echo '============================================'
SELECT nombre_etudiants_par_age(18, 25) AS etudiants_18_25;

\echo '============================================'
\echo '6. TEST : Tranche invalide (min > max)'
\echo '============================================'
DO $$
BEGIN
    BEGIN
        PERFORM nombre_etudiants_par_age(30, 20);
    EXCEPTION
        WHEN others THEN
            RAISE NOTICE 'Erreur attendue OK : %', SQLERRM;
    END;
END;
$$;

\echo '============================================'
\echo '7. TEST : Inscription valide'
\echo '============================================'
CALL inscrire_etudiant_cours('ali@email.com', 'Base de données');

\echo '============================================'
\echo '8. TEST : Inscription doublon'
\echo '============================================'
DO $$
BEGIN
    BEGIN
        CALL inscrire_etudiant_cours('ali@email.com', 'Base de données');
    EXCEPTION
        WHEN others THEN
            RAISE NOTICE 'Erreur attendue OK : %', SQLERRM;
    END;
END;
$$;

\echo '============================================'
\echo '9. TEST : Étudiant introuvable'
\echo '============================================'
DO $$
BEGIN
    BEGIN
        CALL inscrire_etudiant_cours('inconnu@email.com', 'Base de données');
    EXCEPTION
        WHEN others THEN
            RAISE NOTICE 'Erreur attendue OK : %', SQLERRM;
    END;
END;
$$;

\echo '============================================'
\echo '10. VERIFICATION : Table etudiants'
\echo '============================================'
SELECT * FROM etudiants;

\echo '============================================'
\echo '11. VERIFICATION : Table inscriptions'
\echo '============================================'
SELECT * FROM inscriptions;

\echo '============================================'
\echo '12. VERIFICATION : Table logs'
\echo '============================================'
SELECT * FROM logs ORDER BY date_action;
