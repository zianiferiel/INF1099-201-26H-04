-- Fonction
CREATE OR REPLACE FUNCTION ma_fonction(param INT)
RETURNS INT LANGUAGE plpgsql AS $$
BEGIN
    RETURN param * 2;
END;
$$;

-- Procédure
CREATE OR REPLACE PROCEDURE ma_procedure(param TEXT)
LANGUAGE plpgsql AS $$
BEGIN
    INSERT INTO logs(action) VALUES (param);
    RAISE NOTICE 'OK : %', param;
END;
$$;

-- Trigger
CREATE OR REPLACE FUNCTION ma_fonction_trigger()
RETURNS trigger AS $$
BEGIN
    -- NEW = nouvelle ligne, OLD = ancienne ligne
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER mon_trigger
BEFORE INSERT ON ma_table
FOR EACH ROW EXECUTE FUNCTION ma_fonction_trigger();
