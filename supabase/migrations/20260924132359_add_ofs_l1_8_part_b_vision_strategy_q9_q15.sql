/*
# OFS Onshore L1.8 Part B — Develop Vision And Strategy (Q9-Q15)

1. Content added (purely additive)
   - 7 questions: ofs_l3_8_3_1..ofs_l3_8_3_7
   - 7 maturity statements (one per question)

2. Covers L2 process: ofs_l2_8_3 (Develop Business Strategy)

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

  -- ===== L2_8_3: Develop Business Strategy =====

  -- Q9: ofs_l3_8_3_1
  INSERT INTO questions (questionnaire_id, evaluation_type_id, domain_id, process_id,
    question_code, question_text, question_intent, instruction_text, evidence_examples,
    alert_rule_hint, mapped_maturity_model_id, mapped_maturity_statement_id, matched_process_area, sort_order)
  SELECT v_questionnaire_id, v_eval_type_id, v_domain_id, p.id,
    'ofs_l3_8_3_1',
    'How mature is the organization''s process for developing and formally approving an overall mission statement that guides business strategy formulation?',
    'Assess whether business strategy formulation is anchored to a documented, approved mission statement, versus proceeding with no formal mission statement or an outdated one never revisited.',
    'Review the current mission statement, confirm it carries a documented approval, and confirm it is referenced as an input in the business-strategy formulation materials.',
    'Documented mission statement; approval record; strategy formulation materials referencing the mission statement.',
    'Flag if business strategy is formulated with no documented, approved mission statement referenced as an input.',
    'ofs_mm_l1_8', 'ofs_l3_8_3_1', 'ofs_l3_8_3_1', 1
  FROM processes p WHERE p.code = 'ofs_l2_8_3';

  INSERT INTO maturity_statements (maturity_model_id, domain_title, process_area,
    level_1_basic, level_2_developing, level_3_established, level_4_advanced, level_5_leading,
    assessor_instruction, evidence_examples, review_steps, alert_rule_hint, sort_order)
  VALUES ('ofs_mm_l1_8', 'Develop Vision And Strategy', 'ofs_l3_8_3_1',
    'No documented mission statement exists, or business strategy is developed without reference to one.',
    'A mission statement exists but is outdated or not consistently referenced in strategy formulation.',
    'A current, approved mission statement is documented and referenced as an input to every business-strategy formulation cycle.',
    'The mission statement''s continued relevance is periodically reviewed against market and internal analysis findings.',
    'The mission statement is maintained on an integrated strategy platform with revisions tracked and linked to the analyses that triggered them.',
    'Ask for the current mission statement and confirm it is referenced in the latest business-strategy formulation materials.',
    'Documented mission statement; approval record; strategy formulation materials referencing the mission statement.',
    'Confirm the current mission statement is documented, approved, and referenced in the latest strategy formulation cycle.',
    'Flag if business strategy is formulated with no documented, approved mission statement referenced as an input.', 1)
  ON CONFLICT (maturity_model_id, process_area) DO NOTHING;

  -- Q10: ofs_l3_8_3_2
  INSERT INTO questions (questionnaire_id, evaluation_type_id, domain_id, process_id,
    question_code, question_text, question_intent, instruction_text, evidence_examples,
    alert_rule_hint, mapped_maturity_model_id, mapped_maturity_statement_id, matched_process_area, sort_order)
  SELECT v_questionnaire_id, v_eval_type_id, v_domain_id, p.id,
    'ofs_l3_8_3_2',
    'How mature is the organization''s process for formulating a documented strategy for each service line (e.g., well testing, coiled tubing, production equipment) rather than a single undifferentiated company-wide strategy?',
    'Assess whether each service line has its own documented strategy (positioning, target customers, growth/investment posture), versus all service lines being covered by one generic company-wide strategy with no line-specific detail.',
    'Review the service-line strategy documents for the current strategic-planning cycle and confirm each major service line has a distinct, documented strategy rather than a single undifferentiated statement.',
    'Service-line strategy documents; service-line positioning and investment-posture summaries; strategic-planning cycle materials showing line-by-line coverage.',
    'Flag if a major service line has no documented, distinct strategy for the current planning cycle.',
    'ofs_mm_l1_8', 'ofs_l3_8_3_2', 'ofs_l3_8_3_2', 2
  FROM processes p WHERE p.code = 'ofs_l2_8_3';

  INSERT INTO maturity_statements (maturity_model_id, domain_title, process_area,
    level_1_basic, level_2_developing, level_3_established, level_4_advanced, level_5_leading,
    assessor_instruction, evidence_examples, review_steps, alert_rule_hint, sort_order)
  VALUES ('ofs_mm_l1_8', 'Develop Vision And Strategy', 'ofs_l3_8_3_2',
    'A single undifferentiated strategy covers all service lines with no line-specific detail.',
    'Distinct service-line strategies exist for some lines but not consistently across the full service portfolio.',
    'Every major service line has a documented, distinct strategy covering positioning, target customers, and investment posture.',
    'Service-line strategy performance is tracked against targets and used to refine subsequent service-line strategies.',
    'Service-line strategies are maintained on an integrated portfolio-management platform with real-time performance-versus-target visibility.',
    'Ask for the documented strategy for two different service lines in the current planning cycle and confirm each is distinct rather than a shared generic statement.',
    'Service-line strategy documents; service-line positioning and investment-posture summaries; strategic-planning cycle materials showing line-by-line coverage.',
    'Confirm at least two major service lines each have a distinct, documented strategy for the current planning cycle.',
    'Flag if a major service line has no documented, distinct strategy for the current planning cycle.', 2)
  ON CONFLICT (maturity_model_id, process_area) DO NOTHING;

  -- Q11: ofs_l3_8_3_3
  INSERT INTO questions (questionnaire_id, evaluation_type_id, domain_id, process_id,
    question_code, question_text, question_intent, instruction_text, evidence_examples,
    alert_rule_hint, mapped_maturity_model_id, mapped_maturity_statement_id, matched_process_area, sort_order)
  SELECT v_questionnaire_id, v_eval_type_id, v_domain_id, p.id,
    'ofs_l3_8_3_3',
    'How mature is the organization''s process for documenting and evaluating multiple strategic options against defined criteria before selecting a business strategy?',
    'Assess whether multiple strategic options are documented and evaluated against explicit criteria (risk, return, capability fit) before a strategy is chosen, versus a single option being adopted with no documented alternatives or evaluation.',
    'Review the strategic-options evaluation document for the current planning cycle and confirm it presents more than one option assessed against explicit criteria, with the evaluation dated before the strategy was selected.',
    'Strategic-options evaluation matrix or memo; evaluation criteria definition; dated record of the evaluation preceding strategy selection.',
    'Flag if a business strategy is selected with no documented evaluation of more than one strategic option.',
    'ofs_mm_l1_8', 'ofs_l3_8_3_3', 'ofs_l3_8_3_3', 3
  FROM processes p WHERE p.code = 'ofs_l2_8_3';

  INSERT INTO maturity_statements (maturity_model_id, domain_title, process_area,
    level_1_basic, level_2_developing, level_3_established, level_4_advanced, level_5_leading,
    assessor_instruction, evidence_examples, review_steps, alert_rule_hint, sort_order)
  VALUES ('ofs_mm_l1_8', 'Develop Vision And Strategy', 'ofs_l3_8_3_3',
    'A strategy is adopted with no documented alternative options or evaluation criteria.',
    'Options are discussed informally but not consistently documented with explicit evaluation criteria.',
    'Every strategy selection is preceded by a documented evaluation of multiple options against explicit criteria.',
    'Evaluation criteria and outcomes are tracked across cycles to refine how future strategic options are scored.',
    'Strategic-options evaluation is supported by an integrated decision-analytics platform modeling risk/return scenarios for each option.',
    'Ask for the strategic-options evaluation behind the current business strategy and confirm it covers more than one option scored against explicit criteria.',
    'Strategic-options evaluation matrix or memo; evaluation criteria definition; dated record of the evaluation preceding strategy selection.',
    'Confirm the strategic-options evaluation is on file, covers multiple options, and predates the strategy selection date.',
    'Flag if a business strategy is selected with no documented evaluation of more than one strategic option.', 3)
  ON CONFLICT (maturity_model_id, process_area) DO NOTHING;

  -- Q12: ofs_l3_8_3_4
  INSERT INTO questions (questionnaire_id, evaluation_type_id, domain_id, process_id,
    question_code, question_text, question_intent, instruction_text, evidence_examples,
    alert_rule_hint, mapped_maturity_model_id, mapped_maturity_statement_id, matched_process_area, sort_order)
  SELECT v_questionnaire_id, v_eval_type_id, v_domain_id, p.id,
    'ofs_l3_8_3_4',
    'How mature is the organization''s process for formally selecting and approving the long-term business strategy following the options evaluation, with the selection decision documented and traceable?',
    'Assess whether the strategy selection decision is documented, traceable to the options evaluation, and formally approved, versus a strategy that emerges informally with no documented selection decision.',
    'Review the strategy-selection decision record and confirm it references the options evaluation and carries a documented approval from the appropriate leadership level.',
    'Strategy-selection decision memo or minutes; leadership approval record; traceability reference to the options-evaluation document.',
    'Flag if the current business strategy has no documented, approved selection decision traceable to an options evaluation.',
    'ofs_mm_l1_8', 'ofs_l3_8_3_4', 'ofs_l3_8_3_4', 4
  FROM processes p WHERE p.code = 'ofs_l2_8_3';

  INSERT INTO maturity_statements (maturity_model_id, domain_title, process_area,
    level_1_basic, level_2_developing, level_3_established, level_4_advanced, level_5_leading,
    assessor_instruction, evidence_examples, review_steps, alert_rule_hint, sort_order)
  VALUES ('ofs_mm_l1_8', 'Develop Vision And Strategy', 'ofs_l3_8_3_4',
    'The business strategy in use has no documented selection decision or approval record.',
    'A selection decision is documented for some cycles but not consistently traceable to the options evaluation or formally approved.',
    'Every business strategy selection is documented, approved by leadership, and traceable to the options evaluation.',
    'Strategy-selection rationale is tracked over time and reviewed against realized outcomes to refine the selection process.',
    'Strategy selection is managed on an integrated strategy-governance platform linking the decision record, approvals, and downstream execution plans.',
    'Ask for the current strategy-selection decision record and confirm it is approved and traceable to the options evaluation.',
    'Strategy-selection decision memo or minutes; leadership approval record; traceability reference to the options-evaluation document.',
    'Confirm the strategy-selection decision record is on file, approved, and traceable to the options evaluation that preceded it.',
    'Flag if the current business strategy has no documented, approved selection decision traceable to an options evaluation.', 4)
  ON CONFLICT (maturity_model_id, process_area) DO NOTHING;

  -- Q13: ofs_l3_8_3_5
  INSERT INTO questions (questionnaire_id, evaluation_type_id, domain_id, process_id,
    question_code, question_text, question_intent, instruction_text, evidence_examples,
    alert_rule_hint, mapped_maturity_model_id, mapped_maturity_statement_id, matched_process_area, sort_order)
  SELECT v_questionnaire_id, v_eval_type_id, v_domain_id, p.id,
    'ofs_l3_8_3_5',
    'How mature is the organization''s process for coordinating and documenting alignment between functional strategies (operations, HSE, HR, finance, commercial) and the overall business strategy?',
    'Assess whether functional strategies are reviewed and documented as aligned with the overall business strategy through a defined coordination process, versus developed independently by each function with no documented alignment check.',
    'Review the alignment record or cross-functional strategy review for the current planning cycle and confirm it shows each major function''s strategy was checked against the overall business strategy.',
    'Cross-functional strategy alignment review record; functional strategy documents referencing the overall business strategy; strategy-coordination meeting minutes.',
    'Flag if a functional strategy exists with no documented alignment check against the overall business strategy.',
    'ofs_mm_l1_8', 'ofs_l3_8_3_5', 'ofs_l3_8_3_5', 5
  FROM processes p WHERE p.code = 'ofs_l2_8_3';

  INSERT INTO maturity_statements (maturity_model_id, domain_title, process_area,
    level_1_basic, level_2_developing, level_3_established, level_4_advanced, level_5_leading,
    assessor_instruction, evidence_examples, review_steps, alert_rule_hint, sort_order)
  VALUES ('ofs_mm_l1_8', 'Develop Vision And Strategy', 'ofs_l3_8_3_5',
    'Functional strategies are developed independently with no documented alignment process to the overall business strategy.',
    'Alignment is checked for some functions but not consistently documented across all major functions.',
    'Every major functional strategy undergoes a documented alignment review against the overall business strategy.',
    'Alignment gaps identified in reviews are tracked and resolved, with findings used to refine the coordination process.',
    'Functional and business strategy alignment is managed on an integrated strategy-cascade platform with real-time visibility across functions.',
    'Ask for the alignment review covering at least two functional strategies in the current planning cycle and confirm it documents the check against the overall business strategy.',
    'Cross-functional strategy alignment review record; functional strategy documents referencing the overall business strategy; strategy-coordination meeting minutes.',
    'Confirm the cross-functional alignment review is on file and covers at least two major functional strategies for the current cycle.',
    'Flag if a functional strategy exists with no documented alignment check against the overall business strategy.', 5)
  ON CONFLICT (maturity_model_id, process_area) DO NOTHING;

  -- Q14: ofs_l3_8_3_6
  INSERT INTO questions (questionnaire_id, evaluation_type_id, domain_id, process_id,
    question_code, question_text, question_intent, instruction_text, evidence_examples,
    alert_rule_hint, mapped_maturity_model_id, mapped_maturity_statement_id, matched_process_area, sort_order)
  SELECT v_questionnaire_id, v_eval_type_id, v_domain_id, p.id,
    'ofs_l3_8_3_6',
    'How mature is the organization''s process for testing whether the organizational structure fits the selected business strategy as part of strategy formulation, distinct from the periodic organizational-design documentation maintained under the business plan?',
    'Assess whether strategy formulation includes a documented structural-fit assessment (does the current org design support the selected strategy) at the point the strategy is chosen, versus relying only on the organization''s routinely maintained structure documentation with no strategy-specific fit check.',
    'Review the organizational structural-fit assessment produced when the business strategy was selected and confirm it addresses whether the structure supports the specific strategy chosen, not only a general org chart maintained separately.',
    'Structural-fit assessment tied to the selected strategy; strategy-formulation workshop materials addressing organizational implications; resulting structural change recommendations.',
    'Flag if a business strategy is selected with no documented assessment of whether the organizational structure supports it.',
    'ofs_mm_l1_8', 'ofs_l3_8_3_6', 'ofs_l3_8_3_6', 6
  FROM processes p WHERE p.code = 'ofs_l2_8_3';

  INSERT INTO maturity_statements (maturity_model_id, domain_title, process_area,
    level_1_basic, level_2_developing, level_3_established, level_4_advanced, level_5_leading,
    assessor_instruction, evidence_examples, review_steps, alert_rule_hint, sort_order)
  VALUES ('ofs_mm_l1_8', 'Develop Vision And Strategy', 'ofs_l3_8_3_6',
    'Strategy is selected with no documented consideration of organizational structural fit.',
    'Structural fit is discussed informally but not consistently documented at the point of strategy selection.',
    'Every strategy selection includes a documented structural-fit assessment addressing whether the organization design supports the chosen strategy.',
    'Structural-fit findings are tracked against actual execution performance to refine future organizational-design decisions.',
    'Structural-fit assessment is integrated with an organizational-design modeling platform testing multiple structure options against the selected strategy.',
    'Ask for the structural-fit assessment produced when the current business strategy was selected and confirm it is specific to that strategy, not a generic org chart.',
    'Structural-fit assessment tied to the selected strategy; strategy-formulation workshop materials addressing organizational implications; resulting structural change recommendations.',
    'Confirm a strategy-specific structural-fit assessment is on file and dated at or near the strategy-selection decision.',
    'Flag if a business strategy is selected with no documented assessment of whether the organizational structure supports it.', 6)
  ON CONFLICT (maturity_model_id, process_area) DO NOTHING;

  -- Q15: ofs_l3_8_3_7
  INSERT INTO questions (questionnaire_id, evaluation_type_id, domain_id, process_id,
    question_code, question_text, question_intent, instruction_text, evidence_examples,
    alert_rule_hint, mapped_maturity_model_id, mapped_maturity_statement_id, matched_process_area, sort_order)
  SELECT v_questionnaire_id, v_eval_type_id, v_domain_id, p.id,
    'ofs_l3_8_3_7',
    'How mature is the organization''s process for translating the selected business strategy into documented, top-level organizational goals as the direct output of strategy formulation?',
    'Assess whether strategy formulation concludes with documented top-level goals directly traceable to the selected strategy, versus a strategy that is approved with no corresponding set of organizational goals recorded.',
    'Review the top-level organizational goals produced at the conclusion of the strategy-formulation cycle and confirm each goal is traceable to an element of the selected business strategy.',
    'Top-level organizational goals document; traceability matrix linking goals to strategy elements; strategy-formulation cycle output materials.',
    'Flag if the selected business strategy has no documented, traceable set of top-level organizational goals.',
    'ofs_mm_l1_8', 'ofs_l3_8_3_7', 'ofs_l3_8_3_7', 7
  FROM processes p WHERE p.code = 'ofs_l2_8_3';

  INSERT INTO maturity_statements (maturity_model_id, domain_title, process_area,
    level_1_basic, level_2_developing, level_3_established, level_4_advanced, level_5_leading,
    assessor_instruction, evidence_examples, review_steps, alert_rule_hint, sort_order)
  VALUES ('ofs_mm_l1_8', 'Develop Vision And Strategy', 'ofs_l3_8_3_7',
    'Organizational goals are not documented, or are unrelated to the selected business strategy.',
    'Goals are documented but traceability to specific strategy elements is inconsistent or missing.',
    'Top-level organizational goals are documented and each is traceable to a specific element of the selected business strategy.',
    'Goal attainment is tracked against the strategy over time and used to refine how future goals are set.',
    'Organizational goal-setting is managed on an integrated strategy-execution platform with real-time traceability from goals to strategy to results.',
    'Ask for the current top-level organizational goals and confirm each is traceable to a specific element of the selected business strategy.',
    'Top-level organizational goals document; traceability matrix linking goals to strategy elements; strategy-formulation cycle output materials.',
    'Confirm the top-level organizational goals document is on file and shows traceability to the selected business strategy.',
    'Flag if the selected business strategy has no documented, traceable set of top-level organizational goals.', 7)
  ON CONFLICT (maturity_model_id, process_area) DO NOTHING;

END $$;