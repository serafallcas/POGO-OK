/*
# OFS L1.10 Part B - Manage New Business Development And Intellectual Property (Q15-Q27)
# Items ofs_l3_10_3_5 through ofs_l3_10_3_6 (sub-process 10.3 remainder)
# plus ofs_l3_10_4_1 through ofs_l3_10_4_3 (sub-process 10.4)
# plus ofs_l3_10_5_1 through ofs_l3_10_5_5 (sub-process 10.5)
# plus ofs_l3_10_6_1 through ofs_l3_10_6_4 (sub-process 10.6)
# 13 questions + 13 maturity_statements.
# Purely additive, idempotent via ON CONFLICT.
*/
DO $$
DECLARE
  v_questionnaire_id uuid;
  v_eval_type_id uuid;
  v_domain_id uuid;
BEGIN
  SELECT id INTO v_eval_type_id FROM evaluation_types WHERE code = 'ofs_onshore';
  SELECT id INTO v_questionnaire_id FROM questionnaires WHERE code = 'ofs_onshore_questionnaire';
  SELECT id INTO v_domain_id FROM domains WHERE code = 'ofs_l1_10';

  -- 10.3.5
  INSERT INTO questions (questionnaire_id, evaluation_type_id, domain_id, process_id,
    question_code, question_text, question_intent, instruction_text, evidence_examples,
    alert_rule_hint, mapped_maturity_model_id, mapped_maturity_statement_id, matched_process_area, sort_order)
  SELECT v_questionnaire_id, v_eval_type_id, v_domain_id, p.id,
    'ofs_l3_10_3_5', 'How mature is the organization''s process for documenting the agreed project timescale/schedule as part of contract negotiation?', 'Assess whether the agreed project timescale is grounded in a documented schedule basis reconciled to operational capacity, versus timelines being agreed informally with no documented feasibility check.', 'Review the documented schedule basis for a recent contract and confirm it was checked against operational/resource capacity before agreement.', 'Project schedule/timeline estimate; resource-capacity check note; final contract timescale reconciliation.',
    'Flag if a finalized contract''s agreed timescale has no documented capacity-feasibility check on file.', 'ofs_mm_l1_10', 'ofs_l3_10_3_5', 'ofs_l3_10_3_5', 5
  FROM processes p WHERE p.code = 'ofs_l2_10_3';
  INSERT INTO maturity_statements (maturity_model_id, domain_title, process_area,
    level_1_basic, level_2_developing, level_3_established, level_4_advanced, level_5_leading,
    assessor_instruction, evidence_examples, review_steps, alert_rule_hint, sort_order)
  VALUES ('ofs_mm_l1_10', 'Manage New Business Development And Intellectual Property', 'ofs_l3_10_3_5',
    'Project timescale is agreed informally with no documented feasibility check.', 'A schedule basis is documented for some contracts but inconsistently checked against capacity.', 'A documented schedule basis, checked against operational capacity, exists for every finalized contract.', 'Schedule-basis accuracy is tracked against actual project delivery and used to refine future scheduling.', 'Project timescale agreement is supported by an integrated capacity-planning platform using live resource data.',
    'Ask for the documented schedule basis behind the most recently finalized contract and confirm the capacity check.', 'Project schedule/timeline estimate; resource-capacity check note; final contract timescale reconciliation.', 'Confirm a documented schedule basis exists for the most recent contract and was checked against capacity.', 'Flag if a finalized contract''s agreed timescale has no documented capacity-feasibility check on file.', 5)
  ON CONFLICT (maturity_model_id, process_area) DO NOTHING;

  -- 10.3.6
  INSERT INTO questions (questionnaire_id, evaluation_type_id, domain_id, process_id,
    question_code, question_text, question_intent, instruction_text, evidence_examples,
    alert_rule_hint, mapped_maturity_model_id, mapped_maturity_statement_id, matched_process_area, sort_order)
  SELECT v_questionnaire_id, v_eval_type_id, v_domain_id, p.id,
    'ofs_l3_10_3_6', 'How mature is the organization''s process for documenting agreed payment terms as part of contract negotiation, aligned to company cash-flow policy?', 'Assess whether payment terms are agreed against a documented cash-flow/credit policy, versus terms being agreed informally with no documented policy reference.', 'Review the documented payment terms for a recent contract and confirm they were checked against the company''s cash-flow/credit policy before agreement.', 'Payment-terms schedule; cash-flow/credit policy document; credit-check or approval record.',
    'Flag if a finalized contract''s payment terms have no documented credit-policy check on file.', 'ofs_mm_l1_10', 'ofs_l3_10_3_6', 'ofs_l3_10_3_6', 6
  FROM processes p WHERE p.code = 'ofs_l2_10_3';
  INSERT INTO maturity_statements (maturity_model_id, domain_title, process_area,
    level_1_basic, level_2_developing, level_3_established, level_4_advanced, level_5_leading,
    assessor_instruction, evidence_examples, review_steps, alert_rule_hint, sort_order)
  VALUES ('ofs_mm_l1_10', 'Manage New Business Development And Intellectual Property', 'ofs_l3_10_3_6',
    'Payment terms are agreed informally with no documented policy check.', 'Payment terms are checked against policy for some contracts but inconsistently.', 'A documented credit-policy check is performed and recorded for every finalized contract''s payment terms.', 'Payment-term performance (days sales outstanding by term type) is tracked and used to refine credit policy.', 'Payment-terms agreement is supported by an integrated credit-risk platform using live customer payment data.',
    'Ask for the documented credit-policy check behind the most recently finalized contract''s payment terms.', 'Payment-terms schedule; cash-flow/credit policy document; credit-check or approval record.', 'Confirm a documented credit-policy check exists for the most recent contract''s payment terms.', 'Flag if a finalized contract''s payment terms have no documented credit-policy check on file.', 6)
  ON CONFLICT (maturity_model_id, process_area) DO NOTHING;

  -- 10.4.1
  INSERT INTO questions (questionnaire_id, evaluation_type_id, domain_id, process_id,
    question_code, question_text, question_intent, instruction_text, evidence_examples,
    alert_rule_hint, mapped_maturity_model_id, mapped_maturity_statement_id, matched_process_area, sort_order)
  SELECT v_questionnaire_id, v_eval_type_id, v_domain_id, p.id,
    'ofs_l3_10_4_1', 'How mature is the organization''s process for collecting and maintaining documented, current customer account information upon completing a sale?', 'Assess whether customer account information is captured and kept current in a documented system of record, versus being scattered informally across individuals with no documented maintenance process.', 'Review the customer account record for a recently completed sale and confirm it contains current, complete account information per the organization''s standard fields.', 'Customer account record (CRM or equivalent); standard account-information field list; record-completeness check.',
    'Flag if a recently completed sale''s customer account record is missing required standard fields.', 'ofs_mm_l1_10', 'ofs_l3_10_4_1', 'ofs_l3_10_4_1', 1
  FROM processes p WHERE p.code = 'ofs_l2_10_4';
  INSERT INTO maturity_statements (maturity_model_id, domain_title, process_area,
    level_1_basic, level_2_developing, level_3_established, level_4_advanced, level_5_leading,
    assessor_instruction, evidence_examples, review_steps, alert_rule_hint, sort_order)
  VALUES ('ofs_mm_l1_10', 'Manage New Business Development And Intellectual Property', 'ofs_l3_10_4_1',
    'Customer account information is held informally with no documented system of record.', 'Account information is recorded for some customers but inconsistently complete or current.', 'A documented, current customer account record, complete per standard fields, exists for every completed sale.', 'Account-record completeness and currency are audited periodically and gaps tracked to closure.', 'Customer account information is maintained through an integrated CRM platform with automated completeness and currency checks.',
    'Ask for the customer account record of the most recently completed sale and confirm it is complete per standard fields.', 'Customer account record (CRM or equivalent); standard account-information field list; record-completeness check.', 'Confirm the customer account record for the most recent completed sale is documented, current, and complete.', 'Flag if a recently completed sale''s customer account record is missing required standard fields.', 1)
  ON CONFLICT (maturity_model_id, process_area) DO NOTHING;

  -- 10.4.2
  INSERT INTO questions (questionnaire_id, evaluation_type_id, domain_id, process_id,
    question_code, question_text, question_intent, instruction_text, evidence_examples,
    alert_rule_hint, mapped_maturity_model_id, mapped_maturity_statement_id, matched_process_area, sort_order)
  SELECT v_questionnaire_id, v_eval_type_id, v_domain_id, p.id,
    'ofs_l3_10_4_2', 'How mature is the organization''s process for documenting the outcome (won, lost, no-decision) of each sales process, including a recorded rationale?', 'Assess whether sales outcomes are recorded with a documented rationale in a structured way, versus outcomes being known only informally with no documented record or rationale.', 'Review the sales-outcome record for a recent sales process and confirm it states the outcome and a recorded rationale.', 'Sales-outcome/win-loss record; rationale notes; CRM opportunity-closure record.',
    'Flag if a closed sales process has no documented outcome record or recorded rationale.', 'ofs_mm_l1_10', 'ofs_l3_10_4_2', 'ofs_l3_10_4_2', 2
  FROM processes p WHERE p.code = 'ofs_l2_10_4';
  INSERT INTO maturity_statements (maturity_model_id, domain_title, process_area,
    level_1_basic, level_2_developing, level_3_established, level_4_advanced, level_5_leading,
    assessor_instruction, evidence_examples, review_steps, alert_rule_hint, sort_order)
  VALUES ('ofs_mm_l1_10', 'Manage New Business Development And Intellectual Property', 'ofs_l3_10_4_2',
    'Sales outcomes are known informally with no documented record or rationale.', 'Outcomes are recorded for some sales processes but inconsistently, without a stated rationale.', 'A documented outcome record, with stated rationale, exists for every closed sales process.', 'Win/loss rationale patterns are analyzed across sales processes to refine sales strategy and positioning.', 'Sales-outcome recording and win/loss analysis are managed through an integrated CRM/analytics platform in real time.',
    'Ask for the documented outcome record and rationale of the most recently closed sales process.', 'Sales-outcome/win-loss record; rationale notes; CRM opportunity-closure record.', 'Confirm a documented outcome record with stated rationale exists for the most recently closed sales process.', 'Flag if a closed sales process has no documented outcome record or recorded rationale.', 2)
  ON CONFLICT (maturity_model_id, process_area) DO NOTHING;

  -- 10.4.3
  INSERT INTO questions (questionnaire_id, evaluation_type_id, domain_id, process_id,
    question_code, question_text, question_intent, instruction_text, evidence_examples,
    alert_rule_hint, mapped_maturity_model_id, mapped_maturity_statement_id, matched_process_area, sort_order)
  SELECT v_questionnaire_id, v_eval_type_id, v_domain_id, p.id,
    'ofs_l3_10_4_3', 'How mature is the organization''s process for documenting a formal handover of a won sale to the resourcing/delivery function?', 'Assess whether won sales are handed over to delivery through a documented handover package, versus delivery teams learning of new work informally with no documented handover.', 'Review the documented handover package for a recently won sale and confirm it was received and acknowledged by the resourcing/delivery function.', 'Sale-to-delivery handover package; scope and contract-terms summary; resourcing acknowledgment record.',
    'Flag if a won sale proceeded to delivery with no documented, acknowledged handover package on file.', 'ofs_mm_l1_10', 'ofs_l3_10_4_3', 'ofs_l3_10_4_3', 3
  FROM processes p WHERE p.code = 'ofs_l2_10_4';
  INSERT INTO maturity_statements (maturity_model_id, domain_title, process_area,
    level_1_basic, level_2_developing, level_3_established, level_4_advanced, level_5_leading,
    assessor_instruction, evidence_examples, review_steps, alert_rule_hint, sort_order)
  VALUES ('ofs_mm_l1_10', 'Manage New Business Development And Intellectual Property', 'ofs_l3_10_4_3',
    'Won sales are communicated to delivery informally with no documented handover.', 'A handover package is documented for some won sales but inconsistently acknowledged by resourcing.', 'A documented handover package, acknowledged by resourcing, exists for every won sale.', 'Handover quality (completeness, timeliness) is tracked against downstream delivery outcomes to refine the handover process.', 'Sale-to-delivery handover is managed through an integrated CRM-to-delivery platform with automated tracking and acknowledgment.',
    'Ask for the documented handover package of the most recently won sale and confirm resourcing acknowledgment.', 'Sale-to-delivery handover package; scope and contract-terms summary; resourcing acknowledgment record.', 'Confirm a documented, acknowledged handover package exists for the most recently won sale.', 'Flag if a won sale proceeded to delivery with no documented, acknowledged handover package on file.', 3)
  ON CONFLICT (maturity_model_id, process_area) DO NOTHING;

  -- 10.5.1
  INSERT INTO questions (questionnaire_id, evaluation_type_id, domain_id, process_id,
    question_code, question_text, question_intent, instruction_text, evidence_examples,
    alert_rule_hint, mapped_maturity_model_id, mapped_maturity_statement_id, matched_process_area, sort_order)
  SELECT v_questionnaire_id, v_eval_type_id, v_domain_id, p.id,
    'ofs_l3_10_5_1', 'How mature is the organization''s process for conducting and documenting customer and market research specifically to identify new business opportunities?', 'Assess whether opportunity identification is grounded in documented, targeted customer/market research, versus opportunities being noticed informally with no documented research basis.', 'Review the documented customer/market research behind a recently identified opportunity and confirm it supports the opportunity rationale.', 'Opportunity-focused customer/market research; client-need analysis; opportunity rationale memo.',
    'Flag if a pursued opportunity has no documented customer/market research supporting its identification.', 'ofs_mm_l1_10', 'ofs_l3_10_5_1', 'ofs_l3_10_5_1', 1
  FROM processes p WHERE p.code = 'ofs_l2_10_5';
  INSERT INTO maturity_statements (maturity_model_id, domain_title, process_area,
    level_1_basic, level_2_developing, level_3_established, level_4_advanced, level_5_leading,
    assessor_instruction, evidence_examples, review_steps, alert_rule_hint, sort_order)
  VALUES ('ofs_mm_l1_10', 'Manage New Business Development And Intellectual Property', 'ofs_l3_10_5_1',
    'Opportunities are identified informally with no documented research basis.', 'Research is documented for some opportunities but inconsistently or without a clear rationale.', 'Documented customer/market research supports the identification of every pursued opportunity.', 'Research-to-opportunity conversion is tracked to refine future research targeting toward higher-yield areas.', 'Opportunity identification draws on a continuous customer/market-intelligence platform surfacing candidates systematically.',
    'Ask for the documented research behind the most recently identified and pursued opportunity.', 'Opportunity-focused customer/market research; client-need analysis; opportunity rationale memo.', 'Confirm documented customer/market research exists supporting the most recently pursued opportunity.', 'Flag if a pursued opportunity has no documented customer/market research supporting its identification.', 1)
  ON CONFLICT (maturity_model_id, process_area) DO NOTHING;

  -- 10.5.2
  INSERT INTO questions (questionnaire_id, evaluation_type_id, domain_id, process_id,
    question_code, question_text, question_intent, instruction_text, evidence_examples,
    alert_rule_hint, mapped_maturity_model_id, mapped_maturity_statement_id, matched_process_area, sort_order)
  SELECT v_questionnaire_id, v_eval_type_id, v_domain_id, p.id,
    'ofs_l3_10_5_2', 'How mature is the organization''s process for evaluating and prioritizing identified market opportunities using documented criteria?', 'Assess whether opportunities are prioritized against documented evaluation criteria (size, fit, win probability), versus prioritization being an informal judgment call with no documented criteria.', 'Review the documented opportunity-evaluation/prioritization record for the current opportunity pipeline and confirm it applies stated criteria.', 'Opportunity-scoring/prioritization matrix; documented evaluation criteria; prioritized pipeline list.',
    'Flag if the current opportunity pipeline has no documented prioritization based on stated criteria.', 'ofs_mm_l1_10', 'ofs_l3_10_5_2', 'ofs_l3_10_5_2', 2
  FROM processes p WHERE p.code = 'ofs_l2_10_5';
  INSERT INTO maturity_statements (maturity_model_id, domain_title, process_area,
    level_1_basic, level_2_developing, level_3_established, level_4_advanced, level_5_leading,
    assessor_instruction, evidence_examples, review_steps, alert_rule_hint, sort_order)
  VALUES ('ofs_mm_l1_10', 'Manage New Business Development And Intellectual Property', 'ofs_l3_10_5_2',
    'Opportunities are prioritized informally with no documented criteria.', 'Evaluation criteria are documented but applied inconsistently across the opportunity pipeline.', 'A documented prioritization, applying stated criteria, covers the full current opportunity pipeline.', 'Prioritization accuracy is tracked against actual win outcomes and used to refine the scoring criteria.', 'Opportunity prioritization is generated through an integrated pipeline-analytics platform using live win-probability data.',
    'Ask for the documented prioritization of the current opportunity pipeline and confirm the criteria applied.', 'Opportunity-scoring/prioritization matrix; documented evaluation criteria; prioritized pipeline list.', 'Confirm a documented prioritization exists for the current opportunity pipeline, applying stated criteria.', 'Flag if the current opportunity pipeline has no documented prioritization based on stated criteria.', 2)
  ON CONFLICT (maturity_model_id, process_area) DO NOTHING;

  -- 10.5.3
  INSERT INTO questions (questionnaire_id, evaluation_type_id, domain_id, process_id,
    question_code, question_text, question_intent, instruction_text, evidence_examples,
    alert_rule_hint, mapped_maturity_model_id, mapped_maturity_statement_id, matched_process_area, sort_order)
  SELECT v_questionnaire_id, v_eval_type_id, v_domain_id, p.id,
    'ofs_l3_10_5_3', 'How mature is the organization''s process for documenting an ongoing analysis of market and industry trends as an input to opportunity identification?', 'Assess whether opportunity identification draws on a documented, recurring trend analysis, versus trend awareness being informal and not linked to opportunity identification.', 'Review the most recent market/industry-trend analysis and confirm it was referenced in identifying a current opportunity.', 'Market/industry-trend analysis report; opportunity memo referencing trend findings.',
    'Flag if no documented trend analysis has been produced within the current fiscal year or referenced in opportunity identification.', 'ofs_mm_l1_10', 'ofs_l3_10_5_3', 'ofs_l3_10_5_3', 3
  FROM processes p WHERE p.code = 'ofs_l2_10_5';
  INSERT INTO maturity_statements (maturity_model_id, domain_title, process_area,
    level_1_basic, level_2_developing, level_3_established, level_4_advanced, level_5_leading,
    assessor_instruction, evidence_examples, review_steps, alert_rule_hint, sort_order)
  VALUES ('ofs_mm_l1_10', 'Manage New Business Development And Intellectual Property', 'ofs_l3_10_5_3',
    'Market and industry trends are tracked informally with no documented analysis.', 'A trend analysis is produced occasionally but not on a defined cadence or not linked to opportunity identification.', 'A documented trend analysis is produced on a defined cadence and referenced in opportunity identification.', 'Trend analysis is used to proactively identify emerging opportunities ahead of competitors.', 'Market/industry-trend analysis is continuous through an integrated intelligence platform feeding the opportunity pipeline in real time.',
    'Ask for the most recent market/industry-trend analysis and confirm it was referenced in a current opportunity.', 'Market/industry-trend analysis report; opportunity memo referencing trend findings.', 'Confirm a documented, current trend analysis exists and was referenced in identifying a current opportunity.', 'Flag if no documented trend analysis has been produced within the current fiscal year or referenced in opportunity identification.', 3)
  ON CONFLICT (maturity_model_id, process_area) DO NOTHING;

  -- 10.5.4
  INSERT INTO questions (questionnaire_id, evaluation_type_id, domain_id, process_id,
    question_code, question_text, question_intent, instruction_text, evidence_examples,
    alert_rule_hint, mapped_maturity_model_id, mapped_maturity_statement_id, matched_process_area, sort_order)
  SELECT v_questionnaire_id, v_eval_type_id, v_domain_id, p.id,
    'ofs_l3_10_5_4', 'How mature is the organization''s process for documenting a periodic evaluation of existing services as an input to identifying new business opportunities?', 'Assess whether opportunity identification includes a documented review of existing service strengths/gaps, versus opportunities being identified without reference to the current service base.', 'Review the most recent existing-services evaluation and confirm it identifies gaps or extension opportunities referenced in the opportunity pipeline.', 'Existing-service evaluation/gap analysis; opportunity pipeline referencing identified gaps.',
    'Flag if no documented existing-services evaluation has been produced within the current fiscal year.', 'ofs_mm_l1_10', 'ofs_l3_10_5_4', 'ofs_l3_10_5_4', 4
  FROM processes p WHERE p.code = 'ofs_l2_10_5';
  INSERT INTO maturity_statements (maturity_model_id, domain_title, process_area,
    level_1_basic, level_2_developing, level_3_established, level_4_advanced, level_5_leading,
    assessor_instruction, evidence_examples, review_steps, alert_rule_hint, sort_order)
  VALUES ('ofs_mm_l1_10', 'Manage New Business Development And Intellectual Property', 'ofs_l3_10_5_4',
    'Existing services are not formally evaluated as an input to opportunity identification.', 'An evaluation is produced occasionally but inconsistently linked to the opportunity pipeline.', 'A documented existing-services evaluation is produced at least annually and referenced in opportunity identification.', 'Evaluation findings are tracked over cycles to identify recurring service gaps and prioritize development investment.', 'Existing-service evaluation draws on a continuous client-feedback and usage-analytics platform feeding opportunity identification.',
    'Ask for the most recent existing-services evaluation and confirm it is referenced in the current opportunity pipeline.', 'Existing-service evaluation/gap analysis; opportunity pipeline referencing identified gaps.', 'Confirm a documented existing-services evaluation exists within the current fiscal year and informs the opportunity pipeline.', 'Flag if no documented existing-services evaluation has been produced within the current fiscal year.', 4)
  ON CONFLICT (maturity_model_id, process_area) DO NOTHING;

  -- 10.5.5
  INSERT INTO questions (questionnaire_id, evaluation_type_id, domain_id, process_id,
    question_code, question_text, question_intent, instruction_text, evidence_examples,
    alert_rule_hint, mapped_maturity_model_id, mapped_maturity_statement_id, matched_process_area, sort_order)
  SELECT v_questionnaire_id, v_eval_type_id, v_domain_id, p.id,
    'ofs_l3_10_5_5', 'How mature is the organization''s process for documenting a business-environment assessment (regulatory, economic, technological) as an input to identifying new business opportunities?', 'Assess whether opportunity identification factors in a documented business-environment scan, versus opportunities being pursued without reference to the broader environment.', 'Review the most recent business-environment assessment and confirm it was referenced in evaluating a current opportunity.', 'Business-environment assessment/scan; regulatory or economic outlook note; opportunity memo referencing the assessment.',
    'Flag if no documented business-environment assessment has been produced within the current fiscal year.', 'ofs_mm_l1_10', 'ofs_l3_10_5_5', 'ofs_l3_10_5_5', 5
  FROM processes p WHERE p.code = 'ofs_l2_10_5';
  INSERT INTO maturity_statements (maturity_model_id, domain_title, process_area,
    level_1_basic, level_2_developing, level_3_established, level_4_advanced, level_5_leading,
    assessor_instruction, evidence_examples, review_steps, alert_rule_hint, sort_order)
  VALUES ('ofs_mm_l1_10', 'Manage New Business Development And Intellectual Property', 'ofs_l3_10_5_5',
    'Business environment is not formally assessed as an input to opportunity identification.', 'An assessment is produced occasionally but inconsistently referenced in opportunity evaluation.', 'A documented business-environment assessment is produced at least annually and referenced in opportunity identification.', 'Environment-assessment findings are tracked over time and used to proactively adjust the opportunity pipeline.', 'Business-environment assessment is continuous through an integrated regulatory/economic-intelligence platform feeding the pipeline.',
    'Ask for the most recent business-environment assessment and confirm it was referenced in a current opportunity evaluation.', 'Business-environment assessment/scan; regulatory or economic outlook note; opportunity memo referencing the assessment.', 'Confirm a documented business-environment assessment exists within the current fiscal year and informs opportunity evaluation.', 'Flag if no documented business-environment assessment has been produced within the current fiscal year.', 5)
  ON CONFLICT (maturity_model_id, process_area) DO NOTHING;

  -- 10.6.1
  INSERT INTO questions (questionnaire_id, evaluation_type_id, domain_id, process_id,
    question_code, question_text, question_intent, instruction_text, evidence_examples,
    alert_rule_hint, mapped_maturity_model_id, mapped_maturity_statement_id, matched_process_area, sort_order)
  SELECT v_questionnaire_id, v_eval_type_id, v_domain_id, p.id,
    'ofs_l3_10_6_1', 'How mature is the organization''s process for documenting a cost assessment as part of preparing a proposal?', 'Assess whether proposals are built on a documented cost estimate reconciled to the proposed price, versus proposal pricing being estimated informally with no documented cost basis.', 'Review the documented cost assessment behind a recent proposal and confirm it reconciles to the price stated in the proposal.', 'Proposal cost estimate/build-up; margin calculation; proposal document showing reconciled price.',
    'Flag if a submitted proposal''s price does not reconcile to a documented cost assessment.', 'ofs_mm_l1_10', 'ofs_l3_10_6_1', 'ofs_l3_10_6_1', 1
  FROM processes p WHERE p.code = 'ofs_l2_10_6';
  INSERT INTO maturity_statements (maturity_model_id, domain_title, process_area,
    level_1_basic, level_2_developing, level_3_established, level_4_advanced, level_5_leading,
    assessor_instruction, evidence_examples, review_steps, alert_rule_hint, sort_order)
  VALUES ('ofs_mm_l1_10', 'Manage New Business Development And Intellectual Property', 'ofs_l3_10_6_1',
    'Proposal costs are estimated informally with no documented assessment.', 'A cost assessment is documented for some proposals but does not consistently reconcile to the proposed price.', 'A documented cost assessment, reconciled to the proposed price, exists for every submitted proposal.', 'Cost-assessment accuracy is tracked against actual delivered project costs and used to refine future estimating.', 'Proposal cost assessment is supported by an integrated cost-estimating platform using live cost data.',
    'Ask for the documented cost assessment behind the most recently submitted proposal and confirm reconciliation to price.', 'Proposal cost estimate/build-up; margin calculation; proposal document showing reconciled price.', 'Confirm a documented cost assessment exists for the most recent proposal and reconciles to the proposed price.', 'Flag if a submitted proposal''s price does not reconcile to a documented cost assessment.', 1)
  ON CONFLICT (maturity_model_id, process_area) DO NOTHING;

  -- 10.6.2
  INSERT INTO questions (questionnaire_id, evaluation_type_id, domain_id, process_id,
    question_code, question_text, question_intent, instruction_text, evidence_examples,
    alert_rule_hint, mapped_maturity_model_id, mapped_maturity_statement_id, matched_process_area, sort_order)
  SELECT v_questionnaire_id, v_eval_type_id, v_domain_id, p.id,
    'ofs_l3_10_6_2', 'How mature is the organization''s process for documenting a formal bid/no-bid decision, with recorded rationale, before committing resources to a proposal?', 'Assess whether bid commitments follow a documented bid/no-bid decision with recorded rationale, versus proposals being pursued by default with no documented decision point.', 'Review the documented bid/no-bid decision record for a recent opportunity and confirm it states the rationale and decision-maker.', 'Bid/no-bid decision memo; decision criteria checklist; decision-maker sign-off.',
    'Flag if resources were committed to a proposal with no documented bid/no-bid decision on file.', 'ofs_mm_l1_10', 'ofs_l3_10_6_2', 'ofs_l3_10_6_2', 2
  FROM processes p WHERE p.code = 'ofs_l2_10_6';
  INSERT INTO maturity_statements (maturity_model_id, domain_title, process_area,
    level_1_basic, level_2_developing, level_3_established, level_4_advanced, level_5_leading,
    assessor_instruction, evidence_examples, review_steps, alert_rule_hint, sort_order)
  VALUES ('ofs_mm_l1_10', 'Manage New Business Development And Intellectual Property', 'ofs_l3_10_6_2',
    'Bid/no-bid decisions are made informally with no documented record or rationale.', 'A decision record is documented for some opportunities but inconsistently or without stated rationale.', 'A documented bid/no-bid decision, with stated rationale and sign-off, precedes every proposal pursued.', 'Bid/no-bid decision outcomes are tracked against win rate to refine the bid-decision criteria.', 'Bid/no-bid decisions are supported by an integrated opportunity-scoring platform using live win-probability data.',
    'Ask for the documented bid/no-bid decision behind the most recently pursued proposal and confirm stated rationale.', 'Bid/no-bid decision memo; decision criteria checklist; decision-maker sign-off.', 'Confirm a documented bid/no-bid decision, with rationale and sign-off, exists for the most recent proposal.', 'Flag if resources were committed to a proposal with no documented bid/no-bid decision on file.', 2)
  ON CONFLICT (maturity_model_id, process_area) DO NOTHING;

  -- 10.6.3
  INSERT INTO questions (questionnaire_id, evaluation_type_id, domain_id, process_id,
    question_code, question_text, question_intent, instruction_text, evidence_examples,
    alert_rule_hint, mapped_maturity_model_id, mapped_maturity_statement_id, matched_process_area, sort_order)
  SELECT v_questionnaire_id, v_eval_type_id, v_domain_id, p.id,
    'ofs_l3_10_6_3', 'How mature is the organization''s process for obtaining and documenting formal internal approval of a proposal before submission to the client?', 'Assess whether proposals are submitted only after documented internal approval (commercial, legal, technical sign-off), versus proposals being sent with no documented approval record.', 'Review the documented approval record for a recently submitted proposal and confirm it shows sign-off from the required internal functions.', 'Proposal approval record/sign-off sheet; required-approver list; approval workflow log.',
    'Flag if a submitted proposal has no documented internal approval record on file.', 'ofs_mm_l1_10', 'ofs_l3_10_6_3', 'ofs_l3_10_6_3', 3
  FROM processes p WHERE p.code = 'ofs_l2_10_6';
  INSERT INTO maturity_statements (maturity_model_id, domain_title, process_area,
    level_1_basic, level_2_developing, level_3_established, level_4_advanced, level_5_leading,
    assessor_instruction, evidence_examples, review_steps, alert_rule_hint, sort_order)
  VALUES ('ofs_mm_l1_10', 'Manage New Business Development And Intellectual Property', 'ofs_l3_10_6_3',
    'Proposals are submitted with no documented internal approval.', 'Approval is documented for some proposals but does not consistently cover all required functions.', 'A documented approval record, covering all required internal functions, exists for every submitted proposal.', 'Approval cycle time and outcomes are tracked and used to streamline the approval workflow.', 'Proposal approval is managed through an integrated workflow platform with automated routing and audit trail.',
    'Ask for the documented approval record of the most recently submitted proposal and confirm required sign-offs.', 'Proposal approval record/sign-off sheet; required-approver list; approval workflow log.', 'Confirm a documented internal approval record exists for the most recent proposal, covering required functions.', 'Flag if a submitted proposal has no documented internal approval record on file.', 3)
  ON CONFLICT (maturity_model_id, process_area) DO NOTHING;

  -- 10.6.4
  INSERT INTO questions (questionnaire_id, evaluation_type_id, domain_id, process_id,
    question_code, question_text, question_intent, instruction_text, evidence_examples,
    alert_rule_hint, mapped_maturity_model_id, mapped_maturity_statement_id, matched_process_area, sort_order)
  SELECT v_questionnaire_id, v_eval_type_id, v_domain_id, p.id,
    'ofs_l3_10_6_4', 'How mature is the organization''s process for documenting execution of the formal bidding process (submission, clarifications, revisions) through to award or close-out?', 'Assess whether the bidding process is tracked through a documented record from submission to outcome, versus bid execution being managed informally with no documented tracking.', 'Review the documented bid-process tracker for a recent bid and confirm it records submission, any clarification exchanges, and the final outcome.', 'Bid-process tracker; submission and clarification log; bid-outcome record.',
    'Flag if a submitted bid has no documented tracking of clarifications or final outcome.', 'ofs_mm_l1_10', 'ofs_l3_10_6_4', 'ofs_l3_10_6_4', 4
  FROM processes p WHERE p.code = 'ofs_l2_10_6';
  INSERT INTO maturity_statements (maturity_model_id, domain_title, process_area,
    level_1_basic, level_2_developing, level_3_established, level_4_advanced, level_5_leading,
    assessor_instruction, evidence_examples, review_steps, alert_rule_hint, sort_order)
  VALUES ('ofs_mm_l1_10', 'Manage New Business Development And Intellectual Property', 'ofs_l3_10_6_4',
    'The bidding process is managed informally with no documented tracking.', 'A bid tracker is used for some bids but inconsistently maintained through to outcome.', 'A documented bid-process tracker, from submission to outcome, exists for every bid submitted.', 'Bid-process cycle time and clarification patterns are tracked across bids to refine the bidding playbook.', 'Bid-process execution is managed through an integrated bid-management platform with automated tracking and audit trail.',
    'Ask for the documented bid-process tracker of the most recent bid and confirm it covers submission through outcome.', 'Bid-process tracker; submission and clarification log; bid-outcome record.', 'Confirm a documented bid-process tracker exists for the most recent bid, from submission to final outcome.', 'Flag if a submitted bid has no documented tracking of clarifications or final outcome.', 4)
  ON CONFLICT (maturity_model_id, process_area) DO NOTHING;
END $$;