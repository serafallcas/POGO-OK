/*
  OFS Onshore content batch: Install Production Equipment And Maintain Production (ofs_l1_5)
  1 maturity_model (ofs_mm_l1_5) + 23 questions + 23 maturity_statements
  Purely additive, ON CONFLICT DO NOTHING for idempotency.
  Truncation points reconstructed from context.
*/
DO $$
DECLARE
  v_questionnaire_id uuid;
  v_eval_type_id uuid;
  v_domain_id uuid;
BEGIN
  SELECT id INTO v_eval_type_id FROM evaluation_types WHERE code = 'ofs_onshore';
  SELECT id INTO v_questionnaire_id FROM questionnaires WHERE code = 'ofs_onshore_questionnaire';
  SELECT id INTO v_domain_id FROM domains WHERE code = 'ofs_l1_5';

  INSERT INTO maturity_models (code, label, description, domain_id, mapped_domain_id, mapped_domain_name, version, source_workbook, is_active)
  VALUES ('ofs_mm_l1_5', 'Install Production Equipment And Maintain Production - Maturity Model', 'OFS Onshore maturity model for Install Production Equipment And Maintain Production', v_domain_id, 'ofs_l1_5', 'Install Production Equipment And Maintain Production', '1.0', 'POGO-OFS_Level_1-3_framework.pptx', true)
  ON CONFLICT (code) DO NOTHING;

  -- Q1: ofs_l3_5_1_1
  INSERT INTO questions (questionnaire_id, evaluation_type_id, domain_id, process_id,
    question_code, question_text, question_intent, instruction_text, evidence_examples,
    alert_rule_hint, mapped_maturity_model_id, mapped_maturity_statement_id, matched_process_area, sort_order)
  SELECT v_questionnaire_id, v_eval_type_id, v_domain_id, p.id,
    'ofs_l3_5_1_1', 'How mature is the organization''s process for planning and executing cased-hole logging services (production logs, integrity logs) on producing wells?', 'Assess whether cased-hole logging is scheduled against a defined surveillance program with documented objectives, versus run reactively with no plan or objective tied to well performance.', 'Review the cased-hole surveillance program/schedule and the job objective/results record for a recent cased-hole logging run.', 'Cased-hole surveillance program; logging job ticket and objective statement; log results report.',
    'Flag if a cased-hole log is run with no documented objective linked to a surveillance program.', 'ofs_mm_l1_5', 'ofs_l3_5_1_1', 'ofs_l3_5_1_1', 1
  FROM processes p WHERE p.code = 'ofs_l2_5_1';

  INSERT INTO maturity_statements (maturity_model_id, domain_title, process_area,
    level_1_basic, level_2_developing, level_3_established, level_4_advanced, level_5_leading,
    assessor_instruction, evidence_examples, review_steps, alert_rule_hint, sort_order)
  VALUES ('ofs_mm_l1_5', 'Install Production Equipment And Maintain Production', 'ofs_l3_5_1_1',
    'Cased-hole logging is run ad hoc with no documented program or objective.', 'A surveillance program exists but individual job objectives are inconsistently documented.', 'Cased-hole logging follows a documented surveillance program with a stated objective and results record for every run.', 'Log results are tracked across wells to refine the surveillance program and target high-risk wells.', 'Cased-hole surveillance is integrated with predictive well-performance analytics, continuously optimizing the logging schedule across the field.',
    'Ask for the surveillance program and confirm the most recent cased-hole log run against it has a documented objective and result.', 'Cased-hole surveillance program; logging job ticket and objective statement; log results report.', 'Confirm one well''s cased-hole logging run is traceable to the surveillance program and its stated objective.', 'Flag if a cased-hole log is run with no documented objective linked to a surveillance program.', 1)
  ON CONFLICT (maturity_model_id, process_area) DO NOTHING;

  -- Q2: ofs_l3_5_1_2
  INSERT INTO questions (questionnaire_id, evaluation_type_id, domain_id, process_id,
    question_code, question_text, question_intent, instruction_text, evidence_examples,
    alert_rule_hint, mapped_maturity_model_id, mapped_maturity_statement_id, matched_process_area, sort_order)
  SELECT v_questionnaire_id, v_eval_type_id, v_domain_id, p.id,
    'ofs_l3_5_1_2', 'How mature is the organization''s process for ongoing monitoring of cement integrity behind casing over the producing life of the well?', 'Assess whether cement integrity is periodically re-verified (temperature/bond logs, annulus pressure monitoring) on a defined schedule, versus checked only once at completion and never revisited.', 'Review the cement monitoring schedule/program and the most recent monitoring result (bond log, annulus pressure trend) for a producing well.', 'Cement monitoring program; bond/temperature log or annulus pressure trend; monitoring review record.',
    'Flag if a well shows a documented annulus pressure anomaly with no corresponding cement integrity investigation.', 'ofs_mm_l1_5', 'ofs_l3_5_1_2', 'ofs_l3_5_1_2', 2
  FROM processes p WHERE p.code = 'ofs_l2_5_1';

  INSERT INTO maturity_statements (maturity_model_id, domain_title, process_area,
    level_1_basic, level_2_developing, level_3_established, level_4_advanced, level_5_leading,
    assessor_instruction, evidence_examples, review_steps, alert_rule_hint, sort_order)
  VALUES ('ofs_mm_l1_5', 'Install Production Equipment And Maintain Production', 'ofs_l3_5_1_2',
    'Cement integrity is not monitored after initial completion.', 'Monitoring occurs periodically but is not scheduled or systematically reviewed.', 'Cement integrity is monitored on a documented schedule with results reviewed for every well.', 'Monitoring data is analyzed across wells to identify systemic cement degradation trends.', 'Cement integrity monitoring is integrated with real-time annulus pressure surveillance across the well portfolio.',
    'Ask for the most recent cement monitoring result of a producing well and confirm it was reviewed against the monitoring schedule.', 'Cement monitoring program; bond/temperature log or annulus pressure trend; monitoring review record.', 'Confirm one well''s cement monitoring schedule is current and its latest result was reviewed.', 'Flag if a well shows a documented annulus pressure anomaly with no corresponding cement integrity investigation.', 2)
  ON CONFLICT (maturity_model_id, process_area) DO NOTHING;

  -- Q3: ofs_l3_5_1_3
  INSERT INTO questions (questionnaire_id, evaluation_type_id, domain_id, process_id,
    question_code, question_text, question_intent, instruction_text, evidence_examples,
    alert_rule_hint, mapped_maturity_model_id, mapped_maturity_statement_id, matched_process_area, sort_order)
  SELECT v_questionnaire_id, v_eval_type_id, v_domain_id, p.id,
    'ofs_l3_5_1_3', 'How mature is the organization''s process for monitoring internal and external corrosion of production tubulars and equipment?', 'Assess whether corrosion is tracked through documented coupon/probe data and inspection results on a defined schedule, versus addressed only after a leak or failure occurs.', 'Review the corrosion monitoring program (coupons, probes, inspection intervals) and the most recent corrosion rate/inspection result for a producing well or pipeline segment.', 'Corrosion monitoring program; coupon/probe data; inspection report; corrosion rate trend.',
    'Flag if a corrosion rate result exceeds the defined threshold with no documented follow-up action.', 'ofs_mm_l1_5', 'ofs_l3_5_1_3', 'ofs_l3_5_1_3', 3
  FROM processes p WHERE p.code = 'ofs_l2_5_1';

  INSERT INTO maturity_statements (maturity_model_id, domain_title, process_area,
    level_1_basic, level_2_developing, level_3_established, level_4_advanced, level_5_leading,
    assessor_instruction, evidence_examples, review_steps, alert_rule_hint, sort_order)
  VALUES ('ofs_mm_l1_5', 'Install Production Equipment And Maintain Production', 'ofs_l3_5_1_3',
    'Corrosion is not monitored; issues are addressed only after a leak or failure.', 'Monitoring data is collected but not consistently reviewed against thresholds.', 'Corrosion is monitored on a documented schedule with results reviewed against defined thresholds for every asset.', 'Corrosion trends are analyzed across the asset base to refine monitoring intervals and material selection.', 'Corrosion monitoring is integrated with real-time sensors and predictive corrosion modeling across the field.',
    'Ask for the most recent corrosion monitoring result for a producing well or pipeline segment and confirm it was reviewed against the defined threshold.', 'Corrosion monitoring program; coupon/probe data; inspection report; corrosion rate trend.', 'Confirm one asset''s corrosion monitoring result is current and was reviewed against the documented threshold.', 'Flag if a corrosion rate result exceeds the defined threshold with no documented follow-up action.', 3)
  ON CONFLICT (maturity_model_id, process_area) DO NOTHING;

  -- Q4: ofs_l3_5_1_4
  INSERT INTO questions (questionnaire_id, evaluation_type_id, domain_id, process_id,
    question_code, question_text, question_intent, instruction_text, evidence_examples,
    alert_rule_hint, mapped_maturity_model_id, mapped_maturity_statement_id, matched_process_area, sort_order)
  SELECT v_questionnaire_id, v_eval_type_id, v_domain_id, p.id,
    'ofs_l3_5_1_4', 'How mature is the organization''s process for monitoring produced formation fluid properties (water cut, gas-oil ratio, chemistry) over the producing life of the well?', 'Assess whether fluid property changes are tracked on a defined sampling schedule and reviewed for production-management implications, versus sampled irregularly with no systematic review.', 'Review the fluid sampling/monitoring schedule and the trend analysis of recent fluid property results for a producing well.', 'Fluid sampling schedule; laboratory analysis results; fluid property trend report.',
    'Flag if a significant shift in fluid properties (e.g., water cut increase) has no documented review or resulting action.', 'ofs_mm_l1_5', 'ofs_l3_5_1_4', 'ofs_l3_5_1_4', 4
  FROM processes p WHERE p.code = 'ofs_l2_5_1';

  INSERT INTO maturity_statements (maturity_model_id, domain_title, process_area,
    level_1_basic, level_2_developing, level_3_established, level_4_advanced, level_5_leading,
    assessor_instruction, evidence_examples, review_steps, alert_rule_hint, sort_order)
  VALUES ('ofs_mm_l1_5', 'Install Production Equipment And Maintain Production', 'ofs_l3_5_1_4',
    'Formation fluid properties are sampled irregularly with no documented schedule or trend review.', 'A sampling schedule exists but trend review and follow-up action are inconsistent.', 'Fluid properties are sampled on a documented schedule with trends reviewed and actioned for every well.', 'Fluid trend data is analyzed across wells to inform reservoir management and production optimization decisions.', 'Fluid property monitoring is integrated with real-time sensors and predictive production-decline modeling.',
    'Ask for the fluid property trend report of a producing well and confirm any significant shift was reviewed and actioned.', 'Fluid sampling schedule; laboratory analysis results; fluid property trend report.', 'Confirm one well''s fluid sampling schedule is current and its trend report shows evidence of review.', 'Flag if a significant shift in fluid properties (e.g., water cut increase) has no documented review or resulting action.', 4)
  ON CONFLICT (maturity_model_id, process_area) DO NOTHING;

  -- Q5: ofs_l3_5_2_1
  INSERT INTO questions (questionnaire_id, evaluation_type_id, domain_id, process_id,
    question_code, question_text, question_intent, instruction_text, evidence_examples,
    alert_rule_hint, mapped_maturity_model_id, mapped_maturity_statement_id, matched_process_area, sort_order)
  SELECT v_questionnaire_id, v_eval_type_id, v_domain_id, p.id,
    'ofs_l3_5_2_1', 'How mature is the organization''s process for designing gathering/flow pipelines (material selection among carbon steel, HDPE, MDPE) matched to service conditions?', 'Assess whether pipeline material selection is based on documented service-condition analysis (pressure, corrosivity, fluid type), versus a default material used regardless of conditions.', 'Review the pipeline design report specifying material selection and the supporting service-condition analysis (pressure rating, corrosivity, fluid compatibility).', 'Pipeline design report; service-condition/material-selection analysis; pipe specification sheet.',
    'Flag if a pipeline is designed with no documented service-condition analysis supporting the material selection.', 'ofs_mm_l1_5', 'ofs_l3_5_2_1', 'ofs_l3_5_2_1', 1
  FROM processes p WHERE p.code = 'ofs_l2_5_2';

  INSERT INTO maturity_statements (maturity_model_id, domain_title, process_area,
    level_1_basic, level_2_developing, level_3_established, level_4_advanced, level_5_leading,
    assessor_instruction, evidence_examples, review_steps, alert_rule_hint, sort_order)
  VALUES ('ofs_mm_l1_5', 'Install Production Equipment And Maintain Production', 'ofs_l3_5_2_1',
    'Pipeline material is selected by default with no documented service-condition analysis.', 'A design exists for major lines but material-selection rationale is inconsistently documented.', 'Pipeline material selection is documented and supported by service-condition analysis for every line.', 'Pipeline performance and failure data are tracked across the network to refine material-selection standards.', 'Pipeline design is optimized through an integrated materials-engineering and network-modeling workflow across the asset.',
    'Ask for the service-condition analysis supporting the most recently designed pipeline segment''s material selection.', 'Pipeline design report; service-condition/material-selection analysis; pipe specification sheet.', 'Confirm one pipeline segment''s design report references a documented service-condition analysis for its material choice.', 'Flag if a pipeline is designed with no documented service-condition analysis supporting the material selection.', 1)
  ON CONFLICT (maturity_model_id, process_area) DO NOTHING;

  -- Q6: ofs_l3_5_3_1
  INSERT INTO questions (questionnaire_id, evaluation_type_id, domain_id, process_id,
    question_code, question_text, question_intent, instruction_text, evidence_examples,
    alert_rule_hint, mapped_maturity_model_id, mapped_maturity_statement_id, matched_process_area, sort_order)
  SELECT v_questionnaire_id, v_eval_type_id, v_domain_id, p.id,
    'ofs_l3_5_3_1', 'How mature is the organization''s process for selecting, installing and optimizing artificial lift systems (rod pump, ESP, gas lift) matched to well production characteristics?', 'Assess whether artificial lift selection is based on documented well performance/production analysis, versus a default lift method used regardless of well characteristics.', 'Review the artificial lift selection rationale (production forecast, fluid properties, well geometry) and the post-installation performance review against design expectations.', 'Artificial lift selection/design report; well production forecast; post-installation performance review.',
    'Flag if artificial lift equipment is installed with no documented selection rationale referencing well-specific production characteristics.', 'ofs_mm_l1_5', 'ofs_l3_5_3_1', 'ofs_l3_5_3_1', 1
  FROM processes p WHERE p.code = 'ofs_l2_5_3';

  INSERT INTO maturity_statements (maturity_model_id, domain_title, process_area,
    level_1_basic, level_2_developing, level_3_established, level_4_advanced, level_5_leading,
    assessor_instruction, evidence_examples, review_steps, alert_rule_hint, sort_order)
  VALUES ('ofs_mm_l1_5', 'Install Production Equipment And Maintain Production', 'ofs_l3_5_3_1',
    'Artificial lift is selected by default with no documented well-specific analysis.', 'A design rationale exists for major wells but post-installation performance is inconsistently reviewed.', 'Artificial lift selection is documented and matched to well-specific production characteristics, with performance reviewed against design for every installation.', 'Lift performance data is tracked across the well portfolio to refine selection criteria and optimize run life.', 'Artificial lift selection and optimization are integrated with real-time production surveillance and predictive failure analytics across the field.',
    'Ask for the post-installation performance review of the most recently installed artificial lift system and confirm it was compared against design expectations.', 'Artificial lift selection/design report; well production forecast; post-installation performance review.', 'Confirm one well''s artificial lift selection rationale and post-installation performance review are both on file and consistent.', 'Flag if artificial lift equipment is installed with no documented selection rationale referencing well-specific production characteristics.', 1)
  ON CONFLICT (maturity_model_id, process_area) DO NOTHING;

  -- Q7: ofs_l3_5_4_1
  INSERT INTO questions (questionnaire_id, evaluation_type_id, domain_id, process_id,
    question_code, question_text, question_intent, instruction_text, evidence_examples,
    alert_rule_hint, mapped_maturity_model_id, mapped_maturity_statement_id, matched_process_area, sort_order)
  SELECT v_questionnaire_id, v_eval_type_id, v_domain_id, p.id,
    'ofs_l3_5_4_1', 'How mature is the organization''s process for selecting and optimizing production chemical dosing (scale inhibitors, demulsifiers, biocides) based on produced fluid analysis?', 'Assess whether chemical dosing is set and adjusted based on documented fluid analysis and performance monitoring, versus dosed at a fixed rate with no analytical basis.', 'Review the chemical program (type, dosing rate) and its supporting fluid analysis, and confirm dosing adjustments reference monitoring results.', 'Production chemical program; fluid analysis report; dosing adjustment record.',
    'Flag if a chemical dosing rate has not been reviewed against fluid analysis results within the defined interval.', 'ofs_mm_l1_5', 'ofs_l3_5_4_1', 'ofs_l3_5_4_1', 1
  FROM processes p WHERE p.code = 'ofs_l2_5_4';

  INSERT INTO maturity_statements (maturity_model_id, domain_title, process_area,
    level_1_basic, level_2_developing, level_3_established, level_4_advanced, level_5_leading,
    assessor_instruction, evidence_examples, review_steps, alert_rule_hint, sort_order)
  VALUES ('ofs_mm_l1_5', 'Install Production Equipment And Maintain Production', 'ofs_l3_5_4_1',
    'Chemical dosing is fixed with no documented fluid analysis or review.', 'Fluid analysis is performed periodically but dosing adjustments are inconsistently linked to it.', 'Chemical dosing is set and adjusted based on documented fluid analysis, reviewed on a defined schedule for every well.', 'Chemical performance and cost data are tracked across wells to optimize the chemical program.', 'Chemical optimization is integrated with real-time fluid monitoring and automated dosing control across the field.',
    'Ask for the fluid analysis supporting the current chemical dosing rate of a producing well and confirm the dosing was set or adjusted based on it.', 'Production chemical program; fluid analysis report; dosing adjustment record.', 'Confirm one well''s chemical program references a recent fluid analysis and that dosing matches the documented program.', 'Flag if a chemical dosing rate has not been reviewed against fluid analysis results within the defined interval.', 1)
  ON CONFLICT (maturity_model_id, process_area) DO NOTHING;

  -- Q8: ofs_l3_5_5_1
  INSERT INTO questions (questionnaire_id, evaluation_type_id, domain_id, process_id,
    question_code, question_text, question_intent, instruction_text, evidence_examples,
    alert_rule_hint, mapped_maturity_model_id, mapped_maturity_statement_id, matched_process_area, sort_order)
  SELECT v_questionnaire_id, v_eval_type_id, v_domain_id, p.id,
    'ofs_l3_5_5_1', 'How mature is the organization''s process for installing and calibrating sales/custody-transfer meters on gathering pipelines?', 'Assess whether sales meter installation and calibration follow a documented standard (e.g., API MPMS) with verified calibration records, versus installed with no calibration traceability.', 'Review the sales meter specification/standard referenced, the installation record, and the calibration certificate.', 'Sales meter specification; installation record; calibration certificate.',
    'Flag if a sales meter is in custody-transfer service with an expired or missing calibration certificate.', 'ofs_mm_l1_5', 'ofs_l3_5_5_1', 'ofs_l3_5_5_1', 1
  FROM processes p WHERE p.code = 'ofs_l2_5_5';

  INSERT INTO maturity_statements (maturity_model_id, domain_title, process_area,
    level_1_basic, level_2_developing, level_3_established, level_4_advanced, level_5_leading,
    assessor_instruction, evidence_examples, review_steps, alert_rule_hint, sort_order)
  VALUES ('ofs_mm_l1_5', 'Install Production Equipment And Maintain Production', 'ofs_l3_5_5_1',
    'Sales meters are installed with no documented specification or calibration record.', 'A specification exists but calibration certificates are inconsistently current.', 'Every sales meter is installed to a documented standard and has a current, verified calibration certificate.', 'Meter performance and calibration drift data are tracked across the network to refine calibration intervals.', 'Sales metering is integrated with a digital calibration-management system providing real-time compliance visibility across the field.',
    'Ask for the calibration certificate of a sales meter currently in custody-transfer service and confirm it is within its calibration interval.', 'Sales meter specification; installation record; calibration certificate.', 'Confirm one sales meter''s installation record and calibration certificate are on file and current.', 'Flag if a sales meter is in custody-transfer service with an expired or missing calibration certificate.', 1)
  ON CONFLICT (maturity_model_id, process_area) DO NOTHING;

  -- Q9: ofs_l3_5_5_2
  INSERT INTO questions (questionnaire_id, evaluation_type_id, domain_id, process_id,
    question_code, question_text, question_intent, instruction_text, evidence_examples,
    alert_rule_hint, mapped_maturity_model_id, mapped_maturity_statement_id, matched_process_area, sort_order)
  SELECT v_questionnaire_id, v_eval_type_id, v_domain_id, p.id,
    'ofs_l3_5_5_2', 'How mature is the organization''s process for selecting gathering point locations based on documented hydraulic and logistics analysis?', 'Assess whether gathering point selection is grounded in documented hydraulic modeling and logistics/access analysis, versus based on convenience or precedent without analysis.', 'Review the gathering point selection study (hydraulic modeling, access/logistics analysis) for a recent gathering system design.', 'Gathering point selection study; hydraulic model output; access/logistics analysis.',
    'Flag if a gathering point is selected with no documented hydraulic modeling supporting the decision.', 'ofs_mm_l1_5', 'ofs_l3_5_5_2', 'ofs_l3_5_5_2', 2
  FROM processes p WHERE p.code = 'ofs_l2_5_5';

  INSERT INTO maturity_statements (maturity_model_id, domain_title, process_area,
    level_1_basic, level_2_developing, level_3_established, level_4_advanced, level_5_leading,
    assessor_instruction, evidence_examples, review_steps, alert_rule_hint, sort_order)
  VALUES ('ofs_mm_l1_5', 'Install Production Equipment And Maintain Production', 'ofs_l3_5_5_2',
    'Gathering points are selected by convenience with no documented analysis.', 'Analysis is performed for major systems but is not consistently required before selection.', 'Gathering point selection is documented and supported by hydraulic modeling and logistics analysis for every system.', 'Gathering system performance is tracked across the field to refine point-selection criteria.', 'Gathering point selection is optimized through an integrated field-wide hydraulic and logistics modeling platform.',
    'Ask for the hydraulic modeling study supporting the most recently sited gathering point.', 'Gathering point selection study; hydraulic model output; access/logistics analysis.', 'Confirm one gathering point''s siting decision references a documented hydraulic/logistics study.', 'Flag if a gathering point is selected with no documented hydraulic modeling supporting the decision.', 2)
  ON CONFLICT (maturity_model_id, process_area) DO NOTHING;

  -- Q10: ofs_l3_5_5_3
  INSERT INTO questions (questionnaire_id, evaluation_type_id, domain_id, process_id,
    question_code, question_text, question_intent, instruction_text, evidence_examples,
    alert_rule_hint, mapped_maturity_model_id, mapped_maturity_statement_id, matched_process_area, sort_order)
  SELECT v_questionnaire_id, v_eval_type_id, v_domain_id, p.id,
    'ofs_l3_5_5_3', 'How mature is the organization''s process for installing and burying gathering pipeline to documented specifications (depth of cover, bedding, backfill)?', 'Assess whether pipeline installation is verified against documented specifications during construction (depth checks, inspection records), versus buried with no verification that specifications were met.', 'Review the installation specification (depth of cover, bedding/backfill requirements) and the construction inspection/as-built record confirming compliance.', 'Pipeline installation specification; construction inspection log; as-built survey/record.',
    'Flag if a buried pipeline segment has no documented depth-of-cover verification.', 'ofs_mm_l1_5', 'ofs_l3_5_5_3', 'ofs_l3_5_5_3', 3
  FROM processes p WHERE p.code = 'ofs_l2_5_5';

  INSERT INTO maturity_statements (maturity_model_id, domain_title, process_area,
    level_1_basic, level_2_developing, level_3_established, level_4_advanced, level_5_leading,
    assessor_instruction, evidence_examples, review_steps, alert_rule_hint, sort_order)
  VALUES ('ofs_mm_l1_5', 'Install Production Equipment And Maintain Production', 'ofs_l3_5_5_3',
    'Pipeline is buried with no documented specification or inspection verification.', 'A specification exists but inspection verification is inconsistently recorded.', 'Every buried pipeline segment has a documented specification and a verified inspection/as-built record confirming compliance.', 'Installation quality data is tracked across the network to refine construction standards and contractor oversight.', 'Pipeline installation is integrated with real-time digital as-built capture and automated compliance verification.',
    'Ask for the as-built/inspection record of a recently installed gathering pipeline segment and confirm depth of cover met specification.', 'Pipeline installation specification; construction inspection log; as-built survey/record.', 'Confirm one pipeline segment''s installation specification and as-built/inspection record are both on file and consistent.', 'Flag if a buried pipeline segment has no documented depth-of-cover verification.', 3)
  ON CONFLICT (maturity_model_id, process_area) DO NOTHING;

  -- Q11: ofs_l3_5_5_4
  INSERT INTO questions (questionnaire_id, evaluation_type_id, domain_id, process_id,
    question_code, question_text, question_intent, instruction_text, evidence_examples,
    alert_rule_hint, mapped_maturity_model_id, mapped_maturity_statement_id, matched_process_area, sort_order)
  SELECT v_questionnaire_id, v_eval_type_id, v_domain_id, p.id,
    'ofs_l3_5_5_4', 'How mature is the organization''s process for obtaining and tracking the inspections and permits required before a pipeline is placed into operation?', 'Assess whether pipeline commissioning is gated on documented permit and inspection completion, versus placed into service with permits and inspections tracked informally or after the fact.', 'Review the permit/inspection checklist required for the pipeline and confirm all items were completed and documented before the pipeline was placed into service.', 'Permit/inspection checklist; permit approvals; pre-commissioning inspection sign-off.',
    'Flag if a pipeline was placed into operation with an outstanding required permit or inspection item.', 'ofs_mm_l1_5', 'ofs_l3_5_5_4', 'ofs_l3_5_5_4', 4
  FROM processes p WHERE p.code = 'ofs_l2_5_5';

  INSERT INTO maturity_statements (maturity_model_id, domain_title, process_area,
    level_1_basic, level_2_developing, level_3_established, level_4_advanced, level_5_leading,
    assessor_instruction, evidence_examples, review_steps, alert_rule_hint, sort_order)
  VALUES ('ofs_mm_l1_5', 'Install Production Equipment And Maintain Production', 'ofs_l3_5_5_4',
    'Pipelines are placed into operation with no documented permit/inspection tracking.', 'A checklist exists but completion is not consistently verified before commissioning.', 'Every pipeline has a documented permit/inspection checklist fully completed and signed off before commissioning.', 'Permit/inspection cycle times and findings are tracked across the network to streamline commissioning.', 'Permit and inspection tracking is integrated with a digital regulatory-compliance system providing real-time status across the field.',
    'Ask for the permit/inspection checklist of the most recently commissioned pipeline and confirm every item was signed off before start-up.', 'Permit/inspection checklist; permit approvals; pre-commissioning inspection sign-off.', 'Confirm one pipeline''s permit/inspection checklist is complete and precedes its commissioning date.', 'Flag if a pipeline was placed into operation with an outstanding required permit or inspection item.', 4)
  ON CONFLICT (maturity_model_id, process_area) DO NOTHING;

  -- Q12: ofs_l3_5_6_1
  INSERT INTO questions (questionnaire_id, evaluation_type_id, domain_id, process_id,
    question_code, question_text, question_intent, instruction_text, evidence_examples,
    alert_rule_hint, mapped_maturity_model_id, mapped_maturity_statement_id, matched_process_area, sort_order)
  SELECT v_questionnaire_id, v_eval_type_id, v_domain_id, p.id,
    'ofs_l3_5_6_1', 'How mature is the organization''s process for installing and commissioning surface production equipment (separators, compressors, tanks, flare stack) against documented design and commissioning checks?', 'Assess whether surface equipment installation is verified against design specifications and a formal commissioning checklist (pressure tests, safety device checks) before start-up, versus started up with no documented verification.', 'Review the equipment design specification and the commissioning checklist/sign-off (pressure tests, relief/safety device verification) for a recently installed equipment package.', 'Equipment design specification; commissioning checklist; pressure test and safety device verification records.',
    'Flag if surface production equipment is started up with no documented commissioning checklist sign-off.', 'ofs_mm_l1_5', 'ofs_l3_5_6_1', 'ofs_l3_5_6_1', 1
  FROM processes p WHERE p.code = 'ofs_l2_5_6';

  INSERT INTO maturity_statements (maturity_model_id, domain_title, process_area,
    level_1_basic, level_2_developing, level_3_established, level_4_advanced, level_5_leading,
    assessor_instruction, evidence_examples, review_steps, alert_rule_hint, sort_order)
  VALUES ('ofs_mm_l1_5', 'Install Production Equipment And Maintain Production', 'ofs_l3_5_6_1',
    'Equipment is installed and started up with no documented design verification or commissioning checklist.', 'A checklist exists but is inconsistently completed or retained.', 'Every equipment installation has a documented design specification and a fully completed, signed-off commissioning checklist before start-up.', 'Commissioning findings are tracked across installations to refine equipment specification and vendor standards.', 'Equipment installation and commissioning are integrated with a digital asset-management system providing fleet-wide status and history.',
    'Ask for the commissioning checklist of the most recently installed equipment package and confirm all safety device checks were signed off before start-up.', 'Equipment design specification; commissioning checklist; pressure test and safety device verification records.', 'Confirm one equipment package''s design specification and commissioning checklist are both on file and fully signed off.', 'Flag if surface production equipment is started up with no documented commissioning checklist sign-off.', 1)
  ON CONFLICT (maturity_model_id, process_area) DO NOTHING;

  -- Q13: ofs_l3_5_7_1
  INSERT INTO questions (questionnaire_id, evaluation_type_id, domain_id, process_id,
    question_code, question_text, question_intent, instruction_text, evidence_examples,
    alert_rule_hint, mapped_maturity_model_id, mapped_maturity_statement_id, matched_process_area, sort_order)
  SELECT v_questionnaire_id, v_eval_type_id, v_domain_id, p.id,
    'ofs_l3_5_7_1', 'How mature is the organization''s process for planning and executing coiled tubing interventions with documented job design and risk controls?', 'Assess whether coiled tubing jobs follow a documented design (fatigue/force calculations, well control plan) with real-time monitoring, versus run with no engineering basis or documented risk controls.', 'Review the coiled tubing job design (fatigue/force calculation, well control plan) and the real-time job execution log for a recent intervention.', 'Coiled tubing job design; fatigue/force calculation; real-time job execution log; well control plan.',
    'Flag if a coiled tubing job proceeds with no documented fatigue/force calculation for the specific well depth and pressure.', 'ofs_mm_l1_5', 'ofs_l3_5_7_1', 'ofs_l3_5_7_1', 1
  FROM processes p WHERE p.code = 'ofs_l2_5_7';

  INSERT INTO maturity_statements (maturity_model_id, domain_title, process_area,
    level_1_basic, level_2_developing, level_3_established, level_4_advanced, level_5_leading,
    assessor_instruction, evidence_examples, review_steps, alert_rule_hint, sort_order)
  VALUES ('ofs_mm_l1_5', 'Install Production Equipment And Maintain Production', 'ofs_l3_5_7_1',
    'Coiled tubing jobs are run with no documented design or well control plan.', 'A design exists for major jobs but fatigue/force calculations are inconsistently documented.', 'Every coiled tubing job has a documented design, fatigue/force calculation and well control plan, with a real-time execution log.', 'Job performance and tubing fatigue data are tracked across jobs to refine string management and job design.', 'Coiled tubing operations are integrated with real-time fatigue modeling and automated force-limit alerting.',
    'Ask for the fatigue/force calculation of the most recent coiled tubing job and confirm it was completed before the job was executed.', 'Coiled tubing job design; fatigue/force calculation; real-time job execution log; well control plan.', 'Confirm one coiled tubing job''s design, fatigue calculation and execution log are consistent and complete.', 'Flag if a coiled tubing job proceeds with no documented fatigue/force calculation for the specific well depth and pressure.', 1)
  ON CONFLICT (maturity_model_id, process_area) DO NOTHING;

  -- Q14: ofs_l3_5_7_2
  INSERT INTO questions (questionnaire_id, evaluation_type_id, domain_id, process_id,
    question_code, question_text, question_intent, instruction_text, evidence_examples,
    alert_rule_hint, mapped_maturity_model_id, mapped_maturity_statement_id, matched_process_area, sort_order)
  SELECT v_questionnaire_id, v_eval_type_id, v_domain_id, p.id,
    'ofs_l3_5_7_2', 'How mature is the organization''s process for planning and executing slickline interventions with documented job risk assessment and toolstring verification?', 'Assess whether slickline jobs are preceded by a documented risk assessment and toolstring verification (weak point, shear ratings), versus run informally with no risk assessment.', 'Review the slickline job risk assessment and the toolstring verification record (weak point, shear ratings) for a recent job.', 'Slickline job risk assessment; toolstring/BHA diagram with weak point and shear rating; job report.',
    'Flag if a slickline job proceeds with no documented weak point verification in the toolstring.', 'ofs_mm_l1_5', 'ofs_l3_5_7_2', 'ofs_l3_5_7_2', 2
  FROM processes p WHERE p.code = 'ofs_l2_5_7';

  INSERT INTO maturity_statements (maturity_model_id, domain_title, process_area,
    level_1_basic, level_2_developing, level_3_established, level_4_advanced, level_5_leading,
    assessor_instruction, evidence_examples, review_steps, alert_rule_hint, sort_order)
  VALUES ('ofs_mm_l1_5', 'Install Production Equipment And Maintain Production', 'ofs_l3_5_7_2',
    'Slickline jobs are run with no documented risk assessment or toolstring verification.', 'A risk assessment exists for major jobs but toolstring verification is inconsistently documented.', 'Every slickline job has a documented risk assessment and verified toolstring configuration.', 'Job incident and performance data are tracked across jobs to refine risk assessment criteria.', 'Slickline operations are integrated with a digital job-planning system providing real-time toolstring and risk verification across the field.',
    'Ask for the risk assessment and toolstring diagram of the most recent slickline job and confirm the weak point rating is documented.', 'Slickline job risk assessment; toolstring/BHA diagram with weak point and shear rating; job report.', 'Confirm one slickline job''s risk assessment and toolstring verification record are both on file and consistent.', 'Flag if a slickline job proceeds with no documented weak point verification in the toolstring.', 2)
  ON CONFLICT (maturity_model_id, process_area) DO NOTHING;

  -- Q15: ofs_l3_5_7_3
  INSERT INTO questions (questionnaire_id, evaluation_type_id, domain_id, process_id,
    question_code, question_text, question_intent, instruction_text, evidence_examples,
    alert_rule_hint, mapped_maturity_model_id, mapped_maturity_statement_id, matched_process_area, sort_order)
  SELECT v_questionnaire_id, v_eval_type_id, v_domain_id, p.id,
    'ofs_l3_5_7_3', 'How mature is the organization''s process for planning and executing snubbing (hydraulic workover) operations under pressure with documented well control procedures?', 'Assess whether snubbing operations follow a documented well control procedure with force/buckling calculations, versus performed with no engineering basis for the force margins involved.', 'Review the snubbing job well control procedure and the force/buckling calculation supporting the operation for a recent job.', 'Snubbing well control procedure; force/buckling calculation; job execution log.',
    'Flag if a snubbing job proceeds with no documented force/buckling calculation for the specific well pressure and tubing string.', 'ofs_mm_l1_5', 'ofs_l3_5_7_3', 'ofs_l3_5_7_3', 3
  FROM processes p WHERE p.code = 'ofs_l2_5_7';

  INSERT INTO maturity_statements (maturity_model_id, domain_title, process_area,
    level_1_basic, level_2_developing, level_3_established, level_4_advanced, level_5_leading,
    assessor_instruction, evidence_examples, review_steps, alert_rule_hint, sort_order)
  VALUES ('ofs_mm_l1_5', 'Install Production Equipment And Maintain Production', 'ofs_l3_5_7_3',
    'Snubbing operations are performed with no documented well control procedure or force calculation.', 'A procedure exists but force/buckling calculations are inconsistently documented.', 'Every snubbing job has a documented well control procedure and force/buckling calculation before proceeding.', 'Job performance and near-miss data are tracked across jobs to refine well control standards.', 'Snubbing operations are integrated with real-time force monitoring and automated well control decision support.',
    'Ask for the force/buckling calculation of the most recent snubbing job and confirm it was completed before the job proceeded.', 'Snubbing well control procedure; force/buckling calculation; job execution log.', 'Confirm one snubbing job''s well control procedure and force calculation are both on file and consistent with the job executed.', 'Flag if a snubbing job proceeds with no documented force/buckling calculation for the specific well pressure and tubing string.', 3)
  ON CONFLICT (maturity_model_id, process_area) DO NOTHING;

  -- Q16: ofs_l3_5_7_4
  INSERT INTO questions (questionnaire_id, evaluation_type_id, domain_id, process_id,
    question_code, question_text, question_intent, instruction_text, evidence_examples,
    alert_rule_hint, mapped_maturity_model_id, mapped_maturity_statement_id, matched_process_area, sort_order)
  SELECT v_questionnaire_id, v_eval_type_id, v_domain_id, p.id,
    'ofs_l3_5_7_4', 'How mature is the organization''s process for planning and executing workover rig operations with a documented workover program and rig-up verification?', 'Assess whether workover jobs follow a documented program (objectives, procedure, equipment) with a verified rig-up inspection, versus mobilized with no documented plan or pre-job inspection.', 'Review the workover program (objectives, procedure) and the rig-up inspection/verification record for a recent workover job.', 'Workover program document; rig-up inspection checklist; job execution report.',
    'Flag if a workover rig begins operations with no documented rig-up inspection sign-off.', 'ofs_mm_l1_5', 'ofs_l3_5_7_4', 'ofs_l3_5_7_4', 4
  FROM processes p WHERE p.code = 'ofs_l2_5_7';

  INSERT INTO maturity_statements (maturity_model_id, domain_title, process_area,
    level_1_basic, level_2_developing, level_3_established, level_4_advanced, level_5_leading,
    assessor_instruction, evidence_examples, review_steps, alert_rule_hint, sort_order)
  VALUES ('ofs_mm_l1_5', 'Install Production Equipment And Maintain Production', 'ofs_l3_5_7_4',
    'Workover jobs are executed with no documented program or rig-up inspection.', 'A program exists for major jobs but rig-up inspection is inconsistently documented.', 'Every workover job has a documented program and a signed-off rig-up inspection before operations begin.', 'Workover job performance and downtime data are tracked across jobs to refine program planning and rig selection.', 'Workover planning and execution are integrated with a digital rig-management system providing fleet-wide scheduling and performance tracking.',
    'Ask for the rig-up inspection checklist of the most recent workover job and confirm it was signed off before operations began.', 'Workover program document; rig-up inspection checklist; job execution report.', 'Confirm one workover job''s program and rig-up inspection record are both on file and consistent.', 'Flag if a workover rig begins operations with no documented rig-up inspection sign-off.', 4)
  ON CONFLICT (maturity_model_id, process_area) DO NOTHING;

  -- Q17: ofs_l3_5_8_1
  INSERT INTO questions (questionnaire_id, evaluation_type_id, domain_id, process_id,
    question_code, question_text, question_intent, instruction_text, evidence_examples,
    alert_rule_hint, mapped_maturity_model_id, mapped_maturity_statement_id, matched_process_area, sort_order)
  SELECT v_questionnaire_id, v_eval_type_id, v_domain_id, p.id,
    'ofs_l3_5_8_1', 'How mature is the organization''s process for selecting and qualifying corrosion inhibitor chemistries against documented compatibility and performance testing?', 'Assess whether inhibitor selection is based on documented laboratory qualification testing (compatibility, efficacy) for the specific fluid system, versus selected by default with no qualification testing.', 'Review the corrosion inhibitor qualification test report and confirm it addresses the specific fluid system and conditions of the application.', 'Corrosion inhibitor qualification test report; fluid compatibility analysis; vendor technical data sheet.',
    'Flag if a corrosion inhibitor is deployed with no documented qualification testing for the specific fluid system.', 'ofs_mm_l1_5', 'ofs_l3_5_8_1', 'ofs_l3_5_8_1', 1
  FROM processes p WHERE p.code = 'ofs_l2_5_8';

  INSERT INTO maturity_statements (maturity_model_id, domain_title, process_area,
    level_1_basic, level_2_developing, level_3_established, level_4_advanced, level_5_leading,
    assessor_instruction, evidence_examples, review_steps, alert_rule_hint, sort_order)
  VALUES ('ofs_mm_l1_5', 'Install Production Equipment And Maintain Production', 'ofs_l3_5_8_1',
    'Corrosion inhibitors are selected by default with no documented qualification testing.', 'Qualification testing is performed for major applications but is not consistently required before selection.', 'Every corrosion inhibitor selection is supported by documented qualification testing matched to the specific fluid system.', 'Inhibitor performance data is tracked across applications to refine the qualified-product list.', 'Inhibitor selection is optimized through an integrated laboratory-to-field digital qualification and performance-tracking workflow.',
    'Ask for the qualification test report of the corrosion inhibitor currently deployed at a specific well or pipeline segment.', 'Corrosion inhibitor qualification test report; fluid compatibility analysis; vendor technical data sheet.', 'Confirm one deployed inhibitor''s qualification test report is on file and matches the fluid system it is applied to.', 'Flag if a corrosion inhibitor is deployed with no documented qualification testing for the specific fluid system.', 1)
  ON CONFLICT (maturity_model_id, process_area) DO NOTHING;

  -- Q18: ofs_l3_5_8_2
  INSERT INTO questions (questionnaire_id, evaluation_type_id, domain_id, process_id,
    question_code, question_text, question_intent, instruction_text, evidence_examples,
    alert_rule_hint, mapped_maturity_model_id, mapped_maturity_statement_id, matched_process_area, sort_order)
  SELECT v_questionnaire_id, v_eval_type_id, v_domain_id, p.id,
    'ofs_l3_5_8_2', 'How mature is the organization''s process for injecting corrosion inhibitors at verified dosing rates with monitored effectiveness?', 'Assess whether inhibitor injection rates are verified against the design dosing rate and effectiveness is monitored (coupons, corrosion rate trend), versus injected with no verification of actual dose or effectiveness.', 'Review the inhibitor injection system verification (pump calibration, dosing rate record) and the effectiveness monitoring result (coupon or corrosion rate trend).', 'Injection system calibration/dosing record; corrosion coupon or rate trend result; effectiveness review.',
    'Flag if a corrosion monitoring result shows increasing corrosion rate at an inhibitor injection point with no documented review.', 'ofs_mm_l1_5', 'ofs_l3_5_8_2', 'ofs_l3_5_8_2', 2
  FROM processes p WHERE p.code = 'ofs_l2_5_8';

  INSERT INTO maturity_statements (maturity_model_id, domain_title, process_area,
    level_1_basic, level_2_developing, level_3_established, level_4_advanced, level_5_leading,
    assessor_instruction, evidence_examples, review_steps, alert_rule_hint, sort_order)
  VALUES ('ofs_mm_l1_5', 'Install Production Equipment And Maintain Production', 'ofs_l3_5_8_2',
    'Inhibitor injection rates are not verified and effectiveness is not monitored.', 'Injection rates are checked periodically but effectiveness monitoring is inconsistent.', 'Injection rates are verified against design and effectiveness is monitored and reviewed on a defined schedule for every injection point.', 'Injection and effectiveness data are tracked across the field to optimize dosing rates and reduce chemical cost.', 'Corrosion inhibition is managed through an integrated real-time dosing-control and corrosion-monitoring system.',
    'Ask for the most recent effectiveness monitoring result at an inhibitor injection point and confirm the injection rate matches the design dosing rate.', 'Injection system calibration/dosing record; corrosion coupon or rate trend result; effectiveness review.', 'Confirm one injection point''s dosing record and effectiveness monitoring result are both on file and consistent with the design rate.', 'Flag if a corrosion monitoring result shows increasing corrosion rate at an inhibitor injection point with no documented review.', 2)
  ON CONFLICT (maturity_model_id, process_area) DO NOTHING;

  -- Q19: ofs_l3_5_9_1
  INSERT INTO questions (questionnaire_id, evaluation_type_id, domain_id, process_id,
    question_code, question_text, question_intent, instruction_text, evidence_examples,
    alert_rule_hint, mapped_maturity_model_id, mapped_maturity_statement_id, matched_process_area, sort_order)
  SELECT v_questionnaire_id, v_eval_type_id, v_domain_id, p.id,
    'ofs_l3_5_9_1', 'How mature is the organization''s process for planning and coordinating the shut-in of wells or supply points to balance production against downstream capacity or demand?', 'Assess whether shut-in decisions are based on documented capacity/demand analysis with a coordinated plan, versus made informally with no documented rationale.', 'Review the supply/capacity analysis supporting a recent shut-in decision and the coordination plan (notifications, sequencing) for implementing it.', 'Supply/capacity analysis; shut-in coordination plan; shut-in decision record.',
    'Flag if a well or supply point is shut in with no documented rationale or coordination plan.', 'ofs_mm_l1_5', 'ofs_l3_5_9_1', 'ofs_l3_5_9_1', 1
  FROM processes p WHERE p.code = 'ofs_l2_5_9';

  INSERT INTO maturity_statements (maturity_model_id, domain_title, process_area,
    level_1_basic, level_2_developing, level_3_established, level_4_advanced, level_5_leading,
    assessor_instruction, evidence_examples, review_steps, alert_rule_hint, sort_order)
  VALUES ('ofs_mm_l1_5', 'Install Production Equipment And Maintain Production', 'ofs_l3_5_9_1',
    'Shut-in decisions are made informally with no documented analysis or coordination plan.', 'Analysis is performed for major shut-ins but coordination is inconsistently documented.', 'Every shut-in decision is supported by documented capacity/demand analysis and a coordination plan.', 'Shut-in patterns and their production impact are tracked to refine supply-balancing criteria.', 'Supply management is integrated with real-time production and demand forecasting, enabling proactive shut-in/start-up optimization.',
    'Ask for the supply/capacity analysis supporting the most recent shut-in decision and confirm a coordination plan was documented.', 'Supply/capacity analysis; shut-in coordination plan; shut-in decision record.', 'Confirm one shut-in decision''s supporting analysis and coordination plan are both on file and consistent with what was executed.', 'Flag if a well or supply point is shut in with no documented rationale or coordination plan.', 1)
  ON CONFLICT (maturity_model_id, process_area) DO NOTHING;

  -- Q20: ofs_l3_5_9_2
  INSERT INTO questions (questionnaire_id, evaluation_type_id, domain_id, process_id,
    question_code, question_text, question_intent, instruction_text, evidence_examples,
    alert_rule_hint, mapped_maturity_model_id, mapped_maturity_statement_id, matched_process_area, sort_order)
  SELECT v_questionnaire_id, v_eval_type_id, v_domain_id, p.id,
    'ofs_l3_5_9_2', 'How mature is the organization''s process for controlling and verifying production supply rates against allocated targets or nominations?', 'Assess whether actual supply rates are actively monitored and reconciled against allocated targets/nominations with documented corrective action on deviation, versus monitored informally with no reconciliation.', 'Review the supply target/nomination record and the reconciliation of actual delivered volumes against it, including any documented corrective action for deviations.', 'Supply target/nomination record; volume reconciliation report; deviation corrective-action record.',
    'Flag if actual supply volumes deviate significantly from the nomination with no documented corrective action.', 'ofs_mm_l1_5', 'ofs_l3_5_9_2', 'ofs_l3_5_9_2', 2
  FROM processes p WHERE p.code = 'ofs_l2_5_9';

  INSERT INTO maturity_statements (maturity_model_id, domain_title, process_area,
    level_1_basic, level_2_developing, level_3_established, level_4_advanced, level_5_leading,
    assessor_instruction, evidence_examples, review_steps, alert_rule_hint, sort_order)
  VALUES ('ofs_mm_l1_5', 'Install Production Equipment And Maintain Production', 'ofs_l3_5_9_2',
    'Supply rates are not reconciled against targets or nominations.', 'Reconciliation occurs periodically but deviations are inconsistently actioned.', 'Supply rates are reconciled against targets/nominations on a defined schedule, with documented corrective action for deviations.', 'Reconciliation data is analyzed across supply points to improve nomination accuracy and forecasting.', 'Supply control is integrated with real-time production telemetry and automated nomination-reconciliation analytics.',
    'Ask for the most recent volume reconciliation report and confirm any significant deviation from nomination has a documented corrective action.', 'Supply target/nomination record; volume reconciliation report; deviation corrective-action record.', 'Confirm one supply point''s reconciliation report is current and any deviation shown has a documented follow-up action.', 'Flag if actual supply volumes deviate significantly from the nomination with no documented corrective action.', 2)
  ON CONFLICT (maturity_model_id, process_area) DO NOTHING;

  -- Q21: ofs_l3_5_10_1
  INSERT INTO questions (questionnaire_id, evaluation_type_id, domain_id, process_id,
    question_code, question_text, question_intent, instruction_text, evidence_examples,
    alert_rule_hint, mapped_maturity_model_id, mapped_maturity_statement_id, matched_process_area, sort_order)
  SELECT v_questionnaire_id, v_eval_type_id, v_domain_id, p.id,
    'ofs_l3_5_10_1', 'How mature is the organization''s process for designing and specifying compressor packages matched to documented gas composition and throughput requirements?', 'Assess whether compressor package design is based on documented process/gas composition analysis, versus a standard package specified without well- or field-specific engineering.', 'Review the compressor package design specification and the supporting gas composition/throughput analysis for a recent installation.', 'Compressor package design specification; gas composition analysis; throughput/capacity calculation.',
    'Flag if a compressor package is specified with no documented gas composition analysis supporting the design.', 'ofs_mm_l1_5', 'ofs_l3_5_10_1', 'ofs_l3_5_10_1', 1
  FROM processes p WHERE p.code = 'ofs_l2_5_10';

  INSERT INTO maturity_statements (maturity_model_id, domain_title, process_area,
    level_1_basic, level_2_developing, level_3_established, level_4_advanced, level_5_leading,
    assessor_instruction, evidence_examples, review_steps, alert_rule_hint, sort_order)
  VALUES ('ofs_mm_l1_5', 'Install Production Equipment And Maintain Production', 'ofs_l3_5_10_1',
    'Compressor packages are specified by default with no documented gas composition or throughput analysis.', 'Analysis is performed for major installations but is not consistently required before specification.', 'Every compressor package design is documented and supported by gas composition and throughput analysis.', 'Compressor performance data is tracked across the fleet to refine package specification standards.', 'Compressor package design is optimized through an integrated process-simulation and fleet-performance modeling workflow.',
    'Ask for the gas composition/throughput analysis supporting the most recently specified compressor package.', 'Compressor package design specification; gas composition analysis; throughput/capacity calculation.', 'Confirm one compressor package''s design specification references a documented gas composition/throughput analysis.', 'Flag if a compressor package is specified with no documented gas composition analysis supporting the design.', 1)
  ON CONFLICT (maturity_model_id, process_area) DO NOTHING;

  -- Q22: ofs_l3_5_11_1
  INSERT INTO questions (questionnaire_id, evaluation_type_id, domain_id, process_id,
    question_code, question_text, question_intent, instruction_text, evidence_examples,
    alert_rule_hint, mapped_maturity_model_id, mapped_maturity_statement_id, matched_process_area, sort_order)
  SELECT v_questionnaire_id, v_eval_type_id, v_domain_id, p.id,
    'ofs_l3_5_11_1', 'How mature is the organization''s process for designing pipeline integrity monitoring solutions (SCADA, leak detection, corrosion monitoring) matched to pipeline risk?', 'Assess whether monitoring solution design is based on documented risk assessment (consequence of failure, environmental sensitivity), versus a uniform monitoring approach applied regardless of pipeline risk.', 'Review the pipeline risk assessment and the monitoring solution design (SCADA points, leak detection method, corrosion monitoring) matched to that risk profile.', 'Pipeline risk assessment; monitoring solution design document; SCADA/leak-detection specification.',
    'Flag if a high-consequence pipeline segment has no documented monitoring solution matched to its risk assessment.', 'ofs_mm_l1_5', 'ofs_l3_5_11_1', 'ofs_l3_5_11_1', 1
  FROM processes p WHERE p.code = 'ofs_l2_5_11';

  INSERT INTO maturity_statements (maturity_model_id, domain_title, process_area,
    level_1_basic, level_2_developing, level_3_established, level_4_advanced, level_5_leading,
    assessor_instruction, evidence_examples, review_steps, alert_rule_hint, sort_order)
  VALUES ('ofs_mm_l1_5', 'Install Production Equipment And Maintain Production', 'ofs_l3_5_11_1',
    'Monitoring solutions are applied uniformly with no documented risk-based design.', 'A risk assessment exists for major segments but is not consistently linked to the monitoring solution design.', 'Monitoring solution design is documented and matched to a formal risk assessment for every pipeline segment.', 'Monitoring effectiveness and incident data are tracked across the network to refine risk-based monitoring standards.', 'Pipeline monitoring is integrated with real-time analytics and predictive integrity modeling across the network.',
    'Ask for the risk assessment of a high-consequence pipeline segment and confirm the monitoring solution design references it.', 'Pipeline risk assessment; monitoring solution design document; SCADA/leak-detection specification.', 'Confirm one pipeline segment''s risk assessment and monitoring solution design are consistent and both on file.', 'Flag if a high-consequence pipeline segment has no documented monitoring solution matched to its risk assessment.', 1)
  ON CONFLICT (maturity_model_id, process_area) DO NOTHING;

  -- Q23: ofs_l3_5_11_2
  INSERT INTO questions (questionnaire_id, evaluation_type_id, domain_id, process_id,
    question_code, question_text, question_intent, instruction_text, evidence_examples,
    alert_rule_hint, mapped_maturity_model_id, mapped_maturity_statement_id, matched_process_area, sort_order)
  SELECT v_questionnaire_id, v_eval_type_id, v_domain_id, p.id,
    'ofs_l3_5_11_2', 'How mature is the organization''s process for operating and responding to pipeline monitoring systems (SCADA alarms, leak detection alerts) on an ongoing basis?', 'Assess whether monitoring alarms/alerts are managed through a documented response procedure with defined timeframes, versus reviewed informally with no defined response expectations.', 'Review the alarm/alert response procedure and a recent alarm log showing response time and resolution documentation.', 'Alarm/alert response procedure; SCADA alarm log; resolution/close-out record.',
    'Flag if a high-priority pipeline alarm has no documented response within the defined timeframe.', 'ofs_mm_l1_5', 'ofs_l3_5_11_2', 'ofs_l3_5_11_2', 2
  FROM processes p WHERE p.code = 'ofs_l2_5_11';

  INSERT INTO maturity_statements (maturity_model_id, domain_title, process_area,
    level_1_basic, level_2_developing, level_3_established, level_4_advanced, level_5_leading,
    assessor_instruction, evidence_examples, review_steps, alert_rule_hint, sort_order)
  VALUES ('ofs_mm_l1_5', 'Install Production Equipment And Maintain Production', 'ofs_l3_5_11_2',
    'Monitoring alarms are reviewed informally with no documented response procedure or timeframe.', 'A response procedure exists but response times and close-out are inconsistently documented.', 'Every alarm/alert is managed against a documented response procedure with response time and resolution recorded.', 'Alarm response performance is tracked across the network to refine response procedures and reduce false-alarm rates.', 'Pipeline monitoring response is integrated with automated alarm-management and predictive analytics across the network.',
    'Ask for the alarm log of the most recent high-priority pipeline alert and confirm the response time and resolution are documented.', 'Alarm/alert response procedure; SCADA alarm log; resolution/close-out record.', 'Confirm one high-priority alarm''s response time and resolution are documented consistent with the response procedure.', 'Flag if a high-priority pipeline alarm has no documented response within the defined timeframe.', 2)
  ON CONFLICT (maturity_model_id, process_area) DO NOTHING;
END $$;