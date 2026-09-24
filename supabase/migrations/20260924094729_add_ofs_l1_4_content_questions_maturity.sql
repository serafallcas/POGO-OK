/*
# OFS Onshore content batch: Complete The Well (ofs_l1_4)
- 1 maturity_model (ofs_mm_l1_4)
- 29 questions (ofs_l3_4_1_1 through ofs_l3_4_10_4)
- 29 maturity_statements
- Purely additive, ON CONFLICT DO NOTHING for idempotency.
*/
DO $$
DECLARE
  v_questionnaire_id uuid;
  v_eval_type_id uuid;
  v_domain_id uuid;
BEGIN
  SELECT id INTO v_eval_type_id FROM evaluation_types WHERE code = 'ofs_onshore';
  SELECT id INTO v_questionnaire_id FROM questionnaires WHERE code = 'ofs_onshore_questionnaire';
  SELECT id INTO v_domain_id FROM domains WHERE code = 'ofs_l1_4';

  INSERT INTO maturity_models (code, label, description, domain_id, mapped_domain_id, mapped_domain_name, version, source_workbook, is_active)
  VALUES ('ofs_mm_l1_4', 'Complete The Well - Maturity Model', 'OFS Onshore maturity model for Complete The Well', v_domain_id, 'ofs_l1_4', 'Complete The Well', '1.0', 'POGO-OFS_Level_1-3_framework.pptx', true)
  ON CONFLICT (code) DO NOTHING;

  -- Q1: ofs_l3_4_1_1
  INSERT INTO questions (questionnaire_id, evaluation_type_id, domain_id, process_id,
    question_code, question_text, question_intent, instruction_text, evidence_examples,
    alert_rule_hint, mapped_maturity_model_id, mapped_maturity_statement_id, matched_process_area, sort_order)
  SELECT v_questionnaire_id, v_eval_type_id, v_domain_id, p.id,
    'ofs_l3_4_1_1', 'How mature is the organization''s process for designing and selecting the perforating system (gun type, charge, phasing, shot density) matched to the completion objective?', 'Assess whether perforating design is driven by documented reservoir/completion engineering (underbalance/overbalance calculations, charge penetration data) versus a default gun/charge combination used regardless of well conditions.', 'Review the perforating design report (charge type, phasing, shot density, underbalance calculation) and confirm it references the specific well''s reservoir and completion parameters.', 'Perforating design report; charge penetration/API RP 19B data sheet; underbalance/overbalance calculation; job execution ticket.',
    'Flag if a perforating job proceeds with no documented underbalance/overbalance calculation for the specific well.', 'ofs_mm_l1_4', 'ofs_l3_4_1_1', 'ofs_l3_4_1_1', 1
  FROM processes p WHERE p.code = 'ofs_l2_4_1';

  INSERT INTO maturity_statements (maturity_model_id, domain_title, process_area,
    level_1_basic, level_2_developing, level_3_established, level_4_advanced, level_5_leading,
    assessor_instruction, evidence_examples, review_steps, alert_rule_hint, sort_order)
  VALUES ('ofs_mm_l1_4', 'Complete The Well', 'ofs_l3_4_1_1',
    'Perforating gun and charge selection is made by default with no documented design or calculation.', 'A design exists for major wells but underbalance calculations are inconsistently documented.', 'Every perforating job has a documented design (charge, phasing, shot density) with a supporting underbalance/overbalance calculation.', 'Perforating job performance (skin, productivity index) is tracked across wells to refine charge and phasing standards.', 'Perforating design is optimized through an integrated reservoir-to-completion modeling workflow, continuously calibrated against post-job production data.',
    'Ask for the underbalance/overbalance calculation of the most recent perforating job and confirm it was completed before the job was executed.', 'Perforating design report; charge penetration/API RP 19B data sheet; underbalance/overbalance calculation; job execution ticket.', 'Trace one perforating job from its design report through the underbalance calculation to the job execution ticket.', 'Flag if a perforating job proceeds with no documented underbalance/overbalance calculation for the specific well.', 1)
  ON CONFLICT (maturity_model_id, process_area) DO NOTHING;

  -- Q2: ofs_l3_4_1_2
  INSERT INTO questions (questionnaire_id, evaluation_type_id, domain_id, process_id,
    question_code, question_text, question_intent, instruction_text, evidence_examples,
    alert_rule_hint, mapped_maturity_model_id, mapped_maturity_statement_id, matched_process_area, sort_order)
  SELECT v_questionnaire_id, v_eval_type_id, v_domain_id, p.id,
    'ofs_l3_4_1_2', 'How mature is the organization''s process for cleaning the perforation tunnels and near-wellbore flow path after perforating (e.g., surge flow, chemical wash)?', 'Assess whether flow-path cleanup is a planned, verified step (documented surge/flowback procedure with confirmation of debris/fluid recovery) versus assumed to occur without verification.', 'Review the flow-path cleanup procedure (surge design or chemical treatment plan) and the post-cleanup verification record (returns volume, debris recovery, or production test).', 'Flow-path cleanup/surge procedure; returns/debris recovery log; post-cleanup production or injectivity test.',
    'Flag if the well proceeds to the next completion stage with no documented verification that the flow path was cleaned.', 'ofs_mm_l1_4', 'ofs_l3_4_1_2', 'ofs_l3_4_1_2', 2
  FROM processes p WHERE p.code = 'ofs_l2_4_1';

  INSERT INTO maturity_statements (maturity_model_id, domain_title, process_area,
    level_1_basic, level_2_developing, level_3_established, level_4_advanced, level_5_leading,
    assessor_instruction, evidence_examples, review_steps, alert_rule_hint, sort_order)
  VALUES ('ofs_mm_l1_4', 'Complete The Well', 'ofs_l3_4_1_2',
    'Flow-path cleanup is not planned or verified; the well proceeds regardless of debris or fluid recovery.', 'A cleanup step is performed but verification of its effectiveness is inconsistently documented.', 'Flow-path cleanup follows a documented procedure with verified debris/fluid recovery before proceeding.', 'Cleanup effectiveness is tracked across wells (e.g., injectivity improvement) to refine surge/wash design.', 'Flow-path cleanup design is integrated with real-time downhole diagnostics, optimized continuously across the completion program.',
    'Ask for the returns/debris recovery record of the most recent perforating job and confirm it was reviewed before proceeding to the next stage.', 'Flow-path cleanup/surge procedure; returns/debris recovery log; post-cleanup production or injectivity test.', 'Confirm one well''s flow-path cleanup procedure and its verification record are both on file and consistent.', 'Flag if the well proceeds to the next completion stage with no documented verification that the flow path was cleaned.', 2)
  ON CONFLICT (maturity_model_id, process_area) DO NOTHING;

  -- Q3: ofs_l3_4_1_3
  INSERT INTO questions (questionnaire_id, evaluation_type_id, domain_id, process_id,
    question_code, question_text, question_intent, instruction_text, evidence_examples,
    alert_rule_hint, mapped_maturity_model_id, mapped_maturity_statement_id, matched_process_area, sort_order)
  SELECT v_questionnaire_id, v_eval_type_id, v_domain_id, p.id,
    'ofs_l3_4_1_3', 'How mature is the organization''s process for ongoing monitoring of the completion flow path (perforations, sand control, tubing) for degradation over the well''s producing life?', 'Assess whether flow-path integrity is monitored on a defined schedule (production logging, sand production tracking, pressure surveys) versus only investigated after a failure or production decline is already severe.', 'Review the flow-path monitoring schedule/program and recent monitoring results (production logs, sand counts, pressure surveys) for an active well.', 'Flow-path monitoring program; production/sand log; pressure survey results; trend report.',
    'Flag if a well shows a documented production anomaly with no corresponding flow-path monitoring investigation.', 'ofs_mm_l1_4', 'ofs_l3_4_1_3', 'ofs_l3_4_1_3', 3
  FROM processes p WHERE p.code = 'ofs_l2_4_1';

  INSERT INTO maturity_statements (maturity_model_id, domain_title, process_area,
    level_1_basic, level_2_developing, level_3_established, level_4_advanced, level_5_leading,
    assessor_instruction, evidence_examples, review_steps, alert_rule_hint, sort_order)
  VALUES ('ofs_mm_l1_4', 'Complete The Well', 'ofs_l3_4_1_3',
    'Flow-path condition is not monitored; issues are addressed only after a significant failure occurs.', 'Monitoring occurs periodically but is not scheduled or systematically reviewed.', 'Flow-path monitoring follows a documented schedule with results reviewed and trended for every well.', 'Monitoring data across wells is analyzed to predict flow-path degradation and plan proactive intervention.', 'Flow-path condition is monitored through integrated real-time surveillance, triggering automated intervention recommendations.',
    'Ask for the most recent flow-path monitoring result for an active well and confirm it was reviewed against the monitoring schedule.', 'Flow-path monitoring program; production/sand log; pressure survey results; trend report.', 'Confirm one well''s flow-path monitoring schedule is current and its latest result was reviewed and actioned if needed.', 'Flag if a well shows a documented production anomaly with no corresponding flow-path monitoring investigation.', 3)
  ON CONFLICT (maturity_model_id, process_area) DO NOTHING;

  -- Q4: ofs_l3_4_2_1
  INSERT INTO questions (questionnaire_id, evaluation_type_id, domain_id, process_id,
    question_code, question_text, question_intent, instruction_text, evidence_examples,
    alert_rule_hint, mapped_maturity_model_id, mapped_maturity_statement_id, matched_process_area, sort_order)
  SELECT v_questionnaire_id, v_eval_type_id, v_domain_id, p.id,
    'ofs_l3_4_2_1', 'How mature is the organization''s process for designing sand control completions (gravel pack, screen, frac-pack) matched to formation characteristics?', 'Assess whether sand control design is based on documented formation sand analysis (grain size distribution, sieve testing) versus a standard screen/gravel specification applied regardless of formation.', 'Review the sand control design report, the supporting sieve analysis/formation sand study, and the screen/gravel specification selected.', 'Sand control design report; sieve/grain-size analysis; screen and gravel specification.',
    'Flag if a sand control completion is designed with no documented sieve analysis for the specific formation interval.', 'ofs_mm_l1_4', 'ofs_l3_4_2_1', 'ofs_l3_4_2_1', 1
  FROM processes p WHERE p.code = 'ofs_l2_4_2';

  INSERT INTO maturity_statements (maturity_model_id, domain_title, process_area,
    level_1_basic, level_2_developing, level_3_established, level_4_advanced, level_5_leading,
    assessor_instruction, evidence_examples, review_steps, alert_rule_hint, sort_order)
  VALUES ('ofs_mm_l1_4', 'Complete The Well', 'ofs_l3_4_2_1',
    'Sand control design uses a default screen/gravel specification with no formation-specific analysis.', 'Sieve analysis is performed for major wells but is not consistently linked to the final design.', 'Sand control design is documented and directly informed by sieve/grain-size analysis for every well.', 'Sand control performance (sand production, screen erosion) is tracked across wells to refine design standards.', 'Sand control design is optimized through an integrated formation-characterization and completion-modeling workflow across the asset.',
    'Ask for the sieve analysis supporting the most recent sand control design and confirm the screen/gravel specification matches its results.', 'Sand control design report; sieve/grain-size analysis; screen and gravel specification.', 'Confirm one well''s sand control design report references its specific sieve analysis results.', 'Flag if a sand control completion is designed with no documented sieve analysis for the specific formation interval.', 1)
  ON CONFLICT (maturity_model_id, process_area) DO NOTHING;

  -- Q5: ofs_l3_4_2_2
  INSERT INTO questions (questionnaire_id, evaluation_type_id, domain_id, process_id,
    question_code, question_text, question_intent, instruction_text, evidence_examples,
    alert_rule_hint, mapped_maturity_model_id, mapped_maturity_statement_id, matched_process_area, sort_order)
  SELECT v_questionnaire_id, v_eval_type_id, v_domain_id, p.id,
    'ofs_l3_4_2_2', 'How mature is the organization''s process for installing sand control equipment (running screens, placing gravel pack) with verification of correct placement?', 'Assess whether installation follows a documented running procedure with real-time placement verification (pressure/volume monitoring, tag depth confirmation) versus run with no confirmation of a complete pack.', 'Review the sand control installation procedure, the real-time placement monitoring record (pump pressures, volumes, screen-out indicators), and post-installation depth/tag confirmation.', 'Installation/running procedure; real-time placement monitoring log; post-installation tag/depth confirmation.',
    'Flag if a gravel pack job shows a premature screen-out with no documented follow-up assessment.', 'ofs_mm_l1_4', 'ofs_l3_4_2_2', 'ofs_l3_4_2_2', 2
  FROM processes p WHERE p.code = 'ofs_l2_4_2';

  INSERT INTO maturity_statements (maturity_model_id, domain_title, process_area,
    level_1_basic, level_2_developing, level_3_established, level_4_advanced, level_5_leading,
    assessor_instruction, evidence_examples, review_steps, alert_rule_hint, sort_order)
  VALUES ('ofs_mm_l1_4', 'Complete The Well', 'ofs_l3_4_2_2',
    'Sand control is installed without a documented procedure or placement verification.', 'A procedure exists but real-time placement monitoring is inconsistently recorded or reviewed.', 'Installation follows a documented procedure with real-time monitoring and confirmed placement for every job.', 'Installation performance (pack efficiency, screen-out rate) is tracked across wells to refine running procedures.', 'Sand control installation is integrated with real-time digital placement modeling, continuously optimized across the completion program.',
    'Ask for the real-time placement monitoring log of the most recent sand control installation and confirm it shows a complete pack was achieved.', 'Installation/running procedure; real-time placement monitoring log; post-installation tag/depth confirmation.', 'Confirm one sand control installation''s monitoring log and post-job depth confirmation are consistent with a complete pack.', 'Flag if a gravel pack job shows a premature screen-out with no documented follow-up assessment.', 2)
  ON CONFLICT (maturity_model_id, process_area) DO NOTHING;

  -- Q6: ofs_l3_4_2_3
  INSERT INTO questions (questionnaire_id, evaluation_type_id, domain_id, process_id,
    question_code, question_text, question_intent, instruction_text, evidence_examples,
    alert_rule_hint, mapped_maturity_model_id, mapped_maturity_statement_id, matched_process_area, sort_order)
  SELECT v_questionnaire_id, v_eval_type_id, v_domain_id, p.id,
    'ofs_l3_4_2_3', 'How mature is the organization''s process for post-installation evaluation of sand control effectiveness (production logging, sand monitoring)?', 'Assess whether sand control effectiveness is formally evaluated after installation and tied back to design assumptions, versus assumed effective with no follow-up.', 'Review the post-installation evaluation method (production log, sand sampling, differential pressure trend) and confirm results are compared against the original design assumptions.', 'Post-installation evaluation report; production/sand log; design-versus-actual comparison note.',
    'Flag if sand production is reported by operations with no documented post-installation evaluation on file.', 'ofs_mm_l1_4', 'ofs_l3_4_2_3', 'ofs_l3_4_2_3', 3
  FROM processes p WHERE p.code = 'ofs_l2_4_2';

  INSERT INTO maturity_statements (maturity_model_id, domain_title, process_area,
    level_1_basic, level_2_developing, level_3_established, level_4_advanced, level_5_leading,
    assessor_instruction, evidence_examples, review_steps, alert_rule_hint, sort_order)
  VALUES ('ofs_mm_l1_4', 'Complete The Well', 'ofs_l3_4_2_3',
    'Sand control effectiveness is not evaluated after installation.', 'Evaluation occurs for some wells but is not consistently compared against design assumptions.', 'Every sand control installation has a documented post-installation evaluation compared against design assumptions.', 'Evaluation results are aggregated across wells to validate and refine sand control design standards.', 'Sand control evaluation is continuous and automated, feeding directly back into a live design-optimization model.',
    'Ask for the post-installation evaluation of the most recently completed sand control job and confirm it was compared against the design assumptions.', 'Post-installation evaluation report; production/sand log; design-versus-actual comparison note.', 'Confirm one well''s post-installation sand control evaluation is on file and references the original design.', 'Flag if sand production is reported by operations with no documented post-installation evaluation on file.', 3)
  ON CONFLICT (maturity_model_id, process_area) DO NOTHING;

  -- Q7: ofs_l3_4_3_1
  INSERT INTO questions (questionnaire_id, evaluation_type_id, domain_id, process_id,
    question_code, question_text, question_intent, instruction_text, evidence_examples,
    alert_rule_hint, mapped_maturity_model_id, mapped_maturity_statement_id, matched_process_area, sort_order)
  SELECT v_questionnaire_id, v_eval_type_id, v_domain_id, p.id,
    'ofs_l3_4_3_1', 'How mature is the organization''s process for running production/completion casing strings with documented design and running verification?', 'Assess whether casing running follows an engineered design (load case analysis, centralization program) with a documented running record, versus run informally with no design traceability.', 'Review the casing design report (load cases, centralization program) and the running record (torque/drag, depth confirmation) for the production/completion string.', 'Casing design/load-case report; centralization program; casing running record.',
    'Flag if a casing string is run with no documented design or centralization program on file.', 'ofs_mm_l1_4', 'ofs_l3_4_3_1', 'ofs_l3_4_3_1', 1
  FROM processes p WHERE p.code = 'ofs_l2_4_3';

  INSERT INTO maturity_statements (maturity_model_id, domain_title, process_area,
    level_1_basic, level_2_developing, level_3_established, level_4_advanced, level_5_leading,
    assessor_instruction, evidence_examples, review_steps, alert_rule_hint, sort_order)
  VALUES ('ofs_mm_l1_4', 'Complete The Well', 'ofs_l3_4_3_1',
    'Casing is run without a documented design or running record.', 'A design exists but the running record is inconsistently completed or retained.', 'Every casing string has a documented design and a complete running record confirming depth and centralization.', 'Running performance (torque/drag versus prediction) is tracked across wells to refine casing design models.', 'Casing design and running are integrated with real-time torque/drag simulation, continuously calibrated across the well program.',
    'Ask for the running record of the most recently run production casing string and confirm it matches the documented design.', 'Casing design/load-case report; centralization program; casing running record.', 'Confirm one casing string''s design report and running record are both on file and consistent with each other.', 'Flag if a casing string is run with no documented design or centralization program on file.', 1)
  ON CONFLICT (maturity_model_id, process_area) DO NOTHING;

  -- Q8: ofs_l3_4_3_2
  INSERT INTO questions (questionnaire_id, evaluation_type_id, domain_id, process_id,
    question_code, question_text, question_intent, instruction_text, evidence_examples,
    alert_rule_hint, mapped_maturity_model_id, mapped_maturity_statement_id, matched_process_area, sort_order)
  SELECT v_questionnaire_id, v_eval_type_id, v_domain_id, p.id,
    'ofs_l3_4_3_2', 'How mature is the organization''s process for running production tubing with documented design (grade, connection, accessories) and running verification?', 'Assess whether tubing design accounts for well-specific loads (pressure, temperature, corrosion) and is verified during running, versus a standard tubing string used regardless of well conditions.', 'Review the tubing design report (grade, connection rating, accessory placement) and the running record including space-out and landing confirmation.', 'Tubing design report; tubing tally/running record; landing/space-out confirmation.',
    'Flag if production tubing is run with no documented design addressing the well''s specific pressure, temperature or corrosion conditions.', 'ofs_mm_l1_4', 'ofs_l3_4_3_2', 'ofs_l3_4_3_2', 2
  FROM processes p WHERE p.code = 'ofs_l2_4_3';

  INSERT INTO maturity_statements (maturity_model_id, domain_title, process_area,
    level_1_basic, level_2_developing, level_3_established, level_4_advanced, level_5_leading,
    assessor_instruction, evidence_examples, review_steps, alert_rule_hint, sort_order)
  VALUES ('ofs_mm_l1_4', 'Complete The Well', 'ofs_l3_4_3_2',
    'Production tubing is selected and run with no documented design rationale.', 'A design exists but running verification (tally, space-out) is inconsistently documented.', 'Tubing design addresses well-specific conditions and every run has a complete, verified tally and landing record.', 'Tubing performance and failure data are tracked across wells to refine grade and connection selection.', 'Tubing design is optimized through an integrated well-integrity and materials-performance model across the asset.',
    'Ask for the tubing running record of the most recent completion and confirm the landing depth matches the design.', 'Tubing design report; tubing tally/running record; landing/space-out confirmation.', 'Confirm one well''s tubing design report and running/tally record are consistent and both on file.', 'Flag if production tubing is run with no documented design addressing the well''s specific pressure, temperature or corrosion conditions.', 2)
  ON CONFLICT (maturity_model_id, process_area) DO NOTHING;

  -- Q9: ofs_l3_4_3_3
  INSERT INTO questions (questionnaire_id, evaluation_type_id, domain_id, process_id,
    question_code, question_text, question_intent, instruction_text, evidence_examples,
    alert_rule_hint, mapped_maturity_model_id, mapped_maturity_statement_id, matched_process_area, sort_order)
  SELECT v_questionnaire_id, v_eval_type_id, v_domain_id, p.id,
    'ofs_l3_4_3_3', 'How mature is the organization''s process for selecting, tracking and verifying the installation of downhole completion tools (packers, safety valves, sliding sleeves)?', 'Assess whether downhole tool selection and installation are documented and function-tested, versus installed with no verification that they are set or operating correctly.', 'Review the downhole tool selection/specification, the installation/setting record, and the function or pressure test confirming correct operation.', 'Downhole tool specification; setting/installation record; function or pressure test result.',
    'Flag if a downhole safety-critical tool (e.g., subsurface safety valve) has no documented function test after installation.', 'ofs_mm_l1_4', 'ofs_l3_4_3_3', 'ofs_l3_4_3_3', 3
  FROM processes p WHERE p.code = 'ofs_l2_4_3';

  INSERT INTO maturity_statements (maturity_model_id, domain_title, process_area,
    level_1_basic, level_2_developing, level_3_established, level_4_advanced, level_5_leading,
    assessor_instruction, evidence_examples, review_steps, alert_rule_hint, sort_order)
  VALUES ('ofs_mm_l1_4', 'Complete The Well', 'ofs_l3_4_3_3',
    'Downhole tools are installed with no documented specification or post-installation verification.', 'A specification exists but function/pressure testing after installation is inconsistent.', 'Every downhole tool has a documented specification and a verified function/pressure test confirming correct operation.', 'Tool performance and failure data are tracked across wells to refine selection and setting procedures.', 'Downhole tool selection and verification are integrated with a digital well-completion register, enabling fleet-wide reliability tracking.',
    'Ask for the function/pressure test result of the safety-critical downhole tool in the most recently completed well.', 'Downhole tool specification; setting/installation record; function or pressure test result.', 'Confirm one well''s downhole tool specification and its post-installation function test are both on file and consistent.', 'Flag if a downhole safety-critical tool (e.g., subsurface safety valve) has no documented function test after installation.', 3)
  ON CONFLICT (maturity_model_id, process_area) DO NOTHING;

  -- Q10: ofs_l3_4_4_1
  INSERT INTO questions (questionnaire_id, evaluation_type_id, domain_id, process_id,
    question_code, question_text, question_intent, instruction_text, evidence_examples,
    alert_rule_hint, mapped_maturity_model_id, mapped_maturity_statement_id, matched_process_area, sort_order)
  SELECT v_questionnaire_id, v_eval_type_id, v_domain_id, p.id,
    'ofs_l3_4_4_1', 'How mature is the organization''s process for establishing and maintaining a well integrity management system across the completion and producing life of the well?', 'Assess whether well integrity is managed through a documented barrier philosophy and status tracking system, versus addressed reactively when a problem is observed.', 'Review the well integrity management procedure, the documented barrier diagram/status for a specific well, and evidence that barrier status is actively tracked.', 'Well integrity management procedure; barrier diagram and status register; well integrity status report.',
    'Flag if a well''s barrier status register has not been updated within the defined review interval.', 'ofs_mm_l1_4', 'ofs_l3_4_4_1', 'ofs_l3_4_4_1', 1
  FROM processes p WHERE p.code = 'ofs_l2_4_4';

  INSERT INTO maturity_statements (maturity_model_id, domain_title, process_area,
    level_1_basic, level_2_developing, level_3_established, level_4_advanced, level_5_leading,
    assessor_instruction, evidence_examples, review_steps, alert_rule_hint, sort_order)
  VALUES ('ofs_mm_l1_4', 'Complete The Well', 'ofs_l3_4_4_1',
    'Well integrity is not formally managed; issues are addressed only when a failure is observed.', 'A barrier diagram exists but status tracking is inconsistent or out of date.', 'Every well has a documented, current barrier diagram and status register reviewed on a defined interval.', 'Well integrity status is aggregated across the well portfolio to identify systemic risks and prioritize action.', 'Well integrity management is integrated with real-time barrier-status monitoring and predictive analytics across the asset.',
    'Ask for the current barrier diagram/status register of a specific well and confirm it was last reviewed within the defined interval.', 'Well integrity management procedure; barrier diagram and status register; well integrity status report.', 'Confirm one well''s barrier diagram and status register are current and consistent with the well integrity management procedure.', 'Flag if a well''s barrier status register has not been updated within the defined review interval.', 1)
  ON CONFLICT (maturity_model_id, process_area) DO NOTHING;

  -- Q11: ofs_l3_4_4_2
  INSERT INTO questions (questionnaire_id, evaluation_type_id, domain_id, process_id,
    question_code, question_text, question_intent, instruction_text, evidence_examples,
    alert_rule_hint, mapped_maturity_model_id, mapped_maturity_statement_id, matched_process_area, sort_order)
  SELECT v_questionnaire_id, v_eval_type_id, v_domain_id, p.id,
    'ofs_l3_4_4_2', 'How mature is the organization''s process for testing and verifying well integrity barriers (pressure tests, valve function tests) on a defined schedule?', 'Assess whether barrier testing follows a documented schedule with pass/fail criteria and recorded results, versus performed informally with no traceable record.', 'Review the barrier test schedule/procedure and the most recent test results (pressure test charts, valve function test records) for a specific well.', 'Barrier test schedule/procedure; pressure test chart; valve function test record.',
    'Flag if a well is overdue for a scheduled barrier test with no documented deferral approval.', 'ofs_mm_l1_4', 'ofs_l3_4_4_2', 'ofs_l3_4_4_2', 2
  FROM processes p WHERE p.code = 'ofs_l2_4_4';

  INSERT INTO maturity_statements (maturity_model_id, domain_title, process_area,
    level_1_basic, level_2_developing, level_3_established, level_4_advanced, level_5_leading,
    assessor_instruction, evidence_examples, review_steps, alert_rule_hint, sort_order)
  VALUES ('ofs_mm_l1_4', 'Complete The Well', 'ofs_l3_4_4_2',
    'Barrier testing is performed informally with no documented schedule or recorded results.', 'A test schedule exists but results are inconsistently recorded or reviewed against pass/fail criteria.', 'Barrier testing follows a documented schedule with recorded results and pass/fail determination for every well.', 'Barrier test trends are analyzed across wells to identify degrading components and adjust test intervals.', 'Barrier testing is integrated with automated scheduling and real-time result capture across the well portfolio.',
    'Ask for the most recent barrier test result of a specific well and confirm it was completed within the scheduled interval with a documented pass/fail outcome.', 'Barrier test schedule/procedure; pressure test chart; valve function test record.', 'Confirm one well''s barrier test schedule and its most recent recorded result are consistent and current.', 'Flag if a well is overdue for a scheduled barrier test with no documented deferral approval.', 2)
  ON CONFLICT (maturity_model_id, process_area) DO NOTHING;

  -- Q12: ofs_l3_4_4_3
  INSERT INTO questions (questionnaire_id, evaluation_type_id, domain_id, process_id,
    question_code, question_text, question_intent, instruction_text, evidence_examples,
    alert_rule_hint, mapped_maturity_model_id, mapped_maturity_statement_id, matched_process_area, sort_order)
  SELECT v_questionnaire_id, v_eval_type_id, v_domain_id, p.id,
    'ofs_l3_4_4_3', 'How mature is the organization''s process for demonstrating well integrity compliance against regulatory and internal standards?', 'Assess whether compliance status is actively tracked and reportable against specific regulatory/internal requirements, versus assumed compliant with no documented evidence trail.', 'Review the well integrity compliance register/status report and confirm it references the specific regulatory or internal standard each well is being assessed against.', 'Well integrity compliance register; regulatory/internal standard reference; compliance status report.',
    'Flag if a well''s compliance register shows a non-compliant status with no documented corrective action.', 'ofs_mm_l1_4', 'ofs_l3_4_4_3', 'ofs_l3_4_4_3', 3
  FROM processes p WHERE p.code = 'ofs_l2_4_4';

  INSERT INTO maturity_statements (maturity_model_id, domain_title, process_area,
    level_1_basic, level_2_developing, level_3_established, level_4_advanced, level_5_leading,
    assessor_instruction, evidence_examples, review_steps, alert_rule_hint, sort_order)
  VALUES ('ofs_mm_l1_4', 'Complete The Well', 'ofs_l3_4_4_3',
    'Well integrity compliance is not tracked against any documented standard.', 'A compliance register exists but is not consistently updated or linked to specific standards.', 'Well integrity compliance is tracked per well against defined standards, with corrective actions documented for non-compliance.', 'Compliance trends are analyzed across the well portfolio to anticipate and prevent recurring non-compliance.', 'Well integrity compliance is managed through an integrated regulatory-tracking system with automated status reporting across the asset.',
    'Ask for the compliance register entry of a specific well and confirm any non-compliant item has a documented corrective action.', 'Well integrity compliance register; regulatory/internal standard reference; compliance status report.', 'Confirm one well''s compliance register entry references a specific standard and, if non-compliant, shows a documented corrective action.', 'Flag if a well''s compliance register shows a non-compliant status with no documented corrective action.', 3)
  ON CONFLICT (maturity_model_id, process_area) DO NOTHING;

  -- Q13: ofs_l3_4_5_1
  INSERT INTO questions (questionnaire_id, evaluation_type_id, domain_id, process_id,
    question_code, question_text, question_intent, instruction_text, evidence_examples,
    alert_rule_hint, mapped_maturity_model_id, mapped_maturity_statement_id, matched_process_area, sort_order)
  SELECT v_questionnaire_id, v_eval_type_id, v_domain_id, p.id,
    'ofs_l3_4_5_1', 'How mature is the organization''s process for managing the disposal of oilfield produced/completion water in compliance with permits and environmental requirements?', 'Assess whether water disposal is tracked against specific permit limits (volume, quality) with documented records, versus disposed of with no permit traceability.', 'Review the water disposal permit(s), the disposal volume/quality tracking log, and evidence of compliance against permit limits.', 'Water disposal permit; disposal volume/quality log; permit compliance report.',
    'Flag if disposal volumes for a period exceed the permitted limit with no documented notification or corrective action.', 'ofs_mm_l1_4', 'ofs_l3_4_5_1', 'ofs_l3_4_5_1', 1
  FROM processes p WHERE p.code = 'ofs_l2_4_5';

  INSERT INTO maturity_statements (maturity_model_id, domain_title, process_area,
    level_1_basic, level_2_developing, level_3_established, level_4_advanced, level_5_leading,
    assessor_instruction, evidence_examples, review_steps, alert_rule_hint, sort_order)
  VALUES ('ofs_mm_l1_4', 'Complete The Well', 'ofs_l3_4_5_1',
    'Water disposal occurs with no documented permit tracking or volume/quality records.', 'A permit exists but volume/quality tracking against its limits is inconsistent.', 'Disposal volumes and quality are tracked against permit limits for every disposal point, with documented compliance review.', 'Disposal data is analyzed across sites to optimize disposal capacity planning and reduce compliance risk.', 'Water disposal is managed through an integrated real-time monitoring system linked directly to regulatory reporting.',
    'Ask for the most recent disposal volume/quality record for a specific disposal point and confirm it is within the permitted limit.', 'Water disposal permit; disposal volume/quality log; permit compliance report.', 'Confirm one disposal point''s permit and its most recent volume/quality record are consistent and within limits.', 'Flag if disposal volumes for a period exceed the permitted limit with no documented notification or corrective action.', 1)
  ON CONFLICT (maturity_model_id, process_area) DO NOTHING;

  -- Q14: ofs_l3_4_5_2
  INSERT INTO questions (questionnaire_id, evaluation_type_id, domain_id, process_id,
    question_code, question_text, question_intent, instruction_text, evidence_examples,
    alert_rule_hint, mapped_maturity_model_id, mapped_maturity_statement_id, matched_process_area, sort_order)
  SELECT v_questionnaire_id, v_eval_type_id, v_domain_id, p.id,
    'ofs_l3_4_5_2', 'How mature is the organization''s process for selecting and applying water treatment technologies (filtration, chemical treatment) to meet reuse or disposal quality requirements?', 'Assess whether treatment technology selection is based on documented water quality analysis and target specification, versus a default treatment applied regardless of source water characteristics.', 'Review the water quality analysis, the treatment technology selection rationale, and the post-treatment quality verification against the target specification.', 'Source water quality analysis; treatment technology selection rationale; post-treatment quality test result.',
    'Flag if treated water is reused or disposed of with no documented post-treatment quality verification against the target specification.', 'ofs_mm_l1_4', 'ofs_l3_4_5_2', 'ofs_l3_4_5_2', 2
  FROM processes p WHERE p.code = 'ofs_l2_4_5';

  INSERT INTO maturity_statements (maturity_model_id, domain_title, process_area,
    level_1_basic, level_2_developing, level_3_established, level_4_advanced, level_5_leading,
    assessor_instruction, evidence_examples, review_steps, alert_rule_hint, sort_order)
  VALUES ('ofs_mm_l1_4', 'Complete The Well', 'ofs_l3_4_5_2',
    'Treatment technology is applied with no documented water quality analysis or target specification.', 'A target specification exists but post-treatment verification is inconsistently performed.', 'Treatment technology selection is based on documented water quality analysis, with post-treatment quality verified against target specification every time.', 'Treatment performance data is tracked across sites to optimize technology selection and reduce treatment cost.', 'Water treatment is managed through an integrated real-time quality-monitoring and technology-optimization system across the operation.',
    'Ask for the post-treatment quality test result of the most recent batch and confirm it was compared against the target specification.', 'Source water quality analysis; treatment technology selection rationale; post-treatment quality test result.', 'Confirm one treatment batch''s source water analysis, technology selection rationale and post-treatment verification are all on file and consistent.', 'Flag if treated water is reused or disposed of with no documented post-treatment quality verification against the target specification.', 2)
  ON CONFLICT (maturity_model_id, process_area) DO NOTHING;

  -- Q15: ofs_l3_4_6_1
  INSERT INTO questions (questionnaire_id, evaluation_type_id, domain_id, process_id,
    question_code, question_text, question_intent, instruction_text, evidence_examples,
    alert_rule_hint, mapped_maturity_model_id, mapped_maturity_statement_id, matched_process_area, sort_order)
  SELECT v_questionnaire_id, v_eval_type_id, v_domain_id, p.id,
    'ofs_l3_4_6_1', 'How mature is the organization''s process for executing the completion-phase cementing program (production casing/liner cement) against a documented design?', 'Assess whether completion cementing execution is tracked against the specific well''s cement design (slurry volume, placement plan) with documented job records, versus executed as a routine step with no traceability to design.', 'Review the completion cementing design and the job execution record (pumped volumes, pressures, returns) confirming it matches the design.', 'Completion cementing design; job execution record; post-job design-versus-actual comparison.',
    'Flag if actual pumped cement volume deviates significantly from the design with no documented explanation.', 'ofs_mm_l1_4', 'ofs_l3_4_6_1', 'ofs_l3_4_6_1', 1
  FROM processes p WHERE p.code = 'ofs_l2_4_6';

  INSERT INTO maturity_statements (maturity_model_id, domain_title, process_area,
    level_1_basic, level_2_developing, level_3_established, level_4_advanced, level_5_leading,
    assessor_instruction, evidence_examples, review_steps, alert_rule_hint, sort_order)
  VALUES ('ofs_mm_l1_4', 'Complete The Well', 'ofs_l3_4_6_1',
    'Completion cementing is executed with no documented design or job execution record.', 'A design exists but the job execution record is inconsistently compared against it.', 'Every completion cement job has a documented design and a job execution record confirming actual-versus-design comparison.', 'Cement job performance is tracked across wells to refine slurry design and placement planning.', 'Completion cementing is integrated with real-time placement simulation and automated design-versus-actual analytics.',
    'Ask for the job execution record of the most recent completion cement job and confirm it was compared against the original design.', 'Completion cementing design; job execution record; post-job design-versus-actual comparison.', 'Confirm one completion cement job''s design and execution record are consistent, with any deviation documented.', 'Flag if actual pumped cement volume deviates significantly from the design with no documented explanation.', 1)
  ON CONFLICT (maturity_model_id, process_area) DO NOTHING;

  -- Q16: ofs_l3_4_6_2
  INSERT INTO questions (questionnaire_id, evaluation_type_id, domain_id, process_id,
    question_code, question_text, question_intent, instruction_text, evidence_examples,
    alert_rule_hint, mapped_maturity_model_id, mapped_maturity_statement_id, matched_process_area, sort_order)
  SELECT v_questionnaire_id, v_eval_type_id, v_domain_id, p.id,
    'ofs_l3_4_6_2', 'How mature is the organization''s process for mixing cement slurry to verified density and rheological properties before pumping?', 'Assess whether slurry mixing includes real-time density/rheology verification against the design, versus mixed by fixed recipe with no verification during the job.', 'Review the cement mixing procedure and the real-time density/rheology verification log (e.g., pressurized densitometer readings) for a recent job.', 'Cement mixing procedure; real-time density/rheology log; slurry lab test report.',
    'Flag if a cement job proceeds with slurry density readings outside the design tolerance and no documented corrective action.', 'ofs_mm_l1_4', 'ofs_l3_4_6_2', 'ofs_l3_4_6_2', 2
  FROM processes p WHERE p.code = 'ofs_l2_4_6';

  INSERT INTO maturity_statements (maturity_model_id, domain_title, process_area,
    level_1_basic, level_2_developing, level_3_established, level_4_advanced, level_5_leading,
    assessor_instruction, evidence_examples, review_steps, alert_rule_hint, sort_order)
  VALUES ('ofs_mm_l1_4', 'Complete The Well', 'ofs_l3_4_6_2',
    'Cement is mixed with no real-time verification of density or rheological properties.', 'Density is checked periodically but rheological verification and deviation handling are inconsistent.', 'Slurry density and rheology are verified in real time against design tolerances for every job, with documented corrective action on deviation.', 'Mixing performance data is tracked across jobs to refine slurry design and mixing equipment calibration.', 'Cement mixing is integrated with automated real-time density/rheology control and closed-loop correction.',
    'Ask for the real-time density/rheology log of the most recent cement job and confirm any out-of-tolerance reading was documented and addressed.', 'Cement mixing procedure; real-time density/rheology log; slurry lab test report.', 'Confirm one cement job''s real-time mixing log shows density within design tolerance, or a documented corrective action if not.', 'Flag if a cement job proceeds with slurry density readings outside the design tolerance and no documented corrective action.', 2)
  ON CONFLICT (maturity_model_id, process_area) DO NOTHING;

  -- Q17: ofs_l3_4_6_3
  INSERT INTO questions (questionnaire_id, evaluation_type_id, domain_id, process_id,
    question_code, question_text, question_intent, instruction_text, evidence_examples,
    alert_rule_hint, mapped_maturity_model_id, mapped_maturity_statement_id, matched_process_area, sort_order)
  SELECT v_questionnaire_id, v_eval_type_id, v_domain_id, p.id,
    'ofs_l3_4_6_3', 'How mature is the organization''s process for selecting and dosing cement additives (retarders, accelerators, fluid-loss agents) to match well conditions?', 'Assess whether additive selection and dosing are based on documented lab testing for the specific well''s temperature/pressure conditions, versus a standard additive package used regardless of conditions.', 'Review the additive selection rationale, the supporting laboratory slurry test (thickening time, fluid loss) for the well''s specific bottom-hole conditions, and the actual dosing record from the job.', 'Additive selection rationale; laboratory slurry test report; additive dosing/batch record.',
    'Flag if additive dosing on the job does not match the laboratory-tested formulation with no documented justification.', 'ofs_mm_l1_4', 'ofs_l3_4_6_3', 'ofs_l3_4_6_3', 3
  FROM processes p WHERE p.code = 'ofs_l2_4_6';

  INSERT INTO maturity_statements (maturity_model_id, domain_title, process_area,
    level_1_basic, level_2_developing, level_3_established, level_4_advanced, level_5_leading,
    assessor_instruction, evidence_examples, review_steps, alert_rule_hint, sort_order)
  VALUES ('ofs_mm_l1_4', 'Complete The Well', 'ofs_l3_4_6_3',
    'Additives are selected and dosed by default with no documented lab testing for well-specific conditions.', 'Lab testing occurs for major wells but dosing records are inconsistently reconciled against it.', 'Additive selection and dosing are based on documented lab testing matched to well conditions, and job dosing is reconciled against the tested formulation.', 'Additive performance data is tracked across wells to refine standard formulations for recurring well conditions.', 'Additive selection and dosing are optimized through an integrated lab-to-field digital workflow with real-time dosing verification.',
    'Ask for the laboratory slurry test report supporting the most recent job''s additive package and confirm the job dosing record matches it.', 'Additive selection rationale; laboratory slurry test report; additive dosing/batch record.', 'Confirm one job''s additive dosing record matches the laboratory-tested formulation for that well''s specific bottom-hole conditions.', 'Flag if additive dosing on the job does not match the laboratory-tested formulation with no documented justification.', 3)
  ON CONFLICT (maturity_model_id, process_area) DO NOTHING;

  -- Q18: ofs_l3_4_6_4
  INSERT INTO questions (questionnaire_id, evaluation_type_id, domain_id, process_id,
    question_code, question_text, question_intent, instruction_text, evidence_examples,
    alert_rule_hint, mapped_maturity_model_id, mapped_maturity_statement_id, matched_process_area, sort_order)
  SELECT v_questionnaire_id, v_eval_type_id, v_domain_id, p.id,
    'ofs_l3_4_6_4', 'How mature is the organization''s process for verifying cement integrity after placement (bond log, temperature survey, pressure test) before proceeding with the well?', 'Assess whether post-job cement integrity is formally verified and documented before subsequent operations proceed, versus assumed adequate with no verification.', 'Review the post-job cement integrity verification method (bond log, temperature survey, or pressure test) and confirm it was reviewed before the next operation began.', 'Cement bond/temperature log; pressure test result; integrity verification sign-off.',
    'Flag if the well proceeds to perforating or production without a documented cement integrity verification.', 'ofs_mm_l1_4', 'ofs_l3_4_6_4', 'ofs_l3_4_6_4', 4
  FROM processes p WHERE p.code = 'ofs_l2_4_6';

  INSERT INTO maturity_statements (maturity_model_id, domain_title, process_area,
    level_1_basic, level_2_developing, level_3_established, level_4_advanced, level_5_leading,
    assessor_instruction, evidence_examples, review_steps, alert_rule_hint, sort_order)
  VALUES ('ofs_mm_l1_4', 'Complete The Well', 'ofs_l3_4_6_4',
    'Cement integrity is not verified after placement.', 'Verification occurs for some wells but is not consistently completed before proceeding.', 'Cement integrity is verified (bond log, temperature survey, or pressure test) and signed off before every well proceeds to the next operation.', 'Cement integrity results are tracked across wells to identify systemic placement issues and refine job design.', 'Cement integrity monitoring is integrated with automated log interpretation and predictive placement analytics across the well program.',
    'Ask for the cement integrity verification of the most recently cemented well and confirm it was reviewed and signed off before the well proceeded.', 'Cement bond/temperature log; pressure test result; integrity verification sign-off.', 'Confirm one well''s cement integrity verification record exists and precedes the next documented operation on that well.', 'Flag if the well proceeds to perforating or production without a documented cement integrity verification.', 4)
  ON CONFLICT (maturity_model_id, process_area) DO NOTHING;

  -- Q19: ofs_l3_4_7_1
  INSERT INTO questions (questionnaire_id, evaluation_type_id, domain_id, process_id,
    question_code, question_text, question_intent, instruction_text, evidence_examples,
    alert_rule_hint, mapped_maturity_model_id, mapped_maturity_statement_id, matched_process_area, sort_order)
  SELECT v_questionnaire_id, v_eval_type_id, v_domain_id, p.id,
    'ofs_l3_4_7_1', 'How mature is the organization''s process for selecting the base completion fluid (brine type, density) matched to formation and pressure requirements?', 'Assess whether base fluid selection is grounded in documented formation-compatibility and pressure-balance analysis, versus a standard brine used regardless of well conditions.', 'Review the completion fluid design report specifying base fluid type and density, and the supporting formation-compatibility/pressure analysis.', 'Completion fluid design report; formation-compatibility analysis; density/pressure-balance calculation.',
    'Flag if a completion fluid is selected with no documented pressure-balance calculation for the specific well.', 'ofs_mm_l1_4', 'ofs_l3_4_7_1', 'ofs_l3_4_7_1', 1
  FROM processes p WHERE p.code = 'ofs_l2_4_7';

  INSERT INTO maturity_statements (maturity_model_id, domain_title, process_area,
    level_1_basic, level_2_developing, level_3_established, level_4_advanced, level_5_leading,
    assessor_instruction, evidence_examples, review_steps, alert_rule_hint, sort_order)
  VALUES ('ofs_mm_l1_4', 'Complete The Well', 'ofs_l3_4_7_1',
    'Base completion fluid is selected by default with no documented compatibility or pressure analysis.', 'A design exists for major wells but compatibility analysis is inconsistently documented.', 'Base fluid selection is documented and supported by formation-compatibility and pressure-balance analysis for every well.', 'Fluid performance (formation damage indicators) is tracked across wells to refine base fluid standards.', 'Completion fluid design is optimized through an integrated formation-compatibility and reservoir modeling workflow across the asset.',
    'Ask for the pressure-balance calculation supporting the most recent completion fluid design and confirm it matches the actual fluid density used.', 'Completion fluid design report; formation-compatibility analysis; density/pressure-balance calculation.', 'Confirm one well''s completion fluid design report and its supporting compatibility/pressure analysis are consistent with the fluid used.', 'Flag if a completion fluid is selected with no documented pressure-balance calculation for the specific well.', 1)
  ON CONFLICT (maturity_model_id, process_area) DO NOTHING;

  -- Q20: ofs_l3_4_7_2
  INSERT INTO questions (questionnaire_id, evaluation_type_id, domain_id, process_id,
    question_code, question_text, question_intent, instruction_text, evidence_examples,
    alert_rule_hint, mapped_maturity_model_id, mapped_maturity_statement_id, matched_process_area, sort_order)
  SELECT v_questionnaire_id, v_eval_type_id, v_domain_id, p.id,
    'ofs_l3_4_7_2', 'How mature is the organization''s process for preparing and testing chemical additives (corrosion inhibitors, clay stabilizers, biocides) in completion fluids?', 'Assess whether additive preparation includes documented compatibility/performance testing before use, versus added based on standard recipe with no verification.', 'Review the additive compatibility/performance test report and the batch preparation record confirming the tested formulation was what was actually mixed.', 'Additive compatibility/performance test report; batch preparation/mixing record.',
    'Flag if a completion fluid batch is used with no documented compatibility test for its specific additive package.', 'ofs_mm_l1_4', 'ofs_l3_4_7_2', 'ofs_l3_4_7_2', 2
  FROM processes p WHERE p.code = 'ofs_l2_4_7';

  INSERT INTO maturity_statements (maturity_model_id, domain_title, process_area,
    level_1_basic, level_2_developing, level_3_established, level_4_advanced, level_5_leading,
    assessor_instruction, evidence_examples, review_steps, alert_rule_hint, sort_order)
  VALUES ('ofs_mm_l1_4', 'Complete The Well', 'ofs_l3_4_7_2',
    'Chemical additives are added with no documented compatibility or performance testing.', 'Testing occurs for some additive packages but batch records are inconsistently reconciled against test results.', 'Every additive package is compatibility/performance tested, and batch preparation records are reconciled against the tested formulation.', 'Additive performance data is tracked across jobs to refine standard formulations and reduce formation damage risk.', 'Additive selection and preparation are optimized through an integrated lab-to-field digital workflow with real-time batch verification.',
    'Ask for the compatibility/performance test report of the additive package used in the most recent completion fluid batch.', 'Additive compatibility/performance test report; batch preparation/mixing record.', 'Confirm one batch''s preparation record matches the tested and approved additive formulation.', 'Flag if a completion fluid batch is used with no documented compatibility test for its specific additive package.', 2)
  ON CONFLICT (maturity_model_id, process_area) DO NOTHING;

  -- Q21: ofs_l3_4_7_3
  INSERT INTO questions (questionnaire_id, evaluation_type_id, domain_id, process_id,
    question_code, question_text, question_intent, instruction_text, evidence_examples,
    alert_rule_hint, mapped_maturity_model_id, mapped_maturity_statement_id, matched_process_area, sort_order)
  SELECT v_questionnaire_id, v_eval_type_id, v_domain_id, p.id,
    'ofs_l3_4_7_3', 'How mature is the organization''s process for adjusting and verifying the pH of base water used in completion fluids to the target specification?', 'Assess whether pH adjustment is verified by documented testing against a defined target range before use, versus adjusted by feel with no recorded verification.', 'Review the target pH specification and the pH test record confirming the base water was within range before being used in the completion fluid.', 'Target pH specification; pH test record; base water treatment log.',
    'Flag if base water is used in a completion fluid batch with no documented pH verification against the target range.', 'ofs_mm_l1_4', 'ofs_l3_4_7_3', 'ofs_l3_4_7_3', 3
  FROM processes p WHERE p.code = 'ofs_l2_4_7';

  INSERT INTO maturity_statements (maturity_model_id, domain_title, process_area,
    level_1_basic, level_2_developing, level_3_established, level_4_advanced, level_5_leading,
    assessor_instruction, evidence_examples, review_steps, alert_rule_hint, sort_order)
  VALUES ('ofs_mm_l1_4', 'Complete The Well', 'ofs_l3_4_7_3',
    'Base water pH is adjusted with no documented target specification or verification.', 'A target range exists but pH verification records are inconsistently kept.', 'Base water pH is tested and verified against a documented target range before use, for every batch.', 'pH and treatment data are tracked across batches to refine base water treatment procedures.', 'Base water quality management is integrated with real-time automated pH monitoring and dosing control.',
    'Ask for the pH test record of the most recent base water batch and confirm it was within the documented target range before use.', 'Target pH specification; pH test record; base water treatment log.', 'Confirm one base water batch''s pH test record is on file and shows the result was within the target specification.', 'Flag if base water is used in a completion fluid batch with no documented pH verification against the target range.', 3)
  ON CONFLICT (maturity_model_id, process_area) DO NOTHING;

  -- Q22: ofs_l3_4_7_4
  INSERT INTO questions (questionnaire_id, evaluation_type_id, domain_id, process_id,
    question_code, question_text, question_intent, instruction_text, evidence_examples,
    alert_rule_hint, mapped_maturity_model_id, mapped_maturity_statement_id, matched_process_area, sort_order)
  SELECT v_questionnaire_id, v_eval_type_id, v_domain_id, p.id,
    'ofs_l3_4_7_4', 'How mature is the organization''s process for planning completion fluid requirements by operational stage (drill-in, displacement, workover) across the well''s completion sequence?', 'Assess whether fluid requirements are planned as a coherent stage-by-stage program with documented transition/compatibility checks, versus determined ad hoc at each stage.', 'Review the stage-based fluid plan covering the completion sequence and confirm it addresses fluid compatibility at each transition between stages.', 'Stage-based completion fluid plan; inter-stage compatibility check; fluid volume/logistics schedule.',
    'Flag if a fluid transition between completion stages has no documented compatibility check.', 'ofs_mm_l1_4', 'ofs_l3_4_7_4', 'ofs_l3_4_7_4', 4
  FROM processes p WHERE p.code = 'ofs_l2_4_7';

  INSERT INTO maturity_statements (maturity_model_id, domain_title, process_area,
    level_1_basic, level_2_developing, level_3_established, level_4_advanced, level_5_leading,
    assessor_instruction, evidence_examples, review_steps, alert_rule_hint, sort_order)
  VALUES ('ofs_mm_l1_4', 'Complete The Well', 'ofs_l3_4_7_4',
    'Fluid requirements for each completion stage are determined ad hoc with no overall plan.', 'A stage-based plan exists but inter-stage compatibility checks are inconsistently documented.', 'A documented stage-based fluid plan covers the full completion sequence, with compatibility checked at every transition.', 'Stage-based fluid plans are compared across wells to identify and eliminate recurring compatibility or logistics issues.', 'Fluid planning is integrated with digital completion sequencing and real-time logistics optimization across the well program.',
    'Ask for the stage-based fluid plan of the most recent completion and confirm inter-stage compatibility checks are documented.', 'Stage-based completion fluid plan; inter-stage compatibility check; fluid volume/logistics schedule.', 'Confirm one well''s stage-based fluid plan documents each stage and its inter-stage compatibility check.', 'Flag if a fluid transition between completion stages has no documented compatibility check.', 4)
  ON CONFLICT (maturity_model_id, process_area) DO NOTHING;

  -- Q23: ofs_l3_4_8_1
  INSERT INTO questions (questionnaire_id, evaluation_type_id, domain_id, process_id,
    question_code, question_text, question_intent, instruction_text, evidence_examples,
    alert_rule_hint, mapped_maturity_model_id, mapped_maturity_statement_id, matched_process_area, sort_order)
  SELECT v_questionnaire_id, v_eval_type_id, v_domain_id, p.id,
    'ofs_l3_4_8_1', 'How mature is the organization''s process for monitoring hydraulic fracturing treatments in real time (pressure, rate, proppant concentration) against the treatment design?', 'Assess whether frac execution is monitored against defined design parameters and screen-out/deviation limits with documented decisions, versus pumped without real-time comparison to design.', 'Review the frac treatment design and the real-time monitoring log (pressure, rate, proppant concentration) confirming deviations from design were identified and addressed.', 'Frac treatment design; real-time monitoring log/job summary; deviation/decision record.',
    'Flag if a significant deviation from the frac design (e.g., early screen-out, pressure anomaly) has no documented decision record.', 'ofs_mm_l1_4', 'ofs_l3_4_8_1', 'ofs_l3_4_8_1', 1
  FROM processes p WHERE p.code = 'ofs_l2_4_8';

  INSERT INTO maturity_statements (maturity_model_id, domain_title, process_area,
    level_1_basic, level_2_developing, level_3_established, level_4_advanced, level_5_leading,
    assessor_instruction, evidence_examples, review_steps, alert_rule_hint, sort_order)
  VALUES ('ofs_mm_l1_4', 'Complete The Well', 'ofs_l3_4_8_1',
    'Fracturing treatments are pumped with no documented design or real-time monitoring against it.', 'A design exists but real-time monitoring and deviation handling are inconsistently documented.', 'Every frac treatment is monitored in real time against its design, with deviations documented and decisions recorded.', 'Treatment performance data is tracked across wells and stages to refine design models and pumping schedules.', 'Fracture monitoring is integrated with real-time modeling and automated deviation alerts across the completion program.',
    'Ask for the real-time monitoring log of the most recent frac stage and confirm any deviation from design was documented and addressed.', 'Frac treatment design; real-time monitoring log/job summary; deviation/decision record.', 'Confirm one frac stage''s design and real-time monitoring log are consistent, with any deviation documented.', 'Flag if a significant deviation from the frac design (e.g., early screen-out, pressure anomaly) has no documented decision record.', 1)
  ON CONFLICT (maturity_model_id, process_area) DO NOTHING;

  -- Q24: ofs_l3_4_8_2
  INSERT INTO questions (questionnaire_id, evaluation_type_id, domain_id, process_id,
    question_code, question_text, question_intent, instruction_text, evidence_examples,
    alert_rule_hint, mapped_maturity_model_id, mapped_maturity_statement_id, matched_process_area, sort_order)
  SELECT v_questionnaire_id, v_eval_type_id, v_domain_id, p.id,
    'ofs_l3_4_8_2', 'How mature is the organization''s process for using microseismic (or equivalent) monitoring to verify fracture geometry and containment during hydraulic fracturing?', 'Assess whether microseismic or equivalent diagnostic monitoring is planned and its results used to confirm fracture containment and inform completion design, versus not used or used without follow-up analysis.', 'Review the microseismic monitoring plan (or equivalent diagnostic method) and the resulting fracture geometry/containment report, and confirm it was used to inform completion decisions.', 'Microseismic monitoring plan; fracture geometry/containment report; completion design decision referencing the results.',
    'Flag if a microseismic monitoring result indicates fracture growth outside the target zone with no documented follow-up decision.', 'ofs_mm_l1_4', 'ofs_l3_4_8_2', 'ofs_l3_4_8_2', 2
  FROM processes p WHERE p.code = 'ofs_l2_4_8';

  INSERT INTO maturity_statements (maturity_model_id, domain_title, process_area,
    level_1_basic, level_2_developing, level_3_established, level_4_advanced, level_5_leading,
    assessor_instruction, evidence_examples, review_steps, alert_rule_hint, sort_order)
  VALUES ('ofs_mm_l1_4', 'Complete The Well', 'ofs_l3_4_8_2',
    'Microseismic or equivalent fracture diagnostics are not used.', 'Monitoring is used on select wells but results are not consistently analyzed or acted upon.', 'Microseismic (or equivalent) monitoring is planned for representative wells, with results documented and used to inform completion decisions.', 'Monitoring results are aggregated across wells to calibrate fracture models and refine stage spacing/design.', 'Fracture diagnostics are integrated with real-time modeling, directly informing adaptive completion design across the program.',
    'Ask for the fracture geometry/containment report of the most recent monitored well and confirm it informed a documented completion decision.', 'Microseismic monitoring plan; fracture geometry/containment report; completion design decision referencing the results.', 'Confirm one monitored well''s microseismic (or equivalent) report exists and is referenced in a completion design decision.', 'Flag if a microseismic monitoring result indicates fracture growth outside the target zone with no documented follow-up decision.', 2)
  ON CONFLICT (maturity_model_id, process_area) DO NOTHING;

  -- Q25: ofs_l3_4_9_1
  INSERT INTO questions (questionnaire_id, evaluation_type_id, domain_id, process_id,
    question_code, question_text, question_intent, instruction_text, evidence_examples,
    alert_rule_hint, mapped_maturity_model_id, mapped_maturity_statement_id, matched_process_area, sort_order)
  SELECT v_questionnaire_id, v_eval_type_id, v_domain_id, p.id,
    'ofs_l3_4_9_1', 'How mature is the organization''s process for designing, installing and pressure-testing the wellhead assembly (casing head, tubing head, christmas tree)?', 'Assess whether wellhead assembly selection and installation follow a documented design matched to well pressure rating, with a verified pressure test, versus installed from standard stock with no well-specific rating check.', 'Review the wellhead assembly specification (pressure rating matched to well design), the installation record, and the pressure test certificate.', 'Wellhead assembly specification; installation record; pressure test certificate.',
    'Flag if a wellhead assembly is installed with a pressure rating not documented as matching the well''s maximum anticipated surface pressure.', 'ofs_mm_l1_4', 'ofs_l3_4_9_1', 'ofs_l3_4_9_1', 1
  FROM processes p WHERE p.code = 'ofs_l2_4_9';

  INSERT INTO maturity_statements (maturity_model_id, domain_title, process_area,
    level_1_basic, level_2_developing, level_3_established, level_4_advanced, level_5_leading,
    assessor_instruction, evidence_examples, review_steps, alert_rule_hint, sort_order)
  VALUES ('ofs_mm_l1_4', 'Complete The Well', 'ofs_l3_4_9_1',
    'Wellhead assembly is installed with no documented specification or pressure test.', 'A specification exists but pressure test certificates are inconsistently retained.', 'Wellhead assembly specification is matched to well pressure rating and every installation has a verified pressure test certificate.', 'Wellhead component performance and failure data are tracked across wells to refine specification standards.', 'Wellhead assembly design and verification are integrated with a digital well-integrity register, tracked fleet-wide in real time.',
    'Ask for the pressure test certificate of the most recently installed wellhead assembly and confirm its rating matches the well''s maximum anticipated surface pressure.', 'Wellhead assembly specification; installation record; pressure test certificate.', 'Confirm one well''s wellhead assembly specification and pressure test certificate are on file and consistent.', 'Flag if a wellhead assembly is installed with a pressure rating not documented as matching the well''s maximum anticipated surface pressure.', 1)
  ON CONFLICT (maturity_model_id, process_area) DO NOTHING;

  -- Q26: ofs_l3_4_10_1
  INSERT INTO questions (questionnaire_id, evaluation_type_id, domain_id, process_id,
    question_code, question_text, question_intent, instruction_text, evidence_examples,
    alert_rule_hint, mapped_maturity_model_id, mapped_maturity_statement_id, matched_process_area, sort_order)
  SELECT v_questionnaire_id, v_eval_type_id, v_domain_id, p.id,
    'ofs_l3_4_10_1', 'How mature is the organization''s process for determining whether acid stimulation is required, based on documented well/formation design analysis?', 'Assess whether the acid-treatment decision is based on documented formation damage or productivity analysis, versus applied by default regardless of well-specific need.', 'Review the formation damage/productivity analysis supporting the acid treatment decision for a specific well and confirm it was completed before the treatment was scheduled.', 'Formation damage/productivity analysis; acid treatment decision memo; well design report.',
    'Flag if an acid treatment is scheduled with no documented analysis supporting the need for it.', 'ofs_mm_l1_4', 'ofs_l3_4_10_1', 'ofs_l3_4_10_1', 1
  FROM processes p WHERE p.code = 'ofs_l2_4_10';

  INSERT INTO maturity_statements (maturity_model_id, domain_title, process_area,
    level_1_basic, level_2_developing, level_3_established, level_4_advanced, level_5_leading,
    assessor_instruction, evidence_examples, review_steps, alert_rule_hint, sort_order)
  VALUES ('ofs_mm_l1_4', 'Complete The Well', 'ofs_l3_4_10_1',
    'Acid treatment is applied by default with no documented analysis of need.', 'Analysis is performed for major wells but is not consistently required before scheduling treatment.', 'Every acid treatment decision is supported by a documented formation damage/productivity analysis completed before scheduling.', 'Treatment-decision outcomes are tracked across wells to refine the criteria for when acid stimulation is warranted.', 'The acid-treatment decision is integrated with a predictive reservoir/formation-damage model, continuously refined across the asset.',
    'Ask for the formation damage/productivity analysis supporting the most recent acid treatment decision and confirm it preceded the job.', 'Formation damage/productivity analysis; acid treatment decision memo; well design report.', 'Confirm one well''s acid treatment decision references a documented analysis completed before the job was scheduled.', 'Flag if an acid treatment is scheduled with no documented analysis supporting the need for it.', 1)
  ON CONFLICT (maturity_model_id, process_area) DO NOTHING;

  -- Q27: ofs_l3_4_10_2
  INSERT INTO questions (questionnaire_id, evaluation_type_id, domain_id, process_id,
    question_code, question_text, question_intent, instruction_text, evidence_examples,
    alert_rule_hint, mapped_maturity_model_id, mapped_maturity_statement_id, matched_process_area, sort_order)
  SELECT v_questionnaire_id, v_eval_type_id, v_domain_id, p.id,
    'ofs_l3_4_10_2', 'How mature is the organization''s process for determining acid concentration and volume based on the base water and formation mineralogy?', 'Assess whether acid concentration/volume is calculated from documented formation mineralogy and base water compatibility testing, versus a standard concentration applied regardless of formation.', 'Review the acid concentration/volume calculation and its supporting formation mineralogy and base water compatibility data.', 'Formation mineralogy report; acid concentration/volume calculation; base water compatibility test.',
    'Flag if acid concentration is set with no documented formation mineralogy or compatibility data supporting it.', 'ofs_mm_l1_4', 'ofs_l3_4_10_2', 'ofs_l3_4_10_2', 2
  FROM processes p WHERE p.code = 'ofs_l2_4_10';

  INSERT INTO maturity_statements (maturity_model_id, domain_title, process_area,
    level_1_basic, level_2_developing, level_3_established, level_4_advanced, level_5_leading,
    assessor_instruction, evidence_examples, review_steps, alert_rule_hint, sort_order)
  VALUES ('ofs_mm_l1_4', 'Complete The Well', 'ofs_l3_4_10_2',
    'Acid concentration and volume are set by default with no documented mineralogy or compatibility analysis.', 'Mineralogy data exists for major wells but is not consistently linked to the concentration/volume calculation.', 'Acid concentration and volume are calculated from documented formation mineralogy and compatibility testing for every job.', 'Treatment outcomes are tracked across wells and formations to refine standard acid concentration guidelines.', 'Acid treatment design is optimized through an integrated formation-mineralogy and reservoir-response modeling workflow.',
    'Ask for the mineralogy report supporting the most recent acid job''s concentration and volume calculation.', 'Formation mineralogy report; acid concentration/volume calculation; base water compatibility test.', 'Confirm one acid job''s concentration/volume calculation references documented formation mineralogy and base water compatibility data.', 'Flag if acid concentration is set with no documented formation mineralogy or compatibility data supporting it.', 2)
  ON CONFLICT (maturity_model_id, process_area) DO NOTHING;

  -- Q28: ofs_l3_4_10_3
  INSERT INTO questions (questionnaire_id, evaluation_type_id, domain_id, process_id,
    question_code, question_text, question_intent, instruction_text, evidence_examples,
    alert_rule_hint, mapped_maturity_model_id, mapped_maturity_statement_id, matched_process_area, sort_order)
  SELECT v_questionnaire_id, v_eval_type_id, v_domain_id, p.id,
    'ofs_l3_4_10_3', 'How mature is the organization''s process for monitoring reservoir/fracture response (pressure, injectivity) during acid injection in real time?', 'Assess whether acid injection is monitored in real time with a documented response-to-injection relationship, versus pumped at a fixed rate with no monitoring of reservoir response.', 'Review the real-time injection monitoring log (pressure, rate, injectivity index) for an acid job and confirm response trends were reviewed during the job.', 'Real-time injection monitoring log; injectivity index trend; job summary report.',
    'Flag if an acid job''s injectivity trend shows a significant anomaly with no documented review or response.', 'ofs_mm_l1_4', 'ofs_l3_4_10_3', 'ofs_l3_4_10_3', 3
  FROM processes p WHERE p.code = 'ofs_l2_4_10';

  INSERT INTO maturity_statements (maturity_model_id, domain_title, process_area,
    level_1_basic, level_2_developing, level_3_established, level_4_advanced, level_5_leading,
    assessor_instruction, evidence_examples, review_steps, alert_rule_hint, sort_order)
  VALUES ('ofs_mm_l1_4', 'Complete The Well', 'ofs_l3_4_10_3',
    'Acid injection proceeds with no real-time monitoring of pressure or injectivity response.', 'Monitoring data is recorded but not consistently reviewed during or after the job.', 'Real-time injection monitoring is performed and reviewed against expected response for every acid job.', 'Injection response data is tracked across wells to refine expected-response models and treatment design.', 'Fracture/injection response monitoring is integrated with real-time automated decision support during the job.',
    'Ask for the real-time injection monitoring log of the most recent acid job and confirm the injectivity trend was reviewed during the job.', 'Real-time injection monitoring log; injectivity index trend; job summary report.', 'Confirm one acid job''s real-time monitoring log is on file and shows evidence of review during the job.', 'Flag if an acid job''s injectivity trend shows a significant anomaly with no documented review or response.', 3)
  ON CONFLICT (maturity_model_id, process_area) DO NOTHING;

  -- Q29: ofs_l3_4_10_4
  INSERT INTO questions (questionnaire_id, evaluation_type_id, domain_id, process_id,
    question_code, question_text, question_intent, instruction_text, evidence_examples,
    alert_rule_hint, mapped_maturity_model_id, mapped_maturity_statement_id, matched_process_area, sort_order)
  SELECT v_questionnaire_id, v_eval_type_id, v_domain_id, p.id,
    'ofs_l3_4_10_4', 'How mature is the organization''s process for adjusting the acid mixture (concentration, additives) during or between stages based on observed reservoir response?', 'Assess whether mixture adjustments are made based on documented real-time response data with a recorded rationale, versus adjusted informally with no traceable basis.', 'Review the documented rationale for any acid mixture adjustment made during or between stages, referencing the real-time response data that prompted it.', 'Mixture adjustment decision record; real-time response data supporting the adjustment; revised job ticket.',
    'Flag if an acid mixture is changed mid-job with no documented rationale referencing observed response data.', 'ofs_mm_l1_4', 'ofs_l3_4_10_4', 'ofs_l3_4_10_4', 4
  FROM processes p WHERE p.code = 'ofs_l2_4_10';

  INSERT INTO maturity_statements (maturity_model_id, domain_title, process_area,
    level_1_basic, level_2_developing, level_3_established, level_4_advanced, level_5_leading,
    assessor_instruction, evidence_examples, review_steps, alert_rule_hint, sort_order)
  VALUES ('ofs_mm_l1_4', 'Complete The Well', 'ofs_l3_4_10_4',
    'Mixture adjustments are made informally during jobs with no documented rationale.', 'Adjustments are made for major deviations but the rationale is inconsistently documented.', 'Every mixture adjustment is documented with a rationale referencing the real-time response data that prompted it.', 'Adjustment patterns are tracked across wells to refine standard response-based adjustment protocols.', 'Mixture adjustment is supported by real-time automated decision-support tools integrated with the injection monitoring system.',
    'Ask for the documented rationale behind the most recent mid-job acid mixture adjustment and confirm it references the response data that prompted it.', 'Mixture adjustment decision record; real-time response data supporting the adjustment; revised job ticket.', 'Confirm one job''s mixture adjustment record documents the rationale and references the real-time response data behind the decision.', 'Flag if an acid mixture is changed mid-job with no documented rationale referencing observed response data.', 4)
  ON CONFLICT (maturity_model_id, process_area) DO NOTHING;
END $$;
