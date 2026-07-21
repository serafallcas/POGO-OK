/*
# Revert PUMMA back to POGO across all reference data

1. Modified Tables
   - `evaluation_types` - Revert code, label, and source_workbook from PUMMA back to POGO
   - `questions` - Revert question_code from pumma_ back to pogo_
   - `domains` - Revert code and label from pumma_/PUMMA back to pogo_/POGO
   - `processes` - Revert code and label if any PUMMA refs exist
   - `sub_process_areas` - Revert code and label if any PUMMA refs exist

2. Important Notes
   - Exact reversal of the previous rename migration.
   - Data-only, no schema changes. All IDs and foreign keys preserved.
*/

UPDATE evaluation_types SET
  code = REPLACE(code, 'pumma_', 'pogo_'),
  label = REPLACE(label, 'PUMMA', 'POGO'),
  source_workbook = REPLACE(source_workbook, 'PUMMA', 'POGO')
WHERE code ILIKE '%pumma%' OR label ILIKE '%pumma%' OR source_workbook ILIKE '%pumma%';

UPDATE questions SET
  question_code = REPLACE(question_code, 'pumma_', 'pogo_')
WHERE question_code ILIKE '%pumma%';

UPDATE questions SET
  question_text = REPLACE(question_text, 'PUMMA', 'POGO')
WHERE question_text ILIKE '%pumma%';

UPDATE domains SET
  code = REPLACE(code, 'pumma_', 'pogo_'),
  label = REPLACE(label, 'PUMMA', 'POGO')
WHERE code ILIKE '%pumma%' OR label ILIKE '%pumma%';

UPDATE processes SET
  code = REPLACE(code, 'pumma_', 'pogo_'),
  label = REPLACE(label, 'PUMMA', 'POGO')
WHERE code ILIKE '%pumma%' OR label ILIKE '%pumma%';

UPDATE sub_process_areas SET
  code = REPLACE(code, 'pumma_', 'pogo_'),
  label = REPLACE(label, 'PUMMA', 'POGO')
WHERE code ILIKE '%pumma%' OR label ILIKE '%pumma%';
