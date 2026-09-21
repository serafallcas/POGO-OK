/*
# Cleanup: duplicate policies, legacy tables, and unhardened reference tables

## Changes

1. **Drop 8 duplicate old policies** on `recommendation_library` and `question_finding_mappings`.
   These were created by the findings-engine migration and never dropped by the RLS-hardening migration,
   which created `scoped_*` replacements. Removing the old ones eliminates the duplicates.

2. **Drop legacy v1 tables** `findings` and `improvement_actions`.
   Both are empty (0 rows), fully replaced by `assessment_findings_v2` and `finding_action_plans`,
   and no longer referenced by any application code. CASCADE removes their 6 USING(true) policies.

3. **Harden 5 expert-guidance reference tables** (`assessment_type_questions`,
   `question_evidence_guides`, `question_instruction_guides`, `question_maturity_guides`,
   `sub_process_areas`). Replace the old `auth_read_*` SELECT USING(true) and `admin_write_*` FOR ALL
   (which used the defunct `is_pumma_reference_admin()`) with the standard 4-policy model:
   SELECT for all authenticated, INSERT/UPDATE/DELETE for is_admin() only.

## Security
- Eliminates all remaining USING(true) policies on non-public-by-design tables.
- Removes 8 redundant policies that could cause confusion.
- Standardizes write protection on 5 tables to use `is_admin()`.

## Notes
- No data is lost (legacy tables were confirmed empty).
- Net policy count should decrease by ~19 (8 duplicates + 6 from dropped tables + 10 old policies on 5 tables = 24 dropped, +20 new scoped policies on 5 tables = net -4, but also -6 from CASCADE = net -10).
*/

-- ============================================================
-- 1. Drop 8 duplicate old policies on recommendation_library & question_finding_mappings
-- ============================================================

DROP POLICY IF EXISTS "select_qfm" ON question_finding_mappings;
DROP POLICY IF EXISTS "insert_qfm" ON question_finding_mappings;
DROP POLICY IF EXISTS "update_qfm" ON question_finding_mappings;
DROP POLICY IF EXISTS "delete_qfm" ON question_finding_mappings;

DROP POLICY IF EXISTS "select_recommendations" ON recommendation_library;
DROP POLICY IF EXISTS "insert_recommendations" ON recommendation_library;
DROP POLICY IF EXISTS "update_recommendations" ON recommendation_library;
DROP POLICY IF EXISTS "delete_recommendations" ON recommendation_library;

-- ============================================================
-- 2. Drop legacy v1 tables (CASCADE removes their policies)
-- ============================================================

DROP TABLE IF EXISTS findings CASCADE;
DROP TABLE IF EXISTS improvement_actions CASCADE;

-- ============================================================
-- 3. Harden 5 expert-guidance reference tables
--    Drop old policies, create standardized scoped_* policies
-- ============================================================

-- --- assessment_type_questions ---
DROP POLICY IF EXISTS "auth_read_assessment_type_questions" ON assessment_type_questions;
DROP POLICY IF EXISTS "admin_write_assessment_type_questions" ON assessment_type_questions;

DROP POLICY IF EXISTS "scoped_select_assessment_type_questions" ON assessment_type_questions;
CREATE POLICY "scoped_select_assessment_type_questions" ON assessment_type_questions
  FOR SELECT TO authenticated USING (true);

DROP POLICY IF EXISTS "scoped_insert_assessment_type_questions" ON assessment_type_questions;
CREATE POLICY "scoped_insert_assessment_type_questions" ON assessment_type_questions
  FOR INSERT TO authenticated WITH CHECK (is_admin());

DROP POLICY IF EXISTS "scoped_update_assessment_type_questions" ON assessment_type_questions;
CREATE POLICY "scoped_update_assessment_type_questions" ON assessment_type_questions
  FOR UPDATE TO authenticated USING (is_admin()) WITH CHECK (is_admin());

DROP POLICY IF EXISTS "scoped_delete_assessment_type_questions" ON assessment_type_questions;
CREATE POLICY "scoped_delete_assessment_type_questions" ON assessment_type_questions
  FOR DELETE TO authenticated USING (is_admin());

-- --- question_evidence_guides ---
DROP POLICY IF EXISTS "auth_read_question_evidence_guides" ON question_evidence_guides;
DROP POLICY IF EXISTS "admin_write_question_evidence_guides" ON question_evidence_guides;

DROP POLICY IF EXISTS "scoped_select_question_evidence_guides" ON question_evidence_guides;
CREATE POLICY "scoped_select_question_evidence_guides" ON question_evidence_guides
  FOR SELECT TO authenticated USING (true);

DROP POLICY IF EXISTS "scoped_insert_question_evidence_guides" ON question_evidence_guides;
CREATE POLICY "scoped_insert_question_evidence_guides" ON question_evidence_guides
  FOR INSERT TO authenticated WITH CHECK (is_admin());

DROP POLICY IF EXISTS "scoped_update_question_evidence_guides" ON question_evidence_guides;
CREATE POLICY "scoped_update_question_evidence_guides" ON question_evidence_guides
  FOR UPDATE TO authenticated USING (is_admin()) WITH CHECK (is_admin());

DROP POLICY IF EXISTS "scoped_delete_question_evidence_guides" ON question_evidence_guides;
CREATE POLICY "scoped_delete_question_evidence_guides" ON question_evidence_guides
  FOR DELETE TO authenticated USING (is_admin());

-- --- question_instruction_guides ---
DROP POLICY IF EXISTS "auth_read_question_instruction_guides" ON question_instruction_guides;
DROP POLICY IF EXISTS "admin_write_question_instruction_guides" ON question_instruction_guides;

DROP POLICY IF EXISTS "scoped_select_question_instruction_guides" ON question_instruction_guides;
CREATE POLICY "scoped_select_question_instruction_guides" ON question_instruction_guides
  FOR SELECT TO authenticated USING (true);

DROP POLICY IF EXISTS "scoped_insert_question_instruction_guides" ON question_instruction_guides;
CREATE POLICY "scoped_insert_question_instruction_guides" ON question_instruction_guides
  FOR INSERT TO authenticated WITH CHECK (is_admin());

DROP POLICY IF EXISTS "scoped_update_question_instruction_guides" ON question_instruction_guides;
CREATE POLICY "scoped_update_question_instruction_guides" ON question_instruction_guides
  FOR UPDATE TO authenticated USING (is_admin()) WITH CHECK (is_admin());

DROP POLICY IF EXISTS "scoped_delete_question_instruction_guides" ON question_instruction_guides;
CREATE POLICY "scoped_delete_question_instruction_guides" ON question_instruction_guides
  FOR DELETE TO authenticated USING (is_admin());

-- --- question_maturity_guides ---
DROP POLICY IF EXISTS "auth_read_question_maturity_guides" ON question_maturity_guides;
DROP POLICY IF EXISTS "admin_write_question_maturity_guides" ON question_maturity_guides;

DROP POLICY IF EXISTS "scoped_select_question_maturity_guides" ON question_maturity_guides;
CREATE POLICY "scoped_select_question_maturity_guides" ON question_maturity_guides
  FOR SELECT TO authenticated USING (true);

DROP POLICY IF EXISTS "scoped_insert_question_maturity_guides" ON question_maturity_guides;
CREATE POLICY "scoped_insert_question_maturity_guides" ON question_maturity_guides
  FOR INSERT TO authenticated WITH CHECK (is_admin());

DROP POLICY IF EXISTS "scoped_update_question_maturity_guides" ON question_maturity_guides;
CREATE POLICY "scoped_update_question_maturity_guides" ON question_maturity_guides
  FOR UPDATE TO authenticated USING (is_admin()) WITH CHECK (is_admin());

DROP POLICY IF EXISTS "scoped_delete_question_maturity_guides" ON question_maturity_guides;
CREATE POLICY "scoped_delete_question_maturity_guides" ON question_maturity_guides
  FOR DELETE TO authenticated USING (is_admin());

-- --- sub_process_areas ---
DROP POLICY IF EXISTS "auth_read_sub_process_areas" ON sub_process_areas;
DROP POLICY IF EXISTS "admin_write_sub_process_areas" ON sub_process_areas;

DROP POLICY IF EXISTS "scoped_select_sub_process_areas" ON sub_process_areas;
CREATE POLICY "scoped_select_sub_process_areas" ON sub_process_areas
  FOR SELECT TO authenticated USING (true);

DROP POLICY IF EXISTS "scoped_insert_sub_process_areas" ON sub_process_areas;
CREATE POLICY "scoped_insert_sub_process_areas" ON sub_process_areas
  FOR INSERT TO authenticated WITH CHECK (is_admin());

DROP POLICY IF EXISTS "scoped_update_sub_process_areas" ON sub_process_areas;
CREATE POLICY "scoped_update_sub_process_areas" ON sub_process_areas
  FOR UPDATE TO authenticated USING (is_admin()) WITH CHECK (is_admin());

DROP POLICY IF EXISTS "scoped_delete_sub_process_areas" ON sub_process_areas;
CREATE POLICY "scoped_delete_sub_process_areas" ON sub_process_areas
  FOR DELETE TO authenticated USING (is_admin());
