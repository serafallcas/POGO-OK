DO $$ BEGIN
  IF NOT EXISTS (
    SELECT 1 FROM pg_constraint WHERE conname = 'maturity_statements_model_process_unique'
  ) THEN
    DELETE FROM maturity_statements ms
    USING maturity_statements newer
    WHERE ms.maturity_model_id = newer.maturity_model_id
      AND ms.process_area IS NOT DISTINCT FROM newer.process_area
      AND ms.process_area IS NOT NULL
      AND ms.id <> newer.id
      AND (ms.updated_at, ms.id) < (newer.updated_at, newer.id);

    ALTER TABLE maturity_statements
      ADD CONSTRAINT maturity_statements_model_process_unique UNIQUE (maturity_model_id, process_area);
  END IF;
END $$;