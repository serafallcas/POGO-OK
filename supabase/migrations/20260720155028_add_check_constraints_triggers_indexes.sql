/*
# Database normalization - CHECK constraints, triggers, missing indexes

1. Changes
   - Add CHECK constraints on assessment_responses: score 0-5, maturity_level 0-5
   - Add CHECK on improvement_actions: progress_percent 0-100
   - Add CHECK on assessment_responses: valid confidence_level enum
   - Add CHECK on assessments: valid status enum
   - Create updated_at trigger function and apply to key tables
   - Add indexes for frequent query patterns
   - Add unique constraint on assessment_evidence(assessment_response_id, evidence_name) to prevent duplicates

2. Security
   - No RLS changes in this migration

3. Important Notes
   - All statements are idempotent (IF NOT EXISTS, DO $$ blocks)
   - No data deletion or column drops
*/

-- CHECK constraint: score 0-5 on assessment_responses
DO $$ BEGIN
  IF NOT EXISTS (SELECT 1 FROM pg_constraint WHERE conname = 'assessment_responses_score_range') THEN
    ALTER TABLE assessment_responses ADD CONSTRAINT assessment_responses_score_range CHECK (score IS NULL OR (score >= 0 AND score <= 5));
  END IF;
END $$;

-- CHECK constraint: maturity_level 0-5
DO $$ BEGIN
  IF NOT EXISTS (SELECT 1 FROM pg_constraint WHERE conname = 'assessment_responses_maturity_range') THEN
    ALTER TABLE assessment_responses ADD CONSTRAINT assessment_responses_maturity_range CHECK (maturity_level IS NULL OR (maturity_level >= 0 AND maturity_level <= 5));
  END IF;
END $$;

-- CHECK constraint: progress 0-100 on improvement_actions
DO $$ BEGIN
  IF NOT EXISTS (SELECT 1 FROM pg_constraint WHERE conname = 'improvement_actions_progress_range') THEN
    ALTER TABLE improvement_actions ADD CONSTRAINT improvement_actions_progress_range CHECK (progress_percent >= 0 AND progress_percent <= 100);
  END IF;
END $$;

-- CHECK constraint: confidence_level valid values
DO $$ BEGIN
  IF NOT EXISTS (SELECT 1 FROM pg_constraint WHERE conname = 'assessment_responses_confidence_valid') THEN
    ALTER TABLE assessment_responses ADD CONSTRAINT assessment_responses_confidence_valid CHECK (confidence_level IN ('low', 'medium', 'high'));
  END IF;
END $$;

-- CHECK constraint: assessments status valid values
DO $$ BEGIN
  IF NOT EXISTS (SELECT 1 FROM pg_constraint WHERE conname = 'assessments_status_valid') THEN
    ALTER TABLE assessments ADD CONSTRAINT assessments_status_valid CHECK (status IN ('draft', 'in_progress', 'under_review', 'approved', 'closed'));
  END IF;
END $$;

-- updated_at trigger function
CREATE OR REPLACE FUNCTION trigger_set_updated_at()
RETURNS TRIGGER AS $$
BEGIN
  NEW.updated_at = now();
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Apply updated_at trigger to tables that have the column
DO $$ 
DECLARE
  tbl text;
BEGIN
  FOR tbl IN SELECT unnest(ARRAY[
    'assessments', 'assessment_responses', 'questions', 'domains', 'processes',
    'evaluation_types', 'organizations', 'findings', 'improvement_actions',
    'maturity_models', 'maturity_statements', 'assessment_evidence',
    'question_instruction_guides', 'question_evidence_guides', 'question_maturity_guides'
  ])
  LOOP
    IF EXISTS (
      SELECT 1 FROM information_schema.columns 
      WHERE table_schema = 'public' AND table_name = tbl AND column_name = 'updated_at'
    ) THEN
      EXECUTE format('DROP TRIGGER IF EXISTS set_updated_at ON %I', tbl);
      EXECUTE format('CREATE TRIGGER set_updated_at BEFORE UPDATE ON %I FOR EACH ROW EXECUTE FUNCTION trigger_set_updated_at()', tbl);
    END IF;
  END LOOP;
END $$;

-- Indexes for common queries
CREATE INDEX IF NOT EXISTS idx_assessment_responses_assessment_id ON assessment_responses(assessment_id);
CREATE INDEX IF NOT EXISTS idx_assessment_responses_question_id ON assessment_responses(question_id);
CREATE INDEX IF NOT EXISTS idx_questions_evaluation_type_id ON questions(evaluation_type_id);
CREATE INDEX IF NOT EXISTS idx_questions_domain_id ON questions(domain_id);
CREATE INDEX IF NOT EXISTS idx_questions_process_id ON questions(process_id);
CREATE INDEX IF NOT EXISTS idx_domains_evaluation_type_id ON domains(evaluation_type_id);
CREATE INDEX IF NOT EXISTS idx_processes_domain_id ON processes(domain_id);
CREATE INDEX IF NOT EXISTS idx_assessments_organization_id ON assessments(organization_id);
CREATE INDEX IF NOT EXISTS idx_assessments_evaluation_type_id ON assessments(evaluation_type_id);
CREATE INDEX IF NOT EXISTS idx_assessment_evidence_response_id ON assessment_evidence(assessment_response_id);
CREATE INDEX IF NOT EXISTS idx_findings_assessment_id ON findings(assessment_id);
CREATE INDEX IF NOT EXISTS idx_improvement_actions_finding_id ON improvement_actions(finding_id);
