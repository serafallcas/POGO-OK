export interface Organization {
  id: string;
  name: string;
  code: string | null;
  sector: string | null;
  country: string | null;
  status: string;
}

export interface Profile {
  id: string;
  auth_user_id: string;
  full_name: string | null;
  email: string | null;
  role: string;
  organization_id: string | null;
  status: string;
}

export interface EvaluationType {
  id: string;
  code: string;
  label: string;
  description: string | null;
  category: string | null;
  source_workbook: string | null;
  is_active: boolean;
  sort_order: number;
}

export interface Domain {
  id: string;
  evaluation_type_id: string | null;
  code: string;
  label: string;
  description: string | null;
  parent_domain_id: string | null;
  mapped_maturity_model_id: string | null;
  has_maturity_model: boolean;
  is_active: boolean;
  sort_order: number;
}

export interface Process {
  id: string;
  domain_id: string | null;
  evaluation_type_id: string | null;
  code: string;
  label: string;
  description: string | null;
  process_owner_type: string | null;
  criticality: string | null;
  sheet_name: string | null;
  is_active: boolean;
  sort_order: number;
}

export interface MaturityModel {
  id: string;
  code: string;
  label: string;
  description: string | null;
  domain_id: string | null;
  mapped_domain_id: string | null;
  mapped_domain_name: string | null;
  version: string;
  source_workbook: string | null;
  is_active: boolean;
}

export interface MaturityStatement {
  id: string;
  maturity_model_id: string;
  domain_title: string | null;
  mapped_domain_id: string | null;
  process_area: string | null;
  level_1_basic: string | null;
  level_2_developing: string | null;
  level_3_established: string | null;
  level_4_advanced: string | null;
  level_5_leading: string | null;
  assessor_instruction: string | null;
  evidence_examples: string | null;
  is_active: boolean;
}

export interface Question {
  id: string;
  questionnaire_id: string | null;
  evaluation_type_id: string | null;
  domain_id: string | null;
  process_id: string | null;
  question_code: string;
  question_text: string;
  question_intent: string | null;
  instruction_text: string | null;
  evidence_examples: string | null;
  cmmi_reference: string | null;
  alert_rule_hint: string | null;
  mapped_maturity_model_id: string | null;
  mapped_maturity_statement_id: string | null;
  matched_process_area: string | null;
  maturity_match_score: number | null;
  response_type: string;
  scoring_scale: string;
  weight: number;
  is_mandatory: boolean;
  source_cell: string | null;
  sheet_name: string | null;
  sort_order: number;
  is_active: boolean;
}

export interface Assessment {
  id: string;
  organization_id: string | null;
  evaluation_type_id: string | null;
  domain_id: string | null;
  process_id: string | null;
  title: string;
  description: string | null;
  assessment_period: string | null;
  status: string;
  current_maturity_score: number | null;
  target_maturity_score: number | null;
  overall_score: number | null;
  created_by: string | null;
  lead_assessor_id: string | null;
  start_date: string | null;
  end_date: string | null;
  submitted_at: string | null;
  approved_at: string | null;
  created_at: string;
}

export interface AssessmentResponse {
  id: string;
  assessment_id: string;
  question_id: string;
  score: number | null;
  maturity_level: number | null;
  response_text: string | null;
  compliance_status: string | null;
  evaluator_comment: string | null;
  auditee_comment: string | null;
  confidence_level: string;
  status: string;
}

export interface Finding {
  id: string;
  assessment_id: string;
  domain_id: string | null;
  process_id: string | null;
  question_id: string | null;
  severity: string;
  title: string;
  description: string | null;
  root_cause: string | null;
  impact: string | null;
  recommendation: string | null;
  management_response: string | null;
  action_owner: string | null;
  due_date: string | null;
  status: string;
}

export interface ImprovementAction {
  id: string;
  finding_id: string;
  assessment_id: string | null;
  title: string;
  description: string | null;
  priority: string;
  owner_id: string | null;
  due_date: string | null;
  status: string;
  progress_percent: number;
}

export interface AssessmentAlert {
  id: string;
  assessment_id: string;
  question_id: string | null;
  alert_rule_id: string | null;
  severity: string;
  title: string;
  message: string | null;
  status: string;
  owner_id: string | null;
  due_date: string | null;
}

export type AssessmentStatus = 'draft' | 'in_progress' | 'under_review' | 'approved' | 'closed';
export type Severity = 'low' | 'medium' | 'high' | 'critical';
export type ComplianceStatus = 'compliant' | 'partially_compliant' | 'non_compliant' | 'not_applicable';
