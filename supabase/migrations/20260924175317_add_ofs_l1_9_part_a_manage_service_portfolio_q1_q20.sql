/*
# OFS Onshore L1.9 Manage Service Portfolio - Part A (questions 9.1.1 to 9.5.5)

1. Content Added
   - 1 maturity_model row: ofs_mm_l1_9
   - 20 questions: ofs_l3_9_1_1 through ofs_l3_9_5_5
   - 20 maturity_statements matching each question
2. Sub-processes covered
   - 9.1 Set Financial Objectives (4 questions)
   - 9.2 Define Exploration Strategy (3 questions)
   - 9.3 Market & Position Services (5 questions)
   - 9.4 Align to Market Environment (3 questions)
   - 9.5 Manage Service Lifecycle (5 questions)
3. Purely additive DML with ON CONFLICT DO NOTHING
*/
DO $$
DECLARE
  v_questionnaire_id uuid;
  v_eval_type_id uuid;
  v_domain_id uuid;
BEGIN
  SELECT id INTO v_eval_type_id FROM evaluation_types WHERE code = 'ofs_onshore';
  SELECT id INTO v_questionnaire_id FROM questionnaires WHERE code = 'ofs_onshore_questionnaire';
  SELECT id INTO v_domain_id FROM domains WHERE code = 'ofs_l1_9';

  INSERT INTO maturity_models (code, label, description, domain_id, mapped_domain_id, mapped_domain_name, version, source_workbook, is_active)
  VALUES ('ofs_mm_l1_9', 'Manage Service Portfolio - Maturity Model', 'OFS Onshore maturity model for Manage Service Portfolio', v_domain_id, 'ofs_l1_9', 'Manage Service Portfolio', '1.0', 'POGO-OFS_Level_1-3_framework.pptx', true)
  ON CONFLICT (code) DO NOTHING;

  -- 9.1.1
  INSERT INTO questions (questionnaire_id, evaluation_type_id, domain_id, process_id,
    question_code, question_text, question_intent, instruction_text, evidence_examples,
    alert_rule_hint, mapped_maturity_model_id, mapped_maturity_statement_id, matched_process_area, sort_order)
  SELECT v_questionnaire_id, v_eval_type_id, v_domain_id, p.id,
    'ofs_l3_9_1_1', 'How mature is the organization''s process for setting and tracking documented earnings targets (EBITDA, margin by service line) as an input to service-portfolio decisions?', 'Assess whether service-portfolio decisions (which service lines to grow, hold, or exit) are driven by documented, board/leadership-approved earnings targets tracked by service line, versus informal revenue-growth intent with no earnings discipline.', 'Review the current-period earnings target document (by service line where applicable), confirm leadership approval, and confirm a tracking report comparing actual to target was produced in the most recent reporting cycle.', 'Board/leadership-approved earnings target document; service-line P&L or margin tracking report; variance analysis versus target.',
    'Flag if no documented, approved earnings target exists for the current period or if no actual-versus-target tracking report has been produced in the last reporting cycle.', 'ofs_mm_l1_9', 'ofs_l3_9_1_1', 'ofs_l3_9_1_1', 1
  FROM processes p WHERE p.code = 'ofs_l2_9_1';
  INSERT INTO maturity_statements (maturity_model_id, domain_title, process_area,
    level_1_basic, level_2_developing, level_3_established, level_4_advanced, level_5_leading,
    assessor_instruction, evidence_examples, review_steps, alert_rule_hint, sort_order)
  VALUES ('ofs_mm_l1_9', 'Manage Service Portfolio', 'ofs_l3_9_1_1',
    'Earnings targets are discussed informally at leadership level with no documented target or tracking.', 'A company-wide earnings target is documented but not broken out or tracked by service line.', 'Earnings targets are documented, approved, and tracked by service line on a regular reporting cadence.', 'Earnings variance analysis by service line feeds directly into portfolio rebalancing decisions (grow/hold/exit).', 'Earnings targets and tracking are integrated into a live financial-planning platform with automated variance alerts to portfolio owners.',
    'Ask for the current earnings target document and the most recent actual-versus-target tracking report broken out by service line.', 'Board/leadership-approved earnings target document; service-line P&L or margin tracking report; variance analysis versus target.', 'Confirm a documented, approved earnings target exists for the current period and that a service-line tracking report was produced in the last cycle.', 'Flag if no documented, approved earnings target exists for the current period or if no actual-versus-target tracking report has been produced in the last reporting cycle.', 1)
  ON CONFLICT (maturity_model_id, process_area) DO NOTHING;

  -- 9.1.2
  INSERT INTO questions (questionnaire_id, evaluation_type_id, domain_id, process_id,
    question_code, question_text, question_intent, instruction_text, evidence_examples,
    alert_rule_hint, mapped_maturity_model_id, mapped_maturity_statement_id, matched_process_area, sort_order)
  SELECT v_questionnaire_id, v_eval_type_id, v_domain_id, p.id,
    'ofs_l3_9_1_2', 'How mature is the organization''s process for tracking asset-efficiency metrics (equipment utilization rate, revenue per crew/unit) as a documented input to financial-objective setting?', 'Assess whether asset efficiency (utilization of rigs, crews, wireline units, or other capital equipment) is measured and tracked in a documented, recurring way that informs financial objectives, versus utilization being an informal, anecdotal sense with no tracked metric.', 'Review the asset-utilization or revenue-per-unit tracking report for the most recent period and confirm it is produced on a regular cadence and referenced in financial-objective-setting discussions.', 'Equipment/crew utilization report; revenue-per-unit or revenue-per-crew tracking; asset-efficiency dashboard; financial-planning meeting minutes referencing utilization.',
    'Flag if no asset-utilization tracking report has been produced in the last reporting period.', 'ofs_mm_l1_9', 'ofs_l3_9_1_2', 'ofs_l3_9_1_2', 2
  FROM processes p WHERE p.code = 'ofs_l2_9_1';
  INSERT INTO maturity_statements (maturity_model_id, domain_title, process_area,
    level_1_basic, level_2_developing, level_3_established, level_4_advanced, level_5_leading,
    assessor_instruction, evidence_examples, review_steps, alert_rule_hint, sort_order)
  VALUES ('ofs_mm_l1_9', 'Manage Service Portfolio', 'ofs_l3_9_1_2',
    'Asset efficiency is discussed anecdotally with no tracked utilization metric.', 'Utilization is tracked for some asset classes but not consistently or not tied to financial objectives.', 'Asset-efficiency metrics are tracked across all major asset classes on a regular cadence and referenced in financial planning.', 'Asset-efficiency trends are analyzed to identify underperforming assets and inform fleet/crew redeployment or divestment decisions.', 'Asset efficiency is monitored through a real-time fleet-management platform feeding utilization data directly into financial-objective models.',
    'Ask for the most recent asset-utilization or revenue-per-unit report and confirm it was referenced in a financial-objective-setting discussion.', 'Equipment/crew utilization report; revenue-per-unit or revenue-per-crew tracking; asset-efficiency dashboard; financial-planning meeting minutes referencing utilization.', 'Confirm a current asset-efficiency tracking report exists and is referenced in the financial-planning process.', 'Flag if no asset-utilization tracking report has been produced in the last reporting period.', 2)
  ON CONFLICT (maturity_model_id, process_area) DO NOTHING;

  -- 9.1.3
  INSERT INTO questions (questionnaire_id, evaluation_type_id, domain_id, process_id,
    question_code, question_text, question_intent, instruction_text, evidence_examples,
    alert_rule_hint, mapped_maturity_model_id, mapped_maturity_statement_id, matched_process_area, sort_order)
  SELECT v_questionnaire_id, v_eval_type_id, v_domain_id, p.id,
    'ofs_l3_9_1_3', 'How mature is the organization''s process for documenting and reviewing its capital structure (debt/equity mix, leverage ratios, covenant compliance) as an input to financial objectives?', 'Assess whether capital-structure decisions are grounded in a documented, periodically reviewed analysis (leverage ratios, covenant headroom, cost of capital), versus decided informally without a documented capital-structure review.', 'Review the most recent capital-structure or leverage review document, confirm it covers debt/equity mix and covenant compliance, and confirm it was reviewed by finance leadership within the current fiscal year.', 'Capital-structure or leverage review document; covenant compliance certificate/report; cost-of-capital analysis; finance leadership review sign-off.',
    'Flag if no capital-structure review has been documented within the current fiscal year.', 'ofs_mm_l1_9', 'ofs_l3_9_1_3', 'ofs_l3_9_1_3', 3
  FROM processes p WHERE p.code = 'ofs_l2_9_1';
  INSERT INTO maturity_statements (maturity_model_id, domain_title, process_area,
    level_1_basic, level_2_developing, level_3_established, level_4_advanced, level_5_leading,
    assessor_instruction, evidence_examples, review_steps, alert_rule_hint, sort_order)
  VALUES ('ofs_mm_l1_9', 'Manage Service Portfolio', 'ofs_l3_9_1_3',
    'Capital structure is managed reactively with no documented periodic review.', 'A capital-structure review is produced occasionally but not on a defined cadence or without covenant-compliance coverage.', 'A documented capital-structure review, including covenant compliance, is produced at least annually and reviewed by finance leadership.', 'Capital-structure scenarios are modeled against service-portfolio growth plans to test leverage headroom before commitments are made.', 'Capital structure is monitored continuously through an integrated treasury/financial-planning platform with automated covenant-headroom alerts.',
    'Ask for the most recent capital-structure or leverage review and confirm finance leadership sign-off within the current fiscal year.', 'Capital-structure or leverage review document; covenant compliance certificate/report; cost-of-capital analysis; finance leadership review sign-off.', 'Confirm a documented capital-structure review exists, covers covenant compliance, and was reviewed by finance leadership in the current fiscal year.', 'Flag if no capital-structure review has been documented within the current fiscal year.', 3)
  ON CONFLICT (maturity_model_id, process_area) DO NOTHING;

  -- 9.1.4
  INSERT INTO questions (questionnaire_id, evaluation_type_id, domain_id, process_id,
    question_code, question_text, question_intent, instruction_text, evidence_examples,
    alert_rule_hint, mapped_maturity_model_id, mapped_maturity_statement_id, matched_process_area, sort_order)
  SELECT v_questionnaire_id, v_eval_type_id, v_domain_id, p.id,
    'ofs_l3_9_1_4', 'How mature is the organization''s process for documenting a formal risk-tolerance/risk-appetite statement that is applied when setting financial objectives and evaluating service-portfolio decisions?', 'Assess whether financial and portfolio decisions reference a documented, leadership-approved risk-tolerance statement, versus risk appetite being an unwritten, inconsistently applied judgment call.', 'Review the documented risk-tolerance or risk-appetite statement, confirm leadership approval, and confirm at least one recent portfolio or financial decision references it explicitly.', 'Risk-tolerance/risk-appetite statement; leadership approval record; decision memo or board paper referencing the risk-tolerance statement.',
    'Flag if no documented, approved risk-tolerance statement exists or if no recent decision references it.', 'ofs_mm_l1_9', 'ofs_l3_9_1_4', 'ofs_l3_9_1_4', 4
  FROM processes p WHERE p.code = 'ofs_l2_9_1';
  INSERT INTO maturity_statements (maturity_model_id, domain_title, process_area,
    level_1_basic, level_2_developing, level_3_established, level_4_advanced, level_5_leading,
    assessor_instruction, evidence_examples, review_steps, alert_rule_hint, sort_order)
  VALUES ('ofs_mm_l1_9', 'Manage Service Portfolio', 'ofs_l3_9_1_4',
    'Risk tolerance is an unwritten, individually held judgment with no documented statement.', 'A risk-tolerance statement exists but is outdated, unapproved, or not consistently applied to decisions.', 'A documented, leadership-approved risk-tolerance statement is current and referenced in financial and portfolio decisions.', 'Risk-tolerance thresholds are quantified (e.g., maximum single-client revenue concentration, maximum leverage) and tracked against actuals.', 'Risk tolerance is embedded in an integrated enterprise-risk-management platform with automated threshold breach alerts feeding portfolio decisions.',
    'Ask for the current documented risk-tolerance statement and a decision memo that references it.', 'Risk-tolerance/risk-appetite statement; leadership approval record; decision memo or board paper referencing the risk-tolerance statement.', 'Confirm a documented, approved risk-tolerance statement exists and is referenced in at least one recent financial or portfolio decision.', 'Flag if no documented, approved risk-tolerance statement exists or if no recent decision references it.', 4)
  ON CONFLICT (maturity_model_id, process_area) DO NOTHING;

  -- 9.2.1
  INSERT INTO questions (questionnaire_id, evaluation_type_id, domain_id, process_id,
    question_code, question_text, question_intent, instruction_text, evidence_examples,
    alert_rule_hint, mapped_maturity_model_id, mapped_maturity_statement_id, matched_process_area, sort_order)
  SELECT v_questionnaire_id, v_eval_type_id, v_domain_id, p.id,
    'ofs_l3_9_2_1', 'How mature is the organization''s process for developing documented, client-specific seismic acquisition service plans aligned to operator exploration programs?', 'Assess whether seismic acquisition service offerings are planned against documented operator campaign requirements (survey design, crew/equipment allocation, timeline), versus crews being scheduled reactively with no documented plan per program.', 'Review a sample seismic acquisition service plan for a current or recent operator program and confirm it documents survey design parameters, crew/equipment allocation, and delivery timeline.', 'Seismic acquisition service plan; survey design document; crew/equipment allocation schedule; operator program timeline.',
    'Flag if a seismic acquisition service is mobilized with no documented acquisition plan on file.', 'ofs_mm_l1_9', 'ofs_l3_9_2_1', 'ofs_l3_9_2_1', 1
  FROM processes p WHERE p.code = 'ofs_l2_9_2';
  INSERT INTO maturity_statements (maturity_model_id, domain_title, process_area,
    level_1_basic, level_2_developing, level_3_established, level_4_advanced, level_5_leading,
    assessor_instruction, evidence_examples, review_steps, alert_rule_hint, sort_order)
  VALUES ('ofs_mm_l1_9', 'Manage Service Portfolio', 'ofs_l3_9_2_1',
    'Seismic acquisition crews are mobilized based on informal scheduling with no documented service plan.', 'Acquisition plans are documented for some programs but inconsistently, without full coverage of design, resourcing, and timeline.', 'A documented acquisition plan (design, resourcing, timeline) is produced for every seismic acquisition service program.', 'Acquisition plan accuracy (planned versus actual timeline/resourcing) is tracked across programs to refine future planning.', 'Acquisition planning is integrated with a real-time resource-scheduling platform optimizing crew/equipment allocation across concurrent programs.',
    'Ask for the acquisition plan of the most recent seismic program and confirm it documents design, resourcing, and timeline.', 'Seismic acquisition service plan; survey design document; crew/equipment allocation schedule; operator program timeline.', 'Confirm a documented acquisition plan exists for the most recent seismic program and covers design, resourcing, and timeline.', 'Flag if a seismic acquisition service is mobilized with no documented acquisition plan on file.', 1)
  ON CONFLICT (maturity_model_id, process_area) DO NOTHING;

  -- 9.2.2
  INSERT INTO questions (questionnaire_id, evaluation_type_id, domain_id, process_id,
    question_code, question_text, question_intent, instruction_text, evidence_examples,
    alert_rule_hint, mapped_maturity_model_id, mapped_maturity_statement_id, matched_process_area, sort_order)
  SELECT v_questionnaire_id, v_eval_type_id, v_domain_id, p.id,
    'ofs_l3_9_2_2', 'How mature is the organization''s process for developing documented service plans for exploration-well campaigns (drilling/completion service scope, equipment, and personnel aligned to the operator''s well program)?', 'Assess whether services supporting exploration wells are planned against a documented well-by-well service scope aligned to the operator''s program, versus services being deployed reactively with no documented per-well plan.', 'Review a sample exploration-well service plan and confirm it documents scope of services, equipment/personnel allocation, and alignment to the operator''s well program timeline.', 'Exploration-well service plan; equipment/personnel allocation schedule; operator well-program timeline reference.',
    'Flag if services are mobilized to an exploration well with no documented service plan on file.', 'ofs_mm_l1_9', 'ofs_l3_9_2_2', 'ofs_l3_9_2_2', 2
  FROM processes p WHERE p.code = 'ofs_l2_9_2';
  INSERT INTO maturity_statements (maturity_model_id, domain_title, process_area,
    level_1_basic, level_2_developing, level_3_established, level_4_advanced, level_5_leading,
    assessor_instruction, evidence_examples, review_steps, alert_rule_hint, sort_order)
  VALUES ('ofs_mm_l1_9', 'Manage Service Portfolio', 'ofs_l3_9_2_2',
    'Services for exploration wells are deployed reactively with no documented per-well plan.', 'Well service plans are documented for some wells but inconsistently across the exploration program.', 'A documented service plan (scope, resourcing, timeline alignment) exists for every exploration well serviced.', 'Well-plan accuracy is tracked (planned versus actual scope/timeline) and used to refine future exploration-well planning.', 'Exploration-well planning is integrated with the operator''s own well-planning system for real-time scope and schedule alignment.',
    'Ask for the service plan of the most recent exploration well serviced and confirm it documents scope, resourcing, and timeline alignment.', 'Exploration-well service plan; equipment/personnel allocation schedule; operator well-program timeline reference.', 'Confirm a documented service plan exists for the most recent exploration well and covers scope, resourcing, and timeline.', 'Flag if services are mobilized to an exploration well with no documented service plan on file.', 2)
  ON CONFLICT (maturity_model_id, process_area) DO NOTHING;

  -- 9.2.3
  INSERT INTO questions (questionnaire_id, evaluation_type_id, domain_id, process_id,
    question_code, question_text, question_intent, instruction_text, evidence_examples,
    alert_rule_hint, mapped_maturity_model_id, mapped_maturity_statement_id, matched_process_area, sort_order)
  SELECT v_questionnaire_id, v_eval_type_id, v_domain_id, p.id,
    'ofs_l3_9_2_3', 'How mature is the organization''s process for developing documented plans for seismic processing/interpretation study services delivered to operator clients?', 'Assess whether seismic study (processing, reprocessing, interpretation) services are scoped against a documented study plan (objectives, dataset, methodology, deliverables, timeline), versus being undertaken without a documented scope.', 'Review a sample seismic study plan and confirm it documents study objectives, dataset/methodology, deliverables, and timeline agreed with the client.', 'Seismic study plan; scope-of-work document; methodology note; client-agreed deliverables list and timeline.',
    'Flag if a seismic study service is delivered with no documented study plan on file.', 'ofs_mm_l1_9', 'ofs_l3_9_2_3', 'ofs_l3_9_2_3', 3
  FROM processes p WHERE p.code = 'ofs_l2_9_2';
  INSERT INTO maturity_statements (maturity_model_id, domain_title, process_area,
    level_1_basic, level_2_developing, level_3_established, level_4_advanced, level_5_leading,
    assessor_instruction, evidence_examples, review_steps, alert_rule_hint, sort_order)
  VALUES ('ofs_mm_l1_9', 'Manage Service Portfolio', 'ofs_l3_9_2_3',
    'Seismic study services proceed with no documented study plan or agreed scope.', 'Study plans are documented for some engagements but inconsistently, without full coverage of objectives and deliverables.', 'A documented study plan (objectives, methodology, deliverables, timeline) exists for every seismic study service delivered.', 'Study-plan delivery performance (on-time, on-scope) is tracked across engagements and used to refine study methodology.', 'Seismic study planning and delivery tracking are integrated into a project-management platform providing clients real-time deliverable status.',
    'Ask for the study plan of the most recent seismic study service delivered and confirm it documents objectives, methodology, deliverables, and timeline.', 'Seismic study plan; scope-of-work document; methodology note; client-agreed deliverables list and timeline.', 'Confirm a documented study plan exists for the most recent seismic study engagement and covers objectives, methodology, deliverables, and timeline.', 'Flag if a seismic study service is delivered with no documented study plan on file.', 3)
  ON CONFLICT (maturity_model_id, process_area) DO NOTHING;

  -- 9.3.1
  INSERT INTO questions (questionnaire_id, evaluation_type_id, domain_id, process_id,
    question_code, question_text, question_intent, instruction_text, evidence_examples,
    alert_rule_hint, mapped_maturity_model_id, mapped_maturity_statement_id, matched_process_area, sort_order)
  SELECT v_questionnaire_id, v_eval_type_id, v_domain_id, p.id,
    'ofs_l3_9_3_1', 'How mature is the organization''s process for documenting its service offering and market positioning relative to competitors for each service line?', 'Assess whether each service line has a documented offering definition and competitive positioning statement used consistently in sales and strategy, versus positioning being described inconsistently by different people with no documented reference.', 'Review the documented offering/positioning statement for a sample service line and confirm it is current, approved, and used in sales or marketing materials.', 'Service-line offering/positioning document; competitive-positioning matrix; sales/marketing collateral reflecting the positioning.',
    'Flag if a service line has no documented, current offering/positioning statement.', 'ofs_mm_l1_9', 'ofs_l3_9_3_1', 'ofs_l3_9_3_1', 1
  FROM processes p WHERE p.code = 'ofs_l2_9_3';
  INSERT INTO maturity_statements (maturity_model_id, domain_title, process_area,
    level_1_basic, level_2_developing, level_3_established, level_4_advanced, level_5_leading,
    assessor_instruction, evidence_examples, review_steps, alert_rule_hint, sort_order)
  VALUES ('ofs_mm_l1_9', 'Manage Service Portfolio', 'ofs_l3_9_3_1',
    'Service-line positioning is described informally and inconsistently with no documented statement.', 'Positioning is documented for some service lines but not kept current or not consistently used in sales materials.', 'Every service line has a documented, current offering/positioning statement used consistently in sales and marketing.', 'Positioning effectiveness is tracked (win rates, client feedback) and used to refine the offering statement.', 'Offering and positioning are maintained in a live competitive-intelligence platform updated as market conditions and competitor moves change.',
    'Ask for the current offering/positioning statement of a sample service line and confirm it is reflected in sales or marketing materials.', 'Service-line offering/positioning document; competitive-positioning matrix; sales/marketing collateral reflecting the positioning.', 'Confirm a documented, current offering/positioning statement exists for the sampled service line and is used in sales materials.', 'Flag if a service line has no documented, current offering/positioning statement.', 1)
  ON CONFLICT (maturity_model_id, process_area) DO NOTHING;

  -- 9.3.2
  INSERT INTO questions (questionnaire_id, evaluation_type_id, domain_id, process_id,
    question_code, question_text, question_intent, instruction_text, evidence_examples,
    alert_rule_hint, mapped_maturity_model_id, mapped_maturity_statement_id, matched_process_area, sort_order)
  SELECT v_questionnaire_id, v_eval_type_id, v_domain_id, p.id,
    'ofs_l3_9_3_2', 'How mature is the organization''s process for documenting a value proposition and brand positioning tailored to each target client segment?', 'Assess whether value propositions are documented and differentiated by target segment (e.g., major operators versus independents), versus a single generic pitch used for all clients with no segment tailoring.', 'Review the documented value-proposition/brand-positioning statements for at least two target segments and confirm they are differentiated and current.', 'Segment-specific value-proposition documents; brand-positioning guidelines; segment-tailored sales collateral.',
    'Flag if no segment-specific value proposition exists for a defined target client segment.', 'ofs_mm_l1_9', 'ofs_l3_9_3_2', 'ofs_l3_9_3_2', 2
  FROM processes p WHERE p.code = 'ofs_l2_9_3';
  INSERT INTO maturity_statements (maturity_model_id, domain_title, process_area,
    level_1_basic, level_2_developing, level_3_established, level_4_advanced, level_5_leading,
    assessor_instruction, evidence_examples, review_steps, alert_rule_hint, sort_order)
  VALUES ('ofs_mm_l1_9', 'Manage Service Portfolio', 'ofs_l3_9_3_2',
    'A single generic value proposition is used for all clients with no segment tailoring.', 'Segment-specific value propositions exist for some segments but are not consistently documented or used.', 'Documented, current value propositions exist for every defined target segment and are used in client-facing materials.', 'Value-proposition resonance is tracked by segment (client feedback, win rates) and used to refine segment positioning.', 'Value propositions are dynamically tailored through an integrated CRM/marketing platform using real-time client-segment data.',
    'Ask for the documented value proposition of at least two target segments and confirm they are differentiated.', 'Segment-specific value-proposition documents; brand-positioning guidelines; segment-tailored sales collateral.', 'Confirm documented, differentiated value propositions exist for the sampled target segments.', 'Flag if no segment-specific value proposition exists for a defined target client segment.', 2)
  ON CONFLICT (maturity_model_id, process_area) DO NOTHING;

  -- 9.3.3
  INSERT INTO questions (questionnaire_id, evaluation_type_id, domain_id, process_id,
    question_code, question_text, question_intent, instruction_text, evidence_examples,
    alert_rule_hint, mapped_maturity_model_id, mapped_maturity_statement_id, matched_process_area, sort_order)
  SELECT v_questionnaire_id, v_eval_type_id, v_domain_id, p.id,
    'ofs_l3_9_3_3', 'How mature is the organization''s process for validating its value proposition with target-segment clients (client interviews, pilot feedback, win/loss analysis) before finalizing the offering?', 'Assess whether value propositions are validated with real client input before being finalized, versus being finalized internally with no documented external validation.', 'Review documentation of a client validation exercise (interviews, pilot feedback, or win/loss analysis) for a recent value-proposition update and confirm the offering was adjusted based on findings.', 'Client validation interview notes; pilot feedback summary; win/loss analysis report; offering-adjustment record following validation.',
    'Flag if a value proposition was finalized or updated with no documented client validation step.', 'ofs_mm_l1_9', 'ofs_l3_9_3_3', 'ofs_l3_9_3_3', 3
  FROM processes p WHERE p.code = 'ofs_l2_9_3';
  INSERT INTO maturity_statements (maturity_model_id, domain_title, process_area,
    level_1_basic, level_2_developing, level_3_established, level_4_advanced, level_5_leading,
    assessor_instruction, evidence_examples, review_steps, alert_rule_hint, sort_order)
  VALUES ('ofs_mm_l1_9', 'Manage Service Portfolio', 'ofs_l3_9_3_3',
    'Value propositions are finalized internally with no client validation.', 'Client validation occurs occasionally but is undocumented or does not feed back into offering adjustments.', 'A documented client validation step (interviews, pilot feedback, or win/loss analysis) precedes every value-proposition finalization, with resulting offering adjustments recorded.', 'Validation findings are tracked over time to identify recurring gaps between offering and client needs, informing service-development priorities.', 'Value-proposition validation is continuous, drawing on a live client-feedback and win/loss analytics platform.',
    'Ask for documentation of the client validation exercise behind the most recent value-proposition update and confirm resulting offering adjustments.', 'Client validation interview notes; pilot feedback summary; win/loss analysis report; offering-adjustment record following validation.', 'Confirm a documented client validation step exists for the most recent value-proposition update and that offering adjustments were recorded.', 'Flag if a value proposition was finalized or updated with no documented client validation step.', 3)
  ON CONFLICT (maturity_model_id, process_area) DO NOTHING;

  -- 9.3.4
  INSERT INTO questions (questionnaire_id, evaluation_type_id, domain_id, process_id,
    question_code, question_text, question_intent, instruction_text, evidence_examples,
    alert_rule_hint, mapped_maturity_model_id, mapped_maturity_statement_id, matched_process_area, sort_order)
  SELECT v_questionnaire_id, v_eval_type_id, v_domain_id, p.id,
    'ofs_l3_9_3_4', 'How mature is the organization''s process for developing and approving new or updated branding (visual identity, messaging guidelines) in a documented, governed way?', 'Assess whether branding changes follow a documented development and approval process, versus being made ad hoc by individuals with no governance or consistency check.', 'Review the brand guidelines document and the approval record for the most recent branding update, and confirm the guidelines are distributed and applied across client-facing materials.', 'Brand guidelines/style guide; branding-update approval record; distribution record to marketing/sales teams; sample client-facing materials showing compliance.',
    'Flag if branding materials in current use do not match the approved brand guidelines.', 'ofs_mm_l1_9', 'ofs_l3_9_3_4', 'ofs_l3_9_3_4', 4
  FROM processes p WHERE p.code = 'ofs_l2_9_3';
  INSERT INTO maturity_statements (maturity_model_id, domain_title, process_area,
    level_1_basic, level_2_developing, level_3_established, level_4_advanced, level_5_leading,
    assessor_instruction, evidence_examples, review_steps, alert_rule_hint, sort_order)
  VALUES ('ofs_mm_l1_9', 'Manage Service Portfolio', 'ofs_l3_9_3_4',
    'Branding is applied inconsistently by individuals with no documented guidelines.', 'Brand guidelines exist but are outdated or not consistently applied across materials.', 'Current, approved brand guidelines are documented, distributed, and consistently applied across client-facing materials.', 'Brand consistency is audited periodically across materials and channels, with gaps tracked to closure.', 'Brand guidelines are managed through a digital asset-management platform enforcing consistent application across all materials automatically.',
    'Ask for the current brand guidelines and a sample of client-facing materials to confirm compliance.', 'Brand guidelines/style guide; branding-update approval record; distribution record to marketing/sales teams; sample client-facing materials showing compliance.', 'Confirm current, approved brand guidelines exist and that sampled client-facing materials comply with them.', 'Flag if branding materials in current use do not match the approved brand guidelines.', 4)
  ON CONFLICT (maturity_model_id, process_area) DO NOTHING;

  -- 9.3.5
  INSERT INTO questions (questionnaire_id, evaluation_type_id, domain_id, process_id,
    question_code, question_text, question_intent, instruction_text, evidence_examples,
    alert_rule_hint, mapped_maturity_model_id, mapped_maturity_statement_id, matched_process_area, sort_order)
  SELECT v_questionnaire_id, v_eval_type_id, v_domain_id, p.id,
    'ofs_l3_9_3_5', 'How mature is the organization''s process for documenting a pricing strategy for each service line that is explicitly aligned to its value proposition and market positioning?', 'Assess whether pricing decisions follow a documented pricing strategy tied to value proposition and cost/margin targets, versus pricing being set deal-by-deal with no documented strategy or rationale.', 'Review the documented pricing strategy for a sample service line and confirm it references the service line''s value proposition, cost base, and target margin.', 'Service-line pricing strategy document; cost/margin model; rate card or pricing schedule; reference to value proposition in the strategy document.',
    'Flag if a service line has no documented pricing strategy referencing its value proposition and target margin.', 'ofs_mm_l1_9', 'ofs_l3_9_3_5', 'ofs_l3_9_3_5', 5
  FROM processes p WHERE p.code = 'ofs_l2_9_3';
  INSERT INTO maturity_statements (maturity_model_id, domain_title, process_area,
    level_1_basic, level_2_developing, level_3_established, level_4_advanced, level_5_leading,
    assessor_instruction, evidence_examples, review_steps, alert_rule_hint, sort_order)
  VALUES ('ofs_mm_l1_9', 'Manage Service Portfolio', 'ofs_l3_9_3_5',
    'Pricing is set deal-by-deal with no documented strategy or rationale.', 'A pricing strategy is documented for some service lines but not consistently linked to value proposition or margin targets.', 'Every service line has a documented pricing strategy explicitly linked to its value proposition, cost base, and target margin.', 'Pricing strategy effectiveness (realized margin versus target, win/loss by price point) is tracked and used to refine pricing.', 'Pricing strategy is dynamically optimized through an integrated pricing-analytics platform using real-time market and margin data.',
    'Ask for the documented pricing strategy of a sample service line and confirm it references value proposition and target margin.', 'Service-line pricing strategy document; cost/margin model; rate card or pricing schedule; reference to value proposition in the strategy document.', 'Confirm a documented pricing strategy exists for the sampled service line, linked to value proposition and target margin.', 'Flag if a service line has no documented pricing strategy referencing its value proposition and target margin.', 5)
  ON CONFLICT (maturity_model_id, process_area) DO NOTHING;

  -- 9.4.1
  INSERT INTO questions (questionnaire_id, evaluation_type_id, domain_id, process_id,
    question_code, question_text, question_intent, instruction_text, evidence_examples,
    alert_rule_hint, mapped_maturity_model_id, mapped_maturity_statement_id, matched_process_area, sort_order)
  SELECT v_questionnaire_id, v_eval_type_id, v_domain_id, p.id,
    'ofs_l3_9_4_1', 'How mature is the organization''s process for producing a documented commodity-price forecast used as an input to service-portfolio target setting?', 'Assess whether service-portfolio targets are grounded in a documented, periodically updated commodity-price forecast, versus assumptions about oil/gas prices being informal or undocumented.', 'Review the current commodity-price forecast document, confirm its source/methodology, and confirm it was used in the most recent service-portfolio target-setting exercise.', 'Commodity-price forecast document; source/methodology note (internal model or third-party subscription); portfolio target-setting document referencing the forecast.',
    'Flag if the current portfolio target-setting cycle used no documented commodity-price forecast, or the forecast on file is more than one quarter out of date.', 'ofs_mm_l1_9', 'ofs_l3_9_4_1', 'ofs_l3_9_4_1', 1
  FROM processes p WHERE p.code = 'ofs_l2_9_4';
  INSERT INTO maturity_statements (maturity_model_id, domain_title, process_area,
    level_1_basic, level_2_developing, level_3_established, level_4_advanced, level_5_leading,
    assessor_instruction, evidence_examples, review_steps, alert_rule_hint, sort_order)
  VALUES ('ofs_mm_l1_9', 'Manage Service Portfolio', 'ofs_l3_9_4_1',
    'Commodity-price assumptions are informal, undocumented, and not sourced.', 'A price forecast is documented occasionally but not updated on a defined cadence or not consistently used in target-setting.', 'A documented, sourced commodity-price forecast is maintained on a defined cadence and used in every portfolio target-setting cycle.', 'Forecast accuracy is tracked against actual prices and used to refine forecasting methodology or source selection.', 'Commodity-price forecasting draws on a live market-data platform feeding portfolio-planning models continuously.',
    'Ask for the current commodity-price forecast and confirm it was referenced in the most recent portfolio target-setting exercise.', 'Commodity-price forecast document; source/methodology note (internal model or third-party subscription); portfolio target-setting document referencing the forecast.', 'Confirm a documented, current commodity-price forecast exists and was used in the most recent target-setting cycle.', 'Flag if the current portfolio target-setting cycle used no documented commodity-price forecast, or the forecast on file is more than one quarter out of date.', 1)
  ON CONFLICT (maturity_model_id, process_area) DO NOTHING;

  -- 9.4.2
  INSERT INTO questions (questionnaire_id, evaluation_type_id, domain_id, process_id,
    question_code, question_text, question_intent, instruction_text, evidence_examples,
    alert_rule_hint, mapped_maturity_model_id, mapped_maturity_statement_id, matched_process_area, sort_order)
  SELECT v_questionnaire_id, v_eval_type_id, v_domain_id, p.id,
    'ofs_l3_9_4_2', 'How mature is the organization''s process for documenting how commodity-price volatility is managed or hedged as it affects service-portfolio planning?', 'Assess whether volatility exposure (client capex sensitivity to price swings, contract structures) is documented and actively managed, versus volatility risk being unaddressed in portfolio planning.', 'Review the documented volatility-management approach (contract structuring, scenario planning, or hedging policy where applicable) and confirm it is referenced in portfolio planning documents.', 'Volatility-management or hedging policy; price-scenario planning document; contract-structuring guidance referencing price volatility; portfolio plan referencing volatility management.',
    'Flag if portfolio planning documents contain no reference to how commodity-price volatility is managed.', 'ofs_mm_l1_9', 'ofs_l3_9_4_2', 'ofs_l3_9_4_2', 2
  FROM processes p WHERE p.code = 'ofs_l2_9_4';
  INSERT INTO maturity_statements (maturity_model_id, domain_title, process_area,
    level_1_basic, level_2_developing, level_3_established, level_4_advanced, level_5_leading,
    assessor_instruction, evidence_examples, review_steps, alert_rule_hint, sort_order)
  VALUES ('ofs_mm_l1_9', 'Manage Service Portfolio', 'ofs_l3_9_4_2',
    'Commodity-price volatility is not addressed in portfolio planning.', 'Volatility is discussed qualitatively in planning but with no documented management approach.', 'A documented volatility-management approach (scenario planning, contract structuring, or hedging policy) is referenced in every portfolio-planning cycle.', 'Volatility scenarios are quantified and stress-tested against the service portfolio to identify exposure concentrations.', 'Volatility management is integrated into a real-time risk-analytics platform continuously informing portfolio decisions.',
    'Ask for the documented volatility-management approach and confirm it is referenced in the current portfolio plan.', 'Volatility-management or hedging policy; price-scenario planning document; contract-structuring guidance referencing price volatility; portfolio plan referencing volatility management.', 'Confirm a documented volatility-management approach exists and is referenced in the current portfolio-planning cycle.', 'Flag if portfolio planning documents contain no reference to how commodity-price volatility is managed.', 2)
  ON CONFLICT (maturity_model_id, process_area) DO NOTHING;

  -- 9.4.3
  INSERT INTO questions (questionnaire_id, evaluation_type_id, domain_id, process_id,
    question_code, question_text, question_intent, instruction_text, evidence_examples,
    alert_rule_hint, mapped_maturity_model_id, mapped_maturity_statement_id, matched_process_area, sort_order)
  SELECT v_questionnaire_id, v_eval_type_id, v_domain_id, p.id,
    'ofs_l3_9_4_3', 'How mature is the organization''s process for documenting geographic price/cost differentials (basin-level pricing, logistics/mobilization cost differences) as an input to service-portfolio targets?', 'Assess whether geographic differentials across operating basins are documented and factored into portfolio targets, versus basin-level differences being ignored or assumed uniform.', 'Review the documented geographic-differential analysis and confirm it covers each basin/region the organization operates in and is referenced in portfolio target setting.', 'Geographic-differential analysis by basin/region; logistics/mobilization cost comparison; portfolio target document referencing basin-level differentials.',
    'Flag if a basin/region the organization actively operates in has no documented differential analysis on file.', 'ofs_mm_l1_9', 'ofs_l3_9_4_3', 'ofs_l3_9_4_3', 3
  FROM processes p WHERE p.code = 'ofs_l2_9_4';
  INSERT INTO maturity_statements (maturity_model_id, domain_title, process_area,
    level_1_basic, level_2_developing, level_3_established, level_4_advanced, level_5_leading,
    assessor_instruction, evidence_examples, review_steps, alert_rule_hint, sort_order)
  VALUES ('ofs_mm_l1_9', 'Manage Service Portfolio', 'ofs_l3_9_4_3',
    'Geographic differentials are not documented; portfolio targets assume uniform pricing/cost across regions.', 'A differential analysis exists for some basins/regions but not comprehensively across the operating footprint.', 'A documented geographic-differential analysis covers every basin/region and is referenced in portfolio target setting.', 'Differential trends are tracked over time and used to reprioritize investment or capacity allocation across basins.', 'Geographic differentials are monitored through an integrated basin-economics platform feeding portfolio decisions in real time.',
    'Ask for the geographic-differential analysis and confirm it covers all basins/regions of current operation.', 'Geographic-differential analysis by basin/region; logistics/mobilization cost comparison; portfolio target document referencing basin-level differentials.', 'Confirm a documented geographic-differential analysis exists covering all active basins/regions and is referenced in portfolio targets.', 'Flag if a basin/region the organization actively operates in has no documented differential analysis on file.', 3)
  ON CONFLICT (maturity_model_id, process_area) DO NOTHING;

  -- 9.5.1
  INSERT INTO questions (questionnaire_id, evaluation_type_id, domain_id, process_id,
    question_code, question_text, question_intent, instruction_text, evidence_examples,
    alert_rule_hint, mapped_maturity_model_id, mapped_maturity_statement_id, matched_process_area, sort_order)
  SELECT v_questionnaire_id, v_eval_type_id, v_domain_id, p.id,
    'ofs_l3_9_5_1', 'How mature is the organization''s process for documenting a periodic evaluation of existing service-line performance against identified market opportunities?', 'Assess whether service-line performance is systematically benchmarked against market opportunity (addressable market, competitor share, growth segments) in a documented way, versus performance being reviewed only against internal targets with no market-opportunity context.', 'Review the most recent service-line performance-versus-market-opportunity evaluation and confirm it covers addressable market sizing and competitive positioning.', 'Service-line performance-versus-market evaluation; addressable-market sizing analysis; competitor market-share estimate.',
    'Flag if no service-line performance-versus-market evaluation has been documented within the current fiscal year.', 'ofs_mm_l1_9', 'ofs_l3_9_5_1', 'ofs_l3_9_5_1', 1
  FROM processes p WHERE p.code = 'ofs_l2_9_5';
  INSERT INTO maturity_statements (maturity_model_id, domain_title, process_area,
    level_1_basic, level_2_developing, level_3_established, level_4_advanced, level_5_leading,
    assessor_instruction, evidence_examples, review_steps, alert_rule_hint, sort_order)
  VALUES ('ofs_mm_l1_9', 'Manage Service Portfolio', 'ofs_l3_9_5_1',
    'Service-line performance is reviewed only against internal targets with no market-opportunity comparison.', 'A market-opportunity comparison is produced occasionally but not on a defined cadence or without full service-line coverage.', 'A documented performance-versus-market-opportunity evaluation is produced for every service line at least annually.', 'Evaluation findings are tracked over multiple cycles to identify service lines consistently under-penetrating their addressable market.', 'Performance-versus-market evaluation draws on a live market-intelligence platform providing continuously updated opportunity sizing.',
    'Ask for the most recent performance-versus-market-opportunity evaluation for a sample service line.', 'Service-line performance-versus-market evaluation; addressable-market sizing analysis; competitor market-share estimate.', 'Confirm a documented performance-versus-market-opportunity evaluation exists for the sampled service line within the current fiscal year.', 'Flag if no service-line performance-versus-market evaluation has been documented within the current fiscal year.', 1)
  ON CONFLICT (maturity_model_id, process_area) DO NOTHING;

  -- 9.5.2
  INSERT INTO questions (questionnaire_id, evaluation_type_id, domain_id, process_id,
    question_code, question_text, question_intent, instruction_text, evidence_examples,
    alert_rule_hint, mapped_maturity_model_id, mapped_maturity_statement_id, matched_process_area, sort_order)
  SELECT v_questionnaire_id, v_eval_type_id, v_domain_id, p.id,
    'ofs_l3_9_5_2', 'How mature is the organization''s process for documenting formal service-development requirements (technical specification, client need, business case) before a new or revised service is developed?', 'Assess whether new service development begins from a documented requirements/business-case document, versus development proceeding informally with no documented requirements baseline.', 'Review the documented requirements/business-case for a recent service-development initiative and confirm it covers technical specification, client need, and business case.', 'Service-development requirements document; business case; technical specification; client-need statement.',
    'Flag if a service-development initiative proceeded to build stage with no documented requirements or business case on file.', 'ofs_mm_l1_9', 'ofs_l3_9_5_2', 'ofs_l3_9_5_2', 2
  FROM processes p WHERE p.code = 'ofs_l2_9_5';
  INSERT INTO maturity_statements (maturity_model_id, domain_title, process_area,
    level_1_basic, level_2_developing, level_3_established, level_4_advanced, level_5_leading,
    assessor_instruction, evidence_examples, review_steps, alert_rule_hint, sort_order)
  VALUES ('ofs_mm_l1_9', 'Manage Service Portfolio', 'ofs_l3_9_5_2',
    'Service development proceeds informally with no documented requirements.', 'Requirements are documented for some initiatives but inconsistently, without a formal business case.', 'A documented requirements/business-case document (technical specification, client need, business case) precedes every service-development initiative.', 'Requirements-definition quality is tracked against downstream development outcomes (schedule/budget adherence) to refine the requirements process.', 'Service-development requirements are captured and tracked through an integrated product-development platform with stage-gated approvals.',
    'Ask for the requirements/business-case document of the most recent service-development initiative.', 'Service-development requirements document; business case; technical specification; client-need statement.', 'Confirm a documented requirements/business-case document exists for the most recent service-development initiative.', 'Flag if a service-development initiative proceeded to build stage with no documented requirements or business case on file.', 2)
  ON CONFLICT (maturity_model_id, process_area) DO NOTHING;

  -- 9.5.3
  INSERT INTO questions (questionnaire_id, evaluation_type_id, domain_id, process_id,
    question_code, question_text, question_intent, instruction_text, evidence_examples,
    alert_rule_hint, mapped_maturity_model_id, mapped_maturity_statement_id, matched_process_area, sort_order)
  SELECT v_questionnaire_id, v_eval_type_id, v_domain_id, p.id,
    'ofs_l3_9_5_3', 'How mature is the organization''s process for conducting and documenting discovery research (client pain points, technology scouting, feasibility) ahead of service-development decisions?', 'Assess whether service-development decisions are informed by documented discovery research, versus new service ideas being pursued based on assumption with no documented research phase.', 'Review the discovery-research findings for a recent service-development initiative and confirm they cover client pain points and technical/commercial feasibility.', 'Discovery-research report; client pain-point interview notes; technology-scouting summary; feasibility assessment.',
    'Flag if a service-development initiative proceeded with no documented discovery-research findings on file.', 'ofs_mm_l1_9', 'ofs_l3_9_5_3', 'ofs_l3_9_5_3', 3
  FROM processes p WHERE p.code = 'ofs_l2_9_5';
  INSERT INTO maturity_statements (maturity_model_id, domain_title, process_area,
    level_1_basic, level_2_developing, level_3_established, level_4_advanced, level_5_leading,
    assessor_instruction, evidence_examples, review_steps, alert_rule_hint, sort_order)
  VALUES ('ofs_mm_l1_9', 'Manage Service Portfolio', 'ofs_l3_9_5_3',
    'Service-development ideas are pursued with no documented discovery research.', 'Discovery research is performed for some initiatives but not consistently documented or covering feasibility.', 'Documented discovery research (client pain points, feasibility) precedes every service-development initiative.', 'Discovery-research findings are tracked against actual development outcomes to refine the research methodology.', 'Discovery research draws on a continuous client-insight and technology-scouting platform feeding the service-development pipeline.',
    'Ask for the discovery-research findings of the most recent service-development initiative.', 'Discovery-research report; client pain-point interview notes; technology-scouting summary; feasibility assessment.', 'Confirm documented discovery-research findings exist for the most recent service-development initiative and cover feasibility.', 'Flag if a service-development initiative proceeded with no documented discovery-research findings on file.', 3)
  ON CONFLICT (maturity_model_id, process_area) DO NOTHING;

  -- 9.5.4
  INSERT INTO questions (questionnaire_id, evaluation_type_id, domain_id, process_id,
    question_code, question_text, question_intent, instruction_text, evidence_examples,
    alert_rule_hint, mapped_maturity_model_id, mapped_maturity_statement_id, matched_process_area, sort_order)
  SELECT v_questionnaire_id, v_eval_type_id, v_domain_id, p.id,
    'ofs_l3_9_5_4', 'How mature is the organization''s process for documenting a formal check that new service concepts align with the approved business strategy before development proceeds?', 'Assess whether service concepts pass through a documented strategy-alignment check before resourcing, versus concepts being developed without a documented check against strategic priorities.', 'Review the strategy-alignment check/sign-off for a recent service concept and confirm it references the approved business strategy document.', 'Strategy-alignment check or sign-off memo; reference to the approved business-strategy document; service-concept approval record.',
    'Flag if a service concept was resourced for development with no documented strategy-alignment check on file.', 'ofs_mm_l1_9', 'ofs_l3_9_5_4', 'ofs_l3_9_5_4', 4
  FROM processes p WHERE p.code = 'ofs_l2_9_5';
  INSERT INTO maturity_statements (maturity_model_id, domain_title, process_area,
    level_1_basic, level_2_developing, level_3_established, level_4_advanced, level_5_leading,
    assessor_instruction, evidence_examples, review_steps, alert_rule_hint, sort_order)
  VALUES ('ofs_mm_l1_9', 'Manage Service Portfolio', 'ofs_l3_9_5_4',
    'Service concepts proceed to development with no documented strategy-alignment check.', 'A strategy-alignment check is performed for some concepts but inconsistently or without formal sign-off.', 'A documented strategy-alignment check and sign-off precedes resourcing of every service concept.', 'Alignment-check outcomes are tracked to identify recurring strategic gaps in the concept pipeline, informing strategy refresh.', 'Strategy alignment is enforced through an integrated portfolio-governance platform with stage-gated approval workflows.',
    'Ask for the strategy-alignment check/sign-off of the most recent service concept resourced for development.', 'Strategy-alignment check or sign-off memo; reference to the approved business-strategy document; service-concept approval record.', 'Confirm a documented strategy-alignment check and sign-off exists for the most recent service concept.', 'Flag if a service concept was resourced for development with no documented strategy-alignment check on file.', 4)
  ON CONFLICT (maturity_model_id, process_area) DO NOTHING;

  -- 9.5.5
  INSERT INTO questions (questionnaire_id, evaluation_type_id, domain_id, process_id,
    question_code, question_text, question_intent, instruction_text, evidence_examples,
    alert_rule_hint, mapped_maturity_model_id, mapped_maturity_statement_id, matched_process_area, sort_order)
  SELECT v_questionnaire_id, v_eval_type_id, v_domain_id, p.id,
    'ofs_l3_9_5_5', 'How mature is the organization''s process for documenting and tracking each service line''s life-cycle stage (introduction, growth, maturity, decline) to inform investment and exit decisions?', 'Assess whether service lines are managed against a documented life-cycle framework informing investment/exit timing, versus service lines being continued indefinitely with no documented life-cycle assessment.', 'Review the service-portfolio life-cycle assessment and confirm each active service line is classified by life-cycle stage with a documented rationale.', 'Service-portfolio life-cycle assessment/matrix; life-cycle stage classification rationale per service line; investment/exit decision log referencing life-cycle stage.',
    'Flag if an active service line has no documented life-cycle stage classification.', 'ofs_mm_l1_9', 'ofs_l3_9_5_5', 'ofs_l3_9_5_5', 5
  FROM processes p WHERE p.code = 'ofs_l2_9_5';
  INSERT INTO maturity_statements (maturity_model_id, domain_title, process_area,
    level_1_basic, level_2_developing, level_3_established, level_4_advanced, level_5_leading,
    assessor_instruction, evidence_examples, review_steps, alert_rule_hint, sort_order)
  VALUES ('ofs_mm_l1_9', 'Manage Service Portfolio', 'ofs_l3_9_5_5',
    'Service life-cycle stage is not tracked; investment/exit decisions are made without life-cycle context.', 'Life-cycle classification exists for some service lines but is not maintained or not tied to investment decisions.', 'Every active service line has a documented, current life-cycle classification used to inform investment/exit decisions.', 'Life-cycle transitions are tracked over time and trigger structured investment or exit review at defined thresholds.', 'Service life-cycle is monitored through an integrated portfolio-management platform with automated stage-transition alerts.',
    'Ask for the current service-portfolio life-cycle assessment and confirm every active service line is classified.', 'Service-portfolio life-cycle assessment/matrix; life-cycle stage classification rationale per service line; investment/exit decision log referencing life-cycle stage.', 'Confirm a documented, current life-cycle classification exists for every active service line reviewed.', 'Flag if an active service line has no documented life-cycle stage classification.', 5)
  ON CONFLICT (maturity_model_id, process_area) DO NOTHING;
END $$;