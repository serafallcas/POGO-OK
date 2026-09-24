/*
# OFS Onshore L1.6 — Conduct Well Interventions and Workover Activities

1. Content added (purely additive)
   - 1 maturity model: ofs_mm_l1_6
   - 8 questions: ofs_l3_6_1_1, ofs_l3_6_1_2, ofs_l3_6_2_1, ofs_l3_6_3_1, ofs_l3_6_3_2, ofs_l3_6_4_1, ofs_l3_6_5_1, ofs_l3_6_6_1
   - 8 maturity statements (one per question)

2. Assumes evaluation_type 'ofs_onshore', questionnaire 'ofs_onshore_questionnaire',
   domain 'ofs_l1_6', and processes ofs_l2_6_1..ofs_l2_6_6 already exist.

3. No structural changes — data INSERT only with ON CONFLICT DO NOTHING for idempotency.
*/

DO $$
DECLARE
  v_questionnaire_id uuid;
  v_eval_type_id uuid;
  v_domain_id uuid;
BEGIN
  SELECT id INTO v_eval_type_id FROM evaluation_types WHERE code = 'ofs_onshore';
  SELECT id INTO v_questionnaire_id FROM questionnaires WHERE code = 'ofs_onshore_questionnaire';
  SELECT id INTO v_domain_id FROM domains WHERE code = 'ofs_l1_6';

  -- Maturity model
  INSERT INTO maturity_models (code, label, description, domain_id, mapped_domain_id, mapped_domain_name, version, source_workbook, is_active)
  VALUES ('ofs_mm_l1_6', 'Conduct Well Interventions and Workover Activities - Maturity Model', 'OFS Onshore maturity model for Conduct Well Interventions and Workover Activities', v_domain_id, 'ofs_l1_6', 'Conduct Well Interventions and Workover Activities', '1.0', 'POGO-OFS_Level_1-3_framework.pptx', true)
  ON CONFLICT (code) DO NOTHING;

  -- Q1: ofs_l3_6_1_1
  INSERT INTO questions (questionnaire_id, evaluation_type_id, domain_id, process_id,
    question_code, question_text, question_intent, instruction_text, evidence_examples,
    alert_rule_hint, mapped_maturity_model_id, mapped_maturity_statement_id, matched_process_area, sort_order)
  SELECT v_questionnaire_id, v_eval_type_id, v_domain_id, p.id,
    'ofs_l3_6_1_1',
    'How mature is the organization''s process for monitoring hydraulic fracture treatments during re-fracturing operations against a documented pumping schedule and real-time pressure/rate limits?',
    'Assess whether re-frac jobs are monitored in real time against a documented treatment schedule (pressure, rate, proppant concentration limits) with defined stop/deviate criteria, versus pumped with no real-time comparison to the design.',
    'Review the re-frac treatment schedule (planned pressure/rate/proppant curve) and the real-time job log or pumping chart for a recent re-frac, and confirm any deviation from the schedule (e.g., screen-out indicators, pressure spikes) has a documented response.',
    'Re-frac treatment schedule/design; real-time pumping chart or job log; deviation/screen-out response record.',
    'Flag if a re-frac job''s real-time pumping chart shows a significant deviation from the treatment schedule with no documented response.',
    'ofs_mm_l1_6', 'ofs_l3_6_1_1', 'ofs_l3_6_1_1', 1
  FROM processes p WHERE p.code = 'ofs_l2_6_1';

  INSERT INTO maturity_statements (maturity_model_id, domain_title, process_area,
    level_1_basic, level_2_developing, level_3_established, level_4_advanced, level_5_leading,
    assessor_instruction, evidence_examples, review_steps, alert_rule_hint, sort_order)
  VALUES ('ofs_mm_l1_6', 'Conduct Well Interventions and Workover Activities', 'ofs_l3_6_1_1',
    'Re-frac treatments are pumped with no documented schedule and no real-time monitoring against limits.',
    'A treatment schedule exists for major jobs but real-time deviations are not consistently reviewed or actioned.',
    'Every re-frac job has a documented treatment schedule with real-time monitoring, and deviations trigger a documented response.',
    'Treatment performance and deviation data are tracked across re-frac jobs to refine pumping schedules and screen-out avoidance.',
    'Fracture monitoring is integrated with real-time diagnostic modeling, enabling automated schedule adjustment during pumping.',
    'Ask for the treatment schedule and real-time job log of the most recent re-frac job and confirm any pressure/rate deviation has a documented response.',
    'Re-frac treatment schedule/design; real-time pumping chart or job log; deviation/screen-out response record.',
    'Confirm one re-frac job''s treatment schedule and real-time pumping chart are both on file and that any deviation shown was actioned.',
    'Flag if a re-frac job''s real-time pumping chart shows a significant deviation from the treatment schedule with no documented response.', 1)
  ON CONFLICT (maturity_model_id, process_area) DO NOTHING;

  -- Q2: ofs_l3_6_1_2
  INSERT INTO questions (questionnaire_id, evaluation_type_id, domain_id, process_id,
    question_code, question_text, question_intent, instruction_text, evidence_examples,
    alert_rule_hint, mapped_maturity_model_id, mapped_maturity_statement_id, matched_process_area, sort_order)
  SELECT v_questionnaire_id, v_eval_type_id, v_domain_id, p.id,
    'ofs_l3_6_1_2',
    'How mature is the organization''s process for using microseismic (or equivalent) monitoring to confirm fracture geometry and containment during re-fracturing operations?',
    'Assess whether re-frac fracture growth is verified against the target zone through documented microseismic (or offset-well/tiltmeter) monitoring, versus assumed without any geometry verification.',
    'Review the microseismic monitoring plan and the resulting fracture-mapping report for a recent re-frac job, and confirm the mapped fracture geometry was compared against the target zone and offset well spacing.',
    'Microseismic monitoring plan; fracture-mapping/geometry report; comparison against target zone and offset well spacing.',
    'Flag if microseismic mapping shows fracture growth outside the target zone or toward an offset well with no documented follow-up.',
    'ofs_mm_l1_6', 'ofs_l3_6_1_2', 'ofs_l3_6_1_2', 2
  FROM processes p WHERE p.code = 'ofs_l2_6_1';

  INSERT INTO maturity_statements (maturity_model_id, domain_title, process_area,
    level_1_basic, level_2_developing, level_3_established, level_4_advanced, level_5_leading,
    assessor_instruction, evidence_examples, review_steps, alert_rule_hint, sort_order)
  VALUES ('ofs_mm_l1_6', 'Conduct Well Interventions and Workover Activities', 'ofs_l3_6_1_2',
    'Fracture geometry is not monitored or verified during re-frac operations.',
    'Monitoring is performed for major jobs but the resulting geometry is not consistently compared against the target zone.',
    'Every re-frac job has documented microseismic monitoring with the resulting geometry compared against the target zone and offset wells.',
    'Fracture geometry data is analyzed across jobs to refine stage spacing and re-frac candidate selection.',
    'Microseismic monitoring is integrated with real-time geomechanical modeling to actively steer treatment design during pumping.',
    'Ask for the fracture-mapping report of the most recent re-frac job and confirm the mapped geometry was compared against the target zone.',
    'Microseismic monitoring plan; fracture-mapping/geometry report; comparison against target zone and offset well spacing.',
    'Confirm one re-frac job''s microseismic monitoring plan and resulting mapping report are both on file and show a documented comparison to the target zone.',
    'Flag if microseismic mapping shows fracture growth outside the target zone or toward an offset well with no documented follow-up.', 2)
  ON CONFLICT (maturity_model_id, process_area) DO NOTHING;

  -- Q3: ofs_l3_6_2_1
  INSERT INTO questions (questionnaire_id, evaluation_type_id, domain_id, process_id,
    question_code, question_text, question_intent, instruction_text, evidence_examples,
    alert_rule_hint, mapped_maturity_model_id, mapped_maturity_statement_id, matched_process_area, sort_order)
  SELECT v_questionnaire_id, v_eval_type_id, v_domain_id, p.id,
    'ofs_l3_6_2_1',
    'How mature is the organization''s process for designing and executing re-acidulation (re-acid) treatments based on documented production decline diagnosis and post-job evaluation?',
    'Assess whether re-acid jobs are triggered and designed from a documented diagnosis of the production decline (skin, injectivity loss) with a post-job effectiveness evaluation, versus performed on a fixed schedule or by default with no diagnosis or evaluation.',
    'Review the production decline diagnosis supporting the re-acid candidate selection, the treatment design (acid type, volume, staging), and the post-job production or injectivity comparison against pre-job baseline.',
    'Production decline/skin diagnosis; re-acid treatment design; pre- and post-job production or injectivity comparison.',
    'Flag if a re-acid job proceeds with no documented decline diagnosis supporting the candidate selection.',
    'ofs_mm_l1_6', 'ofs_l3_6_2_1', 'ofs_l3_6_2_1', 1
  FROM processes p WHERE p.code = 'ofs_l2_6_2';

  INSERT INTO maturity_statements (maturity_model_id, domain_title, process_area,
    level_1_basic, level_2_developing, level_3_established, level_4_advanced, level_5_leading,
    assessor_instruction, evidence_examples, review_steps, alert_rule_hint, sort_order)
  VALUES ('ofs_mm_l1_6', 'Conduct Well Interventions and Workover Activities', 'ofs_l3_6_2_1',
    'Re-acid jobs are performed with no documented decline diagnosis or post-job evaluation.',
    'A diagnosis is performed for major candidates but post-job effectiveness evaluation is inconsistently documented.',
    'Every re-acid job is supported by a documented decline diagnosis, treatment design, and post-job effectiveness evaluation.',
    'Re-acid effectiveness data is tracked across wells to refine candidate selection criteria and treatment design standards.',
    'Re-acid candidate selection and design are optimized through an integrated production-surveillance and treatment-modeling workflow across the field.',
    'Ask for the decline diagnosis and post-job evaluation of the most recent re-acid treatment and confirm both are documented and consistent with the candidate selected.',
    'Production decline/skin diagnosis; re-acid treatment design; pre- and post-job production or injectivity comparison.',
    'Confirm one re-acid job''s decline diagnosis, treatment design, and post-job evaluation are all on file and traceable to the same well.',
    'Flag if a re-acid job proceeds with no documented decline diagnosis supporting the candidate selection.', 1)
  ON CONFLICT (maturity_model_id, process_area) DO NOTHING;

  -- Q4: ofs_l3_6_3_1
  INSERT INTO questions (questionnaire_id, evaluation_type_id, domain_id, process_id,
    question_code, question_text, question_intent, instruction_text, evidence_examples,
    alert_rule_hint, mapped_maturity_model_id, mapped_maturity_statement_id, matched_process_area, sort_order)
  SELECT v_questionnaire_id, v_eval_type_id, v_domain_id, p.id,
    'ofs_l3_6_3_1',
    'How mature is the organization''s process for installing and verifying the coiled tubing injector head rig-up against a documented pressure rating and well control configuration before intervention operations begin?',
    'Assess whether injector head rig-up is verified against the well''s pressure rating and a documented well control configuration (stripper, BOP stack-up) before operations, versus rigged up with no documented pressure/configuration verification.',
    'Review the injector head rig-up procedure/checklist (pressure rating, BOP stack-up, stripper configuration) and the pre-job verification sign-off for a recent coiled tubing intervention.',
    'Coiled tubing rig-up procedure/checklist; pressure rating verification; pre-job well control configuration sign-off.',
    'Flag if a coiled tubing job begins with no documented rig-up verification sign-off against the well''s pressure rating.',
    'ofs_mm_l1_6', 'ofs_l3_6_3_1', 'ofs_l3_6_3_1', 1
  FROM processes p WHERE p.code = 'ofs_l2_6_3';

  INSERT INTO maturity_statements (maturity_model_id, domain_title, process_area,
    level_1_basic, level_2_developing, level_3_established, level_4_advanced, level_5_leading,
    assessor_instruction, evidence_examples, review_steps, alert_rule_hint, sort_order)
  VALUES ('ofs_mm_l1_6', 'Conduct Well Interventions and Workover Activities', 'ofs_l3_6_3_1',
    'Injector head rig-up is performed with no documented checklist or pressure/configuration verification.',
    'A rig-up checklist exists but pressure rating verification is inconsistently documented before operations begin.',
    'Every coiled tubing job has a documented rig-up checklist with pressure rating and well control configuration verified and signed off before operations begin.',
    'Rig-up verification data and near-miss findings are tracked across jobs to refine checklist standards and equipment specification.',
    'Rig-up verification is integrated with a digital equipment-certification system providing real-time pressure-rating traceability across the fleet.',
    'Ask for the rig-up checklist of the most recent coiled tubing job and confirm the pressure rating and well control configuration were verified and signed off before operations began.',
    'Coiled tubing rig-up procedure/checklist; pressure rating verification; pre-job well control configuration sign-off.',
    'Confirm one coiled tubing job''s rig-up checklist and pressure/configuration verification sign-off are both on file and precede the job start time.',
    'Flag if a coiled tubing job begins with no documented rig-up verification sign-off against the well''s pressure rating.', 1)
  ON CONFLICT (maturity_model_id, process_area) DO NOTHING;

  -- Q5: ofs_l3_6_3_2
  INSERT INTO questions (questionnaire_id, evaluation_type_id, domain_id, process_id,
    question_code, question_text, question_intent, instruction_text, evidence_examples,
    alert_rule_hint, mapped_maturity_model_id, mapped_maturity_statement_id, matched_process_area, sort_order)
  SELECT v_questionnaire_id, v_eval_type_id, v_domain_id, p.id,
    'ofs_l3_6_3_2',
    'How mature is the organization''s process for planning and executing fishing operations during coiled tubing interventions based on a documented fishing risk assessment and toolstring plan?',
    'Assess whether fishing operations follow a documented risk assessment and toolstring/fishing tool plan (matched to the fish description and wellbore geometry), versus attempted improvisationally with no plan.',
    'Review the fishing risk assessment and toolstring/fishing plan (fish description, fishing tool selection, contingency) for a recent fishing job, and confirm the plan was followed or deviations were documented.',
    'Fishing risk assessment; fishing tool/toolstring plan; job execution log; fish description and recovery report.',
    'Flag if a fishing operation begins with no documented fish description or fishing tool plan.',
    'ofs_mm_l1_6', 'ofs_l3_6_3_2', 'ofs_l3_6_3_2', 2
  FROM processes p WHERE p.code = 'ofs_l2_6_3';

  INSERT INTO maturity_statements (maturity_model_id, domain_title, process_area,
    level_1_basic, level_2_developing, level_3_established, level_4_advanced, level_5_leading,
    assessor_instruction, evidence_examples, review_steps, alert_rule_hint, sort_order)
  VALUES ('ofs_mm_l1_6', 'Conduct Well Interventions and Workover Activities', 'ofs_l3_6_3_2',
    'Fishing operations are attempted with no documented risk assessment or toolstring plan.',
    'A plan exists for major fishing jobs but the fish description and contingency planning are inconsistently documented.',
    'Every fishing operation has a documented risk assessment, fish description, and toolstring plan, with execution logged against it.',
    'Fishing job outcomes and recovery rates are tracked across jobs to refine tool selection and contingency planning standards.',
    'Fishing operations are integrated with a digital case-history and tool-selection decision-support system across the field.',
    'Ask for the fishing risk assessment and toolstring plan of the most recent fishing job and confirm the fish description supported the tool selection made.',
    'Fishing risk assessment; fishing tool/toolstring plan; job execution log; fish description and recovery report.',
    'Confirm one fishing job''s risk assessment, toolstring plan, and execution log are all on file and consistent with each other.',
    'Flag if a fishing operation begins with no documented fish description or fishing tool plan.', 2)
  ON CONFLICT (maturity_model_id, process_area) DO NOTHING;

  -- Q6: ofs_l3_6_4_1
  INSERT INTO questions (questionnaire_id, evaluation_type_id, domain_id, process_id,
    question_code, question_text, question_intent, instruction_text, evidence_examples,
    alert_rule_hint, mapped_maturity_model_id, mapped_maturity_statement_id, matched_process_area, sort_order)
  SELECT v_questionnaire_id, v_eval_type_id, v_domain_id, p.id,
    'ofs_l3_6_4_1',
    'How mature is the organization''s process for scheduling and verifying workover rig readiness (crew, equipment certification, well priority) ahead of planned intervention operations?',
    'Assess whether workover rig scheduling is based on a documented prioritization of candidate wells and a verified rig/crew/equipment readiness check, versus scheduled ad hoc with no readiness verification before mobilization.',
    'Review the workover candidate prioritization/schedule and the rig readiness checklist (crew certification, equipment inspection/certification currency) completed before a recent mobilization.',
    'Workover candidate prioritization/schedule; rig and crew readiness checklist; equipment certification records.',
    'Flag if a workover rig is mobilized with an expired equipment certification or no documented readiness checklist.',
    'ofs_mm_l1_6', 'ofs_l3_6_4_1', 'ofs_l3_6_4_1', 1
  FROM processes p WHERE p.code = 'ofs_l2_6_4';

  INSERT INTO maturity_statements (maturity_model_id, domain_title, process_area,
    level_1_basic, level_2_developing, level_3_established, level_4_advanced, level_5_leading,
    assessor_instruction, evidence_examples, review_steps, alert_rule_hint, sort_order)
  VALUES ('ofs_mm_l1_6', 'Conduct Well Interventions and Workover Activities', 'ofs_l3_6_4_1',
    'Workover rig scheduling is informal with no documented prioritization or readiness verification.',
    'A schedule exists but readiness verification (crew, equipment certification) is inconsistently documented before mobilization.',
    'Every workover mobilization follows a documented candidate prioritization and a completed rig/crew/equipment readiness checklist.',
    'Rig utilization and readiness findings are tracked across mobilizations to refine scheduling and equipment maintenance standards.',
    'Workover rig scheduling and readiness are managed through an integrated digital fleet-management system providing real-time crew and equipment status.',
    'Ask for the readiness checklist of the most recently mobilized workover rig and confirm crew and equipment certifications were current at mobilization.',
    'Workover candidate prioritization/schedule; rig and crew readiness checklist; equipment certification records.',
    'Confirm one workover mobilization''s candidate prioritization and readiness checklist are both on file and consistent with the crew/equipment deployed.',
    'Flag if a workover rig is mobilized with an expired equipment certification or no documented readiness checklist.', 1)
  ON CONFLICT (maturity_model_id, process_area) DO NOTHING;

  -- Q7: ofs_l3_6_5_1
  INSERT INTO questions (questionnaire_id, evaluation_type_id, domain_id, process_id,
    question_code, question_text, question_intent, instruction_text, evidence_examples,
    alert_rule_hint, mapped_maturity_model_id, mapped_maturity_statement_id, matched_process_area, sort_order)
  SELECT v_questionnaire_id, v_eval_type_id, v_domain_id, p.id,
    'ofs_l3_6_5_1',
    'How mature is the organization''s process for applying the same documented design, execution, and verification rigor used in original well completions (perforating, sand control, cementing, fluids) to re-completion operations?',
    'Assess whether re-completion jobs are governed by the same documented sub-activity standards as new-well completions (job design, underbalance calculations, commissioning checks), versus treated as a lighter-touch operation with reduced documentation.',
    'Review the re-completion job design and confirm it references the same completion sub-activity standards (perforating design, cementing program, fluids plan) applied to new-well completions, with equivalent sign-offs.',
    'Re-completion job design/program; completion sub-activity design documents (perforating, cementing, fluids) referenced for the re-completion; sign-off records.',
    'Flag if a re-completion job proceeds without the same documented sub-activity design and sign-offs required for a new-well completion.',
    'ofs_mm_l1_6', 'ofs_l3_6_5_1', 'ofs_l3_6_5_1', 1
  FROM processes p WHERE p.code = 'ofs_l2_6_5';

  INSERT INTO maturity_statements (maturity_model_id, domain_title, process_area,
    level_1_basic, level_2_developing, level_3_established, level_4_advanced, level_5_leading,
    assessor_instruction, evidence_examples, review_steps, alert_rule_hint, sort_order)
  VALUES ('ofs_mm_l1_6', 'Conduct Well Interventions and Workover Activities', 'ofs_l3_6_5_1',
    'Re-completion jobs are executed with reduced documentation compared to new-well completions, with no reference to the standard sub-activity design requirements.',
    'Re-completions reference completion standards for major sub-activities but consistency with new-well documentation requirements is not verified.',
    'Every re-completion job is governed by the same documented sub-activity design and sign-off requirements as a new-well completion.',
    'Re-completion performance is tracked against original completion performance across wells to refine re-completion design standards.',
    'Re-completion planning is integrated with an end-to-end well-lifecycle design and verification platform shared with new-well completions.',
    'Ask for the job design of the most recent re-completion and confirm it references the same sub-activity standards (perforating, cementing, fluids) used for new-well completions.',
    'Re-completion job design/program; completion sub-activity design documents (perforating, cementing, fluids) referenced for the re-completion; sign-off records.',
    'Confirm one re-completion job''s design documentation and sign-offs match the standard required for a new-well completion of the same type.',
    'Flag if a re-completion job proceeds without the same documented sub-activity design and sign-offs required for a new-well completion.', 1)
  ON CONFLICT (maturity_model_id, process_area) DO NOTHING;

  -- Q8: ofs_l3_6_6_1
  INSERT INTO questions (questionnaire_id, evaluation_type_id, domain_id, process_id,
    question_code, question_text, question_intent, instruction_text, evidence_examples,
    alert_rule_hint, mapped_maturity_model_id, mapped_maturity_statement_id, matched_process_area, sort_order)
  SELECT v_questionnaire_id, v_eval_type_id, v_domain_id, p.id,
    'ofs_l3_6_6_1',
    'How mature is the organization''s process for inspecting, grading, and reclaiming production tubing pulled during well interventions before it is returned to service or storage?',
    'Assess whether pulled tubing is inspected and graded against a documented standard (wall thickness, thread condition, drift test) before reclamation or reuse, versus returned to service or storage with no documented inspection.',
    'Review the tubing inspection/grading procedure and the inspection record (drift test, thread inspection, wall thickness) for a recent batch of reclaimed tubing, and confirm the grading determined its disposition (reuse, downgrade, scrap).',
    'Tubing inspection/grading procedure; drift test and thread inspection record; disposition (reuse/downgrade/scrap) decision record.',
    'Flag if tubing is returned to service with no documented inspection/grading record supporting that disposition.',
    'ofs_mm_l1_6', 'ofs_l3_6_6_1', 'ofs_l3_6_6_1', 1
  FROM processes p WHERE p.code = 'ofs_l2_6_6';

  INSERT INTO maturity_statements (maturity_model_id, domain_title, process_area,
    level_1_basic, level_2_developing, level_3_established, level_4_advanced, level_5_leading,
    assessor_instruction, evidence_examples, review_steps, alert_rule_hint, sort_order)
  VALUES ('ofs_mm_l1_6', 'Conduct Well Interventions and Workover Activities', 'ofs_l3_6_6_1',
    'Pulled tubing is reclaimed and returned to service or storage with no documented inspection or grading.',
    'Inspection is performed for major batches but grading criteria and disposition decisions are inconsistently documented.',
    'Every batch of pulled tubing is inspected and graded against a documented standard, with disposition recorded before reuse or storage.',
    'Tubing inspection and failure data are tracked across batches to refine grading criteria and reduce in-service failures.',
    'Tubing reclamation is integrated with a digital asset-tracking system providing full lifecycle traceability from initial run to final disposition.',
    'Ask for the inspection/grading record of the most recently reclaimed tubing batch and confirm its disposition (reuse, downgrade, scrap) is documented and consistent with the grading result.',
    'Tubing inspection/grading procedure; drift test and thread inspection record; disposition (reuse/downgrade/scrap) decision record.',
    'Confirm one tubing batch''s inspection/grading record and disposition decision are both on file and consistent with each other.',
    'Flag if tubing is returned to service with no documented inspection/grading record supporting that disposition.', 1)
  ON CONFLICT (maturity_model_id, process_area) DO NOTHING;

END $$;