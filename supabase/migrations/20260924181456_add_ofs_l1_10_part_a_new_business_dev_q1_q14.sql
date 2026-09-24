/*
# OFS L1.10 Part A - Manage New Business Development And Intellectual Property (Q1-Q14)
# Items ofs_l3_10_1_1 through ofs_l3_10_2_3 (sub-processes 10.1 + 10.2) plus
# items ofs_l3_10_3_1 through ofs_l3_10_3_6 (sub-process 10.3) plus
# items ofs_l3_10_4_1 through ofs_l3_10_4_3 (sub-process 10.4 partial)
# plus maturity_model ofs_mm_l1_10.
# 14 questions + 14 maturity_statements + 1 maturity_model.
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

  INSERT INTO maturity_models (code, label, description, domain_id, mapped_domain_id, mapped_domain_name, version, source_workbook, is_active)
  VALUES ('ofs_mm_l1_10', 'Manage New Business Development And Intellectual Property - Maturity Model', 'OFS Onshore maturity model for Manage New Business Development And Intellectual Property', v_domain_id, 'ofs_l1_10', 'Manage New Business Development And Intellectual Property', '1.0', 'POGO-OFS_Level_1-3_framework.pptx', true)
  ON CONFLICT (code) DO NOTHING;

  -- 10.1.1
  INSERT INTO questions (questionnaire_id, evaluation_type_id, domain_id, process_id,
    question_code, question_text, question_intent, instruction_text, evidence_examples,
    alert_rule_hint, mapped_maturity_model_id, mapped_maturity_statement_id, matched_process_area, sort_order)
  SELECT v_questionnaire_id, v_eval_type_id, v_domain_id, p.id,
    'ofs_l3_10_1_1', 'How mature is the organization''s process for conducting and documenting market and customer surveys as an input to marketing strategy?', 'Assess whether marketing strategy is grounded in documented, structured customer/market research, versus being based on informal impressions or anecdotal client feedback with no documented survey process.', 'Review the most recent market/customer survey (methodology, sample, findings) and confirm it was referenced in the current marketing-strategy document.', 'Market/customer survey instrument and results; survey methodology note; marketing-strategy document referencing survey findings.',
    'Flag if the current marketing strategy references no documented market or customer survey conducted within the last planning cycle.', 'ofs_mm_l1_10', 'ofs_l3_10_1_1', 'ofs_l3_10_1_1', 1
  FROM processes p WHERE p.code = 'ofs_l2_10_1';
  INSERT INTO maturity_statements (maturity_model_id, domain_title, process_area,
    level_1_basic, level_2_developing, level_3_established, level_4_advanced, level_5_leading,
    assessor_instruction, evidence_examples, review_steps, alert_rule_hint, sort_order)
  VALUES ('ofs_mm_l1_10', 'Manage New Business Development And Intellectual Property', 'ofs_l3_10_1_1',
    'Customer and market understanding is based on informal, anecdotal impressions with no documented survey.', 'Surveys are conducted occasionally but not on a defined cadence or not consistently used in strategy.', 'A documented market/customer survey is conducted on a defined cadence and referenced in marketing-strategy setting.', 'Survey findings are tracked over multiple cycles to identify shifting customer needs and adjust strategy proactively.', 'Customer and market insight is continuous through an integrated voice-of-customer platform feeding marketing strategy in real time.',
    'Ask for the most recent market/customer survey and confirm it is referenced in the current marketing-strategy document.', 'Market/customer survey instrument and results; survey methodology note; marketing-strategy document referencing survey findings.', 'Confirm a documented market/customer survey exists within the current planning cycle and is referenced in the marketing strategy.', 'Flag if the current marketing strategy references no documented market or customer survey conducted within the last planning cycle.', 1)
  ON CONFLICT (maturity_model_id, process_area) DO NOTHING;

  -- 10.1.2
  INSERT INTO questions (questionnaire_id, evaluation_type_id, domain_id, process_id,
    question_code, question_text, question_intent, instruction_text, evidence_examples,
    alert_rule_hint, mapped_maturity_model_id, mapped_maturity_statement_id, matched_process_area, sort_order)
  SELECT v_questionnaire_id, v_eval_type_id, v_domain_id, p.id,
    'ofs_l3_10_1_2', 'How mature is the organization''s process for researching and documenting competitive positioning and industry trends as an input to marketing strategy?', 'Assess whether marketing strategy is informed by a documented competitive/industry analysis, versus competitor awareness being informal and undocumented.', 'Review the most recent competitive/industry-trend analysis and confirm it covers named competitors and current industry trends relevant to the service portfolio.', 'Competitive-landscape analysis; industry-trend report; competitor benchmarking document.',
    'Flag if no documented competitive/industry analysis has been produced within the current fiscal year.', 'ofs_mm_l1_10', 'ofs_l3_10_1_2', 'ofs_l3_10_1_2', 2
  FROM processes p WHERE p.code = 'ofs_l2_10_1';
  INSERT INTO maturity_statements (maturity_model_id, domain_title, process_area,
    level_1_basic, level_2_developing, level_3_established, level_4_advanced, level_5_leading,
    assessor_instruction, evidence_examples, review_steps, alert_rule_hint, sort_order)
  VALUES ('ofs_mm_l1_10', 'Manage New Business Development And Intellectual Property', 'ofs_l3_10_1_2',
    'Competitive and industry awareness is informal with no documented analysis.', 'A competitive/industry analysis is produced occasionally but inconsistently or without named competitor detail.', 'A documented competitive/industry-trend analysis is produced at least annually and referenced in marketing strategy.', 'Competitive positioning is tracked over time and used to trigger strategy adjustments as competitor moves are detected.', 'Competitive and industry intelligence is continuous through an integrated market-intelligence platform feeding strategy in real time.',
    'Ask for the most recent competitive/industry-trend analysis and confirm it names competitors and current trends.', 'Competitive-landscape analysis; industry-trend report; competitor benchmarking document.', 'Confirm a documented competitive/industry analysis exists within the current fiscal year and is referenced in marketing strategy.', 'Flag if no documented competitive/industry analysis has been produced within the current fiscal year.', 2)
  ON CONFLICT (maturity_model_id, process_area) DO NOTHING;

  -- 10.1.3
  INSERT INTO questions (questionnaire_id, evaluation_type_id, domain_id, process_id,
    question_code, question_text, question_intent, instruction_text, evidence_examples,
    alert_rule_hint, mapped_maturity_model_id, mapped_maturity_statement_id, matched_process_area, sort_order)
  SELECT v_questionnaire_id, v_eval_type_id, v_domain_id, p.id,
    'ofs_l3_10_1_3', 'How mature is the organization''s process for comparing market/customer research findings against existing sales data before finalizing marketing strategy?', 'Assess whether marketing strategy reconciles external research with actual internal sales performance in a documented way, versus strategy being set from research alone with no cross-check against sales data.', 'Review the documented reconciliation of survey/research findings against sales-data trends and confirm it informed the current marketing-strategy decisions.', 'Sales-data trend report; research-versus-sales reconciliation document; marketing-strategy document referencing the comparison.',
    'Flag if the current marketing strategy shows no documented comparison between research findings and actual sales data.', 'ofs_mm_l1_10', 'ofs_l3_10_1_3', 'ofs_l3_10_1_3', 3
  FROM processes p WHERE p.code = 'ofs_l2_10_1';
  INSERT INTO maturity_statements (maturity_model_id, domain_title, process_area,
    level_1_basic, level_2_developing, level_3_established, level_4_advanced, level_5_leading,
    assessor_instruction, evidence_examples, review_steps, alert_rule_hint, sort_order)
  VALUES ('ofs_mm_l1_10', 'Manage New Business Development And Intellectual Property', 'ofs_l3_10_1_3',
    'Market research and sales data are reviewed separately with no documented comparison.', 'A comparison is made occasionally but not consistently documented or not tied to strategy decisions.', 'A documented comparison of research findings against sales data is produced and referenced in every marketing-strategy cycle.', 'Discrepancies between research and sales data are investigated and used to refine research methodology or sales targeting.', 'Research and sales data are reconciled continuously through an integrated analytics platform feeding strategy decisions in real time.',
    'Ask for the documented comparison of research findings against sales data behind the current marketing strategy.', 'Sales-data trend report; research-versus-sales reconciliation document; marketing-strategy document referencing the comparison.', 'Confirm a documented comparison exists between research findings and sales data and that it informed the current strategy.', 'Flag if the current marketing strategy shows no documented comparison between research findings and actual sales data.', 3)
  ON CONFLICT (maturity_model_id, process_area) DO NOTHING;

  -- 10.1.4
  INSERT INTO questions (questionnaire_id, evaluation_type_id, domain_id, process_id,
    question_code, question_text, question_intent, instruction_text, evidence_examples,
    alert_rule_hint, mapped_maturity_model_id, mapped_maturity_statement_id, matched_process_area, sort_order)
  SELECT v_questionnaire_id, v_eval_type_id, v_domain_id, p.id,
    'ofs_l3_10_1_4', 'How mature is the organization''s process for identifying and documenting potential alliances with other service providers to enhance sales opportunities?', 'Assess whether alliance opportunities are identified through a documented, structured evaluation, versus being pursued opportunistically with no documented rationale or screening.', 'Review the documented alliance-opportunity evaluation for a recent or current potential partner and confirm it states the rationale and expected sales impact.', 'Alliance-opportunity screening document; partner evaluation criteria; rationale memo stating expected sales impact.',
    'Flag if an active alliance discussion is underway with no documented opportunity evaluation on file.', 'ofs_mm_l1_10', 'ofs_l3_10_1_4', 'ofs_l3_10_1_4', 4
  FROM processes p WHERE p.code = 'ofs_l2_10_1';
  INSERT INTO maturity_statements (maturity_model_id, domain_title, process_area,
    level_1_basic, level_2_developing, level_3_established, level_4_advanced, level_5_leading,
    assessor_instruction, evidence_examples, review_steps, alert_rule_hint, sort_order)
  VALUES ('ofs_mm_l1_10', 'Manage New Business Development And Intellectual Property', 'ofs_l3_10_1_4',
    'Alliance opportunities are pursued opportunistically with no documented evaluation.', 'An evaluation is documented for some potential alliances but inconsistently or without stated sales-impact rationale.', 'A documented alliance-opportunity evaluation, with sales-impact rationale, precedes every alliance discussion pursued.', 'Alliance-opportunity outcomes are tracked against projected sales impact to refine future partner-selection criteria.', 'Alliance-opportunity identification is continuous through an integrated partner-network platform surfacing candidates systematically.',
    'Ask for the documented evaluation behind the most recent alliance opportunity pursued and confirm stated sales-impact rationale.', 'Alliance-opportunity screening document; partner evaluation criteria; rationale memo stating expected sales impact.', 'Confirm a documented alliance-opportunity evaluation exists for the most recent partner discussion, with stated rationale.', 'Flag if an active alliance discussion is underway with no documented opportunity evaluation on file.', 4)
  ON CONFLICT (maturity_model_id, process_area) DO NOTHING;

  -- 10.1.5
  INSERT INTO questions (questionnaire_id, evaluation_type_id, domain_id, process_id,
    question_code, question_text, question_intent, instruction_text, evidence_examples,
    alert_rule_hint, mapped_maturity_model_id, mapped_maturity_statement_id, matched_process_area, sort_order)
  SELECT v_questionnaire_id, v_eval_type_id, v_domain_id, p.id,
    'ofs_l3_10_1_5', 'How mature is the organization''s process for documenting positioning or repositioning decisions for new or existing services?', 'Assess whether service positioning decisions are grounded in a documented rationale linking market research to the chosen positioning, versus positioning being decided informally with no documented basis.', 'Review the documented positioning statement for a recent new or repositioned service and confirm it references supporting market research.', 'Service positioning statement; supporting market-research reference; go-to-market messaging document.',
    'Flag if a service was positioned or repositioned with no documented positioning statement on file.', 'ofs_mm_l1_10', 'ofs_l3_10_1_5', 'ofs_l3_10_1_5', 5
  FROM processes p WHERE p.code = 'ofs_l2_10_1';
  INSERT INTO maturity_statements (maturity_model_id, domain_title, process_area,
    level_1_basic, level_2_developing, level_3_established, level_4_advanced, level_5_leading,
    assessor_instruction, evidence_examples, review_steps, alert_rule_hint, sort_order)
  VALUES ('ofs_mm_l1_10', 'Manage New Business Development And Intellectual Property', 'ofs_l3_10_1_5',
    'Service positioning is decided informally with no documented statement or rationale.', 'A positioning statement is documented for some services but inconsistently linked to supporting research.', 'A documented positioning statement, linked to supporting market research, exists for every new or repositioned service.', 'Positioning effectiveness is tracked against market response (win rate, client feedback) and used to refine future positioning.', 'Service positioning is continuously optimized through an integrated market-response analytics platform.',
    'Ask for the documented positioning statement of the most recently positioned or repositioned service.', 'Service positioning statement; supporting market-research reference; go-to-market messaging document.', 'Confirm a documented positioning statement exists for the most recent service and references supporting market research.', 'Flag if a service was positioned or repositioned with no documented positioning statement on file.', 5)
  ON CONFLICT (maturity_model_id, process_area) DO NOTHING;

  -- 10.1.6
  INSERT INTO questions (questionnaire_id, evaluation_type_id, domain_id, process_id,
    question_code, question_text, question_intent, instruction_text, evidence_examples,
    alert_rule_hint, mapped_maturity_model_id, mapped_maturity_statement_id, matched_process_area, sort_order)
  SELECT v_questionnaire_id, v_eval_type_id, v_domain_id, p.id,
    'ofs_l3_10_1_6', 'How mature is the organization''s process for determining and documenting the pricing and assortment of services offered, aligned with company strategy?', 'Assess whether pricing and service-assortment decisions follow a documented process explicitly aligned to company strategy, versus being set ad hoc without a documented link to strategic priorities.', 'Review the documented pricing/assortment decision for the current service offering and confirm it explicitly references company strategy.', 'Pricing/assortment decision document; rate card; reference to company strategy document.',
    'Flag if the current service pricing/assortment has no documented decision record linking it to company strategy.', 'ofs_mm_l1_10', 'ofs_l3_10_1_6', 'ofs_l3_10_1_6', 6
  FROM processes p WHERE p.code = 'ofs_l2_10_1';
  INSERT INTO maturity_statements (maturity_model_id, domain_title, process_area,
    level_1_basic, level_2_developing, level_3_established, level_4_advanced, level_5_leading,
    assessor_instruction, evidence_examples, review_steps, alert_rule_hint, sort_order)
  VALUES ('ofs_mm_l1_10', 'Manage New Business Development And Intellectual Property', 'ofs_l3_10_1_6',
    'Pricing and service assortment are set informally with no documented decision record.', 'A pricing/assortment decision is documented for some services but not consistently linked to company strategy.', 'A documented pricing/assortment decision, explicitly aligned to company strategy, exists for the full service offering.', 'Pricing/assortment performance is tracked against strategic targets and used to refine future decisions.', 'Pricing and assortment are dynamically optimized through an integrated pricing-analytics platform aligned to live strategic targets.',
    'Ask for the documented pricing/assortment decision for the current service offering and confirm alignment to company strategy.', 'Pricing/assortment decision document; rate card; reference to company strategy document.', 'Confirm a documented pricing/assortment decision exists for the current offering and references company strategy.', 'Flag if the current service pricing/assortment has no documented decision record linking it to company strategy.', 6)
  ON CONFLICT (maturity_model_id, process_area) DO NOTHING;

  -- 10.2.1
  INSERT INTO questions (questionnaire_id, evaluation_type_id, domain_id, process_id,
    question_code, question_text, question_intent, instruction_text, evidence_examples,
    alert_rule_hint, mapped_maturity_model_id, mapped_maturity_statement_id, matched_process_area, sort_order)
  SELECT v_questionnaire_id, v_eval_type_id, v_domain_id, p.id,
    'ofs_l3_10_2_1', 'How mature is the organization''s process for developing and maintaining a documented, governed corporate image/brand identity used in marketing execution?', 'Assess whether marketing execution draws on a documented, governed brand identity, versus company image being informally and inconsistently represented across materials.', 'Review the documented brand/corporate-image guidelines and confirm they are applied consistently across a sample of current marketing materials.', 'Brand/corporate-image guidelines; visual identity standards; sample marketing materials showing compliance.',
    'Flag if current marketing materials do not match the documented brand/corporate-image guidelines.', 'ofs_mm_l1_10', 'ofs_l3_10_2_1', 'ofs_l3_10_2_1', 1
  FROM processes p WHERE p.code = 'ofs_l2_10_2';
  INSERT INTO maturity_statements (maturity_model_id, domain_title, process_area,
    level_1_basic, level_2_developing, level_3_established, level_4_advanced, level_5_leading,
    assessor_instruction, evidence_examples, review_steps, alert_rule_hint, sort_order)
  VALUES ('ofs_mm_l1_10', 'Manage New Business Development And Intellectual Property', 'ofs_l3_10_2_1',
    'Corporate image is represented inconsistently with no documented guidelines.', 'Brand guidelines exist but are outdated or inconsistently applied across marketing materials.', 'Current, documented brand/corporate-image guidelines are applied consistently across marketing materials.', 'Brand consistency is audited periodically across channels and materials, with gaps tracked to closure.', 'Corporate image is managed through an integrated digital asset-management platform enforcing consistent application automatically.',
    'Ask for the current brand/corporate-image guidelines and a sample of marketing materials to confirm compliance.', 'Brand/corporate-image guidelines; visual identity standards; sample marketing materials showing compliance.', 'Confirm current, documented brand guidelines exist and that sampled marketing materials comply with them.', 'Flag if current marketing materials do not match the documented brand/corporate-image guidelines.', 1)
  ON CONFLICT (maturity_model_id, process_area) DO NOTHING;

  -- 10.2.2
  INSERT INTO questions (questionnaire_id, evaluation_type_id, domain_id, process_id,
    question_code, question_text, question_intent, instruction_text, evidence_examples,
    alert_rule_hint, mapped_maturity_model_id, mapped_maturity_statement_id, matched_process_area, sort_order)
  SELECT v_questionnaire_id, v_eval_type_id, v_domain_id, p.id,
    'ofs_l3_10_2_2', 'How mature is the organization''s process for selecting and documenting the media and promotion vehicles used to execute marketing strategy?', 'Assess whether media/channel selection follows a documented rationale linking channel choice to target audience and expected reach, versus channels being chosen informally with no documented rationale.', 'Review the documented media/channel plan for the current marketing campaign and confirm it states the rationale for the channels selected.', 'Media/channel plan; target-audience analysis; channel-selection rationale document.',
    'Flag if a current marketing campaign has no documented media/channel plan with stated rationale.', 'ofs_mm_l1_10', 'ofs_l3_10_2_2', 'ofs_l3_10_2_2', 2
  FROM processes p WHERE p.code = 'ofs_l2_10_2';
  INSERT INTO maturity_statements (maturity_model_id, domain_title, process_area,
    level_1_basic, level_2_developing, level_3_established, level_4_advanced, level_5_leading,
    assessor_instruction, evidence_examples, review_steps, alert_rule_hint, sort_order)
  VALUES ('ofs_mm_l1_10', 'Manage New Business Development And Intellectual Property', 'ofs_l3_10_2_2',
    'Media and promotion vehicles are selected informally with no documented plan or rationale.', 'A channel plan is documented for some campaigns but inconsistently, without a stated rationale.', 'A documented media/channel plan, with stated rationale linked to target audience, exists for every marketing campaign.', 'Channel performance (reach, engagement, conversion) is tracked and used to refine future channel selection.', 'Media/channel selection is dynamically optimized through an integrated marketing-analytics platform using live performance data.',
    'Ask for the documented media/channel plan of the current marketing campaign and confirm a stated rationale.', 'Media/channel plan; target-audience analysis; channel-selection rationale document.', 'Confirm a documented media/channel plan exists for the current campaign, with a stated selection rationale.', 'Flag if a current marketing campaign has no documented media/channel plan with stated rationale.', 2)
  ON CONFLICT (maturity_model_id, process_area) DO NOTHING;

  -- 10.2.3
  INSERT INTO questions (questionnaire_id, evaluation_type_id, domain_id, process_id,
    question_code, question_text, question_intent, instruction_text, evidence_examples,
    alert_rule_hint, mapped_maturity_model_id, mapped_maturity_statement_id, matched_process_area, sort_order)
  SELECT v_questionnaire_id, v_eval_type_id, v_domain_id, p.id,
    'ofs_l3_10_2_3', 'How mature is the organization''s process for documenting and tracking ongoing marketing activities related to active service and product lines?', 'Assess whether ongoing marketing activity is tracked in a documented, structured way across active service lines, versus activity happening ad hoc with no documented tracking.', 'Review the documented marketing-activity tracker or calendar for the current period and confirm it covers all active service lines.', 'Marketing-activity tracker/calendar; activity status report; coverage list of active service/product lines.',
    'Flag if an active service line has no documented marketing activity tracked in the current period.', 'ofs_mm_l1_10', 'ofs_l3_10_2_3', 'ofs_l3_10_2_3', 3
  FROM processes p WHERE p.code = 'ofs_l2_10_2';
  INSERT INTO maturity_statements (maturity_model_id, domain_title, process_area,
    level_1_basic, level_2_developing, level_3_established, level_4_advanced, level_5_leading,
    assessor_instruction, evidence_examples, review_steps, alert_rule_hint, sort_order)
  VALUES ('ofs_mm_l1_10', 'Manage New Business Development And Intellectual Property', 'ofs_l3_10_2_3',
    'Marketing activities are carried out ad hoc with no documented tracking.', 'Activity is tracked for some service lines but not consistently across the full active portfolio.', 'A documented marketing-activity tracker covers all active service and product lines on a regular cadence.', 'Marketing-activity effectiveness is tracked by service line and used to reallocate marketing effort toward higher-return lines.', 'Marketing-activity tracking and reallocation are managed through an integrated marketing-operations platform in real time.',
    'Ask for the current marketing-activity tracker and confirm it covers all active service and product lines.', 'Marketing-activity tracker/calendar; activity status report; coverage list of active service/product lines.', 'Confirm a documented marketing-activity tracker exists for the current period and covers all active service lines.', 'Flag if an active service line has no documented marketing activity tracked in the current period.', 3)
  ON CONFLICT (maturity_model_id, process_area) DO NOTHING;

  -- 10.3.1
  INSERT INTO questions (questionnaire_id, evaluation_type_id, domain_id, process_id,
    question_code, question_text, question_intent, instruction_text, evidence_examples,
    alert_rule_hint, mapped_maturity_model_id, mapped_maturity_statement_id, matched_process_area, sort_order)
  SELECT v_questionnaire_id, v_eval_type_id, v_domain_id, p.id,
    'ofs_l3_10_3_1', 'How mature is the organization''s process for documenting an assessment of terms and conditions of business before entering contract negotiations?', 'Assess whether contract negotiations begin from a documented review of standard terms and conditions and any required deviations, versus negotiators entering discussions with no documented terms review.', 'Review the documented terms-and-conditions assessment for a recent contract negotiation and confirm it identifies any deviations from standard terms.', 'Standard terms and conditions document; contract-specific terms assessment; deviation log from standard terms.',
    'Flag if a contract negotiation proceeded with no documented terms-and-conditions assessment on file.', 'ofs_mm_l1_10', 'ofs_l3_10_3_1', 'ofs_l3_10_3_1', 1
  FROM processes p WHERE p.code = 'ofs_l2_10_3';
  INSERT INTO maturity_statements (maturity_model_id, domain_title, process_area,
    level_1_basic, level_2_developing, level_3_established, level_4_advanced, level_5_leading,
    assessor_instruction, evidence_examples, review_steps, alert_rule_hint, sort_order)
  VALUES ('ofs_mm_l1_10', 'Manage New Business Development And Intellectual Property', 'ofs_l3_10_3_1',
    'Terms and conditions are reviewed informally with no documented assessment.', 'A terms assessment is documented for some negotiations but inconsistently or without a deviation log.', 'A documented terms-and-conditions assessment, including deviation log, precedes every contract negotiation.', 'Deviation patterns are tracked across negotiations and used to refine standard terms and negotiation playbooks.', 'Terms-and-conditions assessment is supported by an integrated contract-analytics platform flagging risk deviations automatically.',
    'Ask for the documented terms-and-conditions assessment behind the most recent contract negotiation.', 'Standard terms and conditions document; contract-specific terms assessment; deviation log from standard terms.', 'Confirm a documented terms-and-conditions assessment exists for the most recent negotiation, including any deviation log.', 'Flag if a contract negotiation proceeded with no documented terms-and-conditions assessment on file.', 1)
  ON CONFLICT (maturity_model_id, process_area) DO NOTHING;

  -- 10.3.2
  INSERT INTO questions (questionnaire_id, evaluation_type_id, domain_id, process_id,
    question_code, question_text, question_intent, instruction_text, evidence_examples,
    alert_rule_hint, mapped_maturity_model_id, mapped_maturity_statement_id, matched_process_area, sort_order)
  SELECT v_questionnaire_id, v_eval_type_id, v_domain_id, p.id,
    'ofs_l3_10_3_2', 'How mature is the organization''s process for identifying and documenting potential contract risks before finalizing a negotiation?', 'Assess whether contract risk is identified through a documented, structured risk review, versus risk being assessed informally with no documented record.', 'Review the documented contract-risk identification record for a recent negotiation and confirm it covers key risk categories (liability, indemnity, performance).', 'Contract-risk identification checklist/register; legal review note; risk-category coverage record.',
    'Flag if a finalized contract has no documented risk-identification record on file.', 'ofs_mm_l1_10', 'ofs_l3_10_3_2', 'ofs_l3_10_3_2', 2
  FROM processes p WHERE p.code = 'ofs_l2_10_3';
  INSERT INTO maturity_statements (maturity_model_id, domain_title, process_area,
    level_1_basic, level_2_developing, level_3_established, level_4_advanced, level_5_leading,
    assessor_instruction, evidence_examples, review_steps, alert_rule_hint, sort_order)
  VALUES ('ofs_mm_l1_10', 'Manage New Business Development And Intellectual Property', 'ofs_l3_10_3_2',
    'Contract risk is assessed informally with no documented record.', 'A risk-identification record is documented for some contracts but does not consistently cover key risk categories.', 'A documented risk-identification record, covering key risk categories, exists for every finalized contract.', 'Identified risk patterns are tracked across contracts and used to refine standard risk-review checklists.', 'Contract-risk identification is supported by an integrated legal-analytics platform flagging risk clauses automatically.',
    'Ask for the documented risk-identification record behind the most recently finalized contract.', 'Contract-risk identification checklist/register; legal review note; risk-category coverage record.', 'Confirm a documented risk-identification record exists for the most recent contract and covers key risk categories.', 'Flag if a finalized contract has no documented risk-identification record on file.', 2)
  ON CONFLICT (maturity_model_id, process_area) DO NOTHING;

  -- 10.3.3
  INSERT INTO questions (questionnaire_id, evaluation_type_id, domain_id, process_id,
    question_code, question_text, question_intent, instruction_text, evidence_examples,
    alert_rule_hint, mapped_maturity_model_id, mapped_maturity_statement_id, matched_process_area, sort_order)
  SELECT v_questionnaire_id, v_eval_type_id, v_domain_id, p.id,
    'ofs_l3_10_3_3', 'How mature is the organization''s process for documenting risk-mitigation measures taken in response to identified contract risks?', 'Assess whether identified contract risks are addressed through documented mitigation measures with a recorded outcome, versus risks being noted with no documented follow-up.', 'Review the documented mitigation measures taken for a recent contract''s identified risks and confirm each identified risk has a recorded mitigation outcome.', 'Risk-mitigation action log; contract clause amendments addressing identified risk; sign-off confirming mitigation.',
    'Flag if an identified contract risk has no documented mitigation measure or recorded outcome.', 'ofs_mm_l1_10', 'ofs_l3_10_3_3', 'ofs_l3_10_3_3', 3
  FROM processes p WHERE p.code = 'ofs_l2_10_3';
  INSERT INTO maturity_statements (maturity_model_id, domain_title, process_area,
    level_1_basic, level_2_developing, level_3_established, level_4_advanced, level_5_leading,
    assessor_instruction, evidence_examples, review_steps, alert_rule_hint, sort_order)
  VALUES ('ofs_mm_l1_10', 'Manage New Business Development And Intellectual Property', 'ofs_l3_10_3_3',
    'Identified risks are noted with no documented mitigation follow-up.', 'Mitigation measures are documented for some identified risks but inconsistently tracked to outcome.', 'A documented mitigation measure, with recorded outcome, exists for every identified contract risk.', 'Mitigation effectiveness is tracked across contracts and used to refine standard mitigation playbooks.', 'Risk mitigation is supported by an integrated contract-risk platform tracking measures and outcomes automatically.',
    'Ask for the documented mitigation measures and outcomes for the identified risks in the most recent contract.', 'Risk-mitigation action log; contract clause amendments addressing identified risk; sign-off confirming mitigation.', 'Confirm every identified risk in the most recent contract has a documented mitigation measure and recorded outcome.', 'Flag if an identified contract risk has no documented mitigation measure or recorded outcome.', 3)
  ON CONFLICT (maturity_model_id, process_area) DO NOTHING;

  -- 10.3.4
  INSERT INTO questions (questionnaire_id, evaluation_type_id, domain_id, process_id,
    question_code, question_text, question_intent, instruction_text, evidence_examples,
    alert_rule_hint, mapped_maturity_model_id, mapped_maturity_statement_id, matched_process_area, sort_order)
  SELECT v_questionnaire_id, v_eval_type_id, v_domain_id, p.id,
    'ofs_l3_10_3_4', 'How mature is the organization''s process for documenting the agreed cost/price basis of a project as part of contract negotiation?', 'Assess whether the agreed project cost is grounded in a documented cost basis (cost build-up, margin target) reconciled to the contract, versus price being agreed informally with no documented cost basis.', 'Review the documented cost basis for a recent contract and confirm it reconciles to the final agreed contract price.', 'Project cost build-up/estimate; margin-target reference; final contract price reconciliation.',
    'Flag if a finalized contract''s agreed price does not reconcile to a documented cost basis.', 'ofs_mm_l1_10', 'ofs_l3_10_3_4', 'ofs_l3_10_3_4', 4
  FROM processes p WHERE p.code = 'ofs_l2_10_3';
  INSERT INTO maturity_statements (maturity_model_id, domain_title, process_area,
    level_1_basic, level_2_developing, level_3_established, level_4_advanced, level_5_leading,
    assessor_instruction, evidence_examples, review_steps, alert_rule_hint, sort_order)
  VALUES ('ofs_mm_l1_10', 'Manage New Business Development And Intellectual Property', 'ofs_l3_10_3_4',
    'Project cost/price is agreed informally with no documented cost basis.', 'A cost basis is documented for some contracts but does not consistently reconcile to the final agreed price.', 'A documented cost basis, reconciled to the final agreed price, exists for every finalized contract.', 'Cost-basis accuracy is tracked against actual project costs and used to refine future estimating.', 'Project cost/price agreement is supported by an integrated cost-estimating platform using live cost data.',
    'Ask for the documented cost basis behind the most recently finalized contract and confirm reconciliation to the agreed price.', 'Project cost build-up/estimate; margin-target reference; final contract price reconciliation.', 'Confirm a documented cost basis exists for the most recent contract and reconciles to the final agreed price.', 'Flag if a finalized contract''s agreed price does not reconcile to a documented cost basis.', 4)
  ON CONFLICT (maturity_model_id, process_area) DO NOTHING;
END $$;