/*
# OFS Onshore L1.8 Part C — Develop Vision And Strategy (Q16-Q26)

1. Content added (purely additive)
   - 11 questions: ofs_l3_8_4_1..ofs_l3_8_4_4 + ofs_l3_8_5_1..ofs_l3_8_5_6 + ofs_l3_8_6_1
   - 11 maturity statements (one per question)

2. Covers L2 processes: ofs_l2_8_4 (Develop Strategic Initiatives), ofs_l2_8_5 (Develop Business Plan), ofs_l2_8_6 (Develop Marketing And Sales Strategy)

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

  -- ===== L2_8_4: Develop Strategic Initiatives =====

  -- Q16: ofs_l3_8_4_1
  INSERT INTO questions (questionnaire_id, evaluation_type_id, domain_id, process_id,
    question_code, question_text, question_intent, instruction_text, evidence_examples,
    alert_rule_hint, mapped_maturity_model_id, mapped_maturity_statement_id, matched_process_area, sort_order)
  SELECT v_questionnaire_id, v_eval_type_id, v_domain_id, p.id,
    'ofs_l3_8_4_1',
    'How mature is the organization''s process for developing documented strategic initiatives (specific programs of work) designed to close the gap between current state and the organizational goals set by the business strategy?',
    'Assess whether strategic initiatives are developed as documented programs of work explicitly linked to specific organizational goals, versus initiatives that arise informally with no documented linkage to the goals they are meant to achieve.',
    'Review the documented strategic-initiative proposals for the current cycle and confirm each states the organizational goal(s) it is intended to close the gap toward.',
    'Strategic-initiative proposal documents; goal-gap analysis supporting initiative development; initiative-to-goal linkage record.',
    'Flag if a strategic initiative is proposed with no documented link to a specific organizational goal.',
    'ofs_mm_l1_8', 'ofs_l3_8_4_1', 'ofs_l3_8_4_1', 1
  FROM processes p WHERE p.code = 'ofs_l2_8_4';

  INSERT INTO maturity_statements (maturity_model_id, domain_title, process_area,
    level_1_basic, level_2_developing, level_3_established, level_4_advanced, level_5_leading,
    assessor_instruction, evidence_examples, review_steps, alert_rule_hint, sort_order)
  VALUES ('ofs_mm_l1_8', 'Develop Vision And Strategy', 'ofs_l3_8_4_1',
    'Initiatives are proposed informally with no documented development process or linkage to organizational goals.',
    'Initiative proposals are documented for some cases but linkage to specific goals is inconsistent.',
    'Every strategic initiative is developed through a documented proposal explicitly linked to the organizational goal(s) it addresses.',
    'Initiative development draws on gap-analysis data tracked across cycles to prioritize which gaps generate new initiatives.',
    'Strategic-initiative development is integrated with a portfolio-management platform automatically flagging goal gaps requiring new initiatives.',
    'Ask for the documented proposal behind one current strategic initiative and confirm it states the specific organizational goal it addresses.',
    'Strategic-initiative proposal documents; goal-gap analysis supporting initiative development; initiative-to-goal linkage record.',
    'Confirm one strategic initiative''s development documentation is on file and shows an explicit link to an organizational goal.',
    'Flag if a strategic initiative is proposed with no documented link to a specific organizational goal.', 1)
  ON CONFLICT (maturity_model_id, process_area) DO NOTHING;

  -- Q17: ofs_l3_8_4_2
  INSERT INTO questions (questionnaire_id, evaluation_type_id, domain_id, process_id,
    question_code, question_text, question_intent, instruction_text, evidence_examples,
    alert_rule_hint, mapped_maturity_model_id, mapped_maturity_statement_id, matched_process_area, sort_order)
  SELECT v_questionnaire_id, v_eval_type_id, v_domain_id, p.id,
    'ofs_l3_8_4_2',
    'How mature is the organization''s process for evaluating proposed strategic initiatives against documented criteria (cost, resource requirement, expected impact, risk) before they are selected for execution?',
    'Assess whether proposed initiatives undergo a documented evaluation against explicit criteria before selection, versus being advanced or dropped on an ad hoc basis with no recorded evaluation.',
    'Review the initiative-evaluation record for the current cycle and confirm it scores or assesses each proposed initiative against explicit, defined criteria before any selection decision is made.',
    'Strategic-initiative evaluation matrix or scorecard; defined evaluation criteria; record of initiatives assessed prior to selection.',
    'Flag if a strategic initiative reaches the selection stage with no documented evaluation against defined criteria.',
    'ofs_mm_l1_8', 'ofs_l3_8_4_2', 'ofs_l3_8_4_2', 2
  FROM processes p WHERE p.code = 'ofs_l2_8_4';

  INSERT INTO maturity_statements (maturity_model_id, domain_title, process_area,
    level_1_basic, level_2_developing, level_3_established, level_4_advanced, level_5_leading,
    assessor_instruction, evidence_examples, review_steps, alert_rule_hint, sort_order)
  VALUES ('ofs_mm_l1_8', 'Develop Vision And Strategy', 'ofs_l3_8_4_2',
    'Initiatives are advanced or dropped with no documented evaluation against defined criteria.',
    'Evaluation occurs for some initiatives but criteria are not consistently defined or applied.',
    'Every proposed strategic initiative is evaluated against documented, defined criteria before a selection decision.',
    'Evaluation criteria and scoring outcomes are tracked and compared against realized initiative performance to refine the criteria.',
    'Initiative evaluation is supported by an integrated portfolio-analytics platform scoring initiatives on standardized, auditable criteria.',
    'Ask for the evaluation record covering the current cycle''s proposed strategic initiatives and confirm defined criteria were applied before selection.',
    'Strategic-initiative evaluation matrix or scorecard; defined evaluation criteria; record of initiatives assessed prior to selection.',
    'Confirm the initiative-evaluation record is on file, applies defined criteria, and predates the selection decisions for the current cycle.',
    'Flag if a strategic initiative reaches the selection stage with no documented evaluation against defined criteria.', 2)
  ON CONFLICT (maturity_model_id, process_area) DO NOTHING;

  -- Q18: ofs_l3_8_4_3
  INSERT INTO questions (questionnaire_id, evaluation_type_id, domain_id, process_id,
    question_code, question_text, question_intent, instruction_text, evidence_examples,
    alert_rule_hint, mapped_maturity_model_id, mapped_maturity_statement_id, matched_process_area, sort_order)
  SELECT v_questionnaire_id, v_eval_type_id, v_domain_id, p.id,
    'ofs_l3_8_4_3',
    'How mature is the organization''s process for formally selecting and approving the strategic initiatives that will be resourced and executed, with the selection decision documented and traceable to the evaluation?',
    'Assess whether initiative selection is a documented, approved decision traceable to the evaluation results, versus initiatives being resourced informally with no documented selection record.',
    'Review the initiative-selection decision record for the current cycle and confirm it references the evaluation results and carries a documented approval before resources were committed.',
    'Initiative-selection decision memo or minutes; leadership/governance approval record; traceability to the initiative-evaluation results.',
    'Flag if a strategic initiative is resourced with no documented selection decision traceable to its evaluation.',
    'ofs_mm_l1_8', 'ofs_l3_8_4_3', 'ofs_l3_8_4_3', 3
  FROM processes p WHERE p.code = 'ofs_l2_8_4';

  INSERT INTO maturity_statements (maturity_model_id, domain_title, process_area,
    level_1_basic, level_2_developing, level_3_established, level_4_advanced, level_5_leading,
    assessor_instruction, evidence_examples, review_steps, alert_rule_hint, sort_order)
  VALUES ('ofs_mm_l1_8', 'Develop Vision And Strategy', 'ofs_l3_8_4_3',
    'Initiatives are resourced informally with no documented selection decision.',
    'A selection decision is documented for some initiatives but is not consistently traceable to the evaluation or formally approved.',
    'Every selected strategic initiative has a documented, approved selection decision traceable to its evaluation results.',
    'Selection decisions and their rationale are tracked over time and reviewed against realized initiative outcomes.',
    'Initiative selection is governed through an integrated portfolio-governance platform linking evaluation, selection, approval, and execution tracking.',
    'Ask for the selection decision record for one currently resourced strategic initiative and confirm it is approved and traceable to its evaluation.',
    'Initiative-selection decision memo or minutes; leadership/governance approval record; traceability to the initiative-evaluation results.',
    'Confirm one strategic initiative''s selection decision record is on file, approved, and traceable to its evaluation results.',
    'Flag if a strategic initiative is resourced with no documented selection decision traceable to its evaluation.', 3)
  ON CONFLICT (maturity_model_id, process_area) DO NOTHING;

  -- Q19: ofs_l3_8_4_4
  INSERT INTO questions (questionnaire_id, evaluation_type_id, domain_id, process_id,
    question_code, question_text, question_intent, instruction_text, evidence_examples,
    alert_rule_hint, mapped_maturity_model_id, mapped_maturity_statement_id, matched_process_area, sort_order)
  SELECT v_questionnaire_id, v_eval_type_id, v_domain_id, p.id,
    'ofs_l3_8_4_4',
    'How mature is the organization''s process for establishing documented, high-level performance measures and targets for each selected strategic initiative to track its progress?',
    'Assess whether each selected initiative has documented, specific measures/targets established before execution begins, versus initiatives executed with no defined way to measure progress or success.',
    'Review the high-level measures/targets documented for a selected strategic initiative and confirm they were established before or at the start of execution, not retrofitted afterward.',
    'Initiative measures/targets document; baseline and target values; date the measures were established relative to initiative kickoff.',
    'Flag if a strategic initiative is in execution with no documented high-level measures or targets established for it.',
    'ofs_mm_l1_8', 'ofs_l3_8_4_4', 'ofs_l3_8_4_4', 4
  FROM processes p WHERE p.code = 'ofs_l2_8_4';

  INSERT INTO maturity_statements (maturity_model_id, domain_title, process_area,
    level_1_basic, level_2_developing, level_3_established, level_4_advanced, level_5_leading,
    assessor_instruction, evidence_examples, review_steps, alert_rule_hint, sort_order)
  VALUES ('ofs_mm_l1_8', 'Develop Vision And Strategy', 'ofs_l3_8_4_4',
    'Initiatives proceed with no documented measures or targets to assess their progress or success.',
    'Measures are documented for some initiatives but are established inconsistently or after execution has already begun.',
    'Every selected strategic initiative has documented high-level measures and targets established before or at the start of execution.',
    'Measure performance is tracked across initiatives and reviewed to refine how future targets are calibrated.',
    'Initiative measures are tracked on an integrated performance-management platform providing real-time progress visibility against targets.',
    'Ask for the documented measures/targets for one selected strategic initiative and confirm their establishment date precedes or coincides with execution kickoff.',
    'Initiative measures/targets document; baseline and target values; date the measures were established relative to initiative kickoff.',
    'Confirm one strategic initiative''s measures/targets document is on file and dated at or before its execution kickoff.',
    'Flag if a strategic initiative is in execution with no documented high-level measures or targets established for it.', 4)
  ON CONFLICT (maturity_model_id, process_area) DO NOTHING;

  -- ===== L2_8_5: Develop Business Plan =====

  -- Q20: ofs_l3_8_5_1
  INSERT INTO questions (questionnaire_id, evaluation_type_id, domain_id, process_id,
    question_code, question_text, question_intent, instruction_text, evidence_examples,
    alert_rule_hint, mapped_maturity_model_id, mapped_maturity_statement_id, matched_process_area, sort_order)
  SELECT v_questionnaire_id, v_eval_type_id, v_domain_id, p.id,
    'ofs_l3_8_5_1',
    'How mature is the organization''s process for developing a documented corporate taxation plan as part of the business plan, aligned with the selected business strategy and jurisdictions of operation?',
    'Assess whether a documented taxation plan (jurisdictional obligations, structuring considerations, planning assumptions) is produced and kept current as part of the business plan, versus tax matters being handled reactively with no forward-looking documented plan.',
    'Review the current corporate taxation plan and confirm it addresses the jurisdictions in which the organization operates and was reviewed/updated within the current business-planning cycle.',
    'Corporate taxation plan document; jurisdictional tax obligation summary; business-plan cycle materials referencing the taxation plan.',
    'Flag if the business plan for the current cycle includes no documented, current corporate taxation plan.',
    'ofs_mm_l1_8', 'ofs_l3_8_5_1', 'ofs_l3_8_5_1', 1
  FROM processes p WHERE p.code = 'ofs_l2_8_5';

  INSERT INTO maturity_statements (maturity_model_id, domain_title, process_area,
    level_1_basic, level_2_developing, level_3_established, level_4_advanced, level_5_leading,
    assessor_instruction, evidence_examples, review_steps, alert_rule_hint, sort_order)
  VALUES ('ofs_mm_l1_8', 'Develop Vision And Strategy', 'ofs_l3_8_5_1',
    'No documented corporate taxation plan exists; tax matters are handled reactively as they arise.',
    'A taxation plan exists but is not consistently updated within each business-planning cycle.',
    'A documented corporate taxation plan is produced and updated within every business-planning cycle, covering all jurisdictions of operation.',
    'Taxation plan assumptions and outcomes are tracked against actual tax positions to refine future planning.',
    'Corporate tax planning is integrated with a financial-planning platform providing scenario modeling across jurisdictions and structures.',
    'Ask for the current corporate taxation plan and confirm it was reviewed or updated within the current business-planning cycle.',
    'Corporate taxation plan document; jurisdictional tax obligation summary; business-plan cycle materials referencing the taxation plan.',
    'Confirm the current corporate taxation plan is on file, dated within the current cycle, and covers the organization''s operating jurisdictions.',
    'Flag if the business plan for the current cycle includes no documented, current corporate taxation plan.', 1)
  ON CONFLICT (maturity_model_id, process_area) DO NOTHING;

  -- Q21: ofs_l3_8_5_2
  INSERT INTO questions (questionnaire_id, evaluation_type_id, domain_id, process_id,
    question_code, question_text, question_intent, instruction_text, evidence_examples,
    alert_rule_hint, mapped_maturity_model_id, mapped_maturity_statement_id, matched_process_area, sort_order)
  SELECT v_questionnaire_id, v_eval_type_id, v_domain_id, p.id,
    'ofs_l3_8_5_2',
    'How mature is the organization''s process for documenting and maintaining the formal organizational design (structure, governance bodies, reporting lines) as a standing part of the business plan, kept current between strategy-formulation cycles?',
    'Assess whether the organization maintains a documented, current org design (chart, governance charter, reporting lines) as an ongoing business-plan artifact, distinct from the one-time strategy-specific structural-fit assessment performed during strategy formulation.',
    'Review the current organizational design documentation (org chart, governance charter, reporting-line definitions) included in the business plan and confirm it reflects the organization''s actual current structure.',
    'Current organizational chart; governance charter or committee structure document; reporting-line definitions; business-plan section on organizational design.',
    'Flag if the documented organizational design in the business plan is out of date relative to the organization''s actual current structure.',
    'ofs_mm_l1_8', 'ofs_l3_8_5_2', 'ofs_l3_8_5_2', 2
  FROM processes p WHERE p.code = 'ofs_l2_8_5';

  INSERT INTO maturity_statements (maturity_model_id, domain_title, process_area,
    level_1_basic, level_2_developing, level_3_established, level_4_advanced, level_5_leading,
    assessor_instruction, evidence_examples, review_steps, alert_rule_hint, sort_order)
  VALUES ('ofs_mm_l1_8', 'Develop Vision And Strategy', 'ofs_l3_8_5_2',
    'No documented organizational design is maintained as part of the business plan; structure is understood informally.',
    'An org chart or design document exists but is not consistently kept current with actual organizational changes.',
    'The organizational design (structure, governance, reporting lines) is documented in the business plan and kept current with actual changes.',
    'Organizational design changes are tracked with a change history and reviewed periodically for continued fit with operations.',
    'Organizational design is maintained on an integrated HR/governance platform with automatic updates reflected in the business plan.',
    'Ask for the current organizational design documentation in the business plan and confirm it matches the organization''s actual current reporting structure.',
    'Current organizational chart; governance charter or committee structure document; reporting-line definitions; business-plan section on organizational design.',
    'Confirm the business plan''s organizational design documentation is on file and consistent with the organization''s actual current structure.',
    'Flag if the documented organizational design in the business plan is out of date relative to the organization''s actual current structure.', 2)
  ON CONFLICT (maturity_model_id, process_area) DO NOTHING;

  -- Q22: ofs_l3_8_5_3
  INSERT INTO questions (questionnaire_id, evaluation_type_id, domain_id, process_id,
    question_code, question_text, question_intent, instruction_text, evidence_examples,
    alert_rule_hint, mapped_maturity_model_id, mapped_maturity_statement_id, matched_process_area, sort_order)
  SELECT v_questionnaire_id, v_eval_type_id, v_domain_id, p.id,
    'ofs_l3_8_5_3',
    'How mature is the organization''s process for developing a documented improvement plan (operational, quality, HSE, or process improvement priorities) as part of the business plan, with defined actions and owners?',
    'Assess whether the business plan includes a documented improvement plan with specific actions and named owners, versus improvement intentions that remain general statements with no assigned actions or accountability.',
    'Review the current improvement plan included in the business plan and confirm it lists specific improvement actions, each with a named owner and target date.',
    'Improvement plan document; action items with owners and target dates; business-plan section referencing the improvement plan.',
    'Flag if the business plan''s improvement plan contains actions with no named owner or target date.',
    'ofs_mm_l1_8', 'ofs_l3_8_5_3', 'ofs_l3_8_5_3', 3
  FROM processes p WHERE p.code = 'ofs_l2_8_5';

  INSERT INTO maturity_statements (maturity_model_id, domain_title, process_area,
    level_1_basic, level_2_developing, level_3_established, level_4_advanced, level_5_leading,
    assessor_instruction, evidence_examples, review_steps, alert_rule_hint, sort_order)
  VALUES ('ofs_mm_l1_8', 'Develop Vision And Strategy', 'ofs_l3_8_5_3',
    'No documented improvement plan exists, or improvement intentions are stated with no specific actions or owners.',
    'An improvement plan is documented but actions are inconsistently assigned owners or target dates.',
    'The improvement plan documents specific actions, each with a named owner and target date, as part of the business plan.',
    'Improvement plan action completion and impact are tracked across cycles to refine how future improvement priorities are set.',
    'The improvement plan is managed on an integrated performance-improvement platform with real-time action status visible to leadership.',
    'Ask for the current improvement plan and confirm at least one listed action has a named owner and target date.',
    'Improvement plan document; action items with owners and target dates; business-plan section referencing the improvement plan.',
    'Confirm the current improvement plan is on file and its actions carry named owners and target dates.',
    'Flag if the business plan''s improvement plan contains actions with no named owner or target date.', 3)
  ON CONFLICT (maturity_model_id, process_area) DO NOTHING;

  -- Q23: ofs_l3_8_5_4
  INSERT INTO questions (questionnaire_id, evaluation_type_id, domain_id, process_id,
    question_code, question_text, question_intent, instruction_text, evidence_examples,
    alert_rule_hint, mapped_maturity_model_id, mapped_maturity_statement_id, matched_process_area, sort_order)
  SELECT v_questionnaire_id, v_eval_type_id, v_domain_id, p.id,
    'ofs_l3_8_5_4',
    'How mature is the organization''s process for developing a documented performance-management plan defining how organizational, team, and individual performance will be measured and reviewed in support of the business plan?',
    'Assess whether a documented performance-management plan exists (measures, review cadence, escalation) linking individual/team performance to the business plan, versus performance being managed informally with no documented framework.',
    'Review the current performance-management plan and confirm it defines measures and a review cadence, and that it references or aligns with the business plan''s goals.',
    'Performance-management plan document; defined performance measures and review cadence; linkage to business-plan goals.',
    'Flag if no documented performance-management plan exists or if it defines no review cadence.',
    'ofs_mm_l1_8', 'ofs_l3_8_5_4', 'ofs_l3_8_5_4', 4
  FROM processes p WHERE p.code = 'ofs_l2_8_5';

  INSERT INTO maturity_statements (maturity_model_id, domain_title, process_area,
    level_1_basic, level_2_developing, level_3_established, level_4_advanced, level_5_leading,
    assessor_instruction, evidence_examples, review_steps, alert_rule_hint, sort_order)
  VALUES ('ofs_mm_l1_8', 'Develop Vision And Strategy', 'ofs_l3_8_5_4',
    'Performance is managed informally with no documented performance-management plan.',
    'A performance-management plan is documented but review cadence or linkage to business-plan goals is inconsistent.',
    'A documented performance-management plan defines measures and review cadence and is aligned with the business plan''s goals.',
    'Performance-management outcomes are tracked and analyzed across cycles to refine the measures and review process.',
    'Performance management is delivered through an integrated platform providing real-time performance visibility linked to business-plan goals.',
    'Ask for the current performance-management plan and confirm it defines a review cadence and references the business plan''s goals.',
    'Performance-management plan document; defined performance measures and review cadence; linkage to business-plan goals.',
    'Confirm the current performance-management plan is on file, defines a review cadence, and is aligned with business-plan goals.',
    'Flag if no documented performance-management plan exists or if it defines no review cadence.', 4)
  ON CONFLICT (maturity_model_id, process_area) DO NOTHING;

  -- Q24: ofs_l3_8_5_5
  INSERT INTO questions (questionnaire_id, evaluation_type_id, domain_id, process_id,
    question_code, question_text, question_intent, instruction_text, evidence_examples,
    alert_rule_hint, mapped_maturity_model_id, mapped_maturity_statement_id, matched_process_area, sort_order)
  SELECT v_questionnaire_id, v_eval_type_id, v_domain_id, p.id,
    'ofs_l3_8_5_5',
    'How mature is the organization''s process for documenting the current period''s organizational goals within the formal business plan and cascading them to functional and operational levels, distinct from the top-level goals set during strategy formulation?',
    'Assess whether business-plan-level goals are documented and demonstrably cascaded to functional/operational plans for the current period, versus top-level strategic goals existing with no documented cascade into the operating business plan.',
    'Review the business plan''s documented goals for the current period and confirm there is evidence of cascade into at least one functional or operational plan.',
    'Business-plan goals document for the current period; functional/operational plans referencing the cascaded goals; goal-cascade mapping.',
    'Flag if the current business plan''s goals show no documented cascade into any functional or operational plan.',
    'ofs_mm_l1_8', 'ofs_l3_8_5_5', 'ofs_l3_8_5_5', 5
  FROM processes p WHERE p.code = 'ofs_l2_8_5';

  INSERT INTO maturity_statements (maturity_model_id, domain_title, process_area,
    level_1_basic, level_2_developing, level_3_established, level_4_advanced, level_5_leading,
    assessor_instruction, evidence_examples, review_steps, alert_rule_hint, sort_order)
  VALUES ('ofs_mm_l1_8', 'Develop Vision And Strategy', 'ofs_l3_8_5_5',
    'Organizational goals are not documented at the business-plan level, or show no cascade to functional/operational plans.',
    'Goals are documented in the business plan but cascade to functional/operational plans is inconsistent or undocumented.',
    'The business plan documents the current period''s organizational goals with evidenced cascade into functional and operational plans.',
    'Goal cascade and attainment are tracked across functions and periods to refine how goals are set and communicated.',
    'Goal-setting and cascade are managed on an integrated strategy-execution platform with real-time visibility from business-plan goals to operational execution.',
    'Ask for the current business plan''s documented goals and confirm at least one functional or operational plan shows the cascade.',
    'Business-plan goals document for the current period; functional/operational plans referencing the cascaded goals; goal-cascade mapping.',
    'Confirm the business plan''s current-period goals are documented and cascaded into at least one functional or operational plan.',
    'Flag if the current business plan''s goals show no documented cascade into any functional or operational plan.', 5)
  ON CONFLICT (maturity_model_id, process_area) DO NOTHING;

  -- Q25: ofs_l3_8_5_6
  INSERT INTO questions (questionnaire_id, evaluation_type_id, domain_id, process_id,
    question_code, question_text, question_intent, instruction_text, evidence_examples,
    alert_rule_hint, mapped_maturity_model_id, mapped_maturity_statement_id, matched_process_area, sort_order)
  SELECT v_questionnaire_id, v_eval_type_id, v_domain_id, p.id,
    'ofs_l3_8_5_6',
    'How mature is the organization''s process for developing a documented financial plan (revenue, cost, capex, cash flow projections) as part of the business plan, aligned with the selected business strategy and initiatives?',
    'Assess whether the business plan includes a documented financial plan with projections tied to the selected strategy and initiatives, versus financial projections that are produced independently with no documented linkage to strategy.',
    'Review the current financial plan and confirm it includes revenue, cost, capex, and cash-flow projections, and that it references the strategic initiatives or goals it is funding.',
    'Financial plan document (revenue, cost, capex, cash-flow projections); linkage to strategic initiatives or goals; business-plan cycle materials.',
    'Flag if the business plan''s financial plan shows no documented linkage to the selected strategy or its initiatives.',
    'ofs_mm_l1_8', 'ofs_l3_8_5_6', 'ofs_l3_8_5_6', 6
  FROM processes p WHERE p.code = 'ofs_l2_8_5';

  INSERT INTO maturity_statements (maturity_model_id, domain_title, process_area,
    level_1_basic, level_2_developing, level_3_established, level_4_advanced, level_5_leading,
    assessor_instruction, evidence_examples, review_steps, alert_rule_hint, sort_order)
  VALUES ('ofs_mm_l1_8', 'Develop Vision And Strategy', 'ofs_l3_8_5_6',
    'No documented financial plan exists as part of the business plan, or projections are unlinked to the strategy.',
    'A financial plan is documented but its linkage to strategic initiatives or goals is inconsistent or unclear.',
    'A documented financial plan (revenue, cost, capex, cash flow) is produced and explicitly linked to the selected strategy and its initiatives.',
    'Financial-plan projections are tracked against actuals across cycles to refine forecasting assumptions.',
    'The financial plan is maintained on an integrated financial-planning platform with real-time variance tracking against strategic-initiative funding.',
    'Ask for the current financial plan and confirm it links its projections to the funded strategic initiatives or goals.',
    'Financial plan document (revenue, cost, capex, cash-flow projections); linkage to strategic initiatives or goals; business-plan cycle materials.',
    'Confirm the current financial plan is on file and shows documented linkage to the strategic initiatives or goals it funds.',
    'Flag if the business plan''s financial plan shows no documented linkage to the selected strategy or its initiatives.', 6)
  ON CONFLICT (maturity_model_id, process_area) DO NOTHING;

  -- ===== L2_8_6: Develop Marketing And Sales Strategy =====

  -- Q26: ofs_l3_8_6_1
  INSERT INTO questions (questionnaire_id, evaluation_type_id, domain_id, process_id,
    question_code, question_text, question_intent, instruction_text, evidence_examples,
    alert_rule_hint, mapped_maturity_model_id, mapped_maturity_statement_id, matched_process_area, sort_order)
  SELECT v_questionnaire_id, v_eval_type_id, v_domain_id, p.id,
    'ofs_l3_8_6_1',
    'How mature is the organization''s process for developing a documented marketing and sales strategy (target operator segments, service positioning, bidding/pricing posture, key-account priorities) explicitly aligned with the overall corporate strategy and goals?',
    'Assess whether marketing and sales activity follows a documented strategy tied to the corporate strategy (target segments, positioning, key accounts), versus being pursued opportunistically by individual business developers with no documented, corporate-aligned plan.',
    'Review the current marketing and sales strategy document and confirm it identifies target customer segments, service positioning, and key-account priorities, and that it references the overall corporate strategy or goals it supports.',
    'Marketing and sales strategy document; target-segment and key-account definitions; traceability to the overall corporate strategy or goals.',
    'Flag if sales and business-development activity proceeds with no documented marketing and sales strategy aligned to corporate goals.',
    'ofs_mm_l1_8', 'ofs_l3_8_6_1', 'ofs_l3_8_6_1', 1
  FROM processes p WHERE p.code = 'ofs_l2_8_6';

  INSERT INTO maturity_statements (maturity_model_id, domain_title, process_area,
    level_1_basic, level_2_developing, level_3_established, level_4_advanced, level_5_leading,
    assessor_instruction, evidence_examples, review_steps, alert_rule_hint, sort_order)
  VALUES ('ofs_mm_l1_8', 'Develop Vision And Strategy', 'ofs_l3_8_6_1',
    'Marketing and sales activity is pursued opportunistically with no documented strategy or alignment to corporate goals.',
    'A marketing and sales strategy is documented but alignment to the overall corporate strategy is inconsistent or unclear.',
    'A documented marketing and sales strategy defines target segments, positioning, and key accounts and is explicitly aligned to the corporate strategy.',
    'Marketing and sales strategy performance (win rate, pipeline by segment) is tracked and used to refine segment and positioning choices.',
    'Marketing and sales strategy is managed on an integrated CRM/strategy platform with real-time pipeline visibility linked to corporate strategic goals.',
    'Ask for the current marketing and sales strategy document and confirm it references the overall corporate strategy or goals it supports.',
    'Marketing and sales strategy document; target-segment and key-account definitions; traceability to the overall corporate strategy or goals.',
    'Confirm the current marketing and sales strategy document is on file, defines target segments/positioning, and is traceable to the corporate strategy.',
    'Flag if sales and business-development activity proceeds with no documented marketing and sales strategy aligned to corporate goals.', 1)
  ON CONFLICT (maturity_model_id, process_area) DO NOTHING;

END $$;