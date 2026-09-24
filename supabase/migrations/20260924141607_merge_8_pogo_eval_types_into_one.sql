/*
# Merge 8 POGO evaluation_types into a single unified "pogo" type

## Summary
Fuses the 8 legacy evaluation_types (pogo_1, pogo_2_a through pogo_2_f) into one
consolidated type with code='pogo', label='POGO'. The 8 originals were an artificial
split of the same APQC framework and should always have been a single evaluation type.

## Changes
- INSERT: 1 new evaluation_type row (code='pogo', label='POGO', is_active=true).
- UPDATE: Re-point all rows in assessments, domains, processes, questionnaires,
  and questions from the 8 old IDs to the new unified ID.
- UPDATE: Deactivate (is_active=false) the 8 old evaluation_types. No rows are deleted.

## Impact (pre-migration baseline)
- 2 assessments (with 73 assessment_responses) preserved via FK on assessments.
- 38 domains, 76 processes, 92 questions re-pointed.
- 0 questionnaires affected.
- Zero frontend code changes required (no hardcoded pogo_* codes found).

## Security
- No RLS or policy changes.

## Important Notes
1. This migration is PURELY ADDITIVE + UPDATE -- no physical deletions.
2. The 8 old types are DEACTIVATED, not removed, for full traceability.
3. The 2 live assessments and their 73 responses are explicitly in scope.
*/

DO $$
DECLARE
  v_new_id uuid;
  v_old_codes text[] := ARRAY['pogo_1','pogo_2_a','pogo_2_b','pogo_2_c','pogo_2_d_a','pogo_2_d_b','pogo_2_e','pogo_2_f'];
BEGIN
  -- 1. Create the new consolidated "POGO" type
  INSERT INTO evaluation_types (code, label, description, is_active, sort_order)
  VALUES (
    'pogo',
    'POGO',
    'Referentiel POGO consolide -- fusion le 24/09/2026 des 8 anciens types pogo_1 et pogo_2_a a pogo_2_f, qui etaient un decoupage artificiel du meme referentiel APQC et auraient toujours du etre un seul type d''evaluation.',
    true,
    0
  )
  RETURNING id INTO v_new_id;

  -- 2. Re-point all 5 dependent tables to the new type
  UPDATE assessments SET evaluation_type_id = v_new_id
    WHERE evaluation_type_id IN (SELECT id FROM evaluation_types WHERE code = ANY(v_old_codes));

  UPDATE domains SET evaluation_type_id = v_new_id
    WHERE evaluation_type_id IN (SELECT id FROM evaluation_types WHERE code = ANY(v_old_codes));

  UPDATE processes SET evaluation_type_id = v_new_id
    WHERE evaluation_type_id IN (SELECT id FROM evaluation_types WHERE code = ANY(v_old_codes));

  UPDATE questionnaires SET evaluation_type_id = v_new_id
    WHERE evaluation_type_id IN (SELECT id FROM evaluation_types WHERE code = ANY(v_old_codes));

  UPDATE questions SET evaluation_type_id = v_new_id
    WHERE evaluation_type_id IN (SELECT id FROM evaluation_types WHERE code = ANY(v_old_codes));

  -- 3. Deactivate (NOT delete) the 8 old types
  UPDATE evaluation_types SET is_active = false, updated_at = now()
    WHERE code = ANY(v_old_codes);
END $$;