/*
# Rename POGO to PUMMA across all reference data

1. Modified Tables
   - `evaluation_types` - Update code, label, and source_workbook columns replacing POGO/pogo with PUMMA/pumma
   - `questions` - Update question_code column replacing pogo_ prefix with pumma_
   - `domains` - Update code and label columns replacing pogo_/POGO with pumma_/PUMMA
   - `processes` - Update code and label if any POGO refs exist
   - `sub_process_areas` - Update code and label if any POGO refs exist

2. Important Notes
   - Guide tables (question_instruction_guides, question_evidence_guides, question_maturity_guides) use UUID foreign keys - no text to update.
   - `question_expert_guidance` is a VIEW deriving data from underlying tables - no direct update needed.
   - `assessment_type_questions` uses UUID columns (assessment_type_id, question_id) - no text to update.
   - This is a data-only migration, no schema changes.
   - Preserves all IDs and relationships.
*/

-- Update evaluation_types
UPDATE evaluation_types SET
  code = REPLACE(code, 'pogo_', 'pumma_'),
  label = REPLACE(label, 'POGO', 'PUMMA'),
  source_workbook = REPLACE(source_workbook, 'POGO', 'PUMMA')
WHERE code ILIKE '%pogo%' OR label ILIKE '%pogo%' OR source_workbook ILIKE '%pogo%';

-- Update questions (code)
UPDATE questions SET
  question_code = REPLACE(question_code, 'pogo_', 'pumma_')
WHERE question_code ILIKE '%pogo%';

-- Update questions (text content if any)
UPDATE questions SET
  question_text = REPLACE(question_text, 'POGO', 'PUMMA')
WHERE question_text ILIKE '%pogo%';

-- Update domains
UPDATE domains SET
  code = REPLACE(code, 'pogo_', 'pumma_'),
  label = REPLACE(label, 'POGO', 'PUMMA')
WHERE code ILIKE '%pogo%' OR label ILIKE '%pogo%';

-- Update processes
UPDATE processes SET
  code = REPLACE(code, 'pogo_', 'pumma_'),
  label = REPLACE(label, 'POGO', 'PUMMA')
WHERE code ILIKE '%pogo%' OR label ILIKE '%pogo%';

-- Update sub_process_areas
UPDATE sub_process_areas SET
  code = REPLACE(code, 'pogo_', 'pumma_'),
  label = REPLACE(label, 'POGO', 'PUMMA')
WHERE code ILIKE '%pogo%' OR label ILIKE '%pogo%';
