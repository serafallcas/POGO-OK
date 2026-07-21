/*
# POGO Evaluation Tool - Questions, Guides, and Assessment Tables

## New Tables
1. **questionnaires** - Assessment questionnaire containers
2. **questions** - Individual assessment questions with scoring metadata
3. **evidence_guides** - Evidence guidance per question
4. **instruction_guides** - Evaluator instructions per question
5. **cmmi_guides** - CMMI/maturity interpretation guides
6. **alert_rules** - Configurable alert trigger rules
7. **assessments** - Assessment sessions/campaigns
8. **assessment_responses** - Individual question responses
9. **assessment_evidence** - Evidence attachments per response
10. **assessment_alerts** - Generated alerts
11. **findings** - Formal findings from assessments
12. **improvement_actions** - Remediation action plans
13. **audit_log** - Activity audit trail

## Security
- RLS enabled on all tables with authenticated access
*/

-- Questionnaires
CREATE TABLE IF NOT EXISTS questionnaires (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  evaluation_type_id uuid REFERENCES evaluation_types(id),
  domain_id uuid REFERENCES domains(id),
  process_id uuid REFERENCES processes(id),
  code text,
  label text NOT NULL,
  description text,
  version text DEFAULT '1.0',
  is_active boolean NOT NULL DEFAULT true,
  created_at timestamptz DEFAULT now(),
  updated_at timestamptz DEFAULT now()
);

ALTER TABLE questionnaires ENABLE ROW LEVEL SECURITY;
DROP POLICY IF EXISTS "auth_select_questionnaires" ON questionnaires;
CREATE POLICY "auth_select_questionnaires" ON questionnaires FOR SELECT TO authenticated USING (true);
DROP POLICY IF EXISTS "auth_insert_questionnaires" ON questionnaires;
CREATE POLICY "auth_insert_questionnaires" ON questionnaires FOR INSERT TO authenticated WITH CHECK (true);
DROP POLICY IF EXISTS "auth_update_questionnaires" ON questionnaires;
CREATE POLICY "auth_update_questionnaires" ON questionnaires FOR UPDATE TO authenticated USING (true) WITH CHECK (true);
DROP POLICY IF EXISTS "auth_delete_questionnaires" ON questionnaires;
CREATE POLICY "auth_delete_questionnaires" ON questionnaires FOR DELETE TO authenticated USING (true);

-- Questions
CREATE TABLE IF NOT EXISTS questions (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  questionnaire_id uuid REFERENCES questionnaires(id),
  evaluation_type_id uuid REFERENCES evaluation_types(id),
  domain_id uuid REFERENCES domains(id),
  process_id uuid REFERENCES processes(id),
  question_code text UNIQUE NOT NULL,
  question_text text NOT NULL,
  question_intent text,
  instruction_text text,
  evidence_examples text,
  cmmi_reference text,
  alert_rule_hint text,
  mapped_maturity_model_id text,
  mapped_maturity_statement_id text,
  matched_process_area text,
  maturity_match_score numeric,
  response_type text DEFAULT 'numeric_0_5',
  scoring_scale text DEFAULT '0-5',
  weight numeric DEFAULT 1,
  is_mandatory boolean DEFAULT true,
  source_cell text,
  sheet_name text,
  sort_order integer DEFAULT 0,
  is_active boolean NOT NULL DEFAULT true,
  created_at timestamptz DEFAULT now(),
  updated_at timestamptz DEFAULT now()
);

ALTER TABLE questions ENABLE ROW LEVEL SECURITY;
DROP POLICY IF EXISTS "auth_select_questions" ON questions;
CREATE POLICY "auth_select_questions" ON questions FOR SELECT TO authenticated USING (true);
DROP POLICY IF EXISTS "auth_insert_questions" ON questions;
CREATE POLICY "auth_insert_questions" ON questions FOR INSERT TO authenticated WITH CHECK (true);
DROP POLICY IF EXISTS "auth_update_questions" ON questions;
CREATE POLICY "auth_update_questions" ON questions FOR UPDATE TO authenticated USING (true) WITH CHECK (true);
DROP POLICY IF EXISTS "auth_delete_questions" ON questions;
CREATE POLICY "auth_delete_questions" ON questions FOR DELETE TO authenticated USING (true);

CREATE INDEX IF NOT EXISTS idx_questions_domain ON questions(domain_id);
CREATE INDEX IF NOT EXISTS idx_questions_eval_type ON questions(evaluation_type_id);
CREATE INDEX IF NOT EXISTS idx_questions_code ON questions(question_code);

-- Alert Rules
CREATE TABLE IF NOT EXISTS alert_rules (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  question_id uuid REFERENCES questions(id),
  domain_id uuid REFERENCES domains(id),
  process_id uuid REFERENCES processes(id),
  rule_code text,
  rule_name text NOT NULL,
  severity text NOT NULL DEFAULT 'medium',
  condition_type text NOT NULL,
  condition_expression text,
  alert_message text,
  remediation_hint text,
  is_active boolean NOT NULL DEFAULT true,
  created_at timestamptz DEFAULT now()
);

ALTER TABLE alert_rules ENABLE ROW LEVEL SECURITY;
DROP POLICY IF EXISTS "auth_select_alert_rules" ON alert_rules;
CREATE POLICY "auth_select_alert_rules" ON alert_rules FOR SELECT TO authenticated USING (true);
DROP POLICY IF EXISTS "auth_insert_alert_rules" ON alert_rules;
CREATE POLICY "auth_insert_alert_rules" ON alert_rules FOR INSERT TO authenticated WITH CHECK (true);
DROP POLICY IF EXISTS "auth_update_alert_rules" ON alert_rules;
CREATE POLICY "auth_update_alert_rules" ON alert_rules FOR UPDATE TO authenticated USING (true) WITH CHECK (true);
DROP POLICY IF EXISTS "auth_delete_alert_rules" ON alert_rules;
CREATE POLICY "auth_delete_alert_rules" ON alert_rules FOR DELETE TO authenticated USING (true);

-- Assessments
CREATE TABLE IF NOT EXISTS assessments (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  organization_id uuid REFERENCES organizations(id),
  evaluation_type_id uuid REFERENCES evaluation_types(id),
  domain_id uuid REFERENCES domains(id),
  process_id uuid REFERENCES processes(id),
  title text NOT NULL,
  description text,
  assessment_period text,
  status text NOT NULL DEFAULT 'draft',
  current_maturity_score numeric,
  target_maturity_score numeric DEFAULT 3,
  overall_score numeric,
  created_by uuid REFERENCES profiles(id),
  lead_assessor_id uuid REFERENCES profiles(id),
  start_date date,
  end_date date,
  submitted_at timestamptz,
  approved_at timestamptz,
  created_at timestamptz DEFAULT now(),
  updated_at timestamptz DEFAULT now()
);

ALTER TABLE assessments ENABLE ROW LEVEL SECURITY;
DROP POLICY IF EXISTS "auth_select_assessments" ON assessments;
CREATE POLICY "auth_select_assessments" ON assessments FOR SELECT TO authenticated USING (true);
DROP POLICY IF EXISTS "auth_insert_assessments" ON assessments;
CREATE POLICY "auth_insert_assessments" ON assessments FOR INSERT TO authenticated WITH CHECK (true);
DROP POLICY IF EXISTS "auth_update_assessments" ON assessments;
CREATE POLICY "auth_update_assessments" ON assessments FOR UPDATE TO authenticated USING (true) WITH CHECK (true);
DROP POLICY IF EXISTS "auth_delete_assessments" ON assessments;
CREATE POLICY "auth_delete_assessments" ON assessments FOR DELETE TO authenticated USING (true);

CREATE INDEX IF NOT EXISTS idx_assessments_org ON assessments(organization_id);
CREATE INDEX IF NOT EXISTS idx_assessments_status ON assessments(status);

-- Assessment Responses
CREATE TABLE IF NOT EXISTS assessment_responses (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  assessment_id uuid REFERENCES assessments(id) ON DELETE CASCADE,
  question_id uuid REFERENCES questions(id),
  score numeric,
  maturity_level integer,
  response_text text,
  compliance_status text,
  evaluator_comment text,
  auditee_comment text,
  confidence_level text DEFAULT 'medium',
  status text NOT NULL DEFAULT 'not_started',
  last_updated_by uuid REFERENCES profiles(id),
  created_at timestamptz DEFAULT now(),
  updated_at timestamptz DEFAULT now()
);

ALTER TABLE assessment_responses ENABLE ROW LEVEL SECURITY;
DROP POLICY IF EXISTS "auth_select_assessment_responses" ON assessment_responses;
CREATE POLICY "auth_select_assessment_responses" ON assessment_responses FOR SELECT TO authenticated USING (true);
DROP POLICY IF EXISTS "auth_insert_assessment_responses" ON assessment_responses;
CREATE POLICY "auth_insert_assessment_responses" ON assessment_responses FOR INSERT TO authenticated WITH CHECK (true);
DROP POLICY IF EXISTS "auth_update_assessment_responses" ON assessment_responses;
CREATE POLICY "auth_update_assessment_responses" ON assessment_responses FOR UPDATE TO authenticated USING (true) WITH CHECK (true);
DROP POLICY IF EXISTS "auth_delete_assessment_responses" ON assessment_responses;
CREATE POLICY "auth_delete_assessment_responses" ON assessment_responses FOR DELETE TO authenticated USING (true);

CREATE INDEX IF NOT EXISTS idx_responses_assessment ON assessment_responses(assessment_id);
CREATE INDEX IF NOT EXISTS idx_responses_question ON assessment_responses(question_id);

-- Assessment Evidence
CREATE TABLE IF NOT EXISTS assessment_evidence (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  assessment_response_id uuid REFERENCES assessment_responses(id) ON DELETE CASCADE,
  evidence_name text NOT NULL,
  evidence_type text,
  file_url text,
  reference_text text,
  is_validated boolean DEFAULT false,
  validation_comment text,
  created_at timestamptz DEFAULT now()
);

ALTER TABLE assessment_evidence ENABLE ROW LEVEL SECURITY;
DROP POLICY IF EXISTS "auth_select_assessment_evidence" ON assessment_evidence;
CREATE POLICY "auth_select_assessment_evidence" ON assessment_evidence FOR SELECT TO authenticated USING (true);
DROP POLICY IF EXISTS "auth_insert_assessment_evidence" ON assessment_evidence;
CREATE POLICY "auth_insert_assessment_evidence" ON assessment_evidence FOR INSERT TO authenticated WITH CHECK (true);
DROP POLICY IF EXISTS "auth_update_assessment_evidence" ON assessment_evidence;
CREATE POLICY "auth_update_assessment_evidence" ON assessment_evidence FOR UPDATE TO authenticated USING (true) WITH CHECK (true);
DROP POLICY IF EXISTS "auth_delete_assessment_evidence" ON assessment_evidence;
CREATE POLICY "auth_delete_assessment_evidence" ON assessment_evidence FOR DELETE TO authenticated USING (true);

-- Assessment Alerts
CREATE TABLE IF NOT EXISTS assessment_alerts (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  assessment_id uuid REFERENCES assessments(id) ON DELETE CASCADE,
  question_id uuid REFERENCES questions(id),
  alert_rule_id uuid REFERENCES alert_rules(id),
  severity text NOT NULL DEFAULT 'medium',
  title text NOT NULL,
  message text,
  status text NOT NULL DEFAULT 'open',
  owner_id uuid REFERENCES profiles(id),
  due_date date,
  created_at timestamptz DEFAULT now(),
  updated_at timestamptz DEFAULT now()
);

ALTER TABLE assessment_alerts ENABLE ROW LEVEL SECURITY;
DROP POLICY IF EXISTS "auth_select_assessment_alerts" ON assessment_alerts;
CREATE POLICY "auth_select_assessment_alerts" ON assessment_alerts FOR SELECT TO authenticated USING (true);
DROP POLICY IF EXISTS "auth_insert_assessment_alerts" ON assessment_alerts;
CREATE POLICY "auth_insert_assessment_alerts" ON assessment_alerts FOR INSERT TO authenticated WITH CHECK (true);
DROP POLICY IF EXISTS "auth_update_assessment_alerts" ON assessment_alerts;
CREATE POLICY "auth_update_assessment_alerts" ON assessment_alerts FOR UPDATE TO authenticated USING (true) WITH CHECK (true);
DROP POLICY IF EXISTS "auth_delete_assessment_alerts" ON assessment_alerts;
CREATE POLICY "auth_delete_assessment_alerts" ON assessment_alerts FOR DELETE TO authenticated USING (true);

-- Findings
CREATE TABLE IF NOT EXISTS findings (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  assessment_id uuid REFERENCES assessments(id) ON DELETE CASCADE,
  domain_id uuid REFERENCES domains(id),
  process_id uuid REFERENCES processes(id),
  question_id uuid REFERENCES questions(id),
  severity text NOT NULL DEFAULT 'medium',
  title text NOT NULL,
  description text,
  root_cause text,
  impact text,
  recommendation text,
  management_response text,
  action_owner text,
  due_date date,
  status text NOT NULL DEFAULT 'open',
  created_at timestamptz DEFAULT now(),
  updated_at timestamptz DEFAULT now()
);

ALTER TABLE findings ENABLE ROW LEVEL SECURITY;
DROP POLICY IF EXISTS "auth_select_findings" ON findings;
CREATE POLICY "auth_select_findings" ON findings FOR SELECT TO authenticated USING (true);
DROP POLICY IF EXISTS "auth_insert_findings" ON findings;
CREATE POLICY "auth_insert_findings" ON findings FOR INSERT TO authenticated WITH CHECK (true);
DROP POLICY IF EXISTS "auth_update_findings" ON findings;
CREATE POLICY "auth_update_findings" ON findings FOR UPDATE TO authenticated USING (true) WITH CHECK (true);
DROP POLICY IF EXISTS "auth_delete_findings" ON findings;
CREATE POLICY "auth_delete_findings" ON findings FOR DELETE TO authenticated USING (true);

-- Improvement Actions
CREATE TABLE IF NOT EXISTS improvement_actions (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  finding_id uuid REFERENCES findings(id) ON DELETE CASCADE,
  assessment_id uuid REFERENCES assessments(id),
  title text NOT NULL,
  description text,
  priority text DEFAULT 'medium',
  owner_id uuid REFERENCES profiles(id),
  due_date date,
  status text NOT NULL DEFAULT 'open',
  progress_percent integer DEFAULT 0,
  created_at timestamptz DEFAULT now(),
  updated_at timestamptz DEFAULT now()
);

ALTER TABLE improvement_actions ENABLE ROW LEVEL SECURITY;
DROP POLICY IF EXISTS "auth_select_improvement_actions" ON improvement_actions;
CREATE POLICY "auth_select_improvement_actions" ON improvement_actions FOR SELECT TO authenticated USING (true);
DROP POLICY IF EXISTS "auth_insert_improvement_actions" ON improvement_actions;
CREATE POLICY "auth_insert_improvement_actions" ON improvement_actions FOR INSERT TO authenticated WITH CHECK (true);
DROP POLICY IF EXISTS "auth_update_improvement_actions" ON improvement_actions;
CREATE POLICY "auth_update_improvement_actions" ON improvement_actions FOR UPDATE TO authenticated USING (true) WITH CHECK (true);
DROP POLICY IF EXISTS "auth_delete_improvement_actions" ON improvement_actions;
CREATE POLICY "auth_delete_improvement_actions" ON improvement_actions FOR DELETE TO authenticated USING (true);

-- Audit Log
CREATE TABLE IF NOT EXISTS audit_log (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  actor_id uuid,
  action text NOT NULL,
  entity_name text,
  entity_id uuid,
  old_value jsonb,
  new_value jsonb,
  created_at timestamptz DEFAULT now()
);

ALTER TABLE audit_log ENABLE ROW LEVEL SECURITY;
DROP POLICY IF EXISTS "auth_select_audit_log" ON audit_log;
CREATE POLICY "auth_select_audit_log" ON audit_log FOR SELECT TO authenticated USING (true);
DROP POLICY IF EXISTS "auth_insert_audit_log" ON audit_log;
CREATE POLICY "auth_insert_audit_log" ON audit_log FOR INSERT TO authenticated WITH CHECK (true);

-- Auto-create profile on user signup
CREATE OR REPLACE FUNCTION handle_new_user()
RETURNS trigger AS $$
BEGIN
  INSERT INTO profiles (auth_user_id, email, full_name, role)
  VALUES (NEW.id, NEW.email, COALESCE(NEW.raw_user_meta_data->>'full_name', NEW.email), 'evaluator');
  RETURN NEW;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

DROP TRIGGER IF EXISTS on_auth_user_created ON auth.users;
CREATE TRIGGER on_auth_user_created
  AFTER INSERT ON auth.users
  FOR EACH ROW EXECUTE FUNCTION handle_new_user();