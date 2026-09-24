/*
# OFS Onshore L1.8 Part A — Develop Vision And Strategy (Q1-Q8)

1. Content added (purely additive)
   - 1 maturity model: ofs_mm_l1_8
   - 8 questions: ofs_l3_8_1_1..ofs_l3_8_1_4 + ofs_l3_8_2_1..ofs_l3_8_2_4
   - 8 maturity statements (one per question)

2. Covers L2 processes: ofs_l2_8_1 (Assess The Environment), ofs_l2_8_2 (Define The Business Concept And Long-Term Vision)

3. No structural changes — data INSERT only with ON CONFLICT DO NOTHING.
*/

DO $$
DECLARE
  v_questionnaire_id uuid;
  v_eval_type_id uuid;
  v_domain_id uuid;
BEGIN
  SELECT id INTO v_eval_type_id FROM evaluation_types WHERE code = 'ofs_onshore';
  SELECT id INTO v_questionnaire_id FROM questionnaires WHERE code = 'ofs_onshore_questionnaire';
  SELECT id INTO v_domain_id FROM domains WHERE code = 'ofs_l1_8';

  -- Maturity model
  INSERT INTO maturity_models (code, label, description, domain_id, mapped_domain_id, mapped_domain_name, version, source_workbook, is_active)
  VALUES ('ofs_mm_l1_8', 'Develop Vision And Strategy - Maturity Model', 'OFS Onshore maturity model for Develop Vision And Strategy', v_domain_id, 'ofs_l1_8', 'Develop Vision And Strategy', '1.0', 'POGO-OFS_Level_1-3_framework.pptx', true)
  ON CONFLICT (code) DO NOTHING;

  -- ===== L2_8_1: Assess The Environment =====

  -- Q1: ofs_l3_8_1_1
  INSERT INTO questions (questionnaire_id, evaluation_type_id, domain_id, process_id,
    question_code, question_text, question_intent, instruction_text, evidence_examples,
    alert_rule_hint, mapped_maturity_model_id, mapped_maturity_statement_id, matched_process_area, sort_order)
  SELECT v_questionnaire_id, v_eval_type_id, v_domain_id, p.id,
    'ofs_l3_8_1_1',
    'How mature is the organization''s process for assessing the external environment (commodity prices, rig count trends, operator capex cycles, competitor activity, regulatory change) as a documented input to the strategic-planning cycle?',
    'Assess whether the annual/periodic strategy cycle is grounded in a documented external-environment scan (market, competitive, regulatory, macro drivers specific to oilfield services), versus strategy discussions that proceed on assumption or anecdote with no documented scan.',
    'Review the most recent external-environment assessment or market scan produced for the strategic-planning cycle and confirm it covers commodity/activity drivers, competitor positioning, and regulatory developments, and that it was dated before the strategy decisions it informed.',
    'External-environment scan or market-intelligence report; competitor benchmarking summary; strategic-planning cycle calendar/agenda referencing the scan.',
    'Flag if a strategic-planning cycle proceeds with no dated external-environment assessment on file preceding its key decisions.',
    'ofs_mm_l1_8', 'ofs_l3_8_1_1', 'ofs_l3_8_1_1', 1
  FROM processes p WHERE p.code = 'ofs_l2_8_1';

  INSERT INTO maturity_statements (maturity_model_id, domain_title, process_area,
    level_1_basic, level_2_developing, level_3_established, level_4_advanced, level_5_leading,
    assessor_instruction, evidence_examples, review_steps, alert_rule_hint, sort_order)
  VALUES ('ofs_mm_l1_8', 'Develop Vision And Strategy', 'ofs_l3_8_1_1',
    'Strategic discussions proceed with no documented external-environment assessment; market context is assumed informally.',
    'An external scan is produced for some planning cycles but is inconsistent in coverage and not reliably dated ahead of decisions.',
    'Every strategic-planning cycle is preceded by a documented external-environment assessment covering market, competitive, and regulatory drivers.',
    'External-assessment findings are tracked cycle over cycle to validate forecasting accuracy and refine the scanning methodology.',
    'External-environment assessment is supported by a live market-intelligence platform providing continuously updated indicators to strategic planning.',
    'Ask for the external-environment assessment behind the current strategic-planning cycle and confirm its date precedes the cycle''s key decision points.',
    'External-environment scan or market-intelligence report; competitor benchmarking summary; strategic-planning cycle calendar/agenda referencing the scan.',
    'Confirm one planning cycle''s external-environment assessment is on file, dated, and referenced in the resulting strategy decisions.',
    'Flag if a strategic-planning cycle proceeds with no dated external-environment assessment on file preceding its key decisions.', 1)
  ON CONFLICT (maturity_model_id, process_area) DO NOTHING;

  -- Q2: ofs_l3_8_1_2
  INSERT INTO questions (questionnaire_id, evaluation_type_id, domain_id, process_id,
    question_code, question_text, question_intent, instruction_text, evidence_examples,
    alert_rule_hint, mapped_maturity_model_id, mapped_maturity_statement_id, matched_process_area, sort_order)
  SELECT v_questionnaire_id, v_eval_type_id, v_domain_id, p.id,
    'ofs_l3_8_1_2',
    'How mature is the organization''s process for surveying its operator customers to determine their service needs, priorities, and satisfaction as an input to strategic planning?',
    'Assess whether customer needs are captured through a documented, structured process (surveys, account reviews, win/loss analysis) feeding the strategy cycle, versus inferred informally from individual relationships with no documented synthesis.',
    'Review the customer needs/satisfaction survey or structured account-review findings used in the current strategic-planning cycle, and confirm the findings were synthesized and presented to the planning process.',
    'Customer satisfaction/needs survey results; structured account review notes; win/loss analysis summary; synthesis presented to strategic planning.',
    'Flag if a strategic-planning cycle proceeds with no documented customer needs synthesis less than 12 months old.',
    'ofs_mm_l1_8', 'ofs_l3_8_1_2', 'ofs_l3_8_1_2', 2
  FROM processes p WHERE p.code = 'ofs_l2_8_1';

  INSERT INTO maturity_statements (maturity_model_id, domain_title, process_area,
    level_1_basic, level_2_developing, level_3_established, level_4_advanced, level_5_leading,
    assessor_instruction, evidence_examples, review_steps, alert_rule_hint, sort_order)
  VALUES ('ofs_mm_l1_8', 'Develop Vision And Strategy', 'ofs_l3_8_1_2',
    'Customer needs are inferred informally from individual relationships with no documented survey or synthesis.',
    'Customer feedback is collected for some accounts but not consistently synthesized into a strategic-planning input.',
    'Every strategic-planning cycle draws on a documented, structured customer needs/satisfaction assessment across the customer base.',
    'Customer needs data is tracked over time to identify shifting priorities and inform service-line investment decisions.',
    'Customer needs assessment is integrated with a real-time voice-of-customer platform feeding strategic planning continuously.',
    'Ask for the customer needs/satisfaction assessment behind the current strategic-planning cycle and confirm it synthesizes findings across more than one customer account.',
    'Customer satisfaction/needs survey results; structured account review notes; win/loss analysis summary; synthesis presented to strategic planning.',
    'Confirm one planning cycle''s customer needs assessment is on file, less than 12 months old, and referenced in the resulting strategy.',
    'Flag if a strategic-planning cycle proceeds with no documented customer needs synthesis less than 12 months old.', 2)
  ON CONFLICT (maturity_model_id, process_area) DO NOTHING;

  -- Q3: ofs_l3_8_1_3
  INSERT INTO questions (questionnaire_id, evaluation_type_id, domain_id, process_id,
    question_code, question_text, question_intent, instruction_text, evidence_examples,
    alert_rule_hint, mapped_maturity_model_id, mapped_maturity_statement_id, matched_process_area, sort_order)
  SELECT v_questionnaire_id, v_eval_type_id, v_domain_id, p.id,
    'ofs_l3_8_1_3',
    'How mature is the organization''s process for performing a documented internal analysis (capability, capacity, financial performance, HSE performance) as an input to strategic planning?',
    'Assess whether strategic planning is grounded in a documented internal capability/performance analysis (equipment fleet, crew capacity, financial results, HSE record), versus assumed without a documented internal baseline.',
    'Review the internal analysis document (capability inventory, capacity utilization, financial performance summary, HSE performance) prepared for the current strategic-planning cycle and confirm it was completed before the strategy decisions it informed.',
    'Internal capability/capacity analysis; financial performance summary; HSE performance summary; SWOT or equivalent internal assessment document.',
    'Flag if a strategic-planning cycle proceeds with no documented internal analysis preceding its key decisions.',
    'ofs_mm_l1_8', 'ofs_l3_8_1_3', 'ofs_l3_8_1_3', 3
  FROM processes p WHERE p.code = 'ofs_l2_8_1';

  INSERT INTO maturity_statements (maturity_model_id, domain_title, process_area,
    level_1_basic, level_2_developing, level_3_established, level_4_advanced, level_5_leading,
    assessor_instruction, evidence_examples, review_steps, alert_rule_hint, sort_order)
  VALUES ('ofs_mm_l1_8', 'Develop Vision And Strategy', 'ofs_l3_8_1_3',
    'Internal capability and performance are discussed informally with no documented analysis prepared for planning.',
    'An internal analysis is prepared for some planning cycles but coverage (capability, capacity, financial, HSE) is inconsistent.',
    'Every strategic-planning cycle is preceded by a documented internal analysis covering capability, capacity, financial, and HSE performance.',
    'Internal analysis findings are tracked across cycles to validate capacity forecasts and refine investment prioritization.',
    'Internal analysis draws on an integrated operations-and-financial data platform providing real-time capability and performance visibility to strategic planning.',
    'Ask for the internal analysis document behind the current strategic-planning cycle and confirm its date precedes the cycle''s key decision points.',
    'Internal capability/capacity analysis; financial performance summary; HSE performance summary; SWOT or equivalent internal assessment document.',
    'Confirm one planning cycle''s internal analysis is on file, dated, and covers capability, capacity, financial, and HSE performance.',
    'Flag if a strategic-planning cycle proceeds with no documented internal analysis preceding its key decisions.', 3)
  ON CONFLICT (maturity_model_id, process_area) DO NOTHING;

  -- Q4: ofs_l3_8_1_4
  INSERT INTO questions (questionnaire_id, evaluation_type_id, domain_id, process_id,
    question_code, question_text, question_intent, instruction_text, evidence_examples,
    alert_rule_hint, mapped_maturity_model_id, mapped_maturity_statement_id, matched_process_area, sort_order)
  SELECT v_questionnaire_id, v_eval_type_id, v_domain_id, p.id,
    'ofs_l3_8_1_4',
    'How mature is the organization''s process for establishing and formally documenting a strategic vision that is approved by leadership and communicated across the organization?',
    'Assess whether the strategic vision is a documented, leadership-approved statement communicated to the organization, versus an informal, undocumented sense of direction held only by senior leadership.',
    'Review the documented strategic vision statement, confirm it carries a leadership approval/sign-off, and confirm evidence it was communicated to the organization (townhall materials, intranet posting, cascade presentation).',
    'Documented strategic vision statement; leadership approval/sign-off record; communication materials (townhall deck, intranet posting, cascade presentation).',
    'Flag if no leadership-approved, documented strategic vision statement exists or if it was never evidenced as communicated to the organization.',
    'ofs_mm_l1_8', 'ofs_l3_8_1_4', 'ofs_l3_8_1_4', 4
  FROM processes p WHERE p.code = 'ofs_l2_8_1';

  INSERT INTO maturity_statements (maturity_model_id, domain_title, process_area,
    level_1_basic, level_2_developing, level_3_established, level_4_advanced, level_5_leading,
    assessor_instruction, evidence_examples, review_steps, alert_rule_hint, sort_order)
  VALUES ('ofs_mm_l1_8', 'Develop Vision And Strategy', 'ofs_l3_8_1_4',
    'Strategic vision exists informally in leadership''s thinking with no documented, approved statement.',
    'A vision statement is documented but approval or organization-wide communication is inconsistent or undocumented.',
    'The strategic vision is a documented, leadership-approved statement with evidenced communication across the organization.',
    'Awareness and alignment with the vision are tracked (e.g., employee survey) and used to refine communication approach.',
    'The strategic vision is maintained and cascaded through an integrated strategy-management platform with real-time alignment tracking across the organization.',
    'Ask for the current documented strategic vision statement, its leadership approval record, and evidence it was communicated to the organization.',
    'Documented strategic vision statement; leadership approval/sign-off record; communication materials (townhall deck, intranet posting, cascade presentation).',
    'Confirm the current vision statement is documented, carries a leadership approval, and has evidenced organization-wide communication.',
    'Flag if no leadership-approved, documented strategic vision statement exists or if it was never evidenced as communicated to the organization.', 4)
  ON CONFLICT (maturity_model_id, process_area) DO NOTHING;

  -- ===== L2_8_2: Define The Business Concept And Long-Term Vision =====

  -- Q5: ofs_l3_8_2_1
  INSERT INTO questions (questionnaire_id, evaluation_type_id, domain_id, process_id,
    question_code, question_text, question_intent, instruction_text, evidence_examples,
    alert_rule_hint, mapped_maturity_model_id, mapped_maturity_statement_id, matched_process_area, sort_order)
  SELECT v_questionnaire_id, v_eval_type_id, v_domain_id, p.id,
    'ofs_l3_8_2_1',
    'How mature is the organization''s process for collating external market intelligence into a documented, retained repository that informs the definition of the business concept and long-term vision?',
    'Assess whether market intelligence used to define/refresh the business concept is collated into a retained, referenceable repository, versus gathered ad hoc for each discussion with nothing retained afterward.',
    'Review the market-intelligence repository or compilation used when the business concept/long-term vision was last defined or refreshed, and confirm it is retained and referenceable rather than a one-time, undocumented discussion input.',
    'Market-intelligence repository or compiled dossier; business-concept definition workshop materials referencing the intelligence; version history of the repository.',
    'Flag if the business concept/long-term vision was last defined or refreshed with no retained market-intelligence repository supporting it.',
    'ofs_mm_l1_8', 'ofs_l3_8_2_1', 'ofs_l3_8_2_1', 1
  FROM processes p WHERE p.code = 'ofs_l2_8_2';

  INSERT INTO maturity_statements (maturity_model_id, domain_title, process_area,
    level_1_basic, level_2_developing, level_3_established, level_4_advanced, level_5_leading,
    assessor_instruction, evidence_examples, review_steps, alert_rule_hint, sort_order)
  VALUES ('ofs_mm_l1_8', 'Develop Vision And Strategy', 'ofs_l3_8_2_1',
    'Market intelligence for business-concept discussions is gathered ad hoc and not retained afterward.',
    'A market-intelligence compilation exists but is not consistently retained or kept current between business-concept reviews.',
    'A documented, retained market-intelligence repository supports every business-concept/long-term vision definition or refresh.',
    'The market-intelligence repository is tracked and updated on a defined cadence, with accuracy of past intelligence reviewed against outcomes.',
    'Market intelligence collation is integrated with an external data-feed platform providing continuously updated inputs to business-concept definition.',
    'Ask for the market-intelligence repository behind the most recent business-concept/long-term vision definition and confirm it is retained and dated.',
    'Market-intelligence repository or compiled dossier; business-concept definition workshop materials referencing the intelligence; version history of the repository.',
    'Confirm the market-intelligence repository used in the last business-concept definition is on file, dated, and referenced in that definition.',
    'Flag if the business concept/long-term vision was last defined or refreshed with no retained market-intelligence repository supporting it.', 1)
  ON CONFLICT (maturity_model_id, process_area) DO NOTHING;

  -- Q6: ofs_l3_8_2_2
  INSERT INTO questions (questionnaire_id, evaluation_type_id, domain_id, process_id,
    question_code, question_text, question_intent, instruction_text, evidence_examples,
    alert_rule_hint, mapped_maturity_model_id, mapped_maturity_statement_id, matched_process_area, sort_order)
  SELECT v_questionnaire_id, v_eval_type_id, v_domain_id, p.id,
    'ofs_l3_8_2_2',
    'How mature is the organization''s process for validating the long-term business concept against documented customer needs and wants, distinct from the recurring operational customer survey used in day-to-day strategic planning?',
    'Assess whether a foundational, business-concept-level customer needs validation (addressable market, target segments, long-term value proposition) is documented when the business concept is defined or materially revisited, versus relying only on routine operational customer feedback.',
    'Review the customer needs/market validation analysis produced specifically for the business-concept definition (target segments, long-term value proposition) and confirm it is distinct from and more foundational than routine periodic customer surveys.',
    'Target-segment/customer-needs validation analysis for the business concept; addressable-market assessment; long-term value-proposition documentation.',
    'Flag if the business concept was defined or materially revised with no documented customer needs/market validation specific to that decision.',
    'ofs_mm_l1_8', 'ofs_l3_8_2_2', 'ofs_l3_8_2_2', 2
  FROM processes p WHERE p.code = 'ofs_l2_8_2';

  INSERT INTO maturity_statements (maturity_model_id, domain_title, process_area,
    level_1_basic, level_2_developing, level_3_established, level_4_advanced, level_5_leading,
    assessor_instruction, evidence_examples, review_steps, alert_rule_hint, sort_order)
  VALUES ('ofs_mm_l1_8', 'Develop Vision And Strategy', 'ofs_l3_8_2_2',
    'The business concept is defined or revised with no documented customer needs or market validation.',
    'Customer needs input exists but is drawn only from routine operational feedback, not a validation specific to the business concept.',
    'The business concept is supported by a documented customer needs/market validation analysis distinct from routine operational surveys.',
    'Business-concept-level customer validation findings are tracked and compared against realized market outcomes to refine future concept reviews.',
    'Business-concept customer validation is integrated with a strategic market-modeling platform providing scenario-based demand projections.',
    'Ask for the customer needs/market validation analysis specific to the current business concept and confirm it is distinct from routine customer surveys.',
    'Target-segment/customer-needs validation analysis for the business concept; addressable-market assessment; long-term value-proposition documentation.',
    'Confirm the business-concept-level customer validation analysis is on file and distinguishable from routine operational customer feedback.',
    'Flag if the business concept was defined or materially revised with no documented customer needs/market validation specific to that decision.', 2)
  ON CONFLICT (maturity_model_id, process_area) DO NOTHING;

  -- Q7: ofs_l3_8_2_3
  INSERT INTO questions (questionnaire_id, evaluation_type_id, domain_id, process_id,
    question_code, question_text, question_intent, instruction_text, evidence_examples,
    alert_rule_hint, mapped_maturity_model_id, mapped_maturity_statement_id, matched_process_area, sort_order)
  SELECT v_questionnaire_id, v_eval_type_id, v_domain_id, p.id,
    'ofs_l3_8_2_3',
    'How mature is the organization''s process for performing a foundational internal capability and financial-position analysis specifically to test the viability of the long-term business concept?',
    'Assess whether the business concept is tested against a documented, concept-level internal viability analysis (core capabilities, financial capacity, organizational readiness for the long-term vision), versus assumed viable with no dedicated analysis distinct from routine planning.',
    'Review the internal viability analysis produced when the business concept was defined or last materially revisited and confirm it addresses core capability and financial capacity relative to the long-term vision, not only the routine annual internal analysis.',
    'Business-concept viability analysis; core-capability and financial-capacity assessment; organizational-readiness assessment for the long-term vision.',
    'Flag if the business concept was defined or materially revised with no documented internal viability analysis specific to that decision.',
    'ofs_mm_l1_8', 'ofs_l3_8_2_3', 'ofs_l3_8_2_3', 3
  FROM processes p WHERE p.code = 'ofs_l2_8_2';

  INSERT INTO maturity_statements (maturity_model_id, domain_title, process_area,
    level_1_basic, level_2_developing, level_3_established, level_4_advanced, level_5_leading,
    assessor_instruction, evidence_examples, review_steps, alert_rule_hint, sort_order)
  VALUES ('ofs_mm_l1_8', 'Develop Vision And Strategy', 'ofs_l3_8_2_3',
    'The business concept is defined or revised with no documented internal viability analysis.',
    'An internal analysis exists but does not clearly address viability of the long-term concept beyond routine annual planning.',
    'The business concept is supported by a documented internal viability analysis addressing core capability and financial capacity for the long-term vision.',
    'Internal viability findings are tracked against realized performance to refine assumptions used in future business-concept reviews.',
    'Business-concept viability analysis is integrated with a scenario-modeling platform testing capability and financial capacity under multiple long-term vision paths.',
    'Ask for the internal viability analysis specific to the current business concept and confirm it addresses core capability and financial capacity for the long-term vision.',
    'Business-concept viability analysis; core-capability and financial-capacity assessment; organizational-readiness assessment for the long-term vision.',
    'Confirm the business-concept-level internal viability analysis is on file and distinguishable from the routine annual internal analysis.',
    'Flag if the business concept was defined or materially revised with no documented internal viability analysis specific to that decision.', 3)
  ON CONFLICT (maturity_model_id, process_area) DO NOTHING;

  -- Q8: ofs_l3_8_2_4
  INSERT INTO questions (questionnaire_id, evaluation_type_id, domain_id, process_id,
    question_code, question_text, question_intent, instruction_text, evidence_examples,
    alert_rule_hint, mapped_maturity_model_id, mapped_maturity_statement_id, matched_process_area, sort_order)
  SELECT v_questionnaire_id, v_eval_type_id, v_domain_id, p.id,
    'ofs_l3_8_2_4',
    'How mature is the organization''s process for translating the defined business concept into a documented, board- or executive-approved long-term strategic vision statement with a defined time horizon?',
    'Assess whether the business concept results in a formally approved long-term vision statement with an explicit time horizon, versus a business concept that never converts into a documented, approved vision.',
    'Review the long-term strategic vision statement derived from the business concept, confirm its time horizon is explicit, and confirm it carries board- or executive-level approval.',
    'Long-term strategic vision statement with defined time horizon; board or executive approval record; traceability from the business-concept analysis to the vision statement.',
    'Flag if a long-term vision statement exists with no explicit time horizon or no board/executive approval on file.',
    'ofs_mm_l1_8', 'ofs_l3_8_2_4', 'ofs_l3_8_2_4', 4
  FROM processes p WHERE p.code = 'ofs_l2_8_2';

  INSERT INTO maturity_statements (maturity_model_id, domain_title, process_area,
    level_1_basic, level_2_developing, level_3_established, level_4_advanced, level_5_leading,
    assessor_instruction, evidence_examples, review_steps, alert_rule_hint, sort_order)
  VALUES ('ofs_mm_l1_8', 'Develop Vision And Strategy', 'ofs_l3_8_2_4',
    'The business concept does not convert into a documented long-term vision statement.',
    'A long-term vision statement exists but lacks an explicit time horizon or documented board/executive approval.',
    'The long-term strategic vision statement has an explicit time horizon and documented board/executive approval, traceable to the business concept.',
    'Progress against the long-term vision''s time horizon is tracked periodically and used to refine the vision at defined checkpoints.',
    'The long-term vision is maintained on an integrated strategy-management platform with milestone tracking visible to the board and executive team in real time.',
    'Ask for the current long-term strategic vision statement and confirm it states an explicit time horizon and carries board or executive approval.',
    'Long-term strategic vision statement with defined time horizon; board or executive approval record; traceability from the business-concept analysis to the vision statement.',
    'Confirm the long-term vision statement, its time horizon, and its board/executive approval are all on file and traceable to the business concept.',
    'Flag if a long-term vision statement exists with no explicit time horizon or no board/executive approval on file.', 4)
  ON CONFLICT (maturity_model_id, process_area) DO NOTHING;

END $$;