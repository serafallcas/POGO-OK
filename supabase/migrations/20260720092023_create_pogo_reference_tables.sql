/*
# POGO Evaluation Tool - Reference Tables

## Overview
Creates the core reference data tables for the POGO Evaluation Tool enterprise assessment platform.

## New Tables
1. **organizations** - Companies/entities being assessed
   - id, name, code, sector, country, status, timestamps
2. **roles** - RBAC role definitions
   - id, code, label, description
3. **profiles** - User profiles linked to auth.users
   - id, auth_user_id, full_name, email, role, organization_id, status
4. **evaluation_types** - Types of evaluations (POGO 1, POGO 2A-F)
   - id, code, label, description, category, is_active, sort_order
5. **domains** - Business domains for evaluation
   - id, evaluation_type_id, code, label, description, parent_domain_id, mapped_maturity_model_id, is_active, sort_order
6. **processes** - Business processes within domains
   - id, domain_id, evaluation_type_id, code, label, description, process_owner_type, criticality, is_active, sort_order
7. **maturity_models** - Maturity model definitions
   - id, code, label, description, domain_id, version, is_active
8. **maturity_levels** - Levels within a maturity model
   - id, maturity_model_id, level_number, level_code, level_label, level_description, sort_order
9. **maturity_statements** - Detailed statements per maturity level
   - id, maturity_model_id, domain_id, process_id, process_area, level_1 through level_5, assessor_instruction, evidence_examples, sort_order

## Security
- RLS enabled on all tables
- Policies allow authenticated users full CRUD (role-based filtering done at app level)
*/

-- Organizations
CREATE TABLE IF NOT EXISTS organizations (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  name text NOT NULL,
  code text UNIQUE,
  sector text,
  country text,
  status text NOT NULL DEFAULT 'active',
  created_at timestamptz DEFAULT now(),
  updated_at timestamptz DEFAULT now()
);

ALTER TABLE organizations ENABLE ROW LEVEL SECURITY;

DROP POLICY IF EXISTS "auth_select_organizations" ON organizations;
CREATE POLICY "auth_select_organizations" ON organizations FOR SELECT TO authenticated USING (true);
DROP POLICY IF EXISTS "auth_insert_organizations" ON organizations;
CREATE POLICY "auth_insert_organizations" ON organizations FOR INSERT TO authenticated WITH CHECK (true);
DROP POLICY IF EXISTS "auth_update_organizations" ON organizations;
CREATE POLICY "auth_update_organizations" ON organizations FOR UPDATE TO authenticated USING (true) WITH CHECK (true);
DROP POLICY IF EXISTS "auth_delete_organizations" ON organizations;
CREATE POLICY "auth_delete_organizations" ON organizations FOR DELETE TO authenticated USING (true);

-- Roles
CREATE TABLE IF NOT EXISTS roles (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  code text UNIQUE NOT NULL,
  label text NOT NULL,
  description text,
  created_at timestamptz DEFAULT now()
);

ALTER TABLE roles ENABLE ROW LEVEL SECURITY;

DROP POLICY IF EXISTS "auth_select_roles" ON roles;
CREATE POLICY "auth_select_roles" ON roles FOR SELECT TO authenticated USING (true);
DROP POLICY IF EXISTS "auth_insert_roles" ON roles;
CREATE POLICY "auth_insert_roles" ON roles FOR INSERT TO authenticated WITH CHECK (true);
DROP POLICY IF EXISTS "auth_update_roles" ON roles;
CREATE POLICY "auth_update_roles" ON roles FOR UPDATE TO authenticated USING (true) WITH CHECK (true);
DROP POLICY IF EXISTS "auth_delete_roles" ON roles;
CREATE POLICY "auth_delete_roles" ON roles FOR DELETE TO authenticated USING (true);

-- Profiles
CREATE TABLE IF NOT EXISTS profiles (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  auth_user_id uuid UNIQUE REFERENCES auth.users(id) ON DELETE CASCADE,
  full_name text,
  email text,
  role text NOT NULL DEFAULT 'evaluator',
  organization_id uuid REFERENCES organizations(id),
  status text NOT NULL DEFAULT 'active',
  created_at timestamptz DEFAULT now(),
  updated_at timestamptz DEFAULT now()
);

ALTER TABLE profiles ENABLE ROW LEVEL SECURITY;

DROP POLICY IF EXISTS "auth_select_profiles" ON profiles;
CREATE POLICY "auth_select_profiles" ON profiles FOR SELECT TO authenticated USING (true);
DROP POLICY IF EXISTS "auth_insert_profiles" ON profiles;
CREATE POLICY "auth_insert_profiles" ON profiles FOR INSERT TO authenticated WITH CHECK (true);
DROP POLICY IF EXISTS "auth_update_profiles" ON profiles;
CREATE POLICY "auth_update_profiles" ON profiles FOR UPDATE TO authenticated USING (true) WITH CHECK (true);
DROP POLICY IF EXISTS "auth_delete_profiles" ON profiles;
CREATE POLICY "auth_delete_profiles" ON profiles FOR DELETE TO authenticated USING (true);

-- Evaluation Types
CREATE TABLE IF NOT EXISTS evaluation_types (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  code text UNIQUE NOT NULL,
  label text NOT NULL,
  description text,
  category text,
  source_workbook text,
  is_active boolean NOT NULL DEFAULT true,
  sort_order integer DEFAULT 0,
  created_at timestamptz DEFAULT now(),
  updated_at timestamptz DEFAULT now()
);

ALTER TABLE evaluation_types ENABLE ROW LEVEL SECURITY;

DROP POLICY IF EXISTS "auth_select_evaluation_types" ON evaluation_types;
CREATE POLICY "auth_select_evaluation_types" ON evaluation_types FOR SELECT TO authenticated USING (true);
DROP POLICY IF EXISTS "auth_insert_evaluation_types" ON evaluation_types;
CREATE POLICY "auth_insert_evaluation_types" ON evaluation_types FOR INSERT TO authenticated WITH CHECK (true);
DROP POLICY IF EXISTS "auth_update_evaluation_types" ON evaluation_types;
CREATE POLICY "auth_update_evaluation_types" ON evaluation_types FOR UPDATE TO authenticated USING (true) WITH CHECK (true);
DROP POLICY IF EXISTS "auth_delete_evaluation_types" ON evaluation_types;
CREATE POLICY "auth_delete_evaluation_types" ON evaluation_types FOR DELETE TO authenticated USING (true);

-- Domains
CREATE TABLE IF NOT EXISTS domains (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  evaluation_type_id uuid REFERENCES evaluation_types(id),
  code text UNIQUE NOT NULL,
  label text NOT NULL,
  description text,
  parent_domain_id uuid REFERENCES domains(id),
  mapped_maturity_model_id text,
  has_maturity_model boolean DEFAULT false,
  is_active boolean NOT NULL DEFAULT true,
  sort_order integer DEFAULT 0,
  created_at timestamptz DEFAULT now(),
  updated_at timestamptz DEFAULT now()
);

ALTER TABLE domains ENABLE ROW LEVEL SECURITY;

DROP POLICY IF EXISTS "auth_select_domains" ON domains;
CREATE POLICY "auth_select_domains" ON domains FOR SELECT TO authenticated USING (true);
DROP POLICY IF EXISTS "auth_insert_domains" ON domains;
CREATE POLICY "auth_insert_domains" ON domains FOR INSERT TO authenticated WITH CHECK (true);
DROP POLICY IF EXISTS "auth_update_domains" ON domains;
CREATE POLICY "auth_update_domains" ON domains FOR UPDATE TO authenticated USING (true) WITH CHECK (true);
DROP POLICY IF EXISTS "auth_delete_domains" ON domains;
CREATE POLICY "auth_delete_domains" ON domains FOR DELETE TO authenticated USING (true);

CREATE INDEX IF NOT EXISTS idx_domains_eval_type ON domains(evaluation_type_id);

-- Processes
CREATE TABLE IF NOT EXISTS processes (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  domain_id uuid REFERENCES domains(id),
  evaluation_type_id uuid REFERENCES evaluation_types(id),
  code text UNIQUE NOT NULL,
  label text NOT NULL,
  description text,
  process_owner_type text,
  criticality text,
  sheet_name text,
  is_active boolean NOT NULL DEFAULT true,
  sort_order integer DEFAULT 0,
  created_at timestamptz DEFAULT now(),
  updated_at timestamptz DEFAULT now()
);

ALTER TABLE processes ENABLE ROW LEVEL SECURITY;

DROP POLICY IF EXISTS "auth_select_processes" ON processes;
CREATE POLICY "auth_select_processes" ON processes FOR SELECT TO authenticated USING (true);
DROP POLICY IF EXISTS "auth_insert_processes" ON processes;
CREATE POLICY "auth_insert_processes" ON processes FOR INSERT TO authenticated WITH CHECK (true);
DROP POLICY IF EXISTS "auth_update_processes" ON processes;
CREATE POLICY "auth_update_processes" ON processes FOR UPDATE TO authenticated USING (true) WITH CHECK (true);
DROP POLICY IF EXISTS "auth_delete_processes" ON processes;
CREATE POLICY "auth_delete_processes" ON processes FOR DELETE TO authenticated USING (true);

CREATE INDEX IF NOT EXISTS idx_processes_domain ON processes(domain_id);

-- Maturity Models
CREATE TABLE IF NOT EXISTS maturity_models (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  code text UNIQUE NOT NULL,
  label text NOT NULL,
  description text,
  domain_id uuid REFERENCES domains(id),
  mapped_domain_id text,
  mapped_domain_name text,
  version text DEFAULT '1.0',
  source_workbook text,
  is_active boolean NOT NULL DEFAULT true,
  created_at timestamptz DEFAULT now(),
  updated_at timestamptz DEFAULT now()
);

ALTER TABLE maturity_models ENABLE ROW LEVEL SECURITY;

DROP POLICY IF EXISTS "auth_select_maturity_models" ON maturity_models;
CREATE POLICY "auth_select_maturity_models" ON maturity_models FOR SELECT TO authenticated USING (true);
DROP POLICY IF EXISTS "auth_insert_maturity_models" ON maturity_models;
CREATE POLICY "auth_insert_maturity_models" ON maturity_models FOR INSERT TO authenticated WITH CHECK (true);
DROP POLICY IF EXISTS "auth_update_maturity_models" ON maturity_models;
CREATE POLICY "auth_update_maturity_models" ON maturity_models FOR UPDATE TO authenticated USING (true) WITH CHECK (true);
DROP POLICY IF EXISTS "auth_delete_maturity_models" ON maturity_models;
CREATE POLICY "auth_delete_maturity_models" ON maturity_models FOR DELETE TO authenticated USING (true);

-- Maturity Levels
CREATE TABLE IF NOT EXISTS maturity_levels (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  maturity_model_id uuid REFERENCES maturity_models(id) ON DELETE CASCADE,
  level_number integer NOT NULL,
  level_code text,
  level_label text NOT NULL,
  level_description text,
  sort_order integer DEFAULT 0,
  created_at timestamptz DEFAULT now()
);

ALTER TABLE maturity_levels ENABLE ROW LEVEL SECURITY;

DROP POLICY IF EXISTS "auth_select_maturity_levels" ON maturity_levels;
CREATE POLICY "auth_select_maturity_levels" ON maturity_levels FOR SELECT TO authenticated USING (true);
DROP POLICY IF EXISTS "auth_insert_maturity_levels" ON maturity_levels;
CREATE POLICY "auth_insert_maturity_levels" ON maturity_levels FOR INSERT TO authenticated WITH CHECK (true);
DROP POLICY IF EXISTS "auth_update_maturity_levels" ON maturity_levels;
CREATE POLICY "auth_update_maturity_levels" ON maturity_levels FOR UPDATE TO authenticated USING (true) WITH CHECK (true);
DROP POLICY IF EXISTS "auth_delete_maturity_levels" ON maturity_levels;
CREATE POLICY "auth_delete_maturity_levels" ON maturity_levels FOR DELETE TO authenticated USING (true);

CREATE INDEX IF NOT EXISTS idx_maturity_levels_model ON maturity_levels(maturity_model_id);

-- Maturity Statements
CREATE TABLE IF NOT EXISTS maturity_statements (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  maturity_model_id text NOT NULL,
  domain_title text,
  mapped_domain_id text,
  process_area text,
  level_1_basic text,
  level_2_developing text,
  level_3_established text,
  level_4_advanced text,
  level_5_leading text,
  assessor_instruction text,
  evidence_examples text,
  review_steps text,
  alert_rule_hint text,
  source_row text,
  is_active boolean NOT NULL DEFAULT true,
  sort_order integer DEFAULT 0,
  created_at timestamptz DEFAULT now(),
  updated_at timestamptz DEFAULT now()
);

ALTER TABLE maturity_statements ENABLE ROW LEVEL SECURITY;

DROP POLICY IF EXISTS "auth_select_maturity_statements" ON maturity_statements;
CREATE POLICY "auth_select_maturity_statements" ON maturity_statements FOR SELECT TO authenticated USING (true);
DROP POLICY IF EXISTS "auth_insert_maturity_statements" ON maturity_statements;
CREATE POLICY "auth_insert_maturity_statements" ON maturity_statements FOR INSERT TO authenticated WITH CHECK (true);
DROP POLICY IF EXISTS "auth_update_maturity_statements" ON maturity_statements;
CREATE POLICY "auth_update_maturity_statements" ON maturity_statements FOR UPDATE TO authenticated USING (true) WITH CHECK (true);
DROP POLICY IF EXISTS "auth_delete_maturity_statements" ON maturity_statements;
CREATE POLICY "auth_delete_maturity_statements" ON maturity_statements FOR DELETE TO authenticated USING (true);

CREATE INDEX IF NOT EXISTS idx_maturity_statements_model ON maturity_statements(maturity_model_id);

-- Seed default roles
INSERT INTO roles (code, label, description) VALUES
  ('super_admin', 'Super Admin', 'Full platform control'),
  ('program_admin', 'Program Admin', 'Manage evaluation frameworks and mappings'),
  ('assessment_manager', 'Assessment Manager', 'Create and manage assessments'),
  ('evaluator', 'Evaluator', 'Answer questions and upload evidence'),
  ('reviewer', 'Reviewer / QA', 'Review and validate responses'),
  ('read_only', 'Read Only', 'Consult dashboards and reports only')
ON CONFLICT (code) DO NOTHING;