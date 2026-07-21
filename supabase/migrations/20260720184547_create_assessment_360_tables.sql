/*
# Assessment 360 Model - Validation Gates, Response Reviews, Decision Trees

1. New Tables
   - `assessment_validation_gates` - Tracks the 5 mandatory gates per assessment
     - id (uuid PK)
     - assessment_id (uuid FK)
     - gate_number (int 1-5)
     - gate_name (text)
     - status (text: pending/in_progress/passed/failed)
     - checked_by (uuid nullable)
     - checked_at (timestamptz nullable)
     - notes (text nullable)
     - created_at, updated_at
   
   - `response_reviews` - Reviewer actions on individual responses
     - id (uuid PK)
     - assessment_response_id (uuid FK)
     - reviewer_id (uuid FK)
     - action (text: accepted/correction_required/score_adjusted/rejected)
     - previous_score (int nullable)
     - adjusted_score (int nullable)
     - comment (text)
     - created_at
   
   - `decision_tree_responses` - Evaluator answers to decision tree questions
     - id (uuid PK)
     - assessment_response_id (uuid FK)
     - node_key (text - identifies the decision tree question)
     - answer (text - yes/no/na)
     - max_score_cap (int nullable - derived cap from this answer)
     - created_at

   - `assessment_scope_items` - Snapshot of scope at creation
     - id (uuid PK)
     - assessment_id (uuid FK)
     - domain_id (uuid FK)
     - process_id (uuid nullable FK)
     - included (boolean default true)
     - created_at

2. Modified Tables
   - `assessment_responses` - Add review_status, submitted_at, reviewed_at, reviewer_id, score_cap, finding_potential
   - `assessments` - Add validation_progress jsonb column

3. Security
   - RLS enabled on all new tables
   - Policies allow authenticated users CRUD (will be tightened in LOT 13 - RLS)

4. Important Notes
   - All statements are idempotent
   - No data deletion or column drops
   - Existing assessment_responses data preserved
*/

-- 1. assessment_validation_gates
CREATE TABLE IF NOT EXISTS assessment_validation_gates (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  assessment_id uuid NOT NULL REFERENCES assessments(id) ON DELETE CASCADE,
  gate_number int NOT NULL CHECK (gate_number BETWEEN 1 AND 5),
  gate_name text NOT NULL,
  status text NOT NULL DEFAULT 'pending' CHECK (status IN ('pending', 'in_progress', 'passed', 'failed')),
  checked_by uuid REFERENCES profiles(id),
  checked_at timestamptz,
  notes text,
  created_at timestamptz DEFAULT now(),
  updated_at timestamptz DEFAULT now(),
  UNIQUE(assessment_id, gate_number)
);

ALTER TABLE assessment_validation_gates ENABLE ROW LEVEL SECURITY;

DROP POLICY IF EXISTS "auth_select_gates" ON assessment_validation_gates;
CREATE POLICY "auth_select_gates" ON assessment_validation_gates FOR SELECT TO authenticated USING (true);
DROP POLICY IF EXISTS "auth_insert_gates" ON assessment_validation_gates;
CREATE POLICY "auth_insert_gates" ON assessment_validation_gates FOR INSERT TO authenticated WITH CHECK (true);
DROP POLICY IF EXISTS "auth_update_gates" ON assessment_validation_gates;
CREATE POLICY "auth_update_gates" ON assessment_validation_gates FOR UPDATE TO authenticated USING (true) WITH CHECK (true);
DROP POLICY IF EXISTS "auth_delete_gates" ON assessment_validation_gates;
CREATE POLICY "auth_delete_gates" ON assessment_validation_gates FOR DELETE TO authenticated USING (true);

-- 2. response_reviews
CREATE TABLE IF NOT EXISTS response_reviews (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  assessment_response_id uuid NOT NULL REFERENCES assessment_responses(id) ON DELETE CASCADE,
  reviewer_id uuid NOT NULL REFERENCES profiles(id),
  action text NOT NULL CHECK (action IN ('accepted', 'correction_required', 'score_adjusted', 'rejected')),
  previous_score int,
  adjusted_score int,
  comment text,
  created_at timestamptz DEFAULT now()
);

ALTER TABLE response_reviews ENABLE ROW LEVEL SECURITY;

DROP POLICY IF EXISTS "auth_select_reviews" ON response_reviews;
CREATE POLICY "auth_select_reviews" ON response_reviews FOR SELECT TO authenticated USING (true);
DROP POLICY IF EXISTS "auth_insert_reviews" ON response_reviews;
CREATE POLICY "auth_insert_reviews" ON response_reviews FOR INSERT TO authenticated WITH CHECK (true);
DROP POLICY IF EXISTS "auth_update_reviews" ON response_reviews;
CREATE POLICY "auth_update_reviews" ON response_reviews FOR UPDATE TO authenticated USING (true) WITH CHECK (true);
DROP POLICY IF EXISTS "auth_delete_reviews" ON response_reviews;
CREATE POLICY "auth_delete_reviews" ON response_reviews FOR DELETE TO authenticated USING (true);

-- 3. decision_tree_responses
CREATE TABLE IF NOT EXISTS decision_tree_responses (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  assessment_response_id uuid NOT NULL REFERENCES assessment_responses(id) ON DELETE CASCADE,
  node_key text NOT NULL,
  answer text NOT NULL CHECK (answer IN ('yes', 'no', 'na', 'partial')),
  max_score_cap int CHECK (max_score_cap IS NULL OR (max_score_cap >= 0 AND max_score_cap <= 5)),
  created_at timestamptz DEFAULT now(),
  UNIQUE(assessment_response_id, node_key)
);

ALTER TABLE decision_tree_responses ENABLE ROW LEVEL SECURITY;

DROP POLICY IF EXISTS "auth_select_dt" ON decision_tree_responses;
CREATE POLICY "auth_select_dt" ON decision_tree_responses FOR SELECT TO authenticated USING (true);
DROP POLICY IF EXISTS "auth_insert_dt" ON decision_tree_responses;
CREATE POLICY "auth_insert_dt" ON decision_tree_responses FOR INSERT TO authenticated WITH CHECK (true);
DROP POLICY IF EXISTS "auth_update_dt" ON decision_tree_responses;
CREATE POLICY "auth_update_dt" ON decision_tree_responses FOR UPDATE TO authenticated USING (true) WITH CHECK (true);
DROP POLICY IF EXISTS "auth_delete_dt" ON decision_tree_responses;
CREATE POLICY "auth_delete_dt" ON decision_tree_responses FOR DELETE TO authenticated USING (true);

-- 4. assessment_scope_items
CREATE TABLE IF NOT EXISTS assessment_scope_items (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  assessment_id uuid NOT NULL REFERENCES assessments(id) ON DELETE CASCADE,
  domain_id uuid NOT NULL REFERENCES domains(id),
  process_id uuid REFERENCES processes(id),
  included boolean NOT NULL DEFAULT true,
  created_at timestamptz DEFAULT now(),
  UNIQUE(assessment_id, domain_id, process_id)
);

ALTER TABLE assessment_scope_items ENABLE ROW LEVEL SECURITY;

DROP POLICY IF EXISTS "auth_select_scope" ON assessment_scope_items;
CREATE POLICY "auth_select_scope" ON assessment_scope_items FOR SELECT TO authenticated USING (true);
DROP POLICY IF EXISTS "auth_insert_scope" ON assessment_scope_items;
CREATE POLICY "auth_insert_scope" ON assessment_scope_items FOR INSERT TO authenticated WITH CHECK (true);
DROP POLICY IF EXISTS "auth_update_scope" ON assessment_scope_items;
CREATE POLICY "auth_update_scope" ON assessment_scope_items FOR UPDATE TO authenticated USING (true) WITH CHECK (true);
DROP POLICY IF EXISTS "auth_delete_scope" ON assessment_scope_items;
CREATE POLICY "auth_delete_scope" ON assessment_scope_items FOR DELETE TO authenticated USING (true);

-- 5. Add columns to assessment_responses
DO $$ BEGIN
  IF NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_name='assessment_responses' AND column_name='review_status') THEN
    ALTER TABLE assessment_responses ADD COLUMN review_status text DEFAULT 'draft' CHECK (review_status IN ('draft', 'completed', 'submitted', 'reviewed', 'correction_required', 'accepted', 'validated'));
  END IF;
  IF NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_name='assessment_responses' AND column_name='submitted_at') THEN
    ALTER TABLE assessment_responses ADD COLUMN submitted_at timestamptz;
  END IF;
  IF NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_name='assessment_responses' AND column_name='reviewed_at') THEN
    ALTER TABLE assessment_responses ADD COLUMN reviewed_at timestamptz;
  END IF;
  IF NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_name='assessment_responses' AND column_name='reviewer_id') THEN
    ALTER TABLE assessment_responses ADD COLUMN reviewer_id uuid REFERENCES profiles(id);
  END IF;
  IF NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_name='assessment_responses' AND column_name='score_cap') THEN
    ALTER TABLE assessment_responses ADD COLUMN score_cap int CHECK (score_cap IS NULL OR (score_cap >= 0 AND score_cap <= 5));
  END IF;
  IF NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_name='assessment_responses' AND column_name='finding_potential') THEN
    ALTER TABLE assessment_responses ADD COLUMN finding_potential boolean DEFAULT false;
  END IF;
  IF NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_name='assessment_responses' AND column_name='conclusion_text') THEN
    ALTER TABLE assessment_responses ADD COLUMN conclusion_text text;
  END IF;
END $$;

-- 6. Add validation_progress to assessments
DO $$ BEGIN
  IF NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_name='assessments' AND column_name='validation_progress') THEN
    ALTER TABLE assessments ADD COLUMN validation_progress jsonb DEFAULT '{"gate1":false,"gate2":false,"gate3":false,"gate4":false,"gate5":false}'::jsonb;
  END IF;
END $$;

-- 7. Indexes
CREATE INDEX IF NOT EXISTS idx_validation_gates_assessment ON assessment_validation_gates(assessment_id);
CREATE INDEX IF NOT EXISTS idx_response_reviews_response ON response_reviews(assessment_response_id);
CREATE INDEX IF NOT EXISTS idx_decision_tree_response ON decision_tree_responses(assessment_response_id);
CREATE INDEX IF NOT EXISTS idx_scope_items_assessment ON assessment_scope_items(assessment_id);

-- 8. Updated_at triggers for new tables
DROP TRIGGER IF EXISTS set_updated_at ON assessment_validation_gates;
CREATE TRIGGER set_updated_at BEFORE UPDATE ON assessment_validation_gates FOR EACH ROW EXECUTE FUNCTION trigger_set_updated_at();
