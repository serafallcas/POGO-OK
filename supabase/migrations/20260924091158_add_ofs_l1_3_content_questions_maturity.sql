/*
# OFS Onshore content batch: Drill The Well (ofs_l1_3)

1. New Data
   - 1 maturity_model (ofs_mm_l1_3)
   - 24 questions (ofs_l3_3_1_1 through ofs_l3_3_9_3)
   - 24 maturity_statements corresponding to each question
2. Purely additive — no drops, no deletes, no modifications to existing data.
3. All ON CONFLICT DO NOTHING for idempotency.
*/

DO $$
DECLARE
  v_questionnaire_id uuid;
  v_eval_type_id uuid;
  v_domain_id uuid;
BEGIN
  SELECT id INTO v_eval_type_id FROM evaluation_types WHERE code = 'ofs_onshore';
  SELECT id INTO v_questionnaire_id FROM questionnaires WHERE code = 'ofs_onshore_questionnaire';
  SELECT id INTO v_domain_id FROM domains WHERE code = 'ofs_l1_3';

  INSERT INTO maturity_models (code, label, description, domain_id, mapped_domain_id, mapped_domain_name, version, source_workbook, is_active)
  VALUES ('ofs_mm_l1_3', 'Drill The Well - Maturity Model', 'OFS Onshore maturity model for Drill The Well', v_domain_id, 'ofs_l1_3', 'Drill The Well', '1.0', 'POGO-OFS_Level_1-3_framework.pptx', true)
  ON CONFLICT (code) DO NOTHING;

  -- Q1: ofs_l3_3_1_1
  INSERT INTO questions (questionnaire_id, evaluation_type_id, domain_id, process_id,
    question_code, question_text, question_intent, instruction_text, evidence_examples,
    alert_rule_hint, mapped_maturity_model_id, mapped_maturity_statement_id, matched_process_area, sort_order)
  SELECT v_questionnaire_id, v_eval_type_id, v_domain_id, p.id,
    'ofs_l3_3_1_1', 'How mature is the organization''s process for selecting, tracking and evaluating drill bit performance across a well program?', 'Assess whether bit selection is driven by documented formation/offset-well analysis and dull-grading feedback, versus habitual reuse of familiar bit types.', 'Review the bit selection rationale for a recent well, the bit run record (footage, ROP, hours), and the dull-grading (IADC) report at pull.', 'Bit selection/offset-well analysis; bit run record; IADC dull-grading report; bit performance database entry.',
    'Flag if a bit is pulled and re-run without a documented dull-grading assessment.', 'ofs_mm_l1_3', 'ofs_l3_3_1_1', 'ofs_l3_3_1_1', 1
  FROM processes p WHERE p.code = 'ofs_l2_3_1';

  INSERT INTO maturity_statements (maturity_model_id, domain_title, process_area,
    level_1_basic, level_2_developing, level_3_established, level_4_advanced, level_5_leading,
    assessor_instruction, evidence_examples, review_steps, alert_rule_hint, sort_order)
  VALUES ('ofs_mm_l1_3', 'Drill The Well', 'ofs_l3_3_1_1',
    'Bits are selected by habit with no documented rationale or dull-grading records.', 'A bit run record is kept but dull-grading and selection rationale are inconsistent.', 'Bit selection is based on documented formation/offset analysis, and every run is dull-graded (IADC) at pull.', 'Bit performance data (ROP, footage, dull grade) is tracked across wells and used to refine selection criteria.', 'Bit selection is optimized through a shared performance database and predictive ROP modeling across the operator''s well portfolio.',
    'Ask for the dull-grading report of the most recently pulled bit and confirm it informed the selection of the next bit run.', 'Bit selection/offset-well analysis; bit run record; IADC dull-grading report; bit performance database entry.', 'Trace one bit run from selection rationale through the run record to the dull-grading report and confirm the next bit selection referenced it.', 'Flag if a bit is pulled and re-run without a documented dull-grading assessment.', 1)
  ON CONFLICT (maturity_model_id, process_area) DO NOTHING;

  -- Q2: ofs_l3_3_1_2
  INSERT INTO questions (questionnaire_id, evaluation_type_id, domain_id, process_id,
    question_code, question_text, question_intent, instruction_text, evidence_examples,
    alert_rule_hint, mapped_maturity_model_id, mapped_maturity_statement_id, matched_process_area, sort_order)
  SELECT v_questionnaire_id, v_eval_type_id, v_domain_id, p.id,
    'ofs_l3_3_1_2', 'How mature is the organization''s process for inspecting, tracking and managing drill pipe inventory and fitness for service?', 'Assess whether drill pipe is tracked individually (inspection class, fatigue history, torque/tension limits) rather than treated as an undifferentiated commodity.', 'Review the drill pipe inventory register, inspection records (class, wall thickness, connections), and the fatigue/usage tracking method applied.', 'Drill pipe inventory/inspection register; third-party inspection certificates; torque/tension limit tables; fatigue tracking log.',
    'Flag if drill pipe is run in a well without a current, traceable inspection certificate.', 'ofs_mm_l1_3', 'ofs_l3_3_1_2', 'ofs_l3_3_1_2', 2
  FROM processes p WHERE p.code = 'ofs_l2_3_1';

  INSERT INTO maturity_statements (maturity_model_id, domain_title, process_area,
    level_1_basic, level_2_developing, level_3_established, level_4_advanced, level_5_leading,
    assessor_instruction, evidence_examples, review_steps, alert_rule_hint, sort_order)
  VALUES ('ofs_mm_l1_3', 'Drill The Well', 'ofs_l3_3_1_2',
    'Drill pipe is used without individual tracking or current inspection records.', 'An inventory exists but inspection currency and fatigue history are not consistently tracked per joint.', 'Every joint is tracked (inspection class, certificate, torque/tension limits) and verified current before use.', 'Fatigue and usage data across wells are analyzed to optimize string design and retirement timing.', 'Drill pipe fleet management is digitally integrated with real-time downhole load monitoring, enabling predictive failure prevention.',
    'Ask for the inspection certificate of a randomly selected drill pipe joint currently in the string and confirm it is within its inspection interval.', 'Drill pipe inventory/inspection register; third-party inspection certificates; torque/tension limit tables; fatigue tracking log.', 'Sample one joint from the active string and confirm its inspection certificate and fatigue history are on file and current.', 'Flag if drill pipe is run in a well without a current, traceable inspection certificate.', 2)
  ON CONFLICT (maturity_model_id, process_area) DO NOTHING;

  -- Q3: ofs_l3_3_1_3
  INSERT INTO questions (questionnaire_id, evaluation_type_id, domain_id, process_id,
    question_code, question_text, question_intent, instruction_text, evidence_examples,
    alert_rule_hint, mapped_maturity_model_id, mapped_maturity_statement_id, matched_process_area, sort_order)
  SELECT v_questionnaire_id, v_eval_type_id, v_domain_id, p.id,
    'ofs_l3_3_1_3', 'How mature is the organization''s process for selecting, inspecting and managing drill collars used to provide weight-on-bit and directional control?', 'Assess whether drill collar selection (size, connection, magnetic properties for MWD) and inspection are documented and matched to the well program, versus assembled from whatever is available.', 'Review the drill collar selection criteria (including non-magnetic collar placement for MWD tools), inspection records, and the BHA design referencing the selected collars.', 'Drill collar inventory/inspection record; BHA design referencing collar specification; non-magnetic collar certification (where applicable).',
    'Flag if non-magnetic drill collars required for MWD accuracy are not certified or correctly positioned in the BHA.', 'ofs_mm_l1_3', 'ofs_l3_3_1_3', 'ofs_l3_3_1_3', 3
  FROM processes p WHERE p.code = 'ofs_l2_3_1';

  INSERT INTO maturity_statements (maturity_model_id, domain_title, process_area,
    level_1_basic, level_2_developing, level_3_established, level_4_advanced, level_5_leading,
    assessor_instruction, evidence_examples, review_steps, alert_rule_hint, sort_order)
  VALUES ('ofs_mm_l1_3', 'Drill The Well', 'ofs_l3_3_1_3',
    'Drill collars are selected without documented criteria or inspection records.', 'Selection criteria exist but inspection and certification (including non-magnetic collars) are inconsistently tracked.', 'Drill collar selection and inspection are documented and matched to the BHA design for every run, including non-magnetic certification where required.', 'Collar performance and failure data are tracked to refine selection standards.', 'Drill collar and BHA component selection is optimized through an integrated digital BHA design and tracking system.',
    'Ask for the BHA design of a recent MWD run and confirm the non-magnetic collar placement and certification match the design.', 'Drill collar inventory/inspection record; BHA design referencing collar specification; non-magnetic collar certification (where applicable).', 'Confirm one BHA design''s collar specification matches the inspection/certification records of the collars actually run.', 'Flag if non-magnetic drill collars required for MWD accuracy are not certified or correctly positioned in the BHA.', 3)
  ON CONFLICT (maturity_model_id, process_area) DO NOTHING;

  -- Q4: ofs_l3_3_2_1
  INSERT INTO questions (questionnaire_id, evaluation_type_id, domain_id, process_id,
    question_code, question_text, question_intent, instruction_text, evidence_examples,
    alert_rule_hint, mapped_maturity_model_id, mapped_maturity_statement_id, matched_process_area, sort_order)
  SELECT v_questionnaire_id, v_eval_type_id, v_domain_id, p.id,
    'ofs_l3_3_2_1', 'How mature is the organization''s process for capturing and applying real-time reservoir intelligence (pressure, fluid, formation data) during drilling to inform decisions?', 'Assess whether real-time drilling data is systematically fed back into geological/reservoir understanding and decision-making, versus captured but not used.', 'Review how real-time drilling/formation data is captured, the process for escalating significant findings to the geology/reservoir team, and evidence of a resulting decision (e.g., casing point adjustment, well path change).', 'Real-time data capture log; formation evaluation report; decision memo referencing real-time reservoir intelligence.',
    'Flag if a significant real-time formation anomaly has no documented escalation or decision record.', 'ofs_mm_l1_3', 'ofs_l3_3_2_1', 'ofs_l3_3_2_1', 1
  FROM processes p WHERE p.code = 'ofs_l2_3_2';

  INSERT INTO maturity_statements (maturity_model_id, domain_title, process_area,
    level_1_basic, level_2_developing, level_3_established, level_4_advanced, level_5_leading,
    assessor_instruction, evidence_examples, review_steps, alert_rule_hint, sort_order)
  VALUES ('ofs_mm_l1_3', 'Drill The Well', 'ofs_l3_3_2_1',
    'Real-time reservoir data is recorded but not systematically reviewed or escalated.', 'Data is reviewed by the wellsite team but escalation to reservoir/geology is inconsistent.', 'A documented process routes significant real-time findings to the reservoir/geology team, with decisions recorded.', 'Reservoir intelligence from drilling is systematically compared against pre-drill models to calibrate future predictions.', 'Real-time reservoir intelligence is integrated into a shared subsurface model updated continuously across the asset, driving proactive well placement decisions.',
    'Ask for an example of a real-time formation finding during a recent well and confirm it was escalated and led to a documented decision.', 'Real-time data capture log; formation evaluation report; decision memo referencing real-time reservoir intelligence.', 'Trace one real-time data anomaly from capture through escalation to a documented operational decision.', 'Flag if a significant real-time formation anomaly has no documented escalation or decision record.', 1)
  ON CONFLICT (maturity_model_id, process_area) DO NOTHING;

  -- Q5: ofs_l3_3_3_1
  INSERT INTO questions (questionnaire_id, evaluation_type_id, domain_id, process_id,
    question_code, question_text, question_intent, instruction_text, evidence_examples,
    alert_rule_hint, mapped_maturity_model_id, mapped_maturity_statement_id, matched_process_area, sort_order)
  SELECT v_questionnaire_id, v_eval_type_id, v_domain_id, p.id,
    'ofs_l3_3_3_1', 'How mature is the organization''s process for managing and controlling flow (well control, kick detection, choke management) during drilling operations?', 'Assess whether flow/well-control monitoring follows a documented, drilled-in procedure with defined response triggers, versus relying solely on driller experience.', 'Review the well control procedure, flow-check/kick-detection log, and evidence of crew drills (kick drills, choke drills) for the rig.', 'Well control procedure/matrix; flow-check and kick-detection logs; kick/choke drill records; BOP test records.',
    'Flag if a rig has no documented kick drill within the required interval before or during the well.', 'ofs_mm_l1_3', 'ofs_l3_3_3_1', 'ofs_l3_3_3_1', 1
  FROM processes p WHERE p.code = 'ofs_l2_3_3';

  INSERT INTO maturity_statements (maturity_model_id, domain_title, process_area,
    level_1_basic, level_2_developing, level_3_established, level_4_advanced, level_5_leading,
    assessor_instruction, evidence_examples, review_steps, alert_rule_hint, sort_order)
  VALUES ('ofs_mm_l1_3', 'Drill The Well', 'ofs_l3_3_3_1',
    'Flow/well control is managed by driller judgment with no documented procedure or drill records.', 'A well control procedure exists but drill records and flow-check logs are inconsistently kept.', 'A documented well control procedure is followed, with regular kick/choke drills and flow-check logs maintained for every well.', 'Well control incidents and near-misses are analyzed across wells to refine procedures and crew training.', 'Flow/well control management is integrated with real-time automated kick-detection systems and predictive analytics across the rig fleet.',
    'Ask for the most recent kick/choke drill record for the rig and confirm it falls within the required drill interval.', 'Well control procedure/matrix; flow-check and kick-detection logs; kick/choke drill records; BOP test records.', 'Confirm the well control procedure, flow-check logs and drill records are all present and consistent for the current well.', 'Flag if a rig has no documented kick drill within the required interval before or during the well.', 1)
  ON CONFLICT (maturity_model_id, process_area) DO NOTHING;

  -- Q6: ofs_l3_3_4_1
  INSERT INTO questions (questionnaire_id, evaluation_type_id, domain_id, process_id,
    question_code, question_text, question_intent, instruction_text, evidence_examples,
    alert_rule_hint, mapped_maturity_model_id, mapped_maturity_statement_id, matched_process_area, sort_order)
  SELECT v_questionnaire_id, v_eval_type_id, v_domain_id, p.id,
    'ofs_l3_3_4_1', 'How mature is the organization''s process for planning and executing whipstock-assisted sidetrack or deflection operations?', 'Assess whether whipstock operations are engineered (orientation, setting depth, anchor verification) and documented, versus executed as a routine field practice without design review.', 'Review the whipstock setting design (orientation, depth, anchor type), the orientation/setting verification record, and post-run confirmation of deflection success.', 'Whipstock design/orientation plan; setting and anchor verification log; post-run survey confirming deflection.',
    'Flag if a whipstock setting proceeds without a documented orientation and anchor verification record.', 'ofs_mm_l1_3', 'ofs_l3_3_4_1', 'ofs_l3_3_4_1', 1
  FROM processes p WHERE p.code = 'ofs_l2_3_4';

  INSERT INTO maturity_statements (maturity_model_id, domain_title, process_area,
    level_1_basic, level_2_developing, level_3_established, level_4_advanced, level_5_leading,
    assessor_instruction, evidence_examples, review_steps, alert_rule_hint, sort_order)
  VALUES ('ofs_mm_l1_3', 'Drill The Well', 'ofs_l3_3_4_1',
    'Whipstock operations are executed without a documented design or verification record.', 'A basic design exists but orientation/anchor verification is inconsistently documented.', 'Whipstock operations follow a documented design with orientation/anchor verification and post-run confirmation for every run.', 'Whipstock run performance (success rate, rework) is tracked to refine design standards and vendor selection.', 'Whipstock/sidetrack planning is integrated with real-time directional drilling systems for continuous deflection verification.',
    'Ask for the post-run survey of the most recent whipstock operation and confirm it verifies the intended deflection was achieved.', 'Whipstock design/orientation plan; setting and anchor verification log; post-run survey confirming deflection.', 'Confirm the whipstock design, orientation/anchor verification and post-run survey are all consistent for one operation.', 'Flag if a whipstock setting proceeds without a documented orientation and anchor verification record.', 1)
  ON CONFLICT (maturity_model_id, process_area) DO NOTHING;

  -- Q7: ofs_l3_3_4_2
  INSERT INTO questions (questionnaire_id, evaluation_type_id, domain_id, process_id,
    question_code, question_text, question_intent, instruction_text, evidence_examples,
    alert_rule_hint, mapped_maturity_model_id, mapped_maturity_statement_id, matched_process_area, sort_order)
  SELECT v_questionnaire_id, v_eval_type_id, v_domain_id, p.id,
    'ofs_l3_3_4_2', 'How mature is the organization''s process for designing, reviewing and verifying the bottomhole assembly (BHA) configuration for each drilling run?', 'Assess whether BHA configuration is engineered against the well plan (directional, hydraulic, torque/drag requirements) and reviewed before each run, versus assembled from habit.', 'Review the BHA design document, the engineering review/approval record, and the as-run BHA tally confirming it matches the approved design.', 'BHA design document; engineering review/approval sign-off; as-run BHA tally.',
    'Flag if the as-run BHA tally does not match the approved BHA design with no documented deviation approval.', 'ofs_mm_l1_3', 'ofs_l3_3_4_2', 'ofs_l3_3_4_2', 2
  FROM processes p WHERE p.code = 'ofs_l2_3_4';

  INSERT INTO maturity_statements (maturity_model_id, domain_title, process_area,
    level_1_basic, level_2_developing, level_3_established, level_4_advanced, level_5_leading,
    assessor_instruction, evidence_examples, review_steps, alert_rule_hint, sort_order)
  VALUES ('ofs_mm_l1_3', 'Drill The Well', 'ofs_l3_3_4_2',
    'BHA is assembled from habit with no documented design or review.', 'A BHA design is produced for major runs but engineering review and as-run verification are inconsistent.', 'Every BHA run has a documented, engineering-reviewed design and a verified as-run tally matching it (or an approved deviation).', 'BHA performance (directional accuracy, failures) is tracked across runs to refine design standards.', 'BHA design is integrated with real-time drilling optimization software, enabling dynamic configuration adjustment and continuous performance benchmarking.',
    'Ask for the BHA design and as-run tally of the most recent drilling run and confirm they match or any deviation is approved.', 'BHA design document; engineering review/approval sign-off; as-run BHA tally.', 'Compare one BHA''s approved design against its as-run tally and confirm consistency or a documented, approved deviation.', 'Flag if the as-run BHA tally does not match the approved BHA design with no documented deviation approval.', 2)
  ON CONFLICT (maturity_model_id, process_area) DO NOTHING;

  -- Q8: ofs_l3_3_4_3
  INSERT INTO questions (questionnaire_id, evaluation_type_id, domain_id, process_id,
    question_code, question_text, question_intent, instruction_text, evidence_examples,
    alert_rule_hint, mapped_maturity_model_id, mapped_maturity_statement_id, matched_process_area, sort_order)
  SELECT v_questionnaire_id, v_eval_type_id, v_domain_id, p.id,
    'ofs_l3_3_4_3', 'How mature is the organization''s process for operating and calibrating three-dimensional directional measuring devices (survey tools) used to control wellbore placement?', 'Assess whether survey tools are calibrated and their readings quality-controlled against a defined error model, versus trusted without verification.', 'Review the survey tool calibration record, the survey QC process (including error model/correction application), and the survey log for a recent well.', 'Survey tool calibration certificate; survey QC procedure and error-model documentation; well survey log.',
    'Flag if directional surveys are accepted into the official well record without a documented QC/error-model check.', 'ofs_mm_l1_3', 'ofs_l3_3_4_3', 'ofs_l3_3_4_3', 3
  FROM processes p WHERE p.code = 'ofs_l2_3_4';

  INSERT INTO maturity_statements (maturity_model_id, domain_title, process_area,
    level_1_basic, level_2_developing, level_3_established, level_4_advanced, level_5_leading,
    assessor_instruction, evidence_examples, review_steps, alert_rule_hint, sort_order)
  VALUES ('ofs_mm_l1_3', 'Drill The Well', 'ofs_l3_3_4_3',
    'Survey tools are used without documented calibration or QC of readings.', 'Calibration records exist but survey QC/error-model application is inconsistent.', 'Survey tools are calibrated on a defined schedule and every survey is QC''d against a documented error model before acceptance.', 'Survey accuracy and tool performance are tracked across wells to refine tool selection and QC thresholds.', 'Directional surveying is integrated with continuous real-time position uncertainty modeling across the well portfolio.',
    'Ask for the calibration certificate of the survey tool used on the current well and confirm the survey QC log references the applicable error model.', 'Survey tool calibration certificate; survey QC procedure and error-model documentation; well survey log.', 'Confirm the survey tool''s calibration is current and that a sampled survey station passed the documented QC process.', 'Flag if directional surveys are accepted into the official well record without a documented QC/error-model check.', 3)
  ON CONFLICT (maturity_model_id, process_area) DO NOTHING;

  -- Q9: ofs_l3_3_4_4
  INSERT INTO questions (questionnaire_id, evaluation_type_id, domain_id, process_id,
    question_code, question_text, question_intent, instruction_text, evidence_examples,
    alert_rule_hint, mapped_maturity_model_id, mapped_maturity_statement_id, matched_process_area, sort_order)
  SELECT v_questionnaire_id, v_eval_type_id, v_domain_id, p.id,
    'ofs_l3_3_4_4', 'How mature is the organization''s process for selecting, monitoring and evaluating the performance of mud motors used for directional drilling?', 'Assess whether mud motor selection and performance are matched to formation/hydraulic requirements and tracked, versus used generically regardless of application.', 'Review the mud motor selection rationale (bend setting, power section, formation match), the run performance log (ROP, differential pressure, failure history), and post-run teardown/inspection findings.', 'Mud motor selection rationale; run performance log; post-run teardown/inspection report.',
    'Flag if a mud motor failure occurs with no documented post-run teardown/inspection finding.', 'ofs_mm_l1_3', 'ofs_l3_3_4_4', 'ofs_l3_3_4_4', 4
  FROM processes p WHERE p.code = 'ofs_l2_3_4';

  INSERT INTO maturity_statements (maturity_model_id, domain_title, process_area,
    level_1_basic, level_2_developing, level_3_established, level_4_advanced, level_5_leading,
    assessor_instruction, evidence_examples, review_steps, alert_rule_hint, sort_order)
  VALUES ('ofs_mm_l1_3', 'Drill The Well', 'ofs_l3_3_4_4',
    'Mud motors are selected and run without documented rationale or performance tracking.', 'A run log is kept but selection rationale and teardown inspection are inconsistently documented.', 'Mud motor selection is documented and matched to formation/hydraulic requirements, with performance and teardown findings recorded for every run.', 'Motor performance and failure trends are analyzed across wells to refine selection and vendor performance management.', 'Mud motor selection and performance monitoring are integrated with real-time drilling optimization and predictive failure analytics.',
    'Ask for the post-run teardown/inspection report of the most recent mud motor run and confirm findings were reviewed against the selection rationale.', 'Mud motor selection rationale; run performance log; post-run teardown/inspection report.', 'Trace one mud motor run from selection rationale through the performance log to the post-run teardown report.', 'Flag if a mud motor failure occurs with no documented post-run teardown/inspection finding.', 4)
  ON CONFLICT (maturity_model_id, process_area) DO NOTHING;

  -- Q10: ofs_l3_3_5_1
  INSERT INTO questions (questionnaire_id, evaluation_type_id, domain_id, process_id,
    question_code, question_text, question_intent, instruction_text, evidence_examples,
    alert_rule_hint, mapped_maturity_model_id, mapped_maturity_statement_id, matched_process_area, sort_order)
  SELECT v_questionnaire_id, v_eval_type_id, v_domain_id, p.id,
    'ofs_l3_3_5_1', 'How mature is the organization''s process for planning and executing impression block runs to identify fish top condition and orientation during fishing operations?', 'Assess whether impression block operations are planned against known fish data and the resulting impressions are formally interpreted to inform the fishing tool selection, versus run as a routine step without documented interpretation.', 'Review the fish data (type, condition, top depth) used to plan the impression run, the impression block interpretation record, and how it informed the subsequent fishing tool selection.', 'Fish data/well history record; impression block interpretation report; fishing tool selection memo referencing the impression.',
    'Flag if a fishing tool is selected without a documented impression block interpretation on file.', 'ofs_mm_l1_3', 'ofs_l3_3_5_1', 'ofs_l3_3_5_1', 1
  FROM processes p WHERE p.code = 'ofs_l2_3_5';

  INSERT INTO maturity_statements (maturity_model_id, domain_title, process_area,
    level_1_basic, level_2_developing, level_3_established, level_4_advanced, level_5_leading,
    assessor_instruction, evidence_examples, review_steps, alert_rule_hint, sort_order)
  VALUES ('ofs_mm_l1_3', 'Drill The Well', 'ofs_l3_3_5_1',
    'Impression block runs are performed with no documented interpretation or link to fishing tool selection.', 'Impressions are recorded but interpretation quality and use in tool selection are inconsistent.', 'Every impression block run is formally interpreted and documented, with the fishing tool selection explicitly referencing the interpretation.', 'Impression interpretation accuracy is reviewed against actual fishing outcomes to improve interpretation skills.', 'Fishing operations planning is integrated with a digital fish-history database enabling rapid, standardized interpretation across the operator''s wells.',
    'Ask for the impression block interpretation record of the most recent fishing job and confirm the fishing tool selection memo references it.', 'Fish data/well history record; impression block interpretation report; fishing tool selection memo referencing the impression.', 'Confirm one fishing job''s tool selection memo cites the impression block interpretation and fish data on file.', 'Flag if a fishing tool is selected without a documented impression block interpretation on file.', 1)
  ON CONFLICT (maturity_model_id, process_area) DO NOTHING;

  -- Q11: ofs_l3_3_5_2
  INSERT INTO questions (questionnaire_id, evaluation_type_id, domain_id, process_id,
    question_code, question_text, question_intent, instruction_text, evidence_examples,
    alert_rule_hint, mapped_maturity_model_id, mapped_maturity_statement_id, matched_process_area, sort_order)
  SELECT v_questionnaire_id, v_eval_type_id, v_domain_id, p.id,
    'ofs_l3_3_5_2', 'How mature is the organization''s process for planning, executing and QC''ing cased-hole and open-hole logging operations?', 'Assess whether logging operations follow a documented program with tool calibration and log QC before data is used for decisions, versus accepted as delivered without review.', 'Review the logging program, tool calibration records, and the log QC/sign-off process before logs are released for interpretation or decision-making.', 'Logging program/tool specification; calibration records; log QC/sign-off report.',
    'Flag if logs are used for a completion or casing decision without a documented QC sign-off.', 'ofs_mm_l1_3', 'ofs_l3_3_5_2', 'ofs_l3_3_5_2', 2
  FROM processes p WHERE p.code = 'ofs_l2_3_5';

  INSERT INTO maturity_statements (maturity_model_id, domain_title, process_area,
    level_1_basic, level_2_developing, level_3_established, level_4_advanced, level_5_leading,
    assessor_instruction, evidence_examples, review_steps, alert_rule_hint, sort_order)
  VALUES ('ofs_mm_l1_3', 'Drill The Well', 'ofs_l3_3_5_2',
    'Logging is performed with no documented program, calibration record or QC sign-off.', 'A logging program exists but calibration and QC sign-off are inconsistently documented.', 'Logging follows a documented program with tool calibration and formal QC sign-off before logs are used for decisions.', 'Log quality metrics and tool performance are tracked across wells to refine vendor and tool selection.', 'Logging operations are integrated with a real-time petrophysical QC and interpretation platform across the well portfolio.',
    'Ask for the QC sign-off of the most recently run log and confirm it precedes the decision (casing/completion) it supported.', 'Logging program/tool specification; calibration records; log QC/sign-off report.', 'Confirm one logging run''s calibration record and QC sign-off both exist and precede its use in a documented decision.', 'Flag if logs are used for a completion or casing decision without a documented QC sign-off.', 2)
  ON CONFLICT (maturity_model_id, process_area) DO NOTHING;

  -- Q12: ofs_l3_3_6_1
  INSERT INTO questions (questionnaire_id, evaluation_type_id, domain_id, process_id,
    question_code, question_text, question_intent, instruction_text, evidence_examples,
    alert_rule_hint, mapped_maturity_model_id, mapped_maturity_statement_id, matched_process_area, sort_order)
  SELECT v_questionnaire_id, v_eval_type_id, v_domain_id, p.id,
    'ofs_l3_3_6_1', 'How mature is the organization''s process for operating, monitoring and QC''ing measurement-while-drilling (MWD) tools during the well program?', 'Assess whether MWD data quality (signal integrity, calibration, survey QC) is actively monitored during drilling, versus accepted without review until a problem forces attention.', 'Review the MWD tool calibration record, the real-time data QC process during drilling, and the survey/data quality log for a recent well.', 'MWD tool calibration certificate; real-time data QC log; MWD survey quality report.',
    'Flag if MWD survey data with a flagged quality issue is used for wellbore placement without documented resolution.', 'ofs_mm_l1_3', 'ofs_l3_3_6_1', 'ofs_l3_3_6_1', 1
  FROM processes p WHERE p.code = 'ofs_l2_3_6';

  INSERT INTO maturity_statements (maturity_model_id, domain_title, process_area,
    level_1_basic, level_2_developing, level_3_established, level_4_advanced, level_5_leading,
    assessor_instruction, evidence_examples, review_steps, alert_rule_hint, sort_order)
  VALUES ('ofs_mm_l1_3', 'Drill The Well', 'ofs_l3_3_6_1',
    'MWD data is used without documented calibration or quality monitoring.', 'Calibration records exist but real-time data quality monitoring is inconsistent.', 'MWD tools are calibrated and data quality is actively monitored and QC''d in real time for every well.', 'MWD data quality and tool reliability are tracked across wells to refine tool and vendor selection.', 'MWD operations are integrated with automated real-time data quality analytics and predictive tool-failure alerts across the fleet.',
    'Ask for the real-time data QC log of the current or most recent well and confirm any flagged data quality issue was resolved and documented.', 'MWD tool calibration certificate; real-time data QC log; MWD survey quality report.', 'Confirm the MWD calibration certificate is current and that a sampled survey station passed real-time QC.', 'Flag if MWD survey data with a flagged quality issue is used for wellbore placement without documented resolution.', 1)
  ON CONFLICT (maturity_model_id, process_area) DO NOTHING;

  -- Q13: ofs_l3_3_6_2
  INSERT INTO questions (questionnaire_id, evaluation_type_id, domain_id, process_id,
    question_code, question_text, question_intent, instruction_text, evidence_examples,
    alert_rule_hint, mapped_maturity_model_id, mapped_maturity_statement_id, matched_process_area, sort_order)
  SELECT v_questionnaire_id, v_eval_type_id, v_domain_id, p.id,
    'ofs_l3_3_6_2', 'How mature is the organization''s process for operating, monitoring and QC''ing logging-while-drilling (LWD) tools during the well program?', 'Assess whether LWD data (resistivity, gamma, density/neutron) is quality-controlled in real time and formally reconciled against offset/pre-drill models, versus used as-delivered without review.', 'Review the LWD tool calibration record, the real-time data QC process, and the reconciliation of LWD data against pre-drill formation predictions.', 'LWD tool calibration certificate; real-time data QC log; LWD-to-prognosis reconciliation report.',
    'Flag if a significant LWD-to-prognosis discrepancy has no documented review or resulting action.', 'ofs_mm_l1_3', 'ofs_l3_3_6_2', 'ofs_l3_3_6_2', 2
  FROM processes p WHERE p.code = 'ofs_l2_3_6';

  INSERT INTO maturity_statements (maturity_model_id, domain_title, process_area,
    level_1_basic, level_2_developing, level_3_established, level_4_advanced, level_5_leading,
    assessor_instruction, evidence_examples, review_steps, alert_rule_hint, sort_order)
  VALUES ('ofs_mm_l1_3', 'Drill The Well', 'ofs_l3_3_6_2',
    'LWD data is used without documented calibration, QC or reconciliation against pre-drill predictions.', 'Calibration and QC exist but reconciliation against pre-drill prognosis is inconsistent.', 'LWD data is calibrated, QC''d in real time, and formally reconciled against pre-drill prognosis for every well.', 'LWD data quality and prognosis-accuracy trends are tracked across wells to refine pre-drill formation modeling.', 'LWD operations are integrated with a continuously updated subsurface model, enabling real-time geosteering decisions from reconciled data.',
    'Ask for the LWD-to-prognosis reconciliation report for the most recent well and confirm any significant discrepancy was reviewed.', 'LWD tool calibration certificate; real-time data QC log; LWD-to-prognosis reconciliation report.', 'Confirm the LWD calibration certificate is current and that the prognosis reconciliation report is on file for one well.', 'Flag if a significant LWD-to-prognosis discrepancy has no documented review or resulting action.', 2)
  ON CONFLICT (maturity_model_id, process_area) DO NOTHING;

  -- Q14: ofs_l3_3_6_3
  INSERT INTO questions (questionnaire_id, evaluation_type_id, domain_id, process_id,
    question_code, question_text, question_intent, instruction_text, evidence_examples,
    alert_rule_hint, mapped_maturity_model_id, mapped_maturity_statement_id, matched_process_area, sort_order)
  SELECT v_questionnaire_id, v_eval_type_id, v_domain_id, p.id,
    'ofs_l3_3_6_3', 'How mature is the organization''s geosteering process for maintaining wellbore placement within a target zone using real-time formation data?', 'Assess whether geosteering decisions follow a documented workflow with defined roles (geosteering geologist, directional driller) and decision log, versus informal real-time calls with no record.', 'Review the geosteering plan (target zone, decision triggers), the real-time geosteering decision log, and the post-well comparison of actual well path against the target zone.', 'Geosteering plan/target zone definition; real-time geosteering decision log; post-well landing/placement report.',
    'Flag if a significant geosteering course-correction decision has no documented rationale in the decision log.', 'ofs_mm_l1_3', 'ofs_l3_3_6_3', 'ofs_l3_3_6_3', 3
  FROM processes p WHERE p.code = 'ofs_l2_3_6';

  INSERT INTO maturity_statements (maturity_model_id, domain_title, process_area,
    level_1_basic, level_2_developing, level_3_established, level_4_advanced, level_5_leading,
    assessor_instruction, evidence_examples, review_steps, alert_rule_hint, sort_order)
  VALUES ('ofs_mm_l1_3', 'Drill The Well', 'ofs_l3_3_6_3',
    'Geosteering decisions are made informally with no documented plan or decision log.', 'A target zone plan exists but the real-time decision log is incomplete or inconsistent.', 'Geosteering follows a documented plan with a maintained real-time decision log and post-well placement report for every well.', 'Zone placement performance (% in-zone) is tracked across wells and used to refine geosteering criteria.', 'Geosteering is integrated with automated real-time formation modeling and decision-support tools, continuously optimizing placement across the well program.',
    'Ask for the post-well placement report of the most recent geosteered well and confirm the percentage of lateral in-zone is documented and reconciled against the decision log.', 'Geosteering plan/target zone definition; real-time geosteering decision log; post-well landing/placement report.', 'Confirm the geosteering decision log for one well documents the rationale for each significant course correction.', 'Flag if a significant geosteering course-correction decision has no documented rationale in the decision log.', 3)
  ON CONFLICT (maturity_model_id, process_area) DO NOTHING;

  -- Q15: ofs_l3_3_6_4
  INSERT INTO questions (questionnaire_id, evaluation_type_id, domain_id, process_id,
    question_code, question_text, question_intent, instruction_text, evidence_examples,
    alert_rule_hint, mapped_maturity_model_id, mapped_maturity_statement_id, matched_process_area, sort_order)
  SELECT v_questionnaire_id, v_eval_type_id, v_domain_id, p.id,
    'ofs_l3_3_6_4', 'How mature is the organization''s process for planning, executing and preserving core samples taken during drilling?', 'Assess whether coring operations follow a documented program with chain-of-custody and preservation protocols, versus samples being taken without a clear plan for their subsequent use.', 'Review the coring program (interval, tool, objectives), the core recovery/handling log, and the chain-of-custody/preservation record through to laboratory receipt.', 'Coring program; core recovery and handling log; chain-of-custody record; laboratory receipt confirmation.',
    'Flag if a core sample''s chain-of-custody record has a gap between rig-site recovery and laboratory receipt.', 'ofs_mm_l1_3', 'ofs_l3_3_6_4', 'ofs_l3_3_6_4', 4
  FROM processes p WHERE p.code = 'ofs_l2_3_6';

  INSERT INTO maturity_statements (maturity_model_id, domain_title, process_area,
    level_1_basic, level_2_developing, level_3_established, level_4_advanced, level_5_leading,
    assessor_instruction, evidence_examples, review_steps, alert_rule_hint, sort_order)
  VALUES ('ofs_mm_l1_3', 'Drill The Well', 'ofs_l3_3_6_4',
    'Coring is performed without a documented program or chain-of-custody record.', 'A coring program exists but chain-of-custody and preservation records are inconsistently maintained.', 'Coring follows a documented program with a complete chain-of-custody and preservation record through to laboratory receipt, for every core.', 'Core recovery rates and data quality are tracked across wells to refine coring technique and tool selection.', 'Coring operations are integrated with a digital sample-tracking system providing real-time chain-of-custody visibility across the operator''s laboratories.',
    'Ask for the chain-of-custody record of the most recently taken core and confirm there is no unexplained gap between recovery and laboratory receipt.', 'Coring program; core recovery and handling log; chain-of-custody record; laboratory receipt confirmation.', 'Trace one core sample from the coring program through recovery, handling and chain-of-custody to laboratory receipt.', 'Flag if a core sample''s chain-of-custody record has a gap between rig-site recovery and laboratory receipt.', 4)
  ON CONFLICT (maturity_model_id, process_area) DO NOTHING;

  -- Q16: ofs_l3_3_7_1
  INSERT INTO questions (questionnaire_id, evaluation_type_id, domain_id, process_id,
    question_code, question_text, question_intent, instruction_text, evidence_examples,
    alert_rule_hint, mapped_maturity_model_id, mapped_maturity_statement_id, matched_process_area, sort_order)
  SELECT v_questionnaire_id, v_eval_type_id, v_domain_id, p.id,
    'ofs_l3_3_7_1', 'How mature is the organization''s process for planning, executing and verifying well cementing (casing/liner cement jobs)?', 'Assess whether cementing operations follow an engineered design with post-job verification (bond log, pressure test), versus executed as a routine step with no confirmation of integrity.', 'Review the cement job design (slurry properties, volumes, placement plan), the real-time job execution log (pressures, returns), and the post-job verification (cement bond log or pressure test).', 'Cement job design/slurry report; real-time job execution log; cement bond log or pressure test result.',
    'Flag if the well proceeds to the next phase without a documented cement integrity verification (bond log or pressure test).', 'ofs_mm_l1_3', 'ofs_l3_3_7_1', 'ofs_l3_3_7_1', 1
  FROM processes p WHERE p.code = 'ofs_l2_3_7';

  INSERT INTO maturity_statements (maturity_model_id, domain_title, process_area,
    level_1_basic, level_2_developing, level_3_established, level_4_advanced, level_5_leading,
    assessor_instruction, evidence_examples, review_steps, alert_rule_hint, sort_order)
  VALUES ('ofs_mm_l1_3', 'Drill The Well', 'ofs_l3_3_7_1',
    'Cementing is executed without a documented design or post-job verification.', 'A cement design exists but post-job verification is inconsistently performed or documented.', 'Every cement job has a documented design, execution log and post-job integrity verification before proceeding to the next phase.', 'Cement job performance (bond quality, remedial rate) is tracked across wells to refine slurry design and job execution.', 'Cementing operations are integrated with real-time cement placement simulation and automated integrity verification analytics.',
    'Ask for the cement bond log or pressure test result of the most recent casing string and confirm it was reviewed before drilling ahead.', 'Cement job design/slurry report; real-time job execution log; cement bond log or pressure test result.', 'Trace one cement job from design through execution log to a documented integrity verification result.', 'Flag if the well proceeds to the next phase without a documented cement integrity verification (bond log or pressure test).', 1)
  ON CONFLICT (maturity_model_id, process_area) DO NOTHING;

  -- Q17: ofs_l3_3_7_2
  INSERT INTO questions (questionnaire_id, evaluation_type_id, domain_id, process_id,
    question_code, question_text, question_intent, instruction_text, evidence_examples,
    alert_rule_hint, mapped_maturity_model_id, mapped_maturity_statement_id, matched_process_area, sort_order)
  SELECT v_questionnaire_id, v_eval_type_id, v_domain_id, p.id,
    'ofs_l3_3_7_2', 'How mature is the organization''s process for evaluating and selecting cementing technologies (additives, spacers, centralization, specialty slurries) appropriate to well conditions?', 'Distinguish this from the cementing execution above by focusing on the technology-selection decision: whether slurry/additive/centralization technology is matched to specific well conditions (temperature, pressure, formation) through documented analysis.', 'Review the technology selection rationale (lab test data, well condition analysis) for the slurry system, additives, spacers and centralization program used on a recent well.', 'Cementing technology selection rationale; laboratory slurry test report; centralization program design.',
    'Flag if a specialty well condition (e.g., high temperature, narrow margin) proceeds with a standard slurry system with no documented suitability analysis.', 'ofs_mm_l1_3', 'ofs_l3_3_7_2', 'ofs_l3_3_7_2', 2
  FROM processes p WHERE p.code = 'ofs_l2_3_7';

  INSERT INTO maturity_statements (maturity_model_id, domain_title, process_area,
    level_1_basic, level_2_developing, level_3_established, level_4_advanced, level_5_leading,
    assessor_instruction, evidence_examples, review_steps, alert_rule_hint, sort_order)
  VALUES ('ofs_mm_l1_3', 'Drill The Well', 'ofs_l3_3_7_2',
    'Cementing technology is selected by default with no documented well-condition analysis.', 'Technology selection is analyzed for major wells but not consistently documented across the well program.', 'Cementing technology selection is documented and matched to well conditions through laboratory testing and centralization design for every well.', 'Technology performance is tracked across wells to refine the standard technology matrix.', 'Cementing technology selection is optimized through a continuously updated technology-performance database integrated with well planning software.',
    'Ask for the laboratory slurry test report and centralization design for the most recent well and confirm they reference the well''s specific conditions.', 'Cementing technology selection rationale; laboratory slurry test report; centralization program design.', 'Confirm one well''s cementing technology selection rationale is documented and traceable to its specific downhole conditions.', 'Flag if a specialty well condition (e.g., high temperature, narrow margin) proceeds with a standard slurry system with no documented suitability analysis.', 2)
  ON CONFLICT (maturity_model_id, process_area) DO NOTHING;

  -- Q18: ofs_l3_3_8_1
  INSERT INTO questions (questionnaire_id, evaluation_type_id, domain_id, process_id,
    question_code, question_text, question_intent, instruction_text, evidence_examples,
    alert_rule_hint, mapped_maturity_model_id, mapped_maturity_statement_id, matched_process_area, sort_order)
  SELECT v_questionnaire_id, v_eval_type_id, v_domain_id, p.id,
    'ofs_l3_3_8_1', 'How mature is the organization''s process for classifying and documenting the drilling mud system used for each well or hole section?', 'Assess whether mud system classification (water-based, oil-based, synthetic, specific formulation) is documented against the well program''s technical and environmental requirements, versus selected informally.', 'Review the mud program document specifying the classification and rationale for each hole section, and confirm alignment with environmental/regulatory requirements for the mud type used.', 'Mud program document; mud classification rationale; environmental/regulatory compliance reference for the selected mud type.',
    'Flag if the mud type used in a section does not match the classification specified in the approved mud program.', 'ofs_mm_l1_3', 'ofs_l3_3_8_1', 'ofs_l3_3_8_1', 1
  FROM processes p WHERE p.code = 'ofs_l2_3_8';

  INSERT INTO maturity_statements (maturity_model_id, domain_title, process_area,
    level_1_basic, level_2_developing, level_3_established, level_4_advanced, level_5_leading,
    assessor_instruction, evidence_examples, review_steps, alert_rule_hint, sort_order)
  VALUES ('ofs_mm_l1_3', 'Drill The Well', 'ofs_l3_3_8_1',
    'Mud type is selected informally with no documented classification or rationale.', 'A mud program exists but classification rationale and regulatory alignment are inconsistently documented.', 'Every hole section has a documented mud classification and rationale, verified against regulatory requirements, before use.', 'Mud system performance by classification is tracked across wells to refine the standard mud program templates.', 'Mud classification and selection are integrated with a formation-database-driven mud engineering platform, continuously optimized across the well portfolio.',
    'Ask for the mud program of the current well and confirm the mud type in use in each section matches the documented classification.', 'Mud program document; mud classification rationale; environmental/regulatory compliance reference for the selected mud type.', 'Compare the approved mud program''s classification against the mud type actually reported in use for one well.', 'Flag if the mud type used in a section does not match the classification specified in the approved mud program.', 1)
  ON CONFLICT (maturity_model_id, process_area) DO NOTHING;

  -- Q19: ofs_l3_3_8_2
  INSERT INTO questions (questionnaire_id, evaluation_type_id, domain_id, process_id,
    question_code, question_text, question_intent, instruction_text, evidence_examples,
    alert_rule_hint, mapped_maturity_model_id, mapped_maturity_statement_id, matched_process_area, sort_order)
  SELECT v_questionnaire_id, v_eval_type_id, v_domain_id, p.id,
    'ofs_l3_3_8_2', 'How mature is the organization''s process for deploying and managing the mud system (surface equipment, circulation, solids control) during drilling operations?', 'Assess whether the mud system is actively managed against defined hydraulic and solids-control targets, versus run reactively based on visual inspection alone.', 'Review the mud system operating parameters (circulation rate, solids control targets), the daily mud engineering report, and evidence of corrective action when parameters deviated from target.', 'Mud system operating parameters/hydraulics program; daily mud engineering report; corrective action log for parameter deviations.',
    'Flag if mud properties deviate from the program''s specified range with no documented corrective action.', 'ofs_mm_l1_3', 'ofs_l3_3_8_2', 'ofs_l3_3_8_2', 2
  FROM processes p WHERE p.code = 'ofs_l2_3_8';

  INSERT INTO maturity_statements (maturity_model_id, domain_title, process_area,
    level_1_basic, level_2_developing, level_3_established, level_4_advanced, level_5_leading,
    assessor_instruction, evidence_examples, review_steps, alert_rule_hint, sort_order)
  VALUES ('ofs_mm_l1_3', 'Drill The Well', 'ofs_l3_3_8_2',
    'Mud system parameters are monitored informally with no documented targets or daily reporting.', 'A daily mud report is produced but deviations from target parameters are not consistently addressed.', 'Mud system parameters are actively managed against documented targets, with a daily report and corrective action log maintained for every well.', 'Mud system performance data is analyzed across wells to refine hydraulics programs and solids-control equipment selection.', 'Mud system management is integrated with real-time automated hydraulics monitoring and predictive solids-control optimization across the rig fleet.',
    'Ask for the daily mud engineering report of the current well and confirm any parameter deviation from the program has a documented corrective action.', 'Mud system operating parameters/hydraulics program; daily mud engineering report; corrective action log for parameter deviations.', 'Sample one daily mud report and confirm reported parameters were compared against program targets with corrective action where needed.', 'Flag if mud properties deviate from the program''s specified range with no documented corrective action.', 2)
  ON CONFLICT (maturity_model_id, process_area) DO NOTHING;

  -- Q20: ofs_l3_3_8_3
  INSERT INTO questions (questionnaire_id, evaluation_type_id, domain_id, process_id,
    question_code, question_text, question_intent, instruction_text, evidence_examples,
    alert_rule_hint, mapped_maturity_model_id, mapped_maturity_statement_id, matched_process_area, sort_order)
  SELECT v_questionnaire_id, v_eval_type_id, v_domain_id, p.id,
    'ofs_l3_3_8_3', 'How mature is the organization''s process for managing and adjusting mud composition (chemical treatment, additive dosing) to maintain properties within the mud program?', 'Assess whether mud composition changes are made against documented lab test results and treatment plans, versus ad hoc additions based on field judgment alone.', 'Review the mud composition/treatment log, the laboratory test results supporting composition adjustments, and the approval process for significant chemical treatment changes.', 'Mud composition/treatment log; laboratory test results; chemical treatment change approval record.',
    'Flag if a significant chemical treatment change is made without a documented laboratory test or approval.', 'ofs_mm_l1_3', 'ofs_l3_3_8_3', 'ofs_l3_3_8_3', 3
  FROM processes p WHERE p.code = 'ofs_l2_3_8';

  INSERT INTO maturity_statements (maturity_model_id, domain_title, process_area,
    level_1_basic, level_2_developing, level_3_established, level_4_advanced, level_5_leading,
    assessor_instruction, evidence_examples, review_steps, alert_rule_hint, sort_order)
  VALUES ('ofs_mm_l1_3', 'Drill The Well', 'ofs_l3_3_8_3',
    'Mud composition is adjusted informally based on field judgment with no documented test results.', 'Lab testing occurs periodically but is not consistently linked to composition adjustment decisions.', 'Mud composition adjustments are based on documented laboratory test results and approved through a defined process for every well.', 'Composition adjustment patterns and chemical usage are analyzed across wells to optimize treatment programs and costs.', 'Mud composition management is integrated with real-time automated chemical dosing and predictive treatment optimization across the rig fleet.',
    'Ask for the laboratory test results supporting the most recent significant mud composition adjustment and confirm the change was approved before implementation.', 'Mud composition/treatment log; laboratory test results; chemical treatment change approval record.', 'Trace one significant mud composition change from laboratory test results through to documented approval and implementation.', 'Flag if a significant chemical treatment change is made without a documented laboratory test or approval.', 3)
  ON CONFLICT (maturity_model_id, process_area) DO NOTHING;

  -- Q21: ofs_l3_3_8_4
  INSERT INTO questions (questionnaire_id, evaluation_type_id, domain_id, process_id,
    question_code, question_text, question_intent, instruction_text, evidence_examples,
    alert_rule_hint, mapped_maturity_model_id, mapped_maturity_statement_id, matched_process_area, sort_order)
  SELECT v_questionnaire_id, v_eval_type_id, v_domain_id, p.id,
    'ofs_l3_3_8_4', 'How mature is the organization''s process for maintaining and operating mud mixing equipment (hoppers, mixers, pumps) to ensure reliable and accurate mud preparation?', 'Assess whether mixing equipment is maintained to a documented schedule and calibrated for accurate dosing, versus operated until it visibly fails.', 'Review the mixing equipment maintenance schedule, calibration records for dosing/metering equipment, and the equipment downtime/failure log.', 'Mixing equipment maintenance schedule and records; calibration certificates for metering equipment; equipment downtime/failure log.',
    'Flag if mixing/metering equipment is in use with an expired or missing calibration record.', 'ofs_mm_l1_3', 'ofs_l3_3_8_4', 'ofs_l3_3_8_4', 4
  FROM processes p WHERE p.code = 'ofs_l2_3_8';

  INSERT INTO maturity_statements (maturity_model_id, domain_title, process_area,
    level_1_basic, level_2_developing, level_3_established, level_4_advanced, level_5_leading,
    assessor_instruction, evidence_examples, review_steps, alert_rule_hint, sort_order)
  VALUES ('ofs_mm_l1_3', 'Drill The Well', 'ofs_l3_3_8_4',
    'Mixing equipment is maintained reactively with no documented schedule or calibration records.', 'A maintenance schedule exists but calibration of metering equipment is inconsistently tracked.', 'Mixing equipment is maintained to a documented schedule and metering equipment is calibrated and verified current for every well.', 'Equipment downtime and failure trends are analyzed across the rig fleet to optimize maintenance intervals and equipment selection.', 'Mixing equipment management is integrated with a fleet-wide predictive maintenance and remote-monitoring system.',
    'Ask for the calibration certificate of the mixing/metering equipment currently in use and confirm it is within its calibration interval.', 'Mixing equipment maintenance schedule and records; calibration certificates for metering equipment; equipment downtime/failure log.', 'Confirm the maintenance schedule and calibration records for one piece of mixing equipment are current and consistent with the downtime log.', 'Flag if mixing/metering equipment is in use with an expired or missing calibration record.', 4)
  ON CONFLICT (maturity_model_id, process_area) DO NOTHING;

  -- Q22: ofs_l3_3_9_1
  INSERT INTO questions (questionnaire_id, evaluation_type_id, domain_id, process_id,
    question_code, question_text, question_intent, instruction_text, evidence_examples,
    alert_rule_hint, mapped_maturity_model_id, mapped_maturity_statement_id, matched_process_area, sort_order)
  SELECT v_questionnaire_id, v_eval_type_id, v_domain_id, p.id,
    'ofs_l3_3_9_1', 'How mature is the organization''s process for designing, approving and executing the casing program for a well?', 'Assess whether the casing program is engineered (design factors, connection selection, setting depths) and formally approved before running, versus based on a generic template applied without well-specific verification.', 'Review the casing design document (load cases, design factors, connection specification), the engineering approval record, and the running/landing report confirming execution matched the design.', 'Casing design document; engineering approval sign-off; casing running/landing report.',
    'Flag if a casing string is run without a documented, approved casing design specific to that well.', 'ofs_mm_l1_3', 'ofs_l3_3_9_1', 'ofs_l3_3_9_1', 1
  FROM processes p WHERE p.code = 'ofs_l2_3_9';

  INSERT INTO maturity_statements (maturity_model_id, domain_title, process_area,
    level_1_basic, level_2_developing, level_3_established, level_4_advanced, level_5_leading,
    assessor_instruction, evidence_examples, review_steps, alert_rule_hint, sort_order)
  VALUES ('ofs_mm_l1_3', 'Drill The Well', 'ofs_l3_3_9_1',
    'Casing programs are based on a generic template with no well-specific design or approval.', 'A casing design is produced for major wells but formal engineering approval is inconsistent.', 'Every casing string has a documented, well-specific design with engineering approval before running, and a landing report confirming execution.', 'Casing design performance (design factor margins actually realized, running issues) is tracked across wells to refine design standards.', 'Casing program design is integrated with automated well-integrity modeling and continuous design optimization across the well portfolio.',
    'Ask for the casing design and engineering approval of the current well''s most recently run string and confirm the landing report matches the design.', 'Casing design document; engineering approval sign-off; casing running/landing report.', 'Confirm the casing design, approval sign-off and landing report are all present and consistent for one string.', 'Flag if a casing string is run without a documented, approved casing design specific to that well.', 1)
  ON CONFLICT (maturity_model_id, process_area) DO NOTHING;

  -- Q23: ofs_l3_3_9_2
  INSERT INTO questions (questionnaire_id, evaluation_type_id, domain_id, process_id,
    question_code, question_text, question_intent, instruction_text, evidence_examples,
    alert_rule_hint, mapped_maturity_model_id, mapped_maturity_statement_id, matched_process_area, sort_order)
  SELECT v_questionnaire_id, v_eval_type_id, v_domain_id, p.id,
    'ofs_l3_3_9_2', 'How mature is the organization''s process for planning and executing liner running operations, including hanger setting and verification?', 'Assess whether liner running follows a documented procedure with hanger setting verification (pressure test, weight indicator confirmation), versus considered complete once the liner reaches depth.', 'Review the liner running procedure, the hanger setting/verification record (pressure test or mechanical confirmation), and the post-run integrity check.', 'Liner running procedure; hanger setting verification record; post-run pressure test or integrity check.',
    'Flag if a liner hanger setting has no documented pressure test or mechanical verification on file.', 'ofs_mm_l1_3', 'ofs_l3_3_9_2', 'ofs_l3_3_9_2', 2
  FROM processes p WHERE p.code = 'ofs_l2_3_9';

  INSERT INTO maturity_statements (maturity_model_id, domain_title, process_area,
    level_1_basic, level_2_developing, level_3_established, level_4_advanced, level_5_leading,
    assessor_instruction, evidence_examples, review_steps, alert_rule_hint, sort_order)
  VALUES ('ofs_mm_l1_3', 'Drill The Well', 'ofs_l3_3_9_2',
    'Liner running is executed without a documented procedure or hanger setting verification.', 'A running procedure exists but hanger setting verification is inconsistently documented.', 'Liner running follows a documented procedure with formal hanger setting verification and post-run integrity check for every liner.', 'Liner running performance (setting success rate, issues) is tracked across wells to refine procedures and equipment selection.', 'Liner running is integrated with real-time setting-tool telemetry and automated verification analytics across the well program.',
    'Ask for the hanger setting verification record of the most recently run liner and confirm it documents a positive pressure test or mechanical confirmation.', 'Liner running procedure; hanger setting verification record; post-run pressure test or integrity check.', 'Confirm one liner run''s setting verification record and post-run integrity check are both on file and consistent.', 'Flag if a liner hanger setting has no documented pressure test or mechanical verification on file.', 2)
  ON CONFLICT (maturity_model_id, process_area) DO NOTHING;

  -- Q24: ofs_l3_3_9_3
  INSERT INTO questions (questionnaire_id, evaluation_type_id, domain_id, process_id,
    question_code, question_text, question_intent, instruction_text, evidence_examples,
    alert_rule_hint, mapped_maturity_model_id, mapped_maturity_statement_id, matched_process_area, sort_order)
  SELECT v_questionnaire_id, v_eval_type_id, v_domain_id, p.id,
    'ofs_l3_3_9_3', 'How mature is the organization''s process for planning and executing liner tieback string operations to extend zonal isolation to surface?', 'Assess whether tieback operations are engineered (overlap design, seal assembly selection) and verified (pressure test of the tieback seal), versus executed without confirming the tieback achieved isolation.', 'Review the tieback design (overlap length, seal assembly specification), the running/landing record, and the post-run pressure test verifying the tieback seal.', 'Tieback design document; running/landing record; post-run pressure test result for the tieback seal.',
    'Flag if a tieback string is landed with no documented pressure test confirming the seal.', 'ofs_mm_l1_3', 'ofs_l3_3_9_3', 'ofs_l3_3_9_3', 3
  FROM processes p WHERE p.code = 'ofs_l2_3_9';

  INSERT INTO maturity_statements (maturity_model_id, domain_title, process_area,
    level_1_basic, level_2_developing, level_3_established, level_4_advanced, level_5_leading,
    assessor_instruction, evidence_examples, review_steps, alert_rule_hint, sort_order)
  VALUES ('ofs_mm_l1_3', 'Drill The Well', 'ofs_l3_3_9_3',
    'Tieback operations are executed without a documented design or seal verification.', 'A design exists but post-run seal verification is inconsistently performed or documented.', 'Every tieback string has a documented design, running record and a positive pressure test verifying the seal before proceeding.', 'Tieback performance (seal integrity success rate) is tracked across wells to refine seal assembly and overlap design standards.', 'Tieback design and verification are integrated with well-integrity modeling software, continuously optimized across the well portfolio.',
    'Ask for the post-run pressure test result of the most recently run tieback string and confirm it demonstrates a verified seal.', 'Tieback design document; running/landing record; post-run pressure test result for the tieback seal.', 'Confirm the tieback design, running record and post-run pressure test are all present and consistent for one string.', 'Flag if a tieback string is landed with no documented pressure test confirming the seal.', 3)
  ON CONFLICT (maturity_model_id, process_area) DO NOTHING;
END $$;
