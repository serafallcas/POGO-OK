/*
# Create Findings & Recommendations Engine Tables

1. New Tables
  - `recommendation_library` - Central library of 14 reusable recommendations
    - `id` (uuid, PK)
    - `recommendation_code` (text, unique, e.g. REC-0001)
    - `category` (text)
    - `title` (text)
    - `recommendation_text` (text)
    - `recommendation_type` (text)
    - `priority_default` (text)
    - `implementation_horizon` (text)
    - `default_owner_role` (text)
    - `expected_evidence` (text)
    - `closure_criteria` (text)
    - `status` (text, default Active)
    - `version` (text)

  - `finding_templates` - 92 finding templates, one per question
    - `id` (uuid, PK)
    - `template_code` (text, unique, e.g. FND-TPL-0001)
    - `question_code` (text, references questions.code)
    - `domain` (text)
    - `process` (text)
    - `category` (text)
    - `title` (text)
    - `criteria` (text)
    - `condition_template` (text)
    - `root_cause_template` (text)
    - `impact_template` (text)
    - `likelihood_default` (text)
    - `impact_default` (text)
    - `severity_default` (text)
    - `status_default` (text)
    - `recommendation_id` (uuid, FK to recommendation_library)
    - `trigger_rules` (jsonb)
    - `deduplication_rule` (text)
    - `status` (text)
    - `version` (text)

  - `question_finding_mappings` - Links questions to finding templates and recommendations
    - `id` (uuid, PK)
    - `question_code` (text)
    - `finding_template_id` (uuid, FK)
    - `recommendation_id` (uuid, FK)
    - `mapping_type` (text)
    - `validation_rule` (text)

  - `assessment_findings_v2` - Actual findings raised during assessments (workflow-driven)
    - `id` (uuid, PK)
    - `assessment_id` (uuid, FK)
    - `finding_template_id` (uuid, FK, nullable)
    - `title` (text)
    - `criteria` (text)
    - `condition_text` (text)
    - `root_cause` (text)
    - `impact_text` (text)
    - `likelihood` (text)
    - `impact_level` (text)
    - `severity` (text)
    - `status` (text) - Potential/Under Review/Confirmed/Rejected/Merged/Management Response/Action Plan Defined/Closed
    - `created_by` (uuid)
    - `reviewer_id` (uuid, nullable)
    - `merged_into_id` (uuid, nullable, self-reference for merging)
    - `residual_risk_accepted` (boolean)
    - `residual_risk_justification` (text)
    - `created_at`, `updated_at`

  - `finding_source_responses` - Links findings to source assessment_responses (many-to-many)
    - `id` (uuid, PK)
    - `finding_id` (uuid, FK)
    - `assessment_response_id` (uuid, FK)
    - UNIQUE(finding_id, assessment_response_id)

  - `finding_recommendations` - Recommendations attached to a finding (with optional override)
    - `id` (uuid, PK)
    - `finding_id` (uuid, FK)
    - `recommendation_id` (uuid, FK to recommendation_library)
    - `override_text` (text, nullable - contextual customization)
    - `is_primary` (boolean, default true)

  - `finding_action_plans` - Action plans linked to confirmed findings
    - `id` (uuid, PK)
    - `finding_id` (uuid, FK)
    - `title` (text)
    - `description` (text)
    - `owner` (text)
    - `due_date` (date)
    - `priority` (text)
    - `status` (text) - Draft/Management Review/Accepted/In Progress/Evidence Submitted/Closure Review/Closed/Reopened
    - `progress_pct` (integer, CHECK 0-100)
    - `created_at`, `updated_at`

  - `action_plan_evidence` - Evidence attached to action plans
    - `id` (uuid, PK)
    - `action_plan_id` (uuid, FK)
    - `evidence_type` (text)
    - `description` (text)
    - `file_url` (text, nullable)
    - `validated` (boolean, default false)
    - `validated_by` (uuid, nullable)
    - `created_at`

2. Security
  - RLS enabled on all tables with authenticated CRUD policies (app has auth).

3. Notes
  - finding_templates and recommendation_library are reference data (read-mostly).
  - assessment_findings_v2 uses a separate name to avoid conflict with any existing assessment_findings table.
  - The workflow enforces: Potential -> Under Review -> Confirmed/Rejected/Merged -> Management Response -> Action Plan Defined -> Closed.
  - Action plans can only exist for Confirmed findings (enforced in application logic).
*/

-- recommendation_library
CREATE TABLE IF NOT EXISTS recommendation_library (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  recommendation_code text UNIQUE NOT NULL,
  category text NOT NULL,
  title text NOT NULL,
  recommendation_text text NOT NULL,
  recommendation_type text NOT NULL DEFAULT 'Préventive et corrective',
  priority_default text NOT NULL DEFAULT 'Élevée',
  implementation_horizon text,
  default_owner_role text,
  expected_evidence text,
  closure_criteria text,
  status text NOT NULL DEFAULT 'Approved',
  version text NOT NULL DEFAULT '1.0',
  created_at timestamptz DEFAULT now(),
  updated_at timestamptz DEFAULT now()
);

ALTER TABLE recommendation_library ENABLE ROW LEVEL SECURITY;

DROP POLICY IF EXISTS "select_recommendations" ON recommendation_library;
CREATE POLICY "select_recommendations" ON recommendation_library FOR SELECT
  TO authenticated USING (true);

DROP POLICY IF EXISTS "insert_recommendations" ON recommendation_library;
CREATE POLICY "insert_recommendations" ON recommendation_library FOR INSERT
  TO authenticated WITH CHECK (true);

DROP POLICY IF EXISTS "update_recommendations" ON recommendation_library;
CREATE POLICY "update_recommendations" ON recommendation_library FOR UPDATE
  TO authenticated USING (true) WITH CHECK (true);

DROP POLICY IF EXISTS "delete_recommendations" ON recommendation_library;
CREATE POLICY "delete_recommendations" ON recommendation_library FOR DELETE
  TO authenticated USING (true);

-- finding_templates
CREATE TABLE IF NOT EXISTS finding_templates (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  template_code text UNIQUE NOT NULL,
  question_code text NOT NULL,
  domain text DEFAULT '',
  process text DEFAULT '',
  category text NOT NULL,
  title text NOT NULL,
  criteria text NOT NULL,
  condition_template text NOT NULL,
  root_cause_template text NOT NULL,
  impact_template text NOT NULL,
  likelihood_default text NOT NULL DEFAULT 'Possible',
  impact_default text NOT NULL DEFAULT 'Medium',
  severity_default text NOT NULL DEFAULT 'Medium',
  status_default text NOT NULL DEFAULT 'Potential',
  recommendation_id uuid REFERENCES recommendation_library(id),
  trigger_rules jsonb NOT NULL DEFAULT '[]'::jsonb,
  deduplication_rule text,
  status text NOT NULL DEFAULT 'Active',
  version text NOT NULL DEFAULT '1.0',
  created_at timestamptz DEFAULT now(),
  updated_at timestamptz DEFAULT now()
);

ALTER TABLE finding_templates ENABLE ROW LEVEL SECURITY;

DROP POLICY IF EXISTS "select_finding_templates" ON finding_templates;
CREATE POLICY "select_finding_templates" ON finding_templates FOR SELECT
  TO authenticated USING (true);

DROP POLICY IF EXISTS "insert_finding_templates" ON finding_templates;
CREATE POLICY "insert_finding_templates" ON finding_templates FOR INSERT
  TO authenticated WITH CHECK (true);

DROP POLICY IF EXISTS "update_finding_templates" ON finding_templates;
CREATE POLICY "update_finding_templates" ON finding_templates FOR UPDATE
  TO authenticated USING (true) WITH CHECK (true);

DROP POLICY IF EXISTS "delete_finding_templates" ON finding_templates;
CREATE POLICY "delete_finding_templates" ON finding_templates FOR DELETE
  TO authenticated USING (true);

-- question_finding_mappings
CREATE TABLE IF NOT EXISTS question_finding_mappings (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  question_code text NOT NULL,
  finding_template_id uuid REFERENCES finding_templates(id),
  recommendation_id uuid REFERENCES recommendation_library(id),
  mapping_type text NOT NULL DEFAULT 'Primary',
  validation_rule text DEFAULT 'Reviewer confirmation required',
  created_at timestamptz DEFAULT now(),
  UNIQUE(question_code, finding_template_id)
);

ALTER TABLE question_finding_mappings ENABLE ROW LEVEL SECURITY;

DROP POLICY IF EXISTS "select_qfm" ON question_finding_mappings;
CREATE POLICY "select_qfm" ON question_finding_mappings FOR SELECT
  TO authenticated USING (true);

DROP POLICY IF EXISTS "insert_qfm" ON question_finding_mappings;
CREATE POLICY "insert_qfm" ON question_finding_mappings FOR INSERT
  TO authenticated WITH CHECK (true);

DROP POLICY IF EXISTS "update_qfm" ON question_finding_mappings;
CREATE POLICY "update_qfm" ON question_finding_mappings FOR UPDATE
  TO authenticated USING (true) WITH CHECK (true);

DROP POLICY IF EXISTS "delete_qfm" ON question_finding_mappings;
CREATE POLICY "delete_qfm" ON question_finding_mappings FOR DELETE
  TO authenticated USING (true);

-- assessment_findings_v2 (workflow-driven findings)
CREATE TABLE IF NOT EXISTS assessment_findings_v2 (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  assessment_id uuid NOT NULL REFERENCES assessments(id) ON DELETE CASCADE,
  finding_template_id uuid REFERENCES finding_templates(id),
  title text NOT NULL,
  criteria text,
  condition_text text,
  root_cause text,
  impact_text text,
  likelihood text DEFAULT 'Possible',
  impact_level text DEFAULT 'Medium',
  severity text DEFAULT 'Medium',
  status text NOT NULL DEFAULT 'Potential' CHECK (status IN ('Potential', 'Under Review', 'Confirmed', 'Rejected', 'Merged', 'Management Response', 'Action Plan Defined', 'Closed')),
  created_by uuid REFERENCES auth.users(id),
  reviewer_id uuid REFERENCES auth.users(id),
  merged_into_id uuid REFERENCES assessment_findings_v2(id),
  residual_risk_accepted boolean DEFAULT false,
  residual_risk_justification text,
  created_at timestamptz DEFAULT now(),
  updated_at timestamptz DEFAULT now()
);

ALTER TABLE assessment_findings_v2 ENABLE ROW LEVEL SECURITY;

DROP POLICY IF EXISTS "select_findings_v2" ON assessment_findings_v2;
CREATE POLICY "select_findings_v2" ON assessment_findings_v2 FOR SELECT
  TO authenticated USING (true);

DROP POLICY IF EXISTS "insert_findings_v2" ON assessment_findings_v2;
CREATE POLICY "insert_findings_v2" ON assessment_findings_v2 FOR INSERT
  TO authenticated WITH CHECK (true);

DROP POLICY IF EXISTS "update_findings_v2" ON assessment_findings_v2;
CREATE POLICY "update_findings_v2" ON assessment_findings_v2 FOR UPDATE
  TO authenticated USING (true) WITH CHECK (true);

DROP POLICY IF EXISTS "delete_findings_v2" ON assessment_findings_v2;
CREATE POLICY "delete_findings_v2" ON assessment_findings_v2 FOR DELETE
  TO authenticated USING (true);

-- finding_source_responses (many-to-many: finding <-> assessment_responses)
CREATE TABLE IF NOT EXISTS finding_source_responses (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  finding_id uuid NOT NULL REFERENCES assessment_findings_v2(id) ON DELETE CASCADE,
  assessment_response_id uuid NOT NULL REFERENCES assessment_responses(id) ON DELETE CASCADE,
  created_at timestamptz DEFAULT now(),
  UNIQUE(finding_id, assessment_response_id)
);

ALTER TABLE finding_source_responses ENABLE ROW LEVEL SECURITY;

DROP POLICY IF EXISTS "select_fsr" ON finding_source_responses;
CREATE POLICY "select_fsr" ON finding_source_responses FOR SELECT
  TO authenticated USING (true);

DROP POLICY IF EXISTS "insert_fsr" ON finding_source_responses;
CREATE POLICY "insert_fsr" ON finding_source_responses FOR INSERT
  TO authenticated WITH CHECK (true);

DROP POLICY IF EXISTS "update_fsr" ON finding_source_responses;
CREATE POLICY "update_fsr" ON finding_source_responses FOR UPDATE
  TO authenticated USING (true) WITH CHECK (true);

DROP POLICY IF EXISTS "delete_fsr" ON finding_source_responses;
CREATE POLICY "delete_fsr" ON finding_source_responses FOR DELETE
  TO authenticated USING (true);

-- finding_recommendations (recommendations attached to a finding)
CREATE TABLE IF NOT EXISTS finding_recommendations (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  finding_id uuid NOT NULL REFERENCES assessment_findings_v2(id) ON DELETE CASCADE,
  recommendation_id uuid NOT NULL REFERENCES recommendation_library(id),
  override_text text,
  is_primary boolean DEFAULT true,
  created_at timestamptz DEFAULT now(),
  UNIQUE(finding_id, recommendation_id)
);

ALTER TABLE finding_recommendations ENABLE ROW LEVEL SECURITY;

DROP POLICY IF EXISTS "select_fr" ON finding_recommendations;
CREATE POLICY "select_fr" ON finding_recommendations FOR SELECT
  TO authenticated USING (true);

DROP POLICY IF EXISTS "insert_fr" ON finding_recommendations;
CREATE POLICY "insert_fr" ON finding_recommendations FOR INSERT
  TO authenticated WITH CHECK (true);

DROP POLICY IF EXISTS "update_fr" ON finding_recommendations;
CREATE POLICY "update_fr" ON finding_recommendations FOR UPDATE
  TO authenticated USING (true) WITH CHECK (true);

DROP POLICY IF EXISTS "delete_fr" ON finding_recommendations;
CREATE POLICY "delete_fr" ON finding_recommendations FOR DELETE
  TO authenticated USING (true);

-- finding_action_plans
CREATE TABLE IF NOT EXISTS finding_action_plans (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  finding_id uuid NOT NULL REFERENCES assessment_findings_v2(id) ON DELETE CASCADE,
  title text NOT NULL,
  description text,
  owner text,
  due_date date,
  priority text DEFAULT 'Medium',
  status text NOT NULL DEFAULT 'Draft' CHECK (status IN ('Draft', 'Management Review', 'Accepted', 'In Progress', 'Evidence Submitted', 'Closure Review', 'Closed', 'Reopened')),
  progress_pct integer NOT NULL DEFAULT 0 CHECK (progress_pct >= 0 AND progress_pct <= 100),
  created_at timestamptz DEFAULT now(),
  updated_at timestamptz DEFAULT now()
);

ALTER TABLE finding_action_plans ENABLE ROW LEVEL SECURITY;

DROP POLICY IF EXISTS "select_fap" ON finding_action_plans;
CREATE POLICY "select_fap" ON finding_action_plans FOR SELECT
  TO authenticated USING (true);

DROP POLICY IF EXISTS "insert_fap" ON finding_action_plans;
CREATE POLICY "insert_fap" ON finding_action_plans FOR INSERT
  TO authenticated WITH CHECK (true);

DROP POLICY IF EXISTS "update_fap" ON finding_action_plans;
CREATE POLICY "update_fap" ON finding_action_plans FOR UPDATE
  TO authenticated USING (true) WITH CHECK (true);

DROP POLICY IF EXISTS "delete_fap" ON finding_action_plans;
CREATE POLICY "delete_fap" ON finding_action_plans FOR DELETE
  TO authenticated USING (true);

-- action_plan_evidence
CREATE TABLE IF NOT EXISTS action_plan_evidence (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  action_plan_id uuid NOT NULL REFERENCES finding_action_plans(id) ON DELETE CASCADE,
  evidence_type text NOT NULL DEFAULT 'Document',
  description text NOT NULL,
  file_url text,
  validated boolean DEFAULT false,
  validated_by uuid REFERENCES auth.users(id),
  created_at timestamptz DEFAULT now()
);

ALTER TABLE action_plan_evidence ENABLE ROW LEVEL SECURITY;

DROP POLICY IF EXISTS "select_ape" ON action_plan_evidence;
CREATE POLICY "select_ape" ON action_plan_evidence FOR SELECT
  TO authenticated USING (true);

DROP POLICY IF EXISTS "insert_ape" ON action_plan_evidence;
CREATE POLICY "insert_ape" ON action_plan_evidence FOR INSERT
  TO authenticated WITH CHECK (true);

DROP POLICY IF EXISTS "update_ape" ON action_plan_evidence;
CREATE POLICY "update_ape" ON action_plan_evidence FOR UPDATE
  TO authenticated USING (true) WITH CHECK (true);

DROP POLICY IF EXISTS "delete_ape" ON action_plan_evidence;
CREATE POLICY "delete_ape" ON action_plan_evidence FOR DELETE
  TO authenticated USING (true);

-- Indexes for performance
CREATE INDEX IF NOT EXISTS idx_finding_templates_question_code ON finding_templates(question_code);
CREATE INDEX IF NOT EXISTS idx_finding_templates_recommendation ON finding_templates(recommendation_id);
CREATE INDEX IF NOT EXISTS idx_qfm_question_code ON question_finding_mappings(question_code);
CREATE INDEX IF NOT EXISTS idx_findings_v2_assessment ON assessment_findings_v2(assessment_id);
CREATE INDEX IF NOT EXISTS idx_findings_v2_status ON assessment_findings_v2(status);
CREATE INDEX IF NOT EXISTS idx_findings_v2_template ON assessment_findings_v2(finding_template_id);
CREATE INDEX IF NOT EXISTS idx_fsr_finding ON finding_source_responses(finding_id);
CREATE INDEX IF NOT EXISTS idx_fsr_response ON finding_source_responses(assessment_response_id);
CREATE INDEX IF NOT EXISTS idx_fr_finding ON finding_recommendations(finding_id);
CREATE INDEX IF NOT EXISTS idx_fap_finding ON finding_action_plans(finding_id);
CREATE INDEX IF NOT EXISTS idx_fap_status ON finding_action_plans(status);
CREATE INDEX IF NOT EXISTS idx_ape_action_plan ON action_plan_evidence(action_plan_id);
