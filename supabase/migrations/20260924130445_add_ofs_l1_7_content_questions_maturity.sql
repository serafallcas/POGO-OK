/*
# OFS Onshore L1.7 — Plug And Abandon

1. Content added (purely additive)
   - 1 maturity model: ofs_mm_l1_7
   - 5 questions: ofs_l3_7_1_1, ofs_l3_7_2_1, ofs_l3_7_3_1, ofs_l3_7_4_1, ofs_l3_7_5_1
   - 5 maturity statements (one per question)

2. Assumes evaluation_type 'ofs_onshore', questionnaire 'ofs_onshore_questionnaire',
   domain 'ofs_l1_7', and processes ofs_l2_7_1..ofs_l2_7_5 already exist.

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
  SELECT id INTO v_domain_id FROM domains WHERE code = 'ofs_l1_7';

  -- Maturity model
  INSERT INTO maturity_models (code, label, description, domain_id, mapped_domain_id, mapped_domain_name, version, source_workbook, is_active)
  VALUES ('ofs_mm_l1_7', 'Plug And Abandon - Maturity Model', 'OFS Onshore maturity model for Plug And Abandon', v_domain_id, 'ofs_l1_7', 'Plug And Abandon', '1.0', 'POGO-OFS_Level_1-3_framework.pptx', true)
  ON CONFLICT (code) DO NOTHING;

  -- Q1: ofs_l3_7_1_1
  INSERT INTO questions (questionnaire_id, evaluation_type_id, domain_id, process_id,
    question_code, question_text, question_intent, instruction_text, evidence_examples,
    alert_rule_hint, mapped_maturity_model_id, mapped_maturity_statement_id, matched_process_area, sort_order)
  SELECT v_questionnaire_id, v_eval_type_id, v_domain_id, p.id,
    'ofs_l3_7_1_1',
    'How mature is the organization''s process for determining and documenting the applicable regulatory plug-and-abandon requirements (state/federal rules, well-specific permit conditions) before building the P&A business case?',
    'Assess whether the P&A business case is built on a documented regulatory requirements review (jurisdiction rules, permit conditions, cement/plug placement depth requirements) specific to the well, versus assumed from generic knowledge with no well-specific verification.',
    'Review the regulatory requirements determination (applicable rules, permit conditions, required plug depths/types) and confirm it references the specific well''s jurisdiction and permit before the P&A business case was finalized.',
    'Regulatory requirements review/checklist; well permit and jurisdiction reference; P&A business case document.',
    'Flag if a P&A business case is approved with no documented regulatory requirements determination specific to the well.',
    'ofs_mm_l1_7', 'ofs_l3_7_1_1', 'ofs_l3_7_1_1', 1
  FROM processes p WHERE p.code = 'ofs_l2_7_1';

  INSERT INTO maturity_statements (maturity_model_id, domain_title, process_area,
    level_1_basic, level_2_developing, level_3_established, level_4_advanced, level_5_leading,
    assessor_instruction, evidence_examples, review_steps, alert_rule_hint, sort_order)
  VALUES ('ofs_mm_l1_7', 'Plug And Abandon', 'ofs_l3_7_1_1',
    'P&A regulatory requirements are assumed from general knowledge with no documented well-specific review.',
    'A regulatory review is performed for major wells but is not consistently linked to the business case approval.',
    'Every P&A business case is supported by a documented regulatory requirements determination specific to the well and jurisdiction.',
    'Regulatory requirement findings are tracked across wells to maintain a current, centralized jurisdiction rule library.',
    'Regulatory requirements determination is integrated with a digital compliance-tracking system that flags rule changes automatically across the well portfolio.',
    'Ask for the regulatory requirements determination behind the most recent P&A business case and confirm it references the specific well''s jurisdiction and permit conditions.',
    'Regulatory requirements review/checklist; well permit and jurisdiction reference; P&A business case document.',
    'Confirm one P&A business case''s regulatory requirements determination is on file and precedes the case''s approval date.',
    'Flag if a P&A business case is approved with no documented regulatory requirements determination specific to the well.', 1)
  ON CONFLICT (maturity_model_id, process_area) DO NOTHING;

  -- Q2: ofs_l3_7_2_1
  INSERT INTO questions (questionnaire_id, evaluation_type_id, domain_id, process_id,
    question_code, question_text, question_intent, instruction_text, evidence_examples,
    alert_rule_hint, mapped_maturity_model_id, mapped_maturity_statement_id, matched_process_area, sort_order)
  SELECT v_questionnaire_id, v_eval_type_id, v_domain_id, p.id,
    'ofs_l3_7_2_1',
    'How mature is the organization''s process for designing wellbore plug placement (type, depth, cement volume) and verifying installation against regulatory and engineering specifications?',
    'Assess whether plug design and installation are governed by a documented plan (plug type, depth, cement volume/class) with post-placement verification (tag test, pressure test), versus placed with no documented design or verification.',
    'Review the plug design/placement plan (depths, cement volumes, plug types) and the post-installation verification record (tag test, pressure test) for a recent P&A job.',
    'Plug design/placement plan; cement job ticket; tag test or pressure test verification record.',
    'Flag if a wellbore plug is installed with no documented post-placement tag or pressure test verification.',
    'ofs_mm_l1_7', 'ofs_l3_7_2_1', 'ofs_l3_7_2_1', 1
  FROM processes p WHERE p.code = 'ofs_l2_7_2';

  INSERT INTO maturity_statements (maturity_model_id, domain_title, process_area,
    level_1_basic, level_2_developing, level_3_established, level_4_advanced, level_5_leading,
    assessor_instruction, evidence_examples, review_steps, alert_rule_hint, sort_order)
  VALUES ('ofs_mm_l1_7', 'Plug And Abandon', 'ofs_l3_7_2_1',
    'Plugs are placed with no documented design plan or post-placement verification.',
    'A design plan exists for major wells but post-placement verification is inconsistently documented.',
    'Every plug installation follows a documented design plan with post-placement tag/pressure test verification recorded.',
    'Plug placement and verification data are tracked across wells to refine cement volume and placement standards.',
    'Plug design and verification are integrated with a digital cementing-simulation and real-time verification platform across the field.',
    'Ask for the plug design plan and post-placement verification record of the most recent P&A job and confirm the tag or pressure test result meets the design specification.',
    'Plug design/placement plan; cement job ticket; tag test or pressure test verification record.',
    'Confirm one P&A job''s plug design plan and verification record are both on file and consistent with each other.',
    'Flag if a wellbore plug is installed with no documented post-placement tag or pressure test verification.', 1)
  ON CONFLICT (maturity_model_id, process_area) DO NOTHING;

  -- Q3: ofs_l3_7_3_1
  INSERT INTO questions (questionnaire_id, evaluation_type_id, domain_id, process_id,
    question_code, question_text, question_intent, instruction_text, evidence_examples,
    alert_rule_hint, mapped_maturity_model_id, mapped_maturity_statement_id, matched_process_area, sort_order)
  SELECT v_questionnaire_id, v_eval_type_id, v_domain_id, p.id,
    'ofs_l3_7_3_1',
    'How mature is the organization''s process for completing site closeout and environmental remediation (soil testing, surface restoration) before releasing a plugged well site?',
    'Assess whether site closeout is governed by a documented remediation plan with verification (soil/groundwater testing, restoration sign-off) before release, versus closed out with no documented environmental verification.',
    'Review the site remediation plan and the closeout verification record (soil/groundwater test results, restoration sign-off, regulatory closure confirmation) for a recently closed site.',
    'Site remediation plan; soil/groundwater test results; restoration sign-off; regulatory site closure confirmation.',
    'Flag if a site is released with no documented remediation verification or regulatory closure confirmation.',
    'ofs_mm_l1_7', 'ofs_l3_7_3_1', 'ofs_l3_7_3_1', 1
  FROM processes p WHERE p.code = 'ofs_l2_7_3';

  INSERT INTO maturity_statements (maturity_model_id, domain_title, process_area,
    level_1_basic, level_2_developing, level_3_established, level_4_advanced, level_5_leading,
    assessor_instruction, evidence_examples, review_steps, alert_rule_hint, sort_order)
  VALUES ('ofs_mm_l1_7', 'Plug And Abandon', 'ofs_l3_7_3_1',
    'Site closeout occurs with no documented remediation plan or environmental verification.',
    'A remediation plan exists for major sites but verification (soil/groundwater testing) is inconsistently documented before release.',
    'Every site closeout follows a documented remediation plan with verification testing and regulatory closure confirmation on file.',
    'Remediation outcomes and testing data are tracked across sites to refine remediation standards and reduce closure cycle time.',
    'Site closeout and remediation are integrated with a digital environmental-compliance platform providing real-time regulatory closure status across the portfolio.',
    'Ask for the remediation plan and closure verification record of the most recently closed site and confirm regulatory closure was confirmed before release.',
    'Site remediation plan; soil/groundwater test results; restoration sign-off; regulatory site closure confirmation.',
    'Confirm one closed site''s remediation plan, verification testing, and regulatory closure confirmation are all on file and consistent.',
    'Flag if a site is released with no documented remediation verification or regulatory closure confirmation.', 1)
  ON CONFLICT (maturity_model_id, process_area) DO NOTHING;

  -- Q4: ofs_l3_7_4_1
  INSERT INTO questions (questionnaire_id, evaluation_type_id, domain_id, process_id,
    question_code, question_text, question_intent, instruction_text, evidence_examples,
    alert_rule_hint, mapped_maturity_model_id, mapped_maturity_statement_id, matched_process_area, sort_order)
  SELECT v_questionnaire_id, v_eval_type_id, v_domain_id, p.id,
    'ofs_l3_7_4_1',
    'How mature is the organization''s process for removing and disposing of production support materials and surface equipment (tanks, flowlines, pads) at a plugged well site according to documented environmental disposal requirements?',
    'Assess whether removal and disposal of surface equipment/materials follows a documented plan with disposal records matched to material type (hazardous vs. non-hazardous), versus removed with no documented disposal tracking.',
    'Review the equipment/material removal plan and the disposal records (manifests, disposal facility receipts) for a recent site, and confirm material classification (hazardous/non-hazardous) matched the disposal method used.',
    'Removal plan/inventory of surface equipment and materials; disposal manifests or facility receipts; material classification record.',
    'Flag if surface equipment or materials are removed from a site with no documented disposal manifest or receipt.',
    'ofs_mm_l1_7', 'ofs_l3_7_4_1', 'ofs_l3_7_4_1', 1
  FROM processes p WHERE p.code = 'ofs_l2_7_4';

  INSERT INTO maturity_statements (maturity_model_id, domain_title, process_area,
    level_1_basic, level_2_developing, level_3_established, level_4_advanced, level_5_leading,
    assessor_instruction, evidence_examples, review_steps, alert_rule_hint, sort_order)
  VALUES ('ofs_mm_l1_7', 'Plug And Abandon', 'ofs_l3_7_4_1',
    'Surface equipment and materials are removed with no documented disposal tracking.',
    'A removal plan exists for major sites but disposal records are inconsistently retained or matched to material classification.',
    'Every site removal follows a documented plan with disposal manifests/receipts retained and matched to material classification.',
    'Disposal volumes and costs are tracked across sites to refine removal planning and disposal vendor management.',
    'Removal and disposal are integrated with a digital chain-of-custody tracking system providing full material traceability across the portfolio.',
    'Ask for the disposal manifest or receipt for the most recently removed equipment/materials at a site and confirm it matches the material classification recorded.',
    'Removal plan/inventory of surface equipment and materials; disposal manifests or facility receipts; material classification record.',
    'Confirm one site''s removal plan and disposal manifests are both on file and consistent with the material classification recorded.',
    'Flag if surface equipment or materials are removed from a site with no documented disposal manifest or receipt.', 1)
  ON CONFLICT (maturity_model_id, process_area) DO NOTHING;

  -- Q5: ofs_l3_7_5_1
  INSERT INTO questions (questionnaire_id, evaluation_type_id, domain_id, process_id,
    question_code, question_text, question_intent, instruction_text, evidence_examples,
    alert_rule_hint, mapped_maturity_model_id, mapped_maturity_statement_id, matched_process_area, sort_order)
  SELECT v_questionnaire_id, v_eval_type_id, v_domain_id, p.id,
    'ofs_l3_7_5_1',
    'How mature is the organization''s process for conducting well intervention to remove downhole completion equipment (tubing, packers, artificial lift equipment) and verifying wellbore readiness before plugging operations begin?',
    'Assess whether completion equipment removal is planned and verified (retrieval confirmation, wellbore tally/readiness check) before plugging begins, versus plugging attempted with equipment status undocumented or unverified.',
    'Review the completion equipment removal plan (intervention job design, retrieval sequence) and the wellbore readiness verification (retrieval confirmation, tally, junk/fish check) completed before the plugging job began.',
    'Completion equipment removal/intervention job plan; retrieval confirmation record; wellbore readiness/tally verification.',
    'Flag if a plugging job begins with no documented confirmation that downhole completion equipment was fully retrieved or accounted for.',
    'ofs_mm_l1_7', 'ofs_l3_7_5_1', 'ofs_l3_7_5_1', 1
  FROM processes p WHERE p.code = 'ofs_l2_7_5';

  INSERT INTO maturity_statements (maturity_model_id, domain_title, process_area,
    level_1_basic, level_2_developing, level_3_established, level_4_advanced, level_5_leading,
    assessor_instruction, evidence_examples, review_steps, alert_rule_hint, sort_order)
  VALUES ('ofs_mm_l1_7', 'Plug And Abandon', 'ofs_l3_7_5_1',
    'Plugging proceeds with no documented verification that completion equipment was removed or accounted for.',
    'A removal plan exists for major wells but retrieval confirmation is inconsistently documented before plugging begins.',
    'Every plugging job is preceded by a documented completion equipment removal plan with retrieval confirmation and wellbore readiness verification.',
    'Retrieval outcomes and fishing incident data are tracked across wells to refine removal planning and reduce plugging delays.',
    'Completion equipment removal is integrated with a digital well-intervention planning system providing real-time wellbore status ahead of plugging.',
    'Ask for the retrieval confirmation and wellbore readiness verification of the most recent plugging job and confirm they precede the plugging job start date.',
    'Completion equipment removal/intervention job plan; retrieval confirmation record; wellbore readiness/tally verification.',
    'Confirm one plugging job''s completion equipment removal plan and retrieval confirmation are both on file and precede the plugging job start.',
    'Flag if a plugging job begins with no documented confirmation that downhole completion equipment was fully retrieved or accounted for.', 1)
  ON CONFLICT (maturity_model_id, process_area) DO NOTHING;

END $$;