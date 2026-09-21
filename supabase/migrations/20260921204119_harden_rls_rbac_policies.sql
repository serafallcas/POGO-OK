/*
# Harden RLS/RBAC policies — replace USING(true) with org-scoped + role-based access control

1. New Functions
   - current_profile_role()     → returns the calling user's role from profiles
   - current_profile_org()      → returns the calling user's organization_id from profiles
   - is_admin()                 → true if super_admin or program_admin
   - is_assessment_team()       → true if super_admin, program_admin, assessment_manager, evaluator, or reviewer
   - assessment_org_id(uuid)    → returns the organization_id for a given assessment
   - response_assessment_org(uuid) → returns the organization_id for a given assessment_response (via assessment)
   - finding_assessment_org(uuid)  → returns the organization_id for a given finding (via assessment)
   - action_plan_assessment_org(uuid) → returns the organization_id for a given action plan (via finding → assessment)
   - prevent_profile_privilege_escalation() → trigger function that blocks non-admins from changing role/org/status on profiles

2. Trigger
   - guard_profile_privilege_escalation on profiles BEFORE UPDATE

3. Security Changes
   - Reference tables (organizations, roles, evaluation_types, domains, processes,
     maturity_models, maturity_levels, maturity_statements, questionnaires, questions,
     alert_rules, recommendation_library, finding_templates, question_finding_mappings):
     SELECT open to all authenticated, INSERT/UPDATE/DELETE restricted to admins only.
   - profiles: SELECT own row or admin, INSERT admin only, UPDATE own or admin (with escalation trigger), DELETE admin only.
   - assessments: org-scoped SELECT/UPDATE for assessment_team, INSERT/DELETE for assessment_manager within org.
   - assessment_responses: org-scoped via assessment_org_id(), DELETE restricted to assessment_manager.
   - assessment_evidence: org-scoped via response_assessment_org().
   - assessment_alerts, assessment_validation_gates, assessment_scope_items, assessment_findings_v2: org-scoped via assessment_org_id().
   - response_reviews, decision_tree_responses: org-scoped via response_assessment_org().
   - finding_source_responses, finding_recommendations: org-scoped via finding_assessment_org().
   - finding_action_plans: org-scoped via finding_assessment_org().
   - action_plan_evidence: org-scoped via action_plan_assessment_org().
   - audit_log: SELECT restricted to admins only.
*/

CREATE OR REPLACE FUNCTION current_profile_role()
RETURNS text
LANGUAGE sql STABLE SECURITY DEFINER SET search_path = public AS $$
  SELECT role FROM profiles WHERE auth_user_id = auth.uid() LIMIT 1;
$$;

CREATE OR REPLACE FUNCTION current_profile_org()
RETURNS uuid
LANGUAGE sql STABLE SECURITY DEFINER SET search_path = public AS $$
  SELECT organization_id FROM profiles WHERE auth_user_id = auth.uid() LIMIT 1;
$$;

CREATE OR REPLACE FUNCTION is_admin()
RETURNS boolean
LANGUAGE sql STABLE SECURITY DEFINER SET search_path = public AS $$
  SELECT COALESCE(current_profile_role() IN ('super_admin', 'program_admin'), false);
$$;

CREATE OR REPLACE FUNCTION is_assessment_team()
RETURNS boolean
LANGUAGE sql STABLE SECURITY DEFINER SET search_path = public AS $$
  SELECT COALESCE(current_profile_role() IN ('super_admin', 'program_admin', 'assessment_manager', 'evaluator', 'reviewer'), false);
$$;

CREATE OR REPLACE FUNCTION assessment_org_id(p_assessment_id uuid)
RETURNS uuid
LANGUAGE sql STABLE SECURITY DEFINER SET search_path = public AS $$
  SELECT organization_id FROM assessments WHERE id = p_assessment_id;
$$;

CREATE OR REPLACE FUNCTION response_assessment_org(p_response_id uuid)
RETURNS uuid
LANGUAGE sql STABLE SECURITY DEFINER SET search_path = public AS $$
  SELECT a.organization_id FROM assessment_responses r JOIN assessments a ON a.id = r.assessment_id WHERE r.id = p_response_id;
$$;

CREATE OR REPLACE FUNCTION finding_assessment_org(p_finding_id uuid)
RETURNS uuid
LANGUAGE sql STABLE SECURITY DEFINER SET search_path = public AS $$
  SELECT a.organization_id FROM assessment_findings_v2 f JOIN assessments a ON a.id = f.assessment_id WHERE f.id = p_finding_id;
$$;

CREATE OR REPLACE FUNCTION action_plan_assessment_org(p_action_plan_id uuid)
RETURNS uuid
LANGUAGE sql STABLE SECURITY DEFINER SET search_path = public AS $$
  SELECT a.organization_id
  FROM finding_action_plans ap
  JOIN assessment_findings_v2 f ON f.id = ap.finding_id
  JOIN assessments a ON a.id = f.assessment_id
  WHERE ap.id = p_action_plan_id;
$$;

CREATE OR REPLACE FUNCTION prevent_profile_privilege_escalation()
RETURNS trigger
LANGUAGE plpgsql SECURITY DEFINER SET search_path = public AS $$
BEGIN
  IF NOT is_admin() THEN
    IF NEW.role IS DISTINCT FROM OLD.role
       OR NEW.organization_id IS DISTINCT FROM OLD.organization_id
       OR NEW.status IS DISTINCT FROM OLD.status THEN
      RAISE EXCEPTION 'Only administrators can change role, organization or status';
    END IF;
  END IF;
  RETURN NEW;
END;
$$;

DROP TRIGGER IF EXISTS guard_profile_privilege_escalation ON profiles;
CREATE TRIGGER guard_profile_privilege_escalation
  BEFORE UPDATE ON profiles
  FOR EACH ROW EXECUTE FUNCTION prevent_profile_privilege_escalation();

DO $$
DECLARE
  tbl text;
BEGIN
  FOR tbl IN SELECT unnest(ARRAY[
    'organizations', 'roles', 'evaluation_types', 'domains', 'processes',
    'maturity_models', 'maturity_levels', 'maturity_statements', 'questionnaires',
    'questions', 'alert_rules', 'recommendation_library', 'finding_templates',
    'question_finding_mappings'
  ])
  LOOP
    EXECUTE format('DROP POLICY IF EXISTS "auth_select_%s" ON %I', tbl, tbl);
    EXECUTE format('DROP POLICY IF EXISTS "select_%s" ON %I', tbl, tbl);
    EXECUTE format('DROP POLICY IF EXISTS "scoped_select_%s" ON %I', tbl, tbl);
    EXECUTE format('CREATE POLICY "scoped_select_%s" ON %I FOR SELECT TO authenticated USING (true)', tbl, tbl);

    EXECUTE format('DROP POLICY IF EXISTS "auth_insert_%s" ON %I', tbl, tbl);
    EXECUTE format('DROP POLICY IF EXISTS "insert_%s" ON %I', tbl, tbl);
    EXECUTE format('DROP POLICY IF EXISTS "scoped_insert_%s" ON %I', tbl, tbl);
    EXECUTE format('CREATE POLICY "scoped_insert_%s" ON %I FOR INSERT TO authenticated WITH CHECK (is_admin())', tbl, tbl);

    EXECUTE format('DROP POLICY IF EXISTS "auth_update_%s" ON %I', tbl, tbl);
    EXECUTE format('DROP POLICY IF EXISTS "update_%s" ON %I', tbl, tbl);
    EXECUTE format('DROP POLICY IF EXISTS "scoped_update_%s" ON %I', tbl, tbl);
    EXECUTE format('CREATE POLICY "scoped_update_%s" ON %I FOR UPDATE TO authenticated USING (is_admin()) WITH CHECK (is_admin())', tbl, tbl);

    EXECUTE format('DROP POLICY IF EXISTS "auth_delete_%s" ON %I', tbl, tbl);
    EXECUTE format('DROP POLICY IF EXISTS "delete_%s" ON %I', tbl, tbl);
    EXECUTE format('DROP POLICY IF EXISTS "scoped_delete_%s" ON %I', tbl, tbl);
    EXECUTE format('CREATE POLICY "scoped_delete_%s" ON %I FOR DELETE TO authenticated USING (is_admin())', tbl, tbl);
  END LOOP;
END $$;

DROP POLICY IF EXISTS "auth_select_profiles" ON profiles;
DROP POLICY IF EXISTS "scoped_select_profiles" ON profiles;
CREATE POLICY "scoped_select_profiles" ON profiles FOR SELECT TO authenticated
  USING (auth_user_id = auth.uid() OR is_admin());

DROP POLICY IF EXISTS "auth_insert_profiles" ON profiles;
DROP POLICY IF EXISTS "scoped_insert_profiles" ON profiles;
CREATE POLICY "scoped_insert_profiles" ON profiles FOR INSERT TO authenticated
  WITH CHECK (is_admin());

DROP POLICY IF EXISTS "auth_update_profiles" ON profiles;
DROP POLICY IF EXISTS "scoped_update_profiles" ON profiles;
CREATE POLICY "scoped_update_profiles" ON profiles FOR UPDATE TO authenticated
  USING (auth_user_id = auth.uid() OR is_admin())
  WITH CHECK (auth_user_id = auth.uid() OR is_admin());

DROP POLICY IF EXISTS "auth_delete_profiles" ON profiles;
DROP POLICY IF EXISTS "scoped_delete_profiles" ON profiles;
CREATE POLICY "scoped_delete_profiles" ON profiles FOR DELETE TO authenticated
  USING (is_admin());

DROP POLICY IF EXISTS "auth_select_assessments" ON assessments;
DROP POLICY IF EXISTS "scoped_select_assessments" ON assessments;
CREATE POLICY "scoped_select_assessments" ON assessments FOR SELECT TO authenticated
  USING (is_admin() OR organization_id = current_profile_org());

DROP POLICY IF EXISTS "auth_insert_assessments" ON assessments;
DROP POLICY IF EXISTS "scoped_insert_assessments" ON assessments;
CREATE POLICY "scoped_insert_assessments" ON assessments FOR INSERT TO authenticated
  WITH CHECK (is_admin() OR (current_profile_role() = 'assessment_manager' AND organization_id = current_profile_org()));

DROP POLICY IF EXISTS "auth_update_assessments" ON assessments;
DROP POLICY IF EXISTS "scoped_update_assessments" ON assessments;
CREATE POLICY "scoped_update_assessments" ON assessments FOR UPDATE TO authenticated
  USING (is_admin() OR (organization_id = current_profile_org() AND is_assessment_team()))
  WITH CHECK (is_admin() OR (organization_id = current_profile_org() AND is_assessment_team()));

DROP POLICY IF EXISTS "auth_delete_assessments" ON assessments;
DROP POLICY IF EXISTS "scoped_delete_assessments" ON assessments;
CREATE POLICY "scoped_delete_assessments" ON assessments FOR DELETE TO authenticated
  USING (is_admin() OR (current_profile_role() = 'assessment_manager' AND organization_id = current_profile_org()));

DROP POLICY IF EXISTS "auth_select_assessment_responses" ON assessment_responses;
DROP POLICY IF EXISTS "scoped_select_assessment_responses" ON assessment_responses;
CREATE POLICY "scoped_select_assessment_responses" ON assessment_responses FOR SELECT TO authenticated
  USING (is_admin() OR assessment_org_id(assessment_id) = current_profile_org());

DROP POLICY IF EXISTS "auth_insert_assessment_responses" ON assessment_responses;
DROP POLICY IF EXISTS "scoped_insert_assessment_responses" ON assessment_responses;
CREATE POLICY "scoped_insert_assessment_responses" ON assessment_responses FOR INSERT TO authenticated
  WITH CHECK (is_admin() OR (assessment_org_id(assessment_id) = current_profile_org() AND is_assessment_team()));

DROP POLICY IF EXISTS "auth_update_assessment_responses" ON assessment_responses;
DROP POLICY IF EXISTS "scoped_update_assessment_responses" ON assessment_responses;
CREATE POLICY "scoped_update_assessment_responses" ON assessment_responses FOR UPDATE TO authenticated
  USING (is_admin() OR (assessment_org_id(assessment_id) = current_profile_org() AND is_assessment_team()))
  WITH CHECK (is_admin() OR (assessment_org_id(assessment_id) = current_profile_org() AND is_assessment_team()));

DROP POLICY IF EXISTS "auth_delete_assessment_responses" ON assessment_responses;
DROP POLICY IF EXISTS "scoped_delete_assessment_responses" ON assessment_responses;
CREATE POLICY "scoped_delete_assessment_responses" ON assessment_responses FOR DELETE TO authenticated
  USING (is_admin() OR (assessment_org_id(assessment_id) = current_profile_org() AND current_profile_role() = 'assessment_manager'));

DROP POLICY IF EXISTS "auth_select_assessment_evidence" ON assessment_evidence;
DROP POLICY IF EXISTS "scoped_select_assessment_evidence" ON assessment_evidence;
CREATE POLICY "scoped_select_assessment_evidence" ON assessment_evidence FOR SELECT TO authenticated
  USING (is_admin() OR response_assessment_org(assessment_response_id) = current_profile_org());

DROP POLICY IF EXISTS "auth_insert_assessment_evidence" ON assessment_evidence;
DROP POLICY IF EXISTS "scoped_insert_assessment_evidence" ON assessment_evidence;
CREATE POLICY "scoped_insert_assessment_evidence" ON assessment_evidence FOR INSERT TO authenticated
  WITH CHECK (is_admin() OR (response_assessment_org(assessment_response_id) = current_profile_org() AND is_assessment_team()));

DROP POLICY IF EXISTS "auth_update_assessment_evidence" ON assessment_evidence;
DROP POLICY IF EXISTS "scoped_update_assessment_evidence" ON assessment_evidence;
CREATE POLICY "scoped_update_assessment_evidence" ON assessment_evidence FOR UPDATE TO authenticated
  USING (is_admin() OR (response_assessment_org(assessment_response_id) = current_profile_org() AND is_assessment_team()))
  WITH CHECK (is_admin() OR (response_assessment_org(assessment_response_id) = current_profile_org() AND is_assessment_team()));

DROP POLICY IF EXISTS "auth_delete_assessment_evidence" ON assessment_evidence;
DROP POLICY IF EXISTS "scoped_delete_assessment_evidence" ON assessment_evidence;
CREATE POLICY "scoped_delete_assessment_evidence" ON assessment_evidence FOR DELETE TO authenticated
  USING (is_admin() OR (response_assessment_org(assessment_response_id) = current_profile_org() AND is_assessment_team()));

DO $$
DECLARE
  tbl text;
BEGIN
  FOR tbl IN SELECT unnest(ARRAY[
    'assessment_alerts', 'assessment_validation_gates', 'assessment_scope_items', 'assessment_findings_v2'
  ])
  LOOP
    EXECUTE format('DROP POLICY IF EXISTS "auth_select_%s" ON %I', tbl, tbl);
    EXECUTE format('DROP POLICY IF EXISTS "select_%s" ON %I', tbl, tbl);
    EXECUTE format('DROP POLICY IF EXISTS "select_findings_v2" ON %I', tbl, tbl);
    EXECUTE format('DROP POLICY IF EXISTS "auth_select_gates" ON %I', tbl, tbl);
    EXECUTE format('DROP POLICY IF EXISTS "auth_select_scope" ON %I', tbl, tbl);
    EXECUTE format('DROP POLICY IF EXISTS "scoped_select_%s" ON %I', tbl, tbl);
    EXECUTE format('CREATE POLICY "scoped_select_%s" ON %I FOR SELECT TO authenticated USING (is_admin() OR assessment_org_id(assessment_id) = current_profile_org())', tbl, tbl);

    EXECUTE format('DROP POLICY IF EXISTS "auth_insert_%s" ON %I', tbl, tbl);
    EXECUTE format('DROP POLICY IF EXISTS "insert_%s" ON %I', tbl, tbl);
    EXECUTE format('DROP POLICY IF EXISTS "insert_findings_v2" ON %I', tbl, tbl);
    EXECUTE format('DROP POLICY IF EXISTS "auth_insert_gates" ON %I', tbl, tbl);
    EXECUTE format('DROP POLICY IF EXISTS "auth_insert_scope" ON %I', tbl, tbl);
    EXECUTE format('DROP POLICY IF EXISTS "scoped_insert_%s" ON %I', tbl, tbl);
    EXECUTE format('CREATE POLICY "scoped_insert_%s" ON %I FOR INSERT TO authenticated WITH CHECK (is_admin() OR (assessment_org_id(assessment_id) = current_profile_org() AND is_assessment_team()))', tbl, tbl);

    EXECUTE format('DROP POLICY IF EXISTS "auth_update_%s" ON %I', tbl, tbl);
    EXECUTE format('DROP POLICY IF EXISTS "update_%s" ON %I', tbl, tbl);
    EXECUTE format('DROP POLICY IF EXISTS "update_findings_v2" ON %I', tbl, tbl);
    EXECUTE format('DROP POLICY IF EXISTS "auth_update_gates" ON %I', tbl, tbl);
    EXECUTE format('DROP POLICY IF EXISTS "auth_update_scope" ON %I', tbl, tbl);
    EXECUTE format('DROP POLICY IF EXISTS "scoped_update_%s" ON %I', tbl, tbl);
    EXECUTE format('CREATE POLICY "scoped_update_%s" ON %I FOR UPDATE TO authenticated USING (is_admin() OR (assessment_org_id(assessment_id) = current_profile_org() AND is_assessment_team())) WITH CHECK (is_admin() OR (assessment_org_id(assessment_id) = current_profile_org() AND is_assessment_team()))', tbl, tbl);

    EXECUTE format('DROP POLICY IF EXISTS "auth_delete_%s" ON %I', tbl, tbl);
    EXECUTE format('DROP POLICY IF EXISTS "delete_%s" ON %I', tbl, tbl);
    EXECUTE format('DROP POLICY IF EXISTS "delete_findings_v2" ON %I', tbl, tbl);
    EXECUTE format('DROP POLICY IF EXISTS "auth_delete_gates" ON %I', tbl, tbl);
    EXECUTE format('DROP POLICY IF EXISTS "auth_delete_scope" ON %I', tbl, tbl);
    EXECUTE format('DROP POLICY IF EXISTS "scoped_delete_%s" ON %I', tbl, tbl);
    EXECUTE format('CREATE POLICY "scoped_delete_%s" ON %I FOR DELETE TO authenticated USING (is_admin() OR (assessment_org_id(assessment_id) = current_profile_org() AND is_assessment_team()))', tbl, tbl);
  END LOOP;
END $$;

DO $$
DECLARE
  tbl text;
BEGIN
  FOR tbl IN SELECT unnest(ARRAY['response_reviews', 'decision_tree_responses'])
  LOOP
    EXECUTE format('DROP POLICY IF EXISTS "auth_select_reviews" ON %I', tbl);
    EXECUTE format('DROP POLICY IF EXISTS "auth_select_dt" ON %I', tbl);
    EXECUTE format('DROP POLICY IF EXISTS "scoped_select_%s" ON %I', tbl, tbl);
    EXECUTE format('CREATE POLICY "scoped_select_%s" ON %I FOR SELECT TO authenticated USING (is_admin() OR response_assessment_org(assessment_response_id) = current_profile_org())', tbl, tbl);

    EXECUTE format('DROP POLICY IF EXISTS "auth_insert_reviews" ON %I', tbl);
    EXECUTE format('DROP POLICY IF EXISTS "auth_insert_dt" ON %I', tbl);
    EXECUTE format('DROP POLICY IF EXISTS "scoped_insert_%s" ON %I', tbl, tbl);
    EXECUTE format('CREATE POLICY "scoped_insert_%s" ON %I FOR INSERT TO authenticated WITH CHECK (is_admin() OR (response_assessment_org(assessment_response_id) = current_profile_org() AND is_assessment_team()))', tbl, tbl);

    EXECUTE format('DROP POLICY IF EXISTS "auth_update_reviews" ON %I', tbl);
    EXECUTE format('DROP POLICY IF EXISTS "auth_update_dt" ON %I', tbl);
    EXECUTE format('DROP POLICY IF EXISTS "scoped_update_%s" ON %I', tbl, tbl);
    EXECUTE format('CREATE POLICY "scoped_update_%s" ON %I FOR UPDATE TO authenticated USING (is_admin() OR (response_assessment_org(assessment_response_id) = current_profile_org() AND is_assessment_team())) WITH CHECK (is_admin() OR (response_assessment_org(assessment_response_id) = current_profile_org() AND is_assessment_team()))', tbl, tbl);

    EXECUTE format('DROP POLICY IF EXISTS "auth_delete_reviews" ON %I', tbl);
    EXECUTE format('DROP POLICY IF EXISTS "auth_delete_dt" ON %I', tbl);
    EXECUTE format('DROP POLICY IF EXISTS "scoped_delete_%s" ON %I', tbl, tbl);
    EXECUTE format('CREATE POLICY "scoped_delete_%s" ON %I FOR DELETE TO authenticated USING (is_admin() OR (response_assessment_org(assessment_response_id) = current_profile_org() AND is_assessment_team()))', tbl, tbl);
  END LOOP;
END $$;

DO $$
DECLARE
  tbl text;
BEGIN
  FOR tbl IN SELECT unnest(ARRAY['finding_source_responses', 'finding_recommendations'])
  LOOP
    EXECUTE format('DROP POLICY IF EXISTS "select_fsr" ON %I', tbl);
    EXECUTE format('DROP POLICY IF EXISTS "select_fr" ON %I', tbl);
    EXECUTE format('DROP POLICY IF EXISTS "scoped_select_%s" ON %I', tbl, tbl);
    EXECUTE format('CREATE POLICY "scoped_select_%s" ON %I FOR SELECT TO authenticated USING (is_admin() OR finding_assessment_org(finding_id) = current_profile_org())', tbl, tbl);

    EXECUTE format('DROP POLICY IF EXISTS "insert_fsr" ON %I', tbl);
    EXECUTE format('DROP POLICY IF EXISTS "insert_fr" ON %I', tbl);
    EXECUTE format('DROP POLICY IF EXISTS "scoped_insert_%s" ON %I', tbl, tbl);
    EXECUTE format('CREATE POLICY "scoped_insert_%s" ON %I FOR INSERT TO authenticated WITH CHECK (is_admin() OR (finding_assessment_org(finding_id) = current_profile_org() AND is_assessment_team()))', tbl, tbl);

    EXECUTE format('DROP POLICY IF EXISTS "update_fsr" ON %I', tbl);
    EXECUTE format('DROP POLICY IF EXISTS "update_fr" ON %I', tbl);
    EXECUTE format('DROP POLICY IF EXISTS "scoped_update_%s" ON %I', tbl, tbl);
    EXECUTE format('CREATE POLICY "scoped_update_%s" ON %I FOR UPDATE TO authenticated USING (is_admin() OR (finding_assessment_org(finding_id) = current_profile_org() AND is_assessment_team())) WITH CHECK (is_admin() OR (finding_assessment_org(finding_id) = current_profile_org() AND is_assessment_team()))', tbl, tbl);

    EXECUTE format('DROP POLICY IF EXISTS "delete_fsr" ON %I', tbl);
    EXECUTE format('DROP POLICY IF EXISTS "delete_fr" ON %I', tbl);
    EXECUTE format('DROP POLICY IF EXISTS "scoped_delete_%s" ON %I', tbl, tbl);
    EXECUTE format('CREATE POLICY "scoped_delete_%s" ON %I FOR DELETE TO authenticated USING (is_admin() OR (finding_assessment_org(finding_id) = current_profile_org() AND is_assessment_team()))', tbl, tbl);
  END LOOP;
END $$;

DROP POLICY IF EXISTS "select_fap" ON finding_action_plans;
DROP POLICY IF EXISTS "scoped_select_finding_action_plans" ON finding_action_plans;
CREATE POLICY "scoped_select_finding_action_plans" ON finding_action_plans FOR SELECT TO authenticated
  USING (is_admin() OR finding_assessment_org(finding_id) = current_profile_org());

DROP POLICY IF EXISTS "insert_fap" ON finding_action_plans;
DROP POLICY IF EXISTS "scoped_insert_finding_action_plans" ON finding_action_plans;
CREATE POLICY "scoped_insert_finding_action_plans" ON finding_action_plans FOR INSERT TO authenticated
  WITH CHECK (is_admin() OR (finding_assessment_org(finding_id) = current_profile_org() AND is_assessment_team()));

DROP POLICY IF EXISTS "update_fap" ON finding_action_plans;
DROP POLICY IF EXISTS "scoped_update_finding_action_plans" ON finding_action_plans;
CREATE POLICY "scoped_update_finding_action_plans" ON finding_action_plans FOR UPDATE TO authenticated
  USING (is_admin() OR (finding_assessment_org(finding_id) = current_profile_org() AND is_assessment_team()))
  WITH CHECK (is_admin() OR (finding_assessment_org(finding_id) = current_profile_org() AND is_assessment_team()));

DROP POLICY IF EXISTS "delete_fap" ON finding_action_plans;
DROP POLICY IF EXISTS "scoped_delete_finding_action_plans" ON finding_action_plans;
CREATE POLICY "scoped_delete_finding_action_plans" ON finding_action_plans FOR DELETE TO authenticated
  USING (is_admin() OR (finding_assessment_org(finding_id) = current_profile_org() AND is_assessment_team()));

DROP POLICY IF EXISTS "select_ape" ON action_plan_evidence;
DROP POLICY IF EXISTS "scoped_select_action_plan_evidence" ON action_plan_evidence;
CREATE POLICY "scoped_select_action_plan_evidence" ON action_plan_evidence FOR SELECT TO authenticated
  USING (is_admin() OR action_plan_assessment_org(action_plan_id) = current_profile_org());

DROP POLICY IF EXISTS "insert_ape" ON action_plan_evidence;
DROP POLICY IF EXISTS "scoped_insert_action_plan_evidence" ON action_plan_evidence;
CREATE POLICY "scoped_insert_action_plan_evidence" ON action_plan_evidence FOR INSERT TO authenticated
  WITH CHECK (is_admin() OR (action_plan_assessment_org(action_plan_id) = current_profile_org() AND is_assessment_team()));

DROP POLICY IF EXISTS "update_ape" ON action_plan_evidence;
DROP POLICY IF EXISTS "scoped_update_action_plan_evidence" ON action_plan_evidence;
CREATE POLICY "scoped_update_action_plan_evidence" ON action_plan_evidence FOR UPDATE TO authenticated
  USING (is_admin() OR (action_plan_assessment_org(action_plan_id) = current_profile_org() AND is_assessment_team()))
  WITH CHECK (is_admin() OR (action_plan_assessment_org(action_plan_id) = current_profile_org() AND is_assessment_team()));

DROP POLICY IF EXISTS "delete_ape" ON action_plan_evidence;
DROP POLICY IF EXISTS "scoped_delete_action_plan_evidence" ON action_plan_evidence;
CREATE POLICY "scoped_delete_action_plan_evidence" ON action_plan_evidence FOR DELETE TO authenticated
  USING (is_admin() OR (action_plan_assessment_org(action_plan_id) = current_profile_org() AND is_assessment_team()));

DROP POLICY IF EXISTS "auth_select_audit_log" ON audit_log;
DROP POLICY IF EXISTS "scoped_select_audit_log" ON audit_log;
CREATE POLICY "scoped_select_audit_log" ON audit_log FOR SELECT TO authenticated
  USING (is_admin());
