/*
# OFS Onshore content batch: Prepare Sites And Infrastructure (ofs_l1_2)

1. New Data
   - 1 maturity_model (ofs_mm_l1_2)
   - 19 questions (ofs_l3_2_1_1 through ofs_l3_2_1_10 + ofs_l3_2_3_1 through ofs_l3_2_3_9)
   - 19 maturity_statements corresponding to each question
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
  SELECT id INTO v_domain_id FROM domains WHERE code = 'ofs_l1_2';

  INSERT INTO maturity_models (code, label, description, domain_id, mapped_domain_id, mapped_domain_name, version, source_workbook, is_active)
  VALUES ('ofs_mm_l1_2', 'Prepare Sites And Infrastructure - Maturity Model', 'OFS Onshore maturity model for Prepare Sites And Infrastructure', v_domain_id, 'ofs_l1_2', 'Prepare Sites And Infrastructure', '1.0', 'POGO-OFS_Level_1-3_framework.pptx', true)
  ON CONFLICT (code) DO NOTHING;

  -- Q1: ofs_l3_2_1_1
  INSERT INTO questions (questionnaire_id, evaluation_type_id, domain_id, process_id,
    question_code, question_text, question_intent, instruction_text, evidence_examples,
    alert_rule_hint, mapped_maturity_model_id, mapped_maturity_statement_id, matched_process_area, sort_order)
  SELECT v_questionnaire_id, v_eval_type_id, v_domain_id, p.id,
    'ofs_l3_2_1_1', 'How mature is the organization''s tendering process for selecting site preparation and pre-drilling contractors and suppliers?', 'Assess whether tender packages are competitively run against defined technical/commercial criteria and documented, versus contracts awarded informally through existing relationships.', 'Review the tender package template, the bidder evaluation matrix (technical + commercial scoring), and the award/sign-off record for a recent site-preparation tender.', 'Tender package/RFQ; bidder evaluation matrix; award recommendation memo; approval sign-off.',
    'Flag if a site-preparation contract above the organization''s tender threshold was awarded without a documented competitive process.', 'ofs_mm_l1_2', 'ofs_l3_2_1_1', 'ofs_l3_2_1_1', 1
  FROM processes p WHERE p.code = 'ofs_l2_2_1';

  INSERT INTO maturity_statements (maturity_model_id, domain_title, process_area,
    level_1_basic, level_2_developing, level_3_established, level_4_advanced, level_5_leading,
    assessor_instruction, evidence_examples, review_steps, alert_rule_hint, sort_order)
  VALUES ('ofs_mm_l1_2', 'Prepare Sites And Infrastructure', 'ofs_l3_2_1_1',
    'Contractors are selected informally with no documented tender process.', 'A basic tender process exists but evaluation criteria are inconsistent and not always documented.', 'A standard tender process (RFQ, scoring matrix, approval) is documented and applied for all relevant contracts.', 'Tender outcomes are tracked against contractor performance to refine the bidder list and evaluation criteria.', 'Tendering is integrated with a strategic sourcing/vendor management system, with continuous supplier performance benchmarking feeding future awards.',
    'Ask for the tender file of the most recent site-preparation contract and confirm the award decision references the scoring matrix.', 'Tender package/RFQ; bidder evaluation matrix; award recommendation memo; approval sign-off.', 'Sample one tender file end to end; confirm RFQ, bids received, scoring and approval are all present and dated consistently.', 'Flag if a site-preparation contract above the organization''s tender threshold was awarded without a documented competitive process.', 1)
  ON CONFLICT (maturity_model_id, process_area) DO NOTHING;

  -- Q2: ofs_l3_2_1_2
  INSERT INTO questions (questionnaire_id, evaluation_type_id, domain_id, process_id,
    question_code, question_text, question_intent, instruction_text, evidence_examples,
    alert_rule_hint, mapped_maturity_model_id, mapped_maturity_statement_id, matched_process_area, sort_order)
  SELECT v_questionnaire_id, v_eval_type_id, v_domain_id, p.id,
    'ofs_l3_2_1_2', 'How mature is the organization''s process for conducting technical studies (geotechnical, hydrological, access, load-bearing) ahead of site preparation?', 'Determine whether site-specific technical studies are systematically commissioned and used to inform design, versus generic assumptions being applied across sites.', 'Review the scope of technical studies commissioned for a recent site, the study reports, and how findings were incorporated into the site design.', 'Technical study scope of work; geotechnical/hydrological study reports; design documents referencing study findings.',
    'Flag if site design proceeds without a site-specific geotechnical or access study on file.', 'ofs_mm_l1_2', 'ofs_l3_2_1_2', 'ofs_l3_2_1_2', 2
  FROM processes p WHERE p.code = 'ofs_l2_2_1';

  INSERT INTO maturity_statements (maturity_model_id, domain_title, process_area,
    level_1_basic, level_2_developing, level_3_established, level_4_advanced, level_5_leading,
    assessor_instruction, evidence_examples, review_steps, alert_rule_hint, sort_order)
  VALUES ('ofs_mm_l1_2', 'Prepare Sites And Infrastructure', 'ofs_l3_2_1_2',
    'Site design relies on generic assumptions; site-specific technical studies are rarely commissioned.', 'Technical studies are commissioned for some sites but findings are not consistently traced into design decisions.', 'Site-specific technical studies are commissioned for every site and formally referenced in the design package.', 'Study quality and findings are reviewed against actual site conditions post-construction to calibrate future studies.', 'Technical study data feeds a regional geotechnical/hydrological knowledge base used to de-risk and accelerate future site selection.',
    'Request the technical study reports for the most recently prepared site and confirm the site design package cites their findings.', 'Technical study scope of work; geotechnical/hydrological study reports; design documents referencing study findings.', 'Trace one site''s design package back to its technical study reports and confirm consistency between findings and design choices.', 'Flag if site design proceeds without a site-specific geotechnical or access study on file.', 2)
  ON CONFLICT (maturity_model_id, process_area) DO NOTHING;

  -- Q3: ofs_l3_2_1_3
  INSERT INTO questions (questionnaire_id, evaluation_type_id, domain_id, process_id,
    question_code, question_text, question_intent, instruction_text, evidence_examples,
    alert_rule_hint, mapped_maturity_model_id, mapped_maturity_statement_id, matched_process_area, sort_order)
  SELECT v_questionnaire_id, v_eval_type_id, v_domain_id, p.id,
    'ofs_l3_2_1_3', 'How mature is the organization''s contract management process for site-preparation and pre-drilling suppliers, from award through execution?', 'Assess whether contracts are actively managed (scope, milestones, change orders, close-out) after award, rather than filed away until a dispute arises.', 'Review the contract register, change-order log, and milestone tracking for an active or recently completed site-preparation contract.', 'Contract register; signed contract with scope/milestones; change-order log; contract close-out report.',
    'Flag if contract change orders are implemented in the field without a documented, approved change-order record.', 'ofs_mm_l1_2', 'ofs_l3_2_1_3', 'ofs_l3_2_1_3', 3
  FROM processes p WHERE p.code = 'ofs_l2_2_1';

  INSERT INTO maturity_statements (maturity_model_id, domain_title, process_area,
    level_1_basic, level_2_developing, level_3_established, level_4_advanced, level_5_leading,
    assessor_instruction, evidence_examples, review_steps, alert_rule_hint, sort_order)
  VALUES ('ofs_mm_l1_2', 'Prepare Sites And Infrastructure', 'ofs_l3_2_1_3',
    'Contracts are signed and filed with no active tracking of scope, milestones or changes.', 'A contract register exists but milestone and change-order tracking is inconsistent across contracts.', 'All active contracts are tracked against scope and milestones, with change orders formally approved before execution.', 'Contract performance (cost, schedule adherence, change-order frequency) is analyzed to inform future contract terms.', 'Contract management is integrated with the broader supply chain system, with automated milestone/change-order workflows and predictive risk flagging.',
    'Ask for the change-order log of an active site-preparation contract and confirm each change was approved before work began.', 'Contract register; signed contract with scope/milestones; change-order log; contract close-out report.', 'Sample one contract and confirm a documented chain from scope definition through milestones to close-out, including any change orders.', 'Flag if contract change orders are implemented in the field without a documented, approved change-order record.', 3)
  ON CONFLICT (maturity_model_id, process_area) DO NOTHING;

  -- Q4: ofs_l3_2_1_4
  INSERT INTO questions (questionnaire_id, evaluation_type_id, domain_id, process_id,
    question_code, question_text, question_intent, instruction_text, evidence_examples,
    alert_rule_hint, mapped_maturity_model_id, mapped_maturity_statement_id, matched_process_area, sort_order)
  SELECT v_questionnaire_id, v_eval_type_id, v_domain_id, p.id,
    'ofs_l3_2_1_4', 'How mature is the organization''s process for assessing site feasibility (technical, commercial, regulatory) before committing to site preparation investment?', 'Distinguish this from the narrower technical studies above by focusing on the go/no-go investment decision: whether a documented feasibility case is required before committing capital.', 'Review the feasibility study template, the recommendation memo for a recent site, and the approval record for the associated capital commitment.', 'Feasibility study report; investment recommendation memo; capital approval/sign-off record.',
    'Flag if site-preparation capital is committed without a documented feasibility recommendation and approval.', 'ofs_mm_l1_2', 'ofs_l3_2_1_4', 'ofs_l3_2_1_4', 4
  FROM processes p WHERE p.code = 'ofs_l2_2_1';

  INSERT INTO maturity_statements (maturity_model_id, domain_title, process_area,
    level_1_basic, level_2_developing, level_3_established, level_4_advanced, level_5_leading,
    assessor_instruction, evidence_examples, review_steps, alert_rule_hint, sort_order)
  VALUES ('ofs_mm_l1_2', 'Prepare Sites And Infrastructure', 'ofs_l3_2_1_4',
    'Feasibility is assessed informally with no documented study or approval trail.', 'Feasibility studies are produced for major sites but are inconsistent in scope and not always tied to the approval decision.', 'A standard feasibility study and approval process is applied to every site before capital commitment.', 'Feasibility study accuracy is tracked against actual site outcomes and used to refine the assessment methodology.', 'Feasibility assessment is integrated with portfolio-level investment planning, with standardized economic and risk models applied consistently across all candidate sites.',
    'Ask for the feasibility study and approval record for the most recent site investment and confirm the approval references the study''s recommendation.', 'Feasibility study report; investment recommendation memo; capital approval/sign-off record.', 'Confirm the capital approval for one site cites a completed feasibility study with an explicit recommendation.', 'Flag if site-preparation capital is committed without a documented feasibility recommendation and approval.', 4)
  ON CONFLICT (maturity_model_id, process_area) DO NOTHING;

  -- Q5: ofs_l3_2_1_5
  INSERT INTO questions (questionnaire_id, evaluation_type_id, domain_id, process_id,
    question_code, question_text, question_intent, instruction_text, evidence_examples,
    alert_rule_hint, mapped_maturity_model_id, mapped_maturity_statement_id, matched_process_area, sort_order)
  SELECT v_questionnaire_id, v_eval_type_id, v_domain_id, p.id,
    'ofs_l3_2_1_5', 'How mature is the organization''s budgeting and scheduling process for site-preparation and pre-drilling activities?', 'Assess whether site-preparation work is planned against a documented budget and schedule that is actively tracked, versus cost and timing being managed reactively.', 'Review the site-preparation budget and schedule baseline for a recent project, and the variance tracking against actuals.', 'Site-preparation budget/schedule baseline; cost and schedule variance reports; re-forecast records.',
    'Flag if site-preparation costs significantly exceed the approved budget with no documented variance explanation.', 'ofs_mm_l1_2', 'ofs_l3_2_1_5', 'ofs_l3_2_1_5', 5
  FROM processes p WHERE p.code = 'ofs_l2_2_1';

  INSERT INTO maturity_statements (maturity_model_id, domain_title, process_area,
    level_1_basic, level_2_developing, level_3_established, level_4_advanced, level_5_leading,
    assessor_instruction, evidence_examples, review_steps, alert_rule_hint, sort_order)
  VALUES ('ofs_mm_l1_2', 'Prepare Sites And Infrastructure', 'ofs_l3_2_1_5',
    'Budgets and schedules are set informally with no baseline or variance tracking.', 'A budget/schedule baseline exists but variance tracking is infrequent or incomplete.', 'Budget and schedule baselines are set and actively tracked against actuals for every site, with documented variance explanations.', 'Variance trends across sites are analyzed to improve estimating accuracy for future budgets.', 'Budgeting and planning are integrated with an enterprise cost/schedule system, with predictive estimating models continuously calibrated from historical site data.',
    'Ask for the latest cost/schedule variance report for an active site and confirm variances above a defined threshold have a documented explanation.', 'Site-preparation budget/schedule baseline; cost and schedule variance reports; re-forecast records.', 'Compare the approved baseline budget/schedule for one site against the latest actuals and confirm variance reporting occurred on a defined cadence.', 'Flag if site-preparation costs significantly exceed the approved budget with no documented variance explanation.', 5)
  ON CONFLICT (maturity_model_id, process_area) DO NOTHING;

  -- Q6: ofs_l3_2_1_6
  INSERT INTO questions (questionnaire_id, evaluation_type_id, domain_id, process_id,
    question_code, question_text, question_intent, instruction_text, evidence_examples,
    alert_rule_hint, mapped_maturity_model_id, mapped_maturity_statement_id, matched_process_area, sort_order)
  SELECT v_questionnaire_id, v_eval_type_id, v_domain_id, p.id,
    'ofs_l3_2_1_6', 'How mature is the organization''s field site-investigation process (surveys, soil sampling, environmental baseline) ahead of construction?', 'Assess whether field investigations are planned and executed to a defined scope with documented results, versus visual inspection alone.', 'Review the site investigation scope, field survey/sampling records, and how findings were signed off before construction proceeded.', 'Site investigation scope of work; survey/soil sampling reports; environmental baseline report; sign-off before construction start.',
    'Flag if construction begins before site investigation results are reviewed and signed off.', 'ofs_mm_l1_2', 'ofs_l3_2_1_6', 'ofs_l3_2_1_6', 6
  FROM processes p WHERE p.code = 'ofs_l2_2_1';

  INSERT INTO maturity_statements (maturity_model_id, domain_title, process_area,
    level_1_basic, level_2_developing, level_3_established, level_4_advanced, level_5_leading,
    assessor_instruction, evidence_examples, review_steps, alert_rule_hint, sort_order)
  VALUES ('ofs_mm_l1_2', 'Prepare Sites And Infrastructure', 'ofs_l3_2_1_6',
    'Site investigation is a brief visual inspection with no documented scope or results.', 'A basic investigation is performed and recorded but sign-off before construction start is inconsistent.', 'A defined site investigation scope (survey, soil, environmental baseline) is executed and formally signed off before construction begins.', 'Site investigation findings are systematically compared against as-built conditions to validate investigation accuracy.', 'Site investigation data feeds a shared geospatial/environmental database used to de-risk and accelerate investigations at nearby future sites.',
    'Ask for the site investigation report of the most recently constructed site and confirm it was signed off before construction start.', 'Site investigation scope of work; survey/soil sampling reports; environmental baseline report; sign-off before construction start.', 'Confirm the site investigation sign-off date precedes the construction mobilization date for a sampled site.', 'Flag if construction begins before site investigation results are reviewed and signed off.', 6)
  ON CONFLICT (maturity_model_id, process_area) DO NOTHING;

  -- Q7: ofs_l3_2_1_7
  INSERT INTO questions (questionnaire_id, evaluation_type_id, domain_id, process_id,
    question_code, question_text, question_intent, instruction_text, evidence_examples,
    alert_rule_hint, mapped_maturity_model_id, mapped_maturity_statement_id, matched_process_area, sort_order)
  SELECT v_questionnaire_id, v_eval_type_id, v_domain_id, p.id,
    'ofs_l3_2_1_7', 'How mature is the organization''s process for controlling the actual site preparation and construction works (grading, pad construction, access roads)?', 'Assess whether construction execution follows an approved design and is subject to inspection/QC before hand-over, versus proceeding without formal control.', 'Review the approved construction design, field inspection/QC records during construction, and the hand-over/acceptance record.', 'Approved site design/construction drawings; field inspection/QC logs; construction hand-over/acceptance certificate.',
    'Flag if a site is handed over to drilling operations without a documented construction acceptance record.', 'ofs_mm_l1_2', 'ofs_l3_2_1_7', 'ofs_l3_2_1_7', 7
  FROM processes p WHERE p.code = 'ofs_l2_2_1';

  INSERT INTO maturity_statements (maturity_model_id, domain_title, process_area,
    level_1_basic, level_2_developing, level_3_established, level_4_advanced, level_5_leading,
    assessor_instruction, evidence_examples, review_steps, alert_rule_hint, sort_order)
  VALUES ('ofs_mm_l1_2', 'Prepare Sites And Infrastructure', 'ofs_l3_2_1_7',
    'Construction proceeds without a formally approved design or inspection records.', 'Construction follows an approved design but field inspection/QC records are incomplete.', 'Construction is executed against an approved design with documented inspection/QC, and formally accepted at hand-over.', 'Construction quality metrics (rework, inspection findings) are tracked across sites to identify recurring issues.', 'Construction execution uses digital QC/progress tracking integrated with design, enabling real-time deviation management and continuous improvement across the site portfolio.',
    'Ask for the hand-over/acceptance certificate for the most recently constructed site and confirm it references completed inspection records.', 'Approved site design/construction drawings; field inspection/QC logs; construction hand-over/acceptance certificate.', 'Trace one site''s construction package from approved design through inspection records to a signed hand-over/acceptance certificate.', 'Flag if a site is handed over to drilling operations without a documented construction acceptance record.', 7)
  ON CONFLICT (maturity_model_id, process_area) DO NOTHING;

  -- Q8: ofs_l3_2_1_8
  INSERT INTO questions (questionnaire_id, evaluation_type_id, domain_id, process_id,
    question_code, question_text, question_intent, instruction_text, evidence_examples,
    alert_rule_hint, mapped_maturity_model_id, mapped_maturity_statement_id, matched_process_area, sort_order)
  SELECT v_questionnaire_id, v_eval_type_id, v_domain_id, p.id,
    'ofs_l3_2_1_8', 'How mature is the organization''s engineering oversight of site-preparation design and construction (design review, field engineering support, as-built verification)?', 'Distinguish this from field QC above by focusing on the engineering governance layer: whether qualified engineering review/sign-off gates design and material deviations.', 'Review the design review/approval record, the log of field engineering queries or deviations, and how as-built drawings were verified against the approved design.', 'Design review/approval sign-off; field engineering query (RFI) log; as-built verification report.',
    'Flag if field deviations from the approved design proceed without documented engineering review and approval.', 'ofs_mm_l1_2', 'ofs_l3_2_1_8', 'ofs_l3_2_1_8', 8
  FROM processes p WHERE p.code = 'ofs_l2_2_1';

  INSERT INTO maturity_statements (maturity_model_id, domain_title, process_area,
    level_1_basic, level_2_developing, level_3_established, level_4_advanced, level_5_leading,
    assessor_instruction, evidence_examples, review_steps, alert_rule_hint, sort_order)
  VALUES ('ofs_mm_l1_2', 'Prepare Sites And Infrastructure', 'ofs_l3_2_1_8',
    'Design and field deviations are handled without formal engineering review or sign-off.', 'Engineering review occurs for major designs but field deviations are not consistently routed through engineering.', 'A documented engineering review/approval gate covers both the design and any field deviations, with as-built verification performed.', 'Engineering query/deviation trends are analyzed across sites to improve standard designs and reduce recurring field issues.', 'Engineering oversight is digitally integrated with design and construction tracking, enabling real-time deviation management and continuous design standardization.',
    'Ask for the field engineering query log of a recent site and confirm each significant deviation has a documented engineering approval.', 'Design review/approval sign-off; field engineering query (RFI) log; as-built verification report.', 'Sample one field engineering query and confirm the resolution was reviewed and approved by qualified engineering staff before implementation.', 'Flag if field deviations from the approved design proceed without documented engineering review and approval.', 8)
  ON CONFLICT (maturity_model_id, process_area) DO NOTHING;

  -- Q9: ofs_l3_2_1_9
  INSERT INTO questions (questionnaire_id, evaluation_type_id, domain_id, process_id,
    question_code, question_text, question_intent, instruction_text, evidence_examples,
    alert_rule_hint, mapped_maturity_model_id, mapped_maturity_statement_id, matched_process_area, sort_order)
  SELECT v_questionnaire_id, v_eval_type_id, v_domain_id, p.id,
    'ofs_l3_2_1_9', 'How mature is the organization''s process for mobilizing personnel, equipment and materials to a site-preparation project?', 'Assess whether mobilization follows a documented plan (resource, equipment, materials, logistics) coordinated against the schedule, versus ad hoc dispatch.', 'Review the mobilization plan for a recent site, the equipment/material dispatch records, and confirmation that mobilization aligned with the approved schedule.', 'Mobilization plan; equipment/material dispatch log; mobilization completion confirmation against schedule.',
    'Flag if significant mobilization delays occur with no documented cause or corrective action.', 'ofs_mm_l1_2', 'ofs_l3_2_1_9', 'ofs_l3_2_1_9', 9
  FROM processes p WHERE p.code = 'ofs_l2_2_1';

  INSERT INTO maturity_statements (maturity_model_id, domain_title, process_area,
    level_1_basic, level_2_developing, level_3_established, level_4_advanced, level_5_leading,
    assessor_instruction, evidence_examples, review_steps, alert_rule_hint, sort_order)
  VALUES ('ofs_mm_l1_2', 'Prepare Sites And Infrastructure', 'ofs_l3_2_1_9',
    'Mobilization is arranged informally with no documented plan.', 'A mobilization plan exists for major projects but is not consistently tracked against the schedule.', 'A documented mobilization plan (resources, equipment, materials, logistics) is produced and tracked against the schedule for every site.', 'Mobilization performance (on-time %, delay causes) is tracked across sites and used to improve planning accuracy.', 'Mobilization planning is integrated with fleet/resource management systems, enabling predictive scheduling and dynamic re-allocation across concurrent sites.',
    'Ask for the mobilization plan and actual mobilization dates for a recent site and confirm any delays are explained and documented.', 'Mobilization plan; equipment/material dispatch log; mobilization completion confirmation against schedule.', 'Compare planned versus actual mobilization dates for one site and confirm variances above a defined threshold were investigated.', 'Flag if significant mobilization delays occur with no documented cause or corrective action.', 9)
  ON CONFLICT (maturity_model_id, process_area) DO NOTHING;

  -- Q10: ofs_l3_2_1_10
  INSERT INTO questions (questionnaire_id, evaluation_type_id, domain_id, process_id,
    question_code, question_text, question_intent, instruction_text, evidence_examples,
    alert_rule_hint, mapped_maturity_model_id, mapped_maturity_statement_id, matched_process_area, sort_order)
  SELECT v_questionnaire_id, v_eval_type_id, v_domain_id, p.id,
    'ofs_l3_2_1_10', 'How mature is the organization''s process for identifying and satisfying legal and regulatory requirements applicable to site preparation (land rights, environmental permits, local ordinances)?', 'Assess whether legal/regulatory requirements are systematically identified and tracked to closure before site work begins, versus addressed reactively when challenged.', 'Review the legal/regulatory requirements checklist for a recent site, the permit/approval register, and confirmation that all required approvals were obtained before construction.', 'Legal/regulatory requirements checklist; permit and land-rights approval register; construction start authorization referencing completed approvals.',
    'Flag if site construction begins before all identified legal/regulatory approvals are on file.', 'ofs_mm_l1_2', 'ofs_l3_2_1_10', 'ofs_l3_2_1_10', 10
  FROM processes p WHERE p.code = 'ofs_l2_2_1';

  INSERT INTO maturity_statements (maturity_model_id, domain_title, process_area,
    level_1_basic, level_2_developing, level_3_established, level_4_advanced, level_5_leading,
    assessor_instruction, evidence_examples, review_steps, alert_rule_hint, sort_order)
  VALUES ('ofs_mm_l1_2', 'Prepare Sites And Infrastructure', 'ofs_l3_2_1_10',
    'Legal/regulatory requirements are addressed reactively with no documented checklist or tracking.', 'A requirements checklist exists but is applied inconsistently across sites.', 'A documented legal/regulatory checklist and approval register is maintained and verified complete before construction starts, for every site.', 'Legal/regulatory compliance status is tracked centrally with proactive renewal management for time-bound approvals.', 'Legal/regulatory management is integrated with a jurisdiction-aware compliance system providing automated alerts for new or changing requirements across all operating regions.',
    'Ask for the legal/regulatory requirements checklist for the most recent site and confirm every item is closed out with a dated approval on file.', 'Legal/regulatory requirements checklist; permit and land-rights approval register; construction start authorization referencing completed approvals.', 'Verify the construction start authorization for one site references a fully completed legal/regulatory checklist.', 'Flag if site construction begins before all identified legal/regulatory approvals are on file.', 10)
  ON CONFLICT (maturity_model_id, process_area) DO NOTHING;

  -- Q11: ofs_l3_2_3_1
  INSERT INTO questions (questionnaire_id, evaluation_type_id, domain_id, process_id,
    question_code, question_text, question_intent, instruction_text, evidence_examples,
    alert_rule_hint, mapped_maturity_model_id, mapped_maturity_statement_id, matched_process_area, sort_order)
  SELECT v_questionnaire_id, v_eval_type_id, v_domain_id, p.id,
    'ofs_l3_2_3_1', 'How mature is the organization''s process for planning and delivering civil infrastructure (well pads, access roads, drainage) supporting site operations?', 'Assess whether civil infrastructure is designed to defined engineering standards and delivered under a documented plan, versus built to informal local practice.', 'Review the civil infrastructure design standard, the delivery plan for a recent pad/road project, and the acceptance/QC record at completion.', 'Civil infrastructure design standard; pad/road construction plan; QC/acceptance records.',
    'Flag if pad or road construction deviates from the design standard without a documented engineering waiver.', 'ofs_mm_l1_2', 'ofs_l3_2_3_1', 'ofs_l3_2_3_1', 1
  FROM processes p WHERE p.code = 'ofs_l2_2_3';

  INSERT INTO maturity_statements (maturity_model_id, domain_title, process_area,
    level_1_basic, level_2_developing, level_3_established, level_4_advanced, level_5_leading,
    assessor_instruction, evidence_examples, review_steps, alert_rule_hint, sort_order)
  VALUES ('ofs_mm_l1_2', 'Prepare Sites And Infrastructure', 'ofs_l3_2_3_1',
    'Civil infrastructure is built to informal local practice with no documented design standard.', 'A design standard exists but is applied inconsistently across sites.', 'Civil infrastructure is designed and delivered to a documented standard, with QC/acceptance records for every pad and road.', 'Infrastructure performance (durability, maintenance needs) is tracked and used to refine design standards.', 'Civil infrastructure planning is integrated with regional asset/GIS systems, enabling standardized, optimized designs reused across the site portfolio.',
    'Ask for the design standard and QC/acceptance record for a recently built pad or access road and confirm consistency.', 'Civil infrastructure design standard; pad/road construction plan; QC/acceptance records.', 'Sample one pad/road construction and confirm the as-built structure conforms to the documented design standard or has an approved waiver.', 'Flag if pad or road construction deviates from the design standard without a documented engineering waiver.', 1)
  ON CONFLICT (maturity_model_id, process_area) DO NOTHING;

  -- Q12: ofs_l3_2_3_2
  INSERT INTO questions (questionnaire_id, evaluation_type_id, domain_id, process_id,
    question_code, question_text, question_intent, instruction_text, evidence_examples,
    alert_rule_hint, mapped_maturity_model_id, mapped_maturity_statement_id, matched_process_area, sort_order)
  SELECT v_questionnaire_id, v_eval_type_id, v_domain_id, p.id,
    'ofs_l3_2_3_2', 'How mature is the organization''s management of the heavy civil equipment fleet (dozers, graders, compactors) used for site preparation?', 'Assess whether the fleet is planned, maintained and allocated under a documented management process, versus managed informally on an as-needed basis.', 'Review the fleet inventory/utilization plan, maintenance records for heavy civil equipment, and how equipment is allocated across concurrent site projects.', 'Fleet inventory and utilization plan; equipment maintenance log; equipment allocation schedule.',
    'Flag if heavy civil equipment is deployed without a current, documented maintenance record.', 'ofs_mm_l1_2', 'ofs_l3_2_3_2', 'ofs_l3_2_3_2', 2
  FROM processes p WHERE p.code = 'ofs_l2_2_3';

  INSERT INTO maturity_statements (maturity_model_id, domain_title, process_area,
    level_1_basic, level_2_developing, level_3_established, level_4_advanced, level_5_leading,
    assessor_instruction, evidence_examples, review_steps, alert_rule_hint, sort_order)
  VALUES ('ofs_mm_l1_2', 'Prepare Sites And Infrastructure', 'ofs_l3_2_3_2',
    'Fleet management is informal with no documented inventory, maintenance schedule or allocation plan.', 'A fleet inventory exists but maintenance and allocation planning are inconsistent.', 'A documented fleet management process (inventory, maintenance schedule, allocation plan) is maintained and followed.', 'Fleet utilization and maintenance costs are analyzed to optimize fleet size and replacement timing.', 'Fleet management is integrated with a telematics/asset-management system providing real-time utilization, predictive maintenance and dynamic allocation across all sites.',
    'Ask for the maintenance record of a piece of heavy civil equipment currently deployed and confirm it is current.', 'Fleet inventory and utilization plan; equipment maintenance log; equipment allocation schedule.', 'Sample one piece of equipment and confirm its maintenance record is up to date against the documented maintenance schedule.', 'Flag if heavy civil equipment is deployed without a current, documented maintenance record.', 2)
  ON CONFLICT (maturity_model_id, process_area) DO NOTHING;

  -- Q13: ofs_l3_2_3_3
  INSERT INTO questions (questionnaire_id, evaluation_type_id, domain_id, process_id,
    question_code, question_text, question_intent, instruction_text, evidence_examples,
    alert_rule_hint, mapped_maturity_model_id, mapped_maturity_statement_id, matched_process_area, sort_order)
  SELECT v_questionnaire_id, v_eval_type_id, v_domain_id, p.id,
    'ofs_l3_2_3_3', 'How mature is the organization''s process for designing and constructing water transfer systems (pipelines, pumps, storage) supporting site operations?', 'Assess whether water transfer infrastructure is engineered to a documented design and hydraulic capacity requirement, versus assembled ad hoc from available equipment.', 'Review the water transfer system design (capacity/hydraulic calculations), construction records, and pressure/leak testing results before commissioning.', 'Water transfer system design and hydraulic calculations; construction records; pressure/leak test results; commissioning sign-off.',
    'Flag if a water transfer system is commissioned without documented pressure or leak testing.', 'ofs_mm_l1_2', 'ofs_l3_2_3_3', 'ofs_l3_2_3_3', 3
  FROM processes p WHERE p.code = 'ofs_l2_2_3';

  INSERT INTO maturity_statements (maturity_model_id, domain_title, process_area,
    level_1_basic, level_2_developing, level_3_established, level_4_advanced, level_5_leading,
    assessor_instruction, evidence_examples, review_steps, alert_rule_hint, sort_order)
  VALUES ('ofs_mm_l1_2', 'Prepare Sites And Infrastructure', 'ofs_l3_2_3_3',
    'Water transfer systems are assembled ad hoc with no documented design or testing.', 'A basic design is produced but pressure/leak testing before commissioning is inconsistent.', 'Water transfer systems are engineered to a documented design and formally tested before commissioning, for every project.', 'System performance (leak incidents, capacity utilization) is tracked and used to refine future designs.', 'Water transfer system design and monitoring are integrated with a broader water-management strategy, with real-time flow/pressure monitoring across the network.',
    'Ask for the pressure/leak test results of the most recently commissioned water transfer system and confirm they precede the commissioning sign-off date.', 'Water transfer system design and hydraulic calculations; construction records; pressure/leak test results; commissioning sign-off.', 'Confirm the commissioning sign-off for one system references completed and passed pressure/leak testing.', 'Flag if a water transfer system is commissioned without documented pressure or leak testing.', 3)
  ON CONFLICT (maturity_model_id, process_area) DO NOTHING;

  -- Q14: ofs_l3_2_3_4
  INSERT INTO questions (questionnaire_id, evaluation_type_id, domain_id, process_id,
    question_code, question_text, question_intent, instruction_text, evidence_examples,
    alert_rule_hint, mapped_maturity_model_id, mapped_maturity_statement_id, matched_process_area, sort_order)
  SELECT v_questionnaire_id, v_eval_type_id, v_domain_id, p.id,
    'ofs_l3_2_3_4', 'How mature is the organization''s process for identifying and securing laydown space (equipment/material staging areas) with adequate access for a site project?', 'Assess whether laydown space is planned in advance against defined size/access criteria, versus improvised once equipment arrives.', 'Review the laydown space planning criteria, the site-specific laydown plan, and confirmation of secured access/agreements before mobilization.', 'Laydown space planning criteria; site-specific laydown plan/map; land access agreement for laydown area.',
    'Flag if equipment mobilization proceeds to a site with no secured, documented laydown space.', 'ofs_mm_l1_2', 'ofs_l3_2_3_4', 'ofs_l3_2_3_4', 4
  FROM processes p WHERE p.code = 'ofs_l2_2_3';

  INSERT INTO maturity_statements (maturity_model_id, domain_title, process_area,
    level_1_basic, level_2_developing, level_3_established, level_4_advanced, level_5_leading,
    assessor_instruction, evidence_examples, review_steps, alert_rule_hint, sort_order)
  VALUES ('ofs_mm_l1_2', 'Prepare Sites And Infrastructure', 'ofs_l3_2_3_4',
    'Laydown space is improvised on arrival with no documented plan.', 'A laydown plan is produced for major sites but access agreements are not always secured in advance.', 'A documented laydown plan with secured access is produced for every site ahead of mobilization.', 'Laydown space utilization and adequacy are reviewed post-project to refine planning criteria.', 'Laydown space planning is integrated with regional logistics/GIS systems, enabling optimized, pre-approved staging areas reused across nearby sites.',
    'Ask for the laydown plan and access agreement for a recent site and confirm both were finalized before mobilization began.', 'Laydown space planning criteria; site-specific laydown plan/map; land access agreement for laydown area.', 'Confirm the laydown plan and access agreement dates for one site precede the equipment mobilization date.', 'Flag if equipment mobilization proceeds to a site with no secured, documented laydown space.', 4)
  ON CONFLICT (maturity_model_id, process_area) DO NOTHING;

  -- Q15: ofs_l3_2_3_5
  INSERT INTO questions (questionnaire_id, evaluation_type_id, domain_id, process_id,
    question_code, question_text, question_intent, instruction_text, evidence_examples,
    alert_rule_hint, mapped_maturity_model_id, mapped_maturity_statement_id, matched_process_area, sort_order)
  SELECT v_questionnaire_id, v_eval_type_id, v_domain_id, p.id,
    'ofs_l3_2_3_5', 'How mature is the organization''s process for obtaining permits required for site access and supply logistics (road use, oversize load, right-of-way)?', 'Assess whether access/supply permits are systematically identified and obtained ahead of need, versus sourced reactively when a shipment or crew is blocked.', 'Review the access/supply permit checklist for a recent site, the permit register, and confirmation that permits were in hand before the associated activity began.', 'Access/supply permit checklist; permit register with issue/expiry dates; activity logs cross-referenced to permit validity.',
    'Flag if an oversize load or restricted-access shipment moved without a valid permit on file.', 'ofs_mm_l1_2', 'ofs_l3_2_3_5', 'ofs_l3_2_3_5', 5
  FROM processes p WHERE p.code = 'ofs_l2_2_3';

  INSERT INTO maturity_statements (maturity_model_id, domain_title, process_area,
    level_1_basic, level_2_developing, level_3_established, level_4_advanced, level_5_leading,
    assessor_instruction, evidence_examples, review_steps, alert_rule_hint, sort_order)
  VALUES ('ofs_mm_l1_2', 'Prepare Sites And Infrastructure', 'ofs_l3_2_3_5',
    'Access/supply permits are obtained reactively, sometimes after an activity has already started.', 'A permit checklist exists but is not consistently verified before activities begin.', 'All required access/supply permits are identified, obtained and verified valid before the associated activity begins, for every site.', 'Permit lead times and renewal patterns are tracked to proactively avoid delays.', 'Permit management is integrated with a jurisdiction-aware compliance system providing automated alerts ahead of expiry and pre-populated renewal workflows.',
    'Ask for the permit register for a recent site and confirm permit issue dates precede the dates of the activities they cover.', 'Access/supply permit checklist; permit register with issue/expiry dates; activity logs cross-referenced to permit validity.', 'Sample one oversize-load or restricted-access shipment and confirm a valid permit was on file for the shipment date.', 'Flag if an oversize load or restricted-access shipment moved without a valid permit on file.', 5)
  ON CONFLICT (maturity_model_id, process_area) DO NOTHING;

  -- Q16: ofs_l3_2_3_6
  INSERT INTO questions (questionnaire_id, evaluation_type_id, domain_id, process_id,
    question_code, question_text, question_intent, instruction_text, evidence_examples,
    alert_rule_hint, mapped_maturity_model_id, mapped_maturity_statement_id, matched_process_area, sort_order)
  SELECT v_questionnaire_id, v_eval_type_id, v_domain_id, p.id,
    'ofs_l3_2_3_6', 'How mature is the organization''s process for identifying, permitting and managing access to local water sources used in site operations?', 'Assess whether water sourcing is planned against documented water-rights/permits and volumetric limits, versus drawn from local sources without formal authorization.', 'Review the water source assessment, the water-use permit/agreement, and volumetric usage tracking against any permitted limits.', 'Water source assessment; water-use permit or landowner agreement; volumetric water usage log.',
    'Flag if water is drawn from a local source with no documented permit, agreement or usage tracking.', 'ofs_mm_l1_2', 'ofs_l3_2_3_6', 'ofs_l3_2_3_6', 6
  FROM processes p WHERE p.code = 'ofs_l2_2_3';

  INSERT INTO maturity_statements (maturity_model_id, domain_title, process_area,
    level_1_basic, level_2_developing, level_3_established, level_4_advanced, level_5_leading,
    assessor_instruction, evidence_examples, review_steps, alert_rule_hint, sort_order)
  VALUES ('ofs_mm_l1_2', 'Prepare Sites And Infrastructure', 'ofs_l3_2_3_6',
    'Water is sourced locally with no documented permit, agreement or usage tracking.', 'Water-use agreements exist for major sites but usage tracking against permitted limits is inconsistent.', 'A documented water-use permit/agreement and volumetric usage tracking is in place for every site drawing local water.', 'Water usage trends are analyzed across sites to optimize sourcing and reduce dependence on constrained sources.', 'Water sourcing is integrated with a regional water-stewardship strategy, with real-time usage monitoring and proactive engagement with local water authorities/communities.',
    'Ask for the water-use permit or agreement for a site''s water source and confirm usage is tracked against any stated limit.', 'Water source assessment; water-use permit or landowner agreement; volumetric water usage log.', 'Confirm volumetric water usage logs exist for one site and reconcile against the permitted or agreed limit.', 'Flag if water is drawn from a local source with no documented permit, agreement or usage tracking.', 6)
  ON CONFLICT (maturity_model_id, process_area) DO NOTHING;

  -- Q17: ofs_l3_2_3_7
  INSERT INTO questions (questionnaire_id, evaluation_type_id, domain_id, process_id,
    question_code, question_text, question_intent, instruction_text, evidence_examples,
    alert_rule_hint, mapped_maturity_model_id, mapped_maturity_statement_id, matched_process_area, sort_order)
  SELECT v_questionnaire_id, v_eval_type_id, v_domain_id, p.id,
    'ofs_l3_2_3_7', 'How mature is the organization''s process for planning waste disposal (drilling waste, construction debris, sanitary waste) for a site-preparation project?', 'Assess whether a waste disposal plan is developed against applicable regulations and waste-stream characterization, versus disposal being decided informally as waste is generated.', 'Review the waste characterization/disposal plan for a recent site, applicable regulatory requirements, and how the plan was approved before site work began.', 'Waste characterization and disposal plan; applicable regulatory requirements reference; plan approval sign-off.',
    'Flag if site work begins without an approved waste disposal plan on file.', 'ofs_mm_l1_2', 'ofs_l3_2_3_7', 'ofs_l3_2_3_7', 7
  FROM processes p WHERE p.code = 'ofs_l2_2_3';

  INSERT INTO maturity_statements (maturity_model_id, domain_title, process_area,
    level_1_basic, level_2_developing, level_3_established, level_4_advanced, level_5_leading,
    assessor_instruction, evidence_examples, review_steps, alert_rule_hint, sort_order)
  VALUES ('ofs_mm_l1_2', 'Prepare Sites And Infrastructure', 'ofs_l3_2_3_7',
    'Waste disposal decisions are made informally as waste is generated, with no documented plan.', 'A waste disposal plan is produced for major sites but is not consistently approved before work begins.', 'A documented, regulation-aligned waste disposal plan is produced and approved before site work begins, for every site.', 'Waste volumes and disposal costs are tracked across sites to identify waste-reduction opportunities.', 'Waste planning is integrated with a broader environmental management system, with waste-stream data feeding sustainability reporting and continuous reduction targets.',
    'Ask for the waste disposal plan for a recent site and confirm it was approved before site work began.', 'Waste characterization and disposal plan; applicable regulatory requirements reference; plan approval sign-off.', 'Confirm the waste disposal plan approval date for one site precedes the site work start date.', 'Flag if site work begins without an approved waste disposal plan on file.', 7)
  ON CONFLICT (maturity_model_id, process_area) DO NOTHING;

  -- Q18: ofs_l3_2_3_8
  INSERT INTO questions (questionnaire_id, evaluation_type_id, domain_id, process_id,
    question_code, question_text, question_intent, instruction_text, evidence_examples,
    alert_rule_hint, mapped_maturity_model_id, mapped_maturity_statement_id, matched_process_area, sort_order)
  SELECT v_questionnaire_id, v_eval_type_id, v_domain_id, p.id,
    'ofs_l3_2_3_8', 'How mature is the organization''s process for contracting licensed waste disposal service providers and verifying compliant disposal?', 'Assess whether waste disposal contractors are vetted for licensing/compliance and disposal is verified with documentation (manifests, disposal certificates), versus waste being handed off with no chain-of-custody record.', 'Review the waste disposal contractor''s license/certification, the waste manifest or chain-of-custody documentation, and disposal certificates for a recent site.', 'Waste disposal contractor license/certification; waste manifest/chain-of-custody record; disposal certificate.',
    'Flag if waste is handed to a disposal contractor with no manifest or chain-of-custody record retained.', 'ofs_mm_l1_2', 'ofs_l3_2_3_8', 'ofs_l3_2_3_8', 8
  FROM processes p WHERE p.code = 'ofs_l2_2_3';

  INSERT INTO maturity_statements (maturity_model_id, domain_title, process_area,
    level_1_basic, level_2_developing, level_3_established, level_4_advanced, level_5_leading,
    assessor_instruction, evidence_examples, review_steps, alert_rule_hint, sort_order)
  VALUES ('ofs_mm_l1_2', 'Prepare Sites And Infrastructure', 'ofs_l3_2_3_8',
    'Waste is handed to disposal contractors with no license verification or chain-of-custody documentation.', 'Contractor licensing is checked for major contracts but manifest/chain-of-custody documentation is inconsistently retained.', 'Disposal contractors are verified licensed and every waste stream has a retained manifest/chain-of-custody record through to a disposal certificate.', 'Disposal contractor compliance and manifest completeness are periodically audited across sites.', 'Waste disposal contracting is integrated with a digital chain-of-custody system providing real-time tracking from generation to certified disposal across the portfolio.',
    'Ask for the waste manifest and disposal certificate for a recent waste shipment and confirm the contractor''s license was valid at the time.', 'Waste disposal contractor license/certification; waste manifest/chain-of-custody record; disposal certificate.', 'Sample one waste shipment and confirm an unbroken documentation chain from manifest to disposal certificate.', 'Flag if waste is handed to a disposal contractor with no manifest or chain-of-custody record retained.', 8)
  ON CONFLICT (maturity_model_id, process_area) DO NOTHING;

  -- Q19: ofs_l3_2_3_9
  INSERT INTO questions (questionnaire_id, evaluation_type_id, domain_id, process_id,
    question_code, question_text, question_intent, instruction_text, evidence_examples,
    alert_rule_hint, mapped_maturity_model_id, mapped_maturity_statement_id, matched_process_area, sort_order)
  SELECT v_questionnaire_id, v_eval_type_id, v_domain_id, p.id,
    'ofs_l3_2_3_9', 'How mature is the organization''s process for coordinating local travel and personnel logistics (transport, accommodation, crew changes) supporting a site project?', 'Assess whether personnel logistics are planned and coordinated under a documented process aligned with safety and schedule requirements, versus arranged informally on short notice.', 'Review the personnel logistics plan for a recent site (transport routes/providers, accommodation, crew-change schedule) and how it was coordinated with the site schedule and HSE requirements.', 'Personnel logistics plan; transport provider agreements; crew-change schedule; HSE travel-risk assessment.',
    'Flag if personnel travel to a remote or high-risk site route with no documented travel-risk assessment.', 'ofs_mm_l1_2', 'ofs_l3_2_3_9', 'ofs_l3_2_3_9', 9
  FROM processes p WHERE p.code = 'ofs_l2_2_3';

  INSERT INTO maturity_statements (maturity_model_id, domain_title, process_area,
    level_1_basic, level_2_developing, level_3_established, level_4_advanced, level_5_leading,
    assessor_instruction, evidence_examples, review_steps, alert_rule_hint, sort_order)
  VALUES ('ofs_mm_l1_2', 'Prepare Sites And Infrastructure', 'ofs_l3_2_3_9',
    'Personnel logistics are arranged informally on short notice with no documented plan.', 'A logistics plan exists for major sites but is not consistently aligned with HSE travel-risk requirements.', 'A documented personnel logistics plan, including HSE travel-risk assessment, is produced and followed for every site.', 'Logistics performance (delays, incidents) is tracked across sites and used to improve provider selection and routing.', 'Personnel logistics are integrated with a real-time crew-tracking and travel-risk management system, enabling dynamic rerouting and proactive safety intervention.',
    'Ask for the personnel logistics plan and travel-risk assessment for a recent remote site and confirm both were completed before mobilization.', 'Personnel logistics plan; transport provider agreements; crew-change schedule; HSE travel-risk assessment.', 'Confirm the travel-risk assessment for one site''s transport route is documented and dated before personnel mobilization.', 'Flag if personnel travel to a remote or high-risk site route with no documented travel-risk assessment.', 9)
  ON CONFLICT (maturity_model_id, process_area) DO NOTHING;
END $$;
