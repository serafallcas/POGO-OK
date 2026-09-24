/*
# OFS Onshore L1.9 Manage Service Portfolio - Part B (questions 9.6.1 to 9.11.1)

1. Content Added
   - 16 questions: ofs_l3_9_6_1 through ofs_l3_9_11_1
   - 16 maturity_statements matching each question
2. Sub-processes covered
   - 9.6 Service Portfolio Analytics (3 questions)
   - 9.7 RPR Portfolio Targets (2 questions)
   - 9.8 Service Development Process (3 questions)
   - 9.9 RPR Portfolio Analytics (3 questions)
   - 9.10 RPR Investment Analysis (4 questions)
   - 9.11 Service Development Strategy (1 question)
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

  -- 9.6.1
  INSERT INTO questions (questionnaire_id, evaluation_type_id, domain_id, process_id,
    question_code, question_text, question_intent, instruction_text, evidence_examples,
    alert_rule_hint, mapped_maturity_model_id, mapped_maturity_statement_id, matched_process_area, sort_order)
  SELECT v_questionnaire_id, v_eval_type_id, v_domain_id, p.id,
    'ofs_l3_9_6_1', 'How mature is the organization''s process for documenting a periodic evaluation of service-portfolio performance to date against the financial objectives it was set to support?', 'Assess whether portfolio performance is formally, documentedly evaluated against the specific financial objectives it was designed to meet, versus performance being reviewed only in general terms with no explicit objective linkage.', 'Review the most recent portfolio performance evaluation and confirm it explicitly measures performance against the documented financial objectives (see 9.1).', 'Portfolio performance evaluation report; explicit linkage to financial-objective targets; variance analysis against those targets.',
    'Flag if the most recent portfolio review contains no explicit comparison to documented financial objectives.', 'ofs_mm_l1_9', 'ofs_l3_9_6_1', 'ofs_l3_9_6_1', 1
  FROM processes p WHERE p.code = 'ofs_l2_9_6';
  INSERT INTO maturity_statements (maturity_model_id, domain_title, process_area,
    level_1_basic, level_2_developing, level_3_established, level_4_advanced, level_5_leading,
    assessor_instruction, evidence_examples, review_steps, alert_rule_hint, sort_order)
  VALUES ('ofs_mm_l1_9', 'Manage Service Portfolio', 'ofs_l3_9_6_1',
    'Portfolio performance is reviewed informally with no explicit comparison to financial objectives.', 'A performance evaluation is produced but the linkage to specific financial objectives is inconsistent or implicit.', 'A documented portfolio performance evaluation explicitly measures performance against financial objectives on a regular cadence.', 'Performance-versus-objective trends are tracked across multiple cycles to identify systemic over- or under-performance.', 'Performance evaluation is continuous through an integrated financial-performance platform with real-time objective-tracking dashboards.',
    'Ask for the most recent portfolio performance evaluation and confirm it explicitly compares results to financial objectives.', 'Portfolio performance evaluation report; explicit linkage to financial-objective targets; variance analysis against those targets.', 'Confirm a documented portfolio performance evaluation exists and explicitly compares results against financial objectives.', 'Flag if the most recent portfolio review contains no explicit comparison to documented financial objectives.', 1)
  ON CONFLICT (maturity_model_id, process_area) DO NOTHING;

  -- 9.6.2
  INSERT INTO questions (questionnaire_id, evaluation_type_id, domain_id, process_id,
    question_code, question_text, question_intent, instruction_text, evidence_examples,
    alert_rule_hint, mapped_maturity_model_id, mapped_maturity_statement_id, matched_process_area, sort_order)
  SELECT v_questionnaire_id, v_eval_type_id, v_domain_id, p.id,
    'ofs_l3_9_6_2', 'How mature is the organization''s process for producing a documented predictive analysis (forecast of financial-objective attainment) based on portfolio performance to date?', 'Assess whether performance-to-date data is used to produce a documented forward-looking forecast of financial-objective attainment, versus forecasting being an informal extrapolation with no documented methodology.', 'Review the most recent predictive/forecast analysis and confirm it is based on documented performance-to-date data and states a projected attainment against financial objectives.', 'Predictive/forecast analysis document; underlying performance-to-date data set; projected attainment statement against financial objectives.',
    'Flag if no documented predictive analysis of financial-objective attainment has been produced in the current fiscal year.', 'ofs_mm_l1_9', 'ofs_l3_9_6_2', 'ofs_l3_9_6_2', 2
  FROM processes p WHERE p.code = 'ofs_l2_9_6';
  INSERT INTO maturity_statements (maturity_model_id, domain_title, process_area,
    level_1_basic, level_2_developing, level_3_established, level_4_advanced, level_5_leading,
    assessor_instruction, evidence_examples, review_steps, alert_rule_hint, sort_order)
  VALUES ('ofs_mm_l1_9', 'Manage Service Portfolio', 'ofs_l3_9_6_2',
    'No forward-looking forecast is produced; financial-objective attainment is assessed only after period close.', 'A forecast is produced occasionally but without a documented methodology or consistent cadence.', 'A documented predictive analysis, grounded in performance-to-date data, is produced at least quarterly and states projected attainment.', 'Forecast accuracy is tracked against actual outcomes and used to refine the predictive methodology.', 'Predictive analysis is generated continuously through an integrated financial-forecasting platform using live performance data.',
    'Ask for the most recent predictive/forecast analysis and confirm it is grounded in documented performance-to-date data.', 'Predictive/forecast analysis document; underlying performance-to-date data set; projected attainment statement against financial objectives.', 'Confirm a documented predictive analysis exists, is grounded in performance-to-date data, and states projected attainment against objectives.', 'Flag if no documented predictive analysis of financial-objective attainment has been produced in the current fiscal year.', 2)
  ON CONFLICT (maturity_model_id, process_area) DO NOTHING;

  -- 9.6.3
  INSERT INTO questions (questionnaire_id, evaluation_type_id, domain_id, process_id,
    question_code, question_text, question_intent, instruction_text, evidence_examples,
    alert_rule_hint, mapped_maturity_model_id, mapped_maturity_statement_id, matched_process_area, sort_order)
  SELECT v_questionnaire_id, v_eval_type_id, v_domain_id, p.id,
    'ofs_l3_9_6_3', 'How mature is the organization''s process for documenting prescriptive recommendations (portfolio rebalancing actions) when predictive analysis indicates a gap to financial objectives?', 'Assess whether a predicted gap to financial objectives triggers a documented set of prescriptive rebalancing actions with owners and timelines, versus gaps being noted with no documented follow-up action plan.', 'Review the most recent prescriptive action plan produced in response to a predicted gap to financial objectives, and confirm it names specific actions, owners, and timelines.', 'Prescriptive/rebalancing action plan; owner and timeline assignment; follow-up tracking record showing action closure or status.',
    'Flag if a predicted gap to financial objectives was identified with no documented prescriptive action plan produced in response.', 'ofs_mm_l1_9', 'ofs_l3_9_6_3', 'ofs_l3_9_6_3', 3
  FROM processes p WHERE p.code = 'ofs_l2_9_6';
  INSERT INTO maturity_statements (maturity_model_id, domain_title, process_area,
    level_1_basic, level_2_developing, level_3_established, level_4_advanced, level_5_leading,
    assessor_instruction, evidence_examples, review_steps, alert_rule_hint, sort_order)
  VALUES ('ofs_mm_l1_9', 'Manage Service Portfolio', 'ofs_l3_9_6_3',
    'Predicted gaps to financial objectives are noted with no documented follow-up action plan.', 'Action plans are produced for some identified gaps but without consistent owner/timeline assignment or tracking.', 'A documented prescriptive action plan, with owners and timelines, is produced for every identified gap to financial objectives.', 'Action-plan effectiveness (actual improvement achieved) is tracked and used to refine the rebalancing playbook.', 'Prescriptive rebalancing recommendations are generated by an integrated analytics platform modeling multiple rebalancing scenarios in real time.',
    'Ask for the most recent prescriptive action plan produced in response to a predicted gap and confirm owners and timelines are assigned.', 'Prescriptive/rebalancing action plan; owner and timeline assignment; follow-up tracking record showing action closure or status.', 'Confirm a documented prescriptive action plan exists for the most recent identified gap, with owners and timelines assigned.', 'Flag if a predicted gap to financial objectives was identified with no documented prescriptive action plan produced in response.', 3)
  ON CONFLICT (maturity_model_id, process_area) DO NOTHING;

  -- 9.7.1
  INSERT INTO questions (questionnaire_id, evaluation_type_id, domain_id, process_id,
    question_code, question_text, question_intent, instruction_text, evidence_examples,
    alert_rule_hint, mapped_maturity_model_id, mapped_maturity_statement_id, matched_process_area, sort_order)
  SELECT v_questionnaire_id, v_eval_type_id, v_domain_id, p.id,
    'ofs_l3_9_7_1', 'How mature is the organization''s process for setting and documenting reserve/resource-and-prospect (RPR) portfolio targets that align service-capacity planning to the client base''s development pipeline?', 'Assess whether RPR targets (the volume/scope of client reserve and resource development activity the organization plans its service capacity against) are documented and approved, versus capacity planning proceeding without documented RPR targets.', 'Review the documented RPR target-setting document for the current planning period and confirm it is approved and referenced in capacity-planning decisions.', 'RPR target-setting document; leadership approval record; capacity-planning document referencing RPR targets.',
    'Flag if the current planning period has no documented, approved RPR target.', 'ofs_mm_l1_9', 'ofs_l3_9_7_1', 'ofs_l3_9_7_1', 1
  FROM processes p WHERE p.code = 'ofs_l2_9_7';
  INSERT INTO maturity_statements (maturity_model_id, domain_title, process_area,
    level_1_basic, level_2_developing, level_3_established, level_4_advanced, level_5_leading,
    assessor_instruction, evidence_examples, review_steps, alert_rule_hint, sort_order)
  VALUES ('ofs_mm_l1_9', 'Manage Service Portfolio', 'ofs_l3_9_7_1',
    'RPR targets are not documented; capacity planning proceeds without a defined target.', 'RPR targets are documented occasionally but not consistently approved or linked to capacity planning.', 'A documented, approved RPR target is set for every planning period and referenced in capacity planning.', 'RPR target attainment is tracked and used to refine future target-setting assumptions.', 'RPR targets are set and monitored through an integrated capacity-planning platform using live client-pipeline data.',
    'Ask for the current RPR target-setting document and confirm it is approved and referenced in capacity planning.', 'RPR target-setting document; leadership approval record; capacity-planning document referencing RPR targets.', 'Confirm a documented, approved RPR target exists for the current planning period.', 'Flag if the current planning period has no documented, approved RPR target.', 1)
  ON CONFLICT (maturity_model_id, process_area) DO NOTHING;

  -- 9.7.2
  INSERT INTO questions (questionnaire_id, evaluation_type_id, domain_id, process_id,
    question_code, question_text, question_intent, instruction_text, evidence_examples,
    alert_rule_hint, mapped_maturity_model_id, mapped_maturity_statement_id, matched_process_area, sort_order)
  SELECT v_questionnaire_id, v_eval_type_id, v_domain_id, p.id,
    'ofs_l3_9_7_2', 'How mature is the organization''s process for setting and documenting prospect-portfolio targets (new client/opportunity pipeline volume) to support service-portfolio planning?', 'Assess whether prospect targets (new business pipeline volume/value the organization plans to pursue) are documented and approved, versus business-development effort proceeding without a documented target.', 'Review the documented prospect-target-setting document for the current period and confirm it is approved and referenced in business-development planning.', 'Prospect target-setting document; leadership approval record; business-development plan referencing prospect targets.',
    'Flag if the current planning period has no documented, approved prospect target.', 'ofs_mm_l1_9', 'ofs_l3_9_7_2', 'ofs_l3_9_7_2', 2
  FROM processes p WHERE p.code = 'ofs_l2_9_7';
  INSERT INTO maturity_statements (maturity_model_id, domain_title, process_area,
    level_1_basic, level_2_developing, level_3_established, level_4_advanced, level_5_leading,
    assessor_instruction, evidence_examples, review_steps, alert_rule_hint, sort_order)
  VALUES ('ofs_mm_l1_9', 'Manage Service Portfolio', 'ofs_l3_9_7_2',
    'Prospect targets are not documented; business development proceeds without a defined pipeline target.', 'Prospect targets are documented occasionally but not consistently approved or linked to business-development planning.', 'A documented, approved prospect target is set for every planning period and referenced in business-development planning.', 'Prospect-target attainment is tracked by segment and used to refine future target-setting and BD resource allocation.', 'Prospect targets are set and monitored through an integrated CRM/pipeline-analytics platform using live opportunity data.',
    'Ask for the current prospect target-setting document and confirm it is approved and referenced in business-development planning.', 'Prospect target-setting document; leadership approval record; business-development plan referencing prospect targets.', 'Confirm a documented, approved prospect target exists for the current planning period.', 'Flag if the current planning period has no documented, approved prospect target.', 2)
  ON CONFLICT (maturity_model_id, process_area) DO NOTHING;

  -- 9.8.1
  INSERT INTO questions (questionnaire_id, evaluation_type_id, domain_id, process_id,
    question_code, question_text, question_intent, instruction_text, evidence_examples,
    alert_rule_hint, mapped_maturity_model_id, mapped_maturity_statement_id, matched_process_area, sort_order)
  SELECT v_questionnaire_id, v_eval_type_id, v_domain_id, p.id,
    'ofs_l3_9_8_1', 'How mature is the organization''s process for documenting the design, build, and evaluation stages of new service development through to a go/no-go decision?', 'Assess whether new services pass through documented design, build, and evaluation stages with recorded outcomes at each, versus development being an informal, undocumented progression with no stage record.', 'Review the design, build, and evaluation records for a recent service-development initiative and confirm each stage has a documented outcome and the initiative reached a recorded go/no-go decision.', 'Design specification; build/pilot record; evaluation report; documented go/no-go decision record.',
    'Flag if a service-development initiative reached launch with no documented design, build, or evaluation record.', 'ofs_mm_l1_9', 'ofs_l3_9_8_1', 'ofs_l3_9_8_1', 1
  FROM processes p WHERE p.code = 'ofs_l2_9_8';
  INSERT INTO maturity_statements (maturity_model_id, domain_title, process_area,
    level_1_basic, level_2_developing, level_3_established, level_4_advanced, level_5_leading,
    assessor_instruction, evidence_examples, review_steps, alert_rule_hint, sort_order)
  VALUES ('ofs_mm_l1_9', 'Manage Service Portfolio', 'ofs_l3_9_8_1',
    'Service development proceeds informally with no documented design, build, or evaluation stages.', 'Some stages are documented for some initiatives but coverage is inconsistent across design, build, and evaluation.', 'Design, build, and evaluation stages are documented for every service-development initiative, culminating in a recorded go/no-go decision.', 'Stage-gate cycle time and outcomes are tracked across initiatives to identify bottlenecks and improve development velocity.', 'Design-build-evaluate stages are managed through an integrated stage-gate product-development platform with automated status tracking.',
    'Ask for the design, build, and evaluation records of the most recent service-development initiative and confirm a recorded go/no-go decision.', 'Design specification; build/pilot record; evaluation report; documented go/no-go decision record.', 'Confirm documented design, build, and evaluation records exist for the most recent initiative, culminating in a recorded go/no-go decision.', 'Flag if a service-development initiative reached launch with no documented design, build, or evaluation record.', 1)
  ON CONFLICT (maturity_model_id, process_area) DO NOTHING;

  -- 9.8.2
  INSERT INTO questions (questionnaire_id, evaluation_type_id, domain_id, process_id,
    question_code, question_text, question_intent, instruction_text, evidence_examples,
    alert_rule_hint, mapped_maturity_model_id, mapped_maturity_statement_id, matched_process_area, sort_order)
  SELECT v_questionnaire_id, v_eval_type_id, v_domain_id, p.id,
    'ofs_l3_9_8_2', 'How mature is the organization''s process for conducting and documenting a market test (pilot deployment, limited client trial) before a new or revised service is fully launched?', 'Assess whether new/revised services are piloted with documented client trial results before full launch, versus being launched directly to the full client base with no documented market test.', 'Review the market-test/pilot record for a recent new or revised service and confirm it documents client feedback and a launch/no-launch recommendation based on the pilot.', 'Market-test/pilot plan and results; client trial feedback record; launch/no-launch recommendation memo.',
    'Flag if a new or revised service was fully launched with no documented market test on file.', 'ofs_mm_l1_9', 'ofs_l3_9_8_2', 'ofs_l3_9_8_2', 2
  FROM processes p WHERE p.code = 'ofs_l2_9_8';
  INSERT INTO maturity_statements (maturity_model_id, domain_title, process_area,
    level_1_basic, level_2_developing, level_3_established, level_4_advanced, level_5_leading,
    assessor_instruction, evidence_examples, review_steps, alert_rule_hint, sort_order)
  VALUES ('ofs_mm_l1_9', 'Manage Service Portfolio', 'ofs_l3_9_8_2',
    'New or revised services are launched directly with no documented market test.', 'Market tests are conducted for some launches but inconsistently documented or not tied to the launch decision.', 'A documented market test, with client feedback and a launch recommendation, precedes every new or revised service launch.', 'Market-test outcomes are tracked against post-launch performance to calibrate the market-testing methodology.', 'Market testing draws on a continuous client-panel/pilot-network platform providing rapid, structured feedback on new concepts.',
    'Ask for the market-test record of the most recent new or revised service launch and confirm a documented launch recommendation.', 'Market-test/pilot plan and results; client trial feedback record; launch/no-launch recommendation memo.', 'Confirm a documented market-test record exists for the most recent service launch, with a documented launch recommendation.', 'Flag if a new or revised service was fully launched with no documented market test on file.', 2)
  ON CONFLICT (maturity_model_id, process_area) DO NOTHING;

  -- 9.8.3
  INSERT INTO questions (questionnaire_id, evaluation_type_id, domain_id, process_id,
    question_code, question_text, question_intent, instruction_text, evidence_examples,
    alert_rule_hint, mapped_maturity_model_id, mapped_maturity_statement_id, matched_process_area, sort_order)
  SELECT v_questionnaire_id, v_eval_type_id, v_domain_id, p.id,
    'ofs_l3_9_8_3', 'How mature is the organization''s process for documenting a business-environment assessment (regulatory, competitive, technological) specific to a new service concept before development is resourced?', 'Assess whether new service concepts are assessed against a documented business-environment scan specific to that concept, versus relying on the general strategic environment scan with no concept-specific check.', 'Review the business-environment assessment for a recent service concept and confirm it addresses regulatory, competitive, and technological factors specific to that concept.', 'Concept-specific business-environment assessment; regulatory-review note; competitive/technology-landscape summary for the concept.',
    'Flag if a service concept was resourced for development with no concept-specific business-environment assessment on file.', 'ofs_mm_l1_9', 'ofs_l3_9_8_3', 'ofs_l3_9_8_3', 3
  FROM processes p WHERE p.code = 'ofs_l2_9_8';
  INSERT INTO maturity_statements (maturity_model_id, domain_title, process_area,
    level_1_basic, level_2_developing, level_3_established, level_4_advanced, level_5_leading,
    assessor_instruction, evidence_examples, review_steps, alert_rule_hint, sort_order)
  VALUES ('ofs_mm_l1_9', 'Manage Service Portfolio', 'ofs_l3_9_8_3',
    'New service concepts are resourced with no concept-specific business-environment assessment.', 'An environment assessment is produced for some concepts but does not consistently cover regulatory, competitive, and technological factors.', 'A documented, concept-specific business-environment assessment covering regulatory, competitive, and technological factors precedes resourcing of every new service concept.', 'Environment-assessment findings are tracked against actual concept outcomes to calibrate future assessments.', 'Business-environment assessment is continuous through an integrated regulatory/competitive-intelligence platform feeding the concept pipeline.',
    'Ask for the business-environment assessment of the most recent service concept resourced for development.', 'Concept-specific business-environment assessment; regulatory-review note; competitive/technology-landscape summary for the concept.', 'Confirm a documented, concept-specific business-environment assessment exists for the most recent service concept.', 'Flag if a service concept was resourced for development with no concept-specific business-environment assessment on file.', 3)
  ON CONFLICT (maturity_model_id, process_area) DO NOTHING;

  -- 9.9.1
  INSERT INTO questions (questionnaire_id, evaluation_type_id, domain_id, process_id,
    question_code, question_text, question_intent, instruction_text, evidence_examples,
    alert_rule_hint, mapped_maturity_model_id, mapped_maturity_statement_id, matched_process_area, sort_order)
  SELECT v_questionnaire_id, v_eval_type_id, v_domain_id, p.id,
    'ofs_l3_9_9_1', 'How mature is the organization''s process for documenting a periodic evaluation of reserve/resource-and-prospect (RPR) portfolio performance against the financial objectives it supports?', 'Assess whether RPR portfolio performance is formally evaluated against financial objectives in a documented way, versus being assessed only informally with no explicit objective linkage.', 'Review the most recent RPR portfolio performance evaluation and confirm it explicitly measures performance against the documented financial objectives.', 'RPR portfolio performance evaluation report; explicit linkage to financial-objective targets; variance analysis against those targets.',
    'Flag if the most recent RPR portfolio review contains no explicit comparison to documented financial objectives.', 'ofs_mm_l1_9', 'ofs_l3_9_9_1', 'ofs_l3_9_9_1', 1
  FROM processes p WHERE p.code = 'ofs_l2_9_9';
  INSERT INTO maturity_statements (maturity_model_id, domain_title, process_area,
    level_1_basic, level_2_developing, level_3_established, level_4_advanced, level_5_leading,
    assessor_instruction, evidence_examples, review_steps, alert_rule_hint, sort_order)
  VALUES ('ofs_mm_l1_9', 'Manage Service Portfolio', 'ofs_l3_9_9_1',
    'RPR portfolio performance is reviewed informally with no explicit comparison to financial objectives.', 'A performance evaluation is produced but the linkage to specific financial objectives is inconsistent or implicit.', 'A documented RPR portfolio performance evaluation explicitly measures performance against financial objectives on a regular cadence.', 'Performance-versus-objective trends are tracked across multiple cycles to identify systemic over- or under-performance in the RPR portfolio.', 'RPR performance evaluation is continuous through an integrated financial-performance platform with real-time objective-tracking dashboards.',
    'Ask for the most recent RPR portfolio performance evaluation and confirm it explicitly compares results to financial objectives.', 'RPR portfolio performance evaluation report; explicit linkage to financial-objective targets; variance analysis against those targets.', 'Confirm a documented RPR portfolio performance evaluation exists and explicitly compares results against financial objectives.', 'Flag if the most recent RPR portfolio review contains no explicit comparison to documented financial objectives.', 1)
  ON CONFLICT (maturity_model_id, process_area) DO NOTHING;

  -- 9.9.2
  INSERT INTO questions (questionnaire_id, evaluation_type_id, domain_id, process_id,
    question_code, question_text, question_intent, instruction_text, evidence_examples,
    alert_rule_hint, mapped_maturity_model_id, mapped_maturity_statement_id, matched_process_area, sort_order)
  SELECT v_questionnaire_id, v_eval_type_id, v_domain_id, p.id,
    'ofs_l3_9_9_2', 'How mature is the organization''s process for producing a documented predictive analysis of financial-objective attainment based on reserve/resource-and-prospect (RPR) portfolio performance to date?', 'Assess whether RPR performance-to-date data is used to produce a documented forward-looking forecast of financial-objective attainment, versus forecasting being informal with no documented methodology.', 'Review the most recent RPR predictive/forecast analysis and confirm it is based on documented performance-to-date data and states a projected attainment against financial objectives.', 'RPR predictive/forecast analysis document; underlying performance-to-date data set; projected attainment statement against financial objectives.',
    'Flag if no documented predictive analysis of RPR-related financial-objective attainment has been produced in the current fiscal year.', 'ofs_mm_l1_9', 'ofs_l3_9_9_2', 'ofs_l3_9_9_2', 2
  FROM processes p WHERE p.code = 'ofs_l2_9_9';
  INSERT INTO maturity_statements (maturity_model_id, domain_title, process_area,
    level_1_basic, level_2_developing, level_3_established, level_4_advanced, level_5_leading,
    assessor_instruction, evidence_examples, review_steps, alert_rule_hint, sort_order)
  VALUES ('ofs_mm_l1_9', 'Manage Service Portfolio', 'ofs_l3_9_9_2',
    'No forward-looking forecast is produced for the RPR portfolio; attainment is assessed only after period close.', 'A forecast is produced occasionally but without a documented methodology or consistent cadence.', 'A documented predictive analysis, grounded in RPR performance-to-date data, is produced at least quarterly.', 'Forecast accuracy is tracked against actual outcomes and used to refine the predictive methodology for the RPR portfolio.', 'Predictive analysis for the RPR portfolio is generated continuously through an integrated financial-forecasting platform using live performance data.',
    'Ask for the most recent RPR predictive/forecast analysis and confirm it is grounded in documented performance-to-date data.', 'RPR predictive/forecast analysis document; underlying performance-to-date data set; projected attainment statement against financial objectives.', 'Confirm a documented predictive analysis exists for the RPR portfolio, grounded in performance-to-date data.', 'Flag if no documented predictive analysis of RPR-related financial-objective attainment has been produced in the current fiscal year.', 2)
  ON CONFLICT (maturity_model_id, process_area) DO NOTHING;

  -- 9.9.3
  INSERT INTO questions (questionnaire_id, evaluation_type_id, domain_id, process_id,
    question_code, question_text, question_intent, instruction_text, evidence_examples,
    alert_rule_hint, mapped_maturity_model_id, mapped_maturity_statement_id, matched_process_area, sort_order)
  SELECT v_questionnaire_id, v_eval_type_id, v_domain_id, p.id,
    'ofs_l3_9_9_3', 'How mature is the organization''s process for documenting prescriptive rebalancing recommendations for the reserve/resource-and-prospect (RPR) portfolio when predictive analysis indicates a gap to financial objectives?', 'Assess whether a predicted RPR gap to financial objectives triggers a documented set of prescriptive rebalancing actions with owners and timelines, versus gaps being noted with no documented follow-up.', 'Review the most recent prescriptive action plan produced in response to a predicted RPR gap and confirm it names specific actions, owners, and timelines.', 'RPR prescriptive/rebalancing action plan; owner and timeline assignment; follow-up tracking record showing action closure or status.',
    'Flag if a predicted RPR gap to financial objectives was identified with no documented prescriptive action plan produced in response.', 'ofs_mm_l1_9', 'ofs_l3_9_9_3', 'ofs_l3_9_9_3', 3
  FROM processes p WHERE p.code = 'ofs_l2_9_9';
  INSERT INTO maturity_statements (maturity_model_id, domain_title, process_area,
    level_1_basic, level_2_developing, level_3_established, level_4_advanced, level_5_leading,
    assessor_instruction, evidence_examples, review_steps, alert_rule_hint, sort_order)
  VALUES ('ofs_mm_l1_9', 'Manage Service Portfolio', 'ofs_l3_9_9_3',
    'Predicted RPR gaps to financial objectives are noted with no documented follow-up action plan.', 'Action plans are produced for some identified RPR gaps but without consistent owner/timeline assignment or tracking.', 'A documented prescriptive action plan, with owners and timelines, is produced for every identified RPR gap to financial objectives.', 'Action-plan effectiveness (actual improvement achieved) is tracked and used to refine the RPR rebalancing playbook.', 'Prescriptive RPR rebalancing recommendations are generated by an integrated analytics platform modeling multiple rebalancing scenarios in real time.',
    'Ask for the most recent prescriptive action plan produced in response to a predicted RPR gap and confirm owners and timelines are assigned.', 'RPR prescriptive/rebalancing action plan; owner and timeline assignment; follow-up tracking record showing action closure or status.', 'Confirm a documented prescriptive action plan exists for the most recent identified RPR gap, with owners and timelines assigned.', 'Flag if a predicted RPR gap to financial objectives was identified with no documented prescriptive action plan produced in response.', 3)
  ON CONFLICT (maturity_model_id, process_area) DO NOTHING;

  -- 9.10.1
  INSERT INTO questions (questionnaire_id, evaluation_type_id, domain_id, process_id,
    question_code, question_text, question_intent, instruction_text, evidence_examples,
    alert_rule_hint, mapped_maturity_model_id, mapped_maturity_statement_id, matched_process_area, sort_order)
  SELECT v_questionnaire_id, v_eval_type_id, v_domain_id, p.id,
    'ofs_l3_9_10_1', 'How mature is the organization''s process for producing a documented forecast of net free asset (NFA)/available capital capacity to support new reserve/resource and prospect portfolio investments?', 'Assess whether investment decisions are grounded in a documented forecast of available capacity to invest (capital, balance-sheet headroom), versus commitments being made without a documented capacity forecast.', 'Review the current NFA/capacity forecast document and confirm it was used in the most recent portfolio-strategy decision.', 'NFA/available-capacity forecast document; capital-headroom analysis; portfolio-strategy document referencing the capacity forecast.',
    'Flag if a portfolio investment decision was made with no documented NFA/capacity forecast on file.', 'ofs_mm_l1_9', 'ofs_l3_9_10_1', 'ofs_l3_9_10_1', 1
  FROM processes p WHERE p.code = 'ofs_l2_9_10';
  INSERT INTO maturity_statements (maturity_model_id, domain_title, process_area,
    level_1_basic, level_2_developing, level_3_established, level_4_advanced, level_5_leading,
    assessor_instruction, evidence_examples, review_steps, alert_rule_hint, sort_order)
  VALUES ('ofs_mm_l1_9', 'Manage Service Portfolio', 'ofs_l3_9_10_1',
    'Available investment capacity is assessed informally with no documented forecast.', 'A capacity forecast is documented occasionally but not on a defined cadence or not consistently used in decisions.', 'A documented NFA/capacity forecast is maintained on a defined cadence and used in every portfolio-strategy decision.', 'Capacity-forecast accuracy is tracked against actual capital deployed and used to refine the forecasting methodology.', 'NFA/capacity forecasting is integrated into a live treasury/capital-planning platform feeding portfolio-strategy decisions continuously.',
    'Ask for the current NFA/capacity forecast and confirm it was referenced in the most recent portfolio-strategy decision.', 'NFA/available-capacity forecast document; capital-headroom analysis; portfolio-strategy document referencing the capacity forecast.', 'Confirm a documented, current NFA/capacity forecast exists and was used in the most recent portfolio-strategy decision.', 'Flag if a portfolio investment decision was made with no documented NFA/capacity forecast on file.', 1)
  ON CONFLICT (maturity_model_id, process_area) DO NOTHING;

  -- 9.10.2
  INSERT INTO questions (questionnaire_id, evaluation_type_id, domain_id, process_id,
    question_code, question_text, question_intent, instruction_text, evidence_examples,
    alert_rule_hint, mapped_maturity_model_id, mapped_maturity_statement_id, matched_process_area, sort_order)
  SELECT v_questionnaire_id, v_eval_type_id, v_domain_id, p.id,
    'ofs_l3_9_10_2', 'How mature is the organization''s process for documenting the identification of new capacity/investment projects needed to meet reserve/resource and prospect portfolio strategy?', 'Assess whether new project needs are identified through a documented gap analysis against portfolio strategy, versus projects being proposed ad hoc with no documented needs justification.', 'Review the documented project-needs analysis and confirm it identifies a gap against portfolio strategy that each proposed new project addresses.', 'Project-needs/gap analysis document; portfolio-strategy reference; new-project proposal documenting the gap addressed.',
    'Flag if a new project was proposed with no documented gap analysis linking it to portfolio strategy.', 'ofs_mm_l1_9', 'ofs_l3_9_10_2', 'ofs_l3_9_10_2', 2
  FROM processes p WHERE p.code = 'ofs_l2_9_10';
  INSERT INTO maturity_statements (maturity_model_id, domain_title, process_area,
    level_1_basic, level_2_developing, level_3_established, level_4_advanced, level_5_leading,
    assessor_instruction, evidence_examples, review_steps, alert_rule_hint, sort_order)
  VALUES ('ofs_mm_l1_9', 'Manage Service Portfolio', 'ofs_l3_9_10_2',
    'New projects are proposed ad hoc with no documented needs analysis.', 'A needs analysis is documented for some projects but not consistently linked to portfolio strategy.', 'A documented gap analysis against portfolio strategy justifies every new project proposal.', 'Needs-analysis accuracy is tracked against realized project value to refine future project-selection criteria.', 'Project-needs identification is continuous through an integrated portfolio-strategy platform highlighting capacity gaps in real time.',
    'Ask for the documented needs/gap analysis behind the most recently proposed new project.', 'Project-needs/gap analysis document; portfolio-strategy reference; new-project proposal documenting the gap addressed.', 'Confirm a documented gap analysis exists for the most recently proposed new project, linked to portfolio strategy.', 'Flag if a new project was proposed with no documented gap analysis linking it to portfolio strategy.', 2)
  ON CONFLICT (maturity_model_id, process_area) DO NOTHING;

  -- 9.10.3
  INSERT INTO questions (questionnaire_id, evaluation_type_id, domain_id, process_id,
    question_code, question_text, question_intent, instruction_text, evidence_examples,
    alert_rule_hint, mapped_maturity_model_id, mapped_maturity_statement_id, matched_process_area, sort_order)
  SELECT v_questionnaire_id, v_eval_type_id, v_domain_id, p.id,
    'ofs_l3_9_10_3', 'How mature is the organization''s process for documenting a net present value (NPV) analysis for each individual project proposed within the reserve/resource and prospect portfolio strategy?', 'Assess whether project investment decisions are grounded in a documented NPV analysis with stated assumptions, versus decisions being made on qualitative judgment with no documented financial valuation.', 'Review the NPV analysis for a recent proposed project and confirm it documents cash-flow assumptions, discount rate, and resulting NPV.', 'Project NPV analysis/model; documented cash-flow and discount-rate assumptions; investment-decision memo referencing the NPV.',
    'Flag if a proposed project was approved with no documented NPV analysis on file.', 'ofs_mm_l1_9', 'ofs_l3_9_10_3', 'ofs_l3_9_10_3', 3
  FROM processes p WHERE p.code = 'ofs_l2_9_10';
  INSERT INTO maturity_statements (maturity_model_id, domain_title, process_area,
    level_1_basic, level_2_developing, level_3_established, level_4_advanced, level_5_leading,
    assessor_instruction, evidence_examples, review_steps, alert_rule_hint, sort_order)
  VALUES ('ofs_mm_l1_9', 'Manage Service Portfolio', 'ofs_l3_9_10_3',
    'Project investment decisions are made without a documented NPV or financial valuation.', 'NPV analysis is produced for some projects but assumptions are undocumented or inconsistent.', 'A documented NPV analysis, with stated assumptions, is produced for every proposed project and referenced in the investment decision.', 'NPV assumption accuracy is tracked against actual project outcomes and used to refine valuation assumptions.', 'Project NPV analysis is generated through an integrated financial-modeling platform using live cost and price data.',
    'Ask for the NPV analysis of the most recently approved project and confirm documented cash-flow and discount-rate assumptions.', 'Project NPV analysis/model; documented cash-flow and discount-rate assumptions; investment-decision memo referencing the NPV.', 'Confirm a documented NPV analysis with stated assumptions exists for the most recently approved project.', 'Flag if a proposed project was approved with no documented NPV analysis on file.', 3)
  ON CONFLICT (maturity_model_id, process_area) DO NOTHING;

  -- 9.10.4
  INSERT INTO questions (questionnaire_id, evaluation_type_id, domain_id, process_id,
    question_code, question_text, question_intent, instruction_text, evidence_examples,
    alert_rule_hint, mapped_maturity_model_id, mapped_maturity_statement_id, matched_process_area, sort_order)
  SELECT v_questionnaire_id, v_eval_type_id, v_domain_id, p.id,
    'ofs_l3_9_10_4', 'How mature is the organization''s process for documenting a risk/volatility assessment (sensitivity analysis, probability-weighted scenarios) for each individual project proposed within the portfolio strategy?', 'Assess whether project decisions are informed by a documented risk/volatility assessment alongside the NPV, versus investment decisions relying on a single-point NPV estimate with no documented risk analysis.', 'Review the risk/volatility assessment for a recent proposed project and confirm it documents sensitivity ranges or probability-weighted scenarios.', 'Project risk/volatility or sensitivity analysis; probability-weighted scenario model; investment-decision memo referencing the risk assessment.',
    'Flag if a proposed project was approved with no documented risk/volatility assessment alongside its NPV.', 'ofs_mm_l1_9', 'ofs_l3_9_10_4', 'ofs_l3_9_10_4', 4
  FROM processes p WHERE p.code = 'ofs_l2_9_10';
  INSERT INTO maturity_statements (maturity_model_id, domain_title, process_area,
    level_1_basic, level_2_developing, level_3_established, level_4_advanced, level_5_leading,
    assessor_instruction, evidence_examples, review_steps, alert_rule_hint, sort_order)
  VALUES ('ofs_mm_l1_9', 'Manage Service Portfolio', 'ofs_l3_9_10_4',
    'Project decisions rely on a single-point NPV estimate with no documented risk/volatility assessment.', 'A risk assessment is produced for some projects but inconsistently or without documented sensitivity ranges.', 'A documented risk/volatility assessment (sensitivity or probability-weighted scenarios) accompanies every project''s NPV and investment decision.', 'Risk-assessment accuracy is tracked against actual project outcome variance and used to refine risk-modeling assumptions.', 'Project risk/volatility assessment is generated through an integrated Monte Carlo/scenario-modeling platform using live market data.',
    'Ask for the risk/volatility assessment of the most recently approved project and confirm documented sensitivity ranges or scenarios.', 'Project risk/volatility or sensitivity analysis; probability-weighted scenario model; investment-decision memo referencing the risk assessment.', 'Confirm a documented risk/volatility assessment exists for the most recently approved project, alongside its NPV.', 'Flag if a proposed project was approved with no documented risk/volatility assessment alongside its NPV.', 4)
  ON CONFLICT (maturity_model_id, process_area) DO NOTHING;

  -- 9.11.1
  INSERT INTO questions (questionnaire_id, evaluation_type_id, domain_id, process_id,
    question_code, question_text, question_intent, instruction_text, evidence_examples,
    alert_rule_hint, mapped_maturity_model_id, mapped_maturity_statement_id, matched_process_area, sort_order)
  SELECT v_questionnaire_id, v_eval_type_id, v_domain_id, p.id,
    'ofs_l3_9_11_1', 'How mature is the organization''s process for documenting the selection of a service-development strategy (build in-house, partner, license technology, or acquire) for a given service gap or opportunity?', 'Assess whether the build/partner/license/acquire decision for closing a service gap is made through a documented options analysis with a recorded rationale, versus being decided informally with no documented comparison of options.', 'Review the documented strategy-selection analysis for a recent service-development decision and confirm it compares at least two development options (e.g., build versus partner) with a recorded rationale for the option selected.', 'Service-development strategy-selection analysis; options-comparison document (build/partner/license/acquire); decision memo with recorded rationale.',
    'Flag if a service-development strategy was committed to with no documented options analysis or rationale on file.', 'ofs_mm_l1_9', 'ofs_l3_9_11_1', 'ofs_l3_9_11_1', 1
  FROM processes p WHERE p.code = 'ofs_l2_9_11';
  INSERT INTO maturity_statements (maturity_model_id, domain_title, process_area,
    level_1_basic, level_2_developing, level_3_established, level_4_advanced, level_5_leading,
    assessor_instruction, evidence_examples, review_steps, alert_rule_hint, sort_order)
  VALUES ('ofs_mm_l1_9', 'Manage Service Portfolio', 'ofs_l3_9_11_1',
    'Service-development strategy (build/partner/license/acquire) is decided informally with no documented options analysis.', 'An options analysis is documented for some decisions but inconsistently or without a recorded rationale.', 'A documented options analysis, comparing at least two development approaches with a recorded rationale, precedes every service-development strategy decision.', 'Strategy-selection outcomes are tracked against actual development results (cost, time-to-market) to refine the selection criteria.', 'Service-development strategy selection is supported by an integrated decision-analytics platform modeling build/partner/license/acquire scenarios.',
    'Ask for the documented options analysis behind the most recent service-development strategy decision and confirm a recorded rationale.', 'Service-development strategy-selection analysis; options-comparison document (build/partner/license/acquire); decision memo with recorded rationale.', 'Confirm a documented options analysis with a recorded rationale exists for the most recent service-development strategy decision.', 'Flag if a service-development strategy was committed to with no documented options analysis or rationale on file.', 1)
  ON CONFLICT (maturity_model_id, process_area) DO NOTHING;
END $$;