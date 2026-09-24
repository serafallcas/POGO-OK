/*
# OFS Onshore content batch: Manage Geological & Geophysical Surveys (ofs_l1_1)

1. New Data
   - 1 questionnaire row for the OFS Onshore evaluation type
   - 1 maturity_model (ofs_mm_l1_1)
   - 14 questions (ofs_l3_1_1_1 through ofs_l3_1_1_10 + ofs_l3_1_3_1 through ofs_l3_1_3_4)
   - 14 maturity_statements corresponding to each question
2. Purely additive — no drops, no deletes, no modifications to existing data.
3. All ON CONFLICT DO NOTHING for idempotency.
*/

DO $$
DECLARE
  v_questionnaire_id uuid;
  v_eval_type_id uuid;
  v_domain_id uuid;
BEGIN
  INSERT INTO questionnaires (evaluation_type_id, code, label, description, version, is_active)
  SELECT id, 'ofs_onshore_questionnaire', 'OFS Onshore Assessment Questionnaire',
         'EY Process model framework for Oil & Gas Oil Field Services Organizations - Onshore (Level 1-3)', '1.0', true
  FROM evaluation_types WHERE code = 'ofs_onshore'
  ON CONFLICT DO NOTHING;

  SELECT id INTO v_eval_type_id FROM evaluation_types WHERE code = 'ofs_onshore';
  SELECT id INTO v_questionnaire_id FROM questionnaires WHERE code = 'ofs_onshore_questionnaire';
  SELECT id INTO v_domain_id FROM domains WHERE code = 'ofs_l1_1';

  INSERT INTO maturity_models (code, label, description, domain_id, mapped_domain_id, mapped_domain_name, version, source_workbook, is_active)
  VALUES ('ofs_mm_l1_1', 'Manage Geological & Geophysical Surveys - Maturity Model', 'OFS Onshore maturity model for Manage Geological & Geophysical Surveys', v_domain_id, 'ofs_l1_1', 'Manage Geological & Geophysical Surveys', '1.0', 'POGO-OFS_Level_1-3_framework.pptx', true)
  ON CONFLICT (code) DO NOTHING;

  -- Q1: ofs_l3_1_1_1
  INSERT INTO questions (questionnaire_id, evaluation_type_id, domain_id, process_id,
    question_code, question_text, question_intent, instruction_text, evidence_examples,
    alert_rule_hint, mapped_maturity_model_id, mapped_maturity_statement_id, matched_process_area, sort_order)
  SELECT v_questionnaire_id, v_eval_type_id, v_domain_id, p.id,
    'ofs_l3_1_1_1', 'How mature is the organization''s process for planning and executing seismic data acquisition campaigns (2D/3D/4D, land or marine crews and subcontractors)?', 'Assess whether seismic acquisition is run as a controlled, permitted, safety-managed operation with defined technical specifications, rather than an ad hoc field activity driven solely by the crew contractor.', 'Review the acquisition program design (source/receiver geometry, fold, bin size), the permitting and HSE clearance trail, and how field QC (near-real-time noise/coverage monitoring) feeds back into acquisition parameters during the survey.', 'Acquisition design report; land/marine access permits and HSE clearances; daily field QC/observer reports; source and receiver test records; final acquisition report vs. program.',
    'Flag if surveys are routinely executed without a documented acquisition design or without any field QC/observer sign-off trail.', 'ofs_mm_l1_1', 'ofs_l3_1_1_1', 'ofs_l3_1_1_1', 1
  FROM processes p WHERE p.code = 'ofs_l2_1_1';

  INSERT INTO maturity_statements (maturity_model_id, domain_title, process_area,
    level_1_basic, level_2_developing, level_3_established, level_4_advanced, level_5_leading,
    assessor_instruction, evidence_examples, review_steps, alert_rule_hint, sort_order)
  VALUES ('ofs_mm_l1_1', 'Manage Geological & Geophysical Surveys', 'ofs_l3_1_1_1',
    'Acquisition is subcontracted with minimal specification; there is no documented acquisition design and field QC is verbal/ad hoc.', 'A basic acquisition design (geometry, fold) is produced per survey, but permitting/HSE clearance and field QC records are inconsistently kept.', 'Acquisition design, permitting and field QC are documented and approved for every survey, following an internal standard.', 'Acquisition parameters are actively adjusted mid-survey based on real-time QC data, and post-survey performance (fold, S/N, cost vs. budget) is systematically reviewed against the design.', 'Acquisition planning integrates lessons learned and rock-physics/imaging feedback across campaigns, with predictive parameter optimization and continuous benchmarking of crew/contractor performance.',
    'Request the last three acquisition design reports and match them against field QC logs and the final acquisition report; confirm sign-off dates precede mobilization.', 'Acquisition design report; land/marine access permits and HSE clearances; daily field QC/observer reports; source and receiver test records; final acquisition report vs. program.', 'Confirm existence of design→permit→field QC→close-out report chain; sample one survey end to end; check for design deviations that were never re-approved.', 'Flag if surveys are routinely executed without a documented acquisition design or without any field QC/observer sign-off trail.', 1)
  ON CONFLICT (maturity_model_id, process_area) DO NOTHING;

  -- Q2: ofs_l3_1_1_2
  INSERT INTO questions (questionnaire_id, evaluation_type_id, domain_id, process_id,
    question_code, question_text, question_intent, instruction_text, evidence_examples,
    alert_rule_hint, mapped_maturity_model_id, mapped_maturity_statement_id, matched_process_area, sort_order)
  SELECT v_questionnaire_id, v_eval_type_id, v_domain_id, p.id,
    'ofs_l3_1_1_2', 'How mature is the organization''s process for performing reservoir imaging (velocity model building, migration, inversion) and ensuring quality of the resulting subsurface image?', 'Assess whether imaging workflows follow a controlled sequence with documented QC (especially well-tie validation), rather than being a black-box vendor deliverable.', 'Review the imaging workflow documentation, velocity model build/update records, migration algorithm selection rationale, and well-tie QC reports for the most recent imaging project.', 'Velocity model iterations; migration/inversion parameter logs; well-tie QC reports; imaging sign-off memo.',
    'Flag if imaged volumes are delivered without a documented well-tie or velocity QC step.', 'ofs_mm_l1_1', 'ofs_l3_1_1_2', 'ofs_l3_1_1_2', 2
  FROM processes p WHERE p.code = 'ofs_l2_1_1';

  INSERT INTO maturity_statements (maturity_model_id, domain_title, process_area,
    level_1_basic, level_2_developing, level_3_established, level_4_advanced, level_5_leading,
    assessor_instruction, evidence_examples, review_steps, alert_rule_hint, sort_order)
  VALUES ('ofs_mm_l1_1', 'Manage Geological & Geophysical Surveys', 'ofs_l3_1_1_2',
    'Imaging is outsourced with no internal review of velocity models or well ties.', 'Velocity models exist but updates are undocumented; well-tie QC is occasional.', 'A standard workflow (velocity build → migration → well-tie QC → sign-off) is documented and followed.', 'Imaging quality metrics (well-tie residuals, resolution) are tracked over time and used to select algorithms/vendors.', 'Imaging workflows are continuously benchmarked, with feedback loops from drilling results used to refine velocity models for future campaigns.',
    'Ask for the well-tie QC report for the most recent imaging project and confirm it was reviewed before the volume was released to interpreters.', 'Velocity model iterations; migration/inversion parameter logs; well-tie QC reports; imaging sign-off memo.', 'Trace one imaging deliverable from raw processed volume to sign-off; verify well-tie residual is documented and within stated tolerance.', 'Flag if imaged volumes are delivered without a documented well-tie or velocity QC step.', 2)
  ON CONFLICT (maturity_model_id, process_area) DO NOTHING;

  -- Q3: ofs_l3_1_1_3
  INSERT INTO questions (questionnaire_id, evaluation_type_id, domain_id, process_id,
    question_code, question_text, question_intent, instruction_text, evidence_examples,
    alert_rule_hint, mapped_maturity_model_id, mapped_maturity_statement_id, matched_process_area, sort_order)
  SELECT v_questionnaire_id, v_eval_type_id, v_domain_id, p.id,
    'ofs_l3_1_1_3', 'How mature is the organization''s governance of seismic data assets (raw, processed, interpreted) across their lifecycle?', 'Assess whether seismic data is catalogued, versioned and access-controlled, avoiding loss, duplication or use of superseded volumes.', 'Review the seismic data management system/catalogue, versioning conventions, license/ownership tracking for licensed or multi-client data, and backup/archival policy.', 'Seismic data catalogue export; data license register; backup/archival logs; naming/versioning standard document.',
    'Flag if there is no central catalogue and staff locate seismic volumes via personal folders or memory.', 'ofs_mm_l1_1', 'ofs_l3_1_1_3', 'ofs_l3_1_1_3', 3
  FROM processes p WHERE p.code = 'ofs_l2_1_1';

  INSERT INTO maturity_statements (maturity_model_id, domain_title, process_area,
    level_1_basic, level_2_developing, level_3_established, level_4_advanced, level_5_leading,
    assessor_instruction, evidence_examples, review_steps, alert_rule_hint, sort_order)
  VALUES ('ofs_mm_l1_1', 'Manage Geological & Geophysical Surveys', 'ofs_l3_1_1_3',
    'Seismic volumes are stored on individual workstations/shared drives with no catalogue or version control.', 'A shared repository exists but cataloguing is incomplete and versioning is informal.', 'A documented catalogue with versioning, licensing status and access rights is maintained and kept current.', 'Data management is audited periodically; usage/access is logged and license compliance is actively monitored.', 'Seismic data governance is integrated with the broader subsurface data management strategy, with automated lifecycle policies (archival, purge, license expiry alerts).',
    'Request an export of the seismic catalogue and cross-check three volumes against physical/electronic storage to confirm accuracy.', 'Seismic data catalogue export; data license register; backup/archival logs; naming/versioning standard document.', 'Verify catalogue completeness against a sample of known surveys; check license expiry tracking for at least one multi-client dataset.', 'Flag if there is no central catalogue and staff locate seismic volumes via personal folders or memory.', 3)
  ON CONFLICT (maturity_model_id, process_area) DO NOTHING;

  -- Q4: ofs_l3_1_1_4
  INSERT INTO questions (questionnaire_id, evaluation_type_id, domain_id, process_id,
    question_code, question_text, question_intent, instruction_text, evidence_examples,
    alert_rule_hint, mapped_maturity_model_id, mapped_maturity_statement_id, matched_process_area, sort_order)
  SELECT v_questionnaire_id, v_eval_type_id, v_domain_id, p.id,
    'ofs_l3_1_1_4', 'How mature is the organization''s process for building, running and controlling reservoir simulation models used to support development decisions?', 'Determine whether simulation models are version-controlled, history-matched and validated before being used for decisions, versus used as unchecked black boxes.', 'Review model build documentation, history-match reports, sensitivity/uncertainty runs, and the approval step before a model is used to support a business decision.', 'Model documentation report; history-match QC package; run log/version register; decision memo referencing simulation output.',
    'Flag if simulation outputs feed investment decisions without a documented history-match or peer review.', 'ofs_mm_l1_1', 'ofs_l3_1_1_4', 'ofs_l3_1_1_4', 4
  FROM processes p WHERE p.code = 'ofs_l2_1_1';

  INSERT INTO maturity_statements (maturity_model_id, domain_title, process_area,
    level_1_basic, level_2_developing, level_3_established, level_4_advanced, level_5_leading,
    assessor_instruction, evidence_examples, review_steps, alert_rule_hint, sort_order)
  VALUES ('ofs_mm_l1_1', 'Manage Geological & Geophysical Surveys', 'ofs_l3_1_1_4',
    'Simulation models are built ad hoc with no documentation or history-match evidence.', 'Models are documented but history-matching and peer review are inconsistent.', 'A standard model-build and history-match/QC process is documented and applied before model use.', 'Uncertainty/sensitivity analysis is routinely performed and version history of the model is fully traceable.', 'Simulation practice is benchmarked and continuously improved using production surveillance feedback, with automated history-match tooling.',
    'Ask for the history-match report of the model currently used for the active field development plan and confirm it was peer-reviewed.', 'Model documentation report; history-match QC package; run log/version register; decision memo referencing simulation output.', 'Confirm model version referenced in the latest development decision matches an approved, dated history-match package.', 'Flag if simulation outputs feed investment decisions without a documented history-match or peer review.', 4)
  ON CONFLICT (maturity_model_id, process_area) DO NOTHING;

  -- Q5: ofs_l3_1_1_5
  INSERT INTO questions (questionnaire_id, evaluation_type_id, domain_id, process_id,
    question_code, question_text, question_intent, instruction_text, evidence_examples,
    alert_rule_hint, mapped_maturity_model_id, mapped_maturity_statement_id, matched_process_area, sort_order)
  SELECT v_questionnaire_id, v_eval_type_id, v_domain_id, p.id,
    'ofs_l3_1_1_5', 'How mature is the organization''s control over seismic data processing (in-house or subcontracted), from raw field data to final processed volume?', 'Assess whether processing sequences and parameters are specified, QC''d and signed off, rather than accepted as delivered from a vendor without review.', 'Review the processing flow specification, intermediate QC checkpoints, and the final acceptance/sign-off record against the contracted specification.', 'Processing sequence/parameter document; intermediate QC reports; vendor deliverable acceptance sign-off; processing contract specification.',
    'Flag if processed volumes are accepted without comparing deliverables against the contracted processing specification.', 'ofs_mm_l1_1', 'ofs_l3_1_1_5', 'ofs_l3_1_1_5', 5
  FROM processes p WHERE p.code = 'ofs_l2_1_1';

  INSERT INTO maturity_statements (maturity_model_id, domain_title, process_area,
    level_1_basic, level_2_developing, level_3_established, level_4_advanced, level_5_leading,
    assessor_instruction, evidence_examples, review_steps, alert_rule_hint, sort_order)
  VALUES ('ofs_mm_l1_1', 'Manage Geological & Geophysical Surveys', 'ofs_l3_1_1_5',
    'Processing is fully outsourced with no internal specification or QC of deliverables.', 'A basic specification exists but intermediate QC checkpoints are rarely reviewed internally.', 'Processing flow, QC checkpoints and final acceptance are documented and followed for every project.', 'Processing performance (turnaround, QC metrics) is tracked across vendors/projects and used in vendor selection.', 'Processing parameter libraries and QC benchmarks are continuously refined from project experience, with reprocessing decisions driven by quantified imaging uplift.',
    'Request the QC sign-off record for the last processing project and verify it references the contracted specification.', 'Processing sequence/parameter document; intermediate QC reports; vendor deliverable acceptance sign-off; processing contract specification.', 'Sample one processing deliverable and confirm each contracted QC checkpoint has a corresponding signed record.', 'Flag if processed volumes are accepted without comparing deliverables against the contracted processing specification.', 5)
  ON CONFLICT (maturity_model_id, process_area) DO NOTHING;

  -- Q6: ofs_l3_1_1_6
  INSERT INTO questions (questionnaire_id, evaluation_type_id, domain_id, process_id,
    question_code, question_text, question_intent, instruction_text, evidence_examples,
    alert_rule_hint, mapped_maturity_model_id, mapped_maturity_statement_id, matched_process_area, sort_order)
  SELECT v_questionnaire_id, v_eval_type_id, v_domain_id, p.id,
    'ofs_l3_1_1_6', 'How mature is the organization''s process for translating subsurface interpretation into reserves estimates and economic evaluations?', 'Determine whether reserves/economics work follows a controlled, auditable methodology consistent with recognized standards (e.g., SPE-PRMS), versus informal spreadsheet-based estimates.', 'Review the reserves estimation methodology document, the economic model assumptions register (price deck, cost basis), and the internal/external audit trail for reserves bookings.', 'Reserves estimation methodology; economic model assumption register; reserves audit report; sign-off record for reserves bookings.',
    'Flag if reserves figures used externally have no traceable link to an approved estimation methodology or audit.', 'ofs_mm_l1_1', 'ofs_l3_1_1_6', 'ofs_l3_1_1_6', 6
  FROM processes p WHERE p.code = 'ofs_l2_1_1';

  INSERT INTO maturity_statements (maturity_model_id, domain_title, process_area,
    level_1_basic, level_2_developing, level_3_established, level_4_advanced, level_5_leading,
    assessor_instruction, evidence_examples, review_steps, alert_rule_hint, sort_order)
  VALUES ('ofs_mm_l1_1', 'Manage Geological & Geophysical Surveys', 'ofs_l3_1_1_6',
    'Reserves/economics are estimated informally with no documented methodology or assumption register.', 'A methodology exists but is applied inconsistently; assumptions are not centrally tracked.', 'A documented, PRMS-aligned methodology is applied consistently, with a maintained assumption register and sign-off.', 'Reserves estimates undergo periodic independent audit and variance analysis against actuals.', 'Reserves/economics processes are continuously calibrated against production and price outcomes, with full traceability from raw data to booked reserves.',
    'Ask for the most recent reserves audit report and confirm findings were tracked to closure.', 'Reserves estimation methodology; economic model assumption register; reserves audit report; sign-off record for reserves bookings.', 'Trace one reserves category booking back to its supporting interpretation and assumption set.', 'Flag if reserves figures used externally have no traceable link to an approved estimation methodology or audit.', 6)
  ON CONFLICT (maturity_model_id, process_area) DO NOTHING;

  -- Q7: ofs_l3_1_1_7
  INSERT INTO questions (questionnaire_id, evaluation_type_id, domain_id, process_id,
    question_code, question_text, question_intent, instruction_text, evidence_examples,
    alert_rule_hint, mapped_maturity_model_id, mapped_maturity_statement_id, matched_process_area, sort_order)
  SELECT v_questionnaire_id, v_eval_type_id, v_domain_id, p.id,
    'ofs_l3_1_1_7', 'How mature is the organization''s overall survey management (scope definition, contractor selection, mobilization/demobilization, HSE oversight) for seismic surveys?', 'Assess whether survey execution is managed as a project with defined scope, budget, schedule and HSE oversight, rather than delegated wholesale to the contractor.', 'Review the survey scope of work, contractor selection/evaluation records, mobilization plan, and HSE incident/near-miss tracking specific to the survey.', 'Survey scope of work; contractor bid evaluation; mobilization/demobilization plan; survey HSE statistics.',
    'Flag if survey HSE performance is not tracked separately from general company HSE statistics.', 'ofs_mm_l1_1', 'ofs_l3_1_1_7', 'ofs_l3_1_1_7', 7
  FROM processes p WHERE p.code = 'ofs_l2_1_1';

  INSERT INTO maturity_statements (maturity_model_id, domain_title, process_area,
    level_1_basic, level_2_developing, level_3_established, level_4_advanced, level_5_leading,
    assessor_instruction, evidence_examples, review_steps, alert_rule_hint, sort_order)
  VALUES ('ofs_mm_l1_1', 'Manage Geological & Geophysical Surveys', 'ofs_l3_1_1_7',
    'Survey scope is loosely defined and contractor performance is not tracked.', 'A scope of work exists but contractor evaluation and HSE tracking are inconsistent across surveys.', 'Scope, contractor selection criteria and HSE oversight are documented and applied for every survey.', 'Survey performance (cost, schedule, HSE, data quality) is tracked and benchmarked across contractors and campaigns.', 'Survey management practices are continuously improved through structured lessons-learned and contractor performance scorecards feeding procurement decisions.',
    'Request the contractor evaluation scorecard for the last two surveys and check whether scores influenced contractor selection.', 'Survey scope of work; contractor bid evaluation; mobilization/demobilization plan; survey HSE statistics.', 'Confirm HSE statistics are logged per survey and reviewed in a close-out meeting with documented minutes.', 'Flag if survey HSE performance is not tracked separately from general company HSE statistics.', 7)
  ON CONFLICT (maturity_model_id, process_area) DO NOTHING;

  -- Q8: ofs_l3_1_1_8
  INSERT INTO questions (questionnaire_id, evaluation_type_id, domain_id, process_id,
    question_code, question_text, question_intent, instruction_text, evidence_examples,
    alert_rule_hint, mapped_maturity_model_id, mapped_maturity_statement_id, matched_process_area, sort_order)
  SELECT v_questionnaire_id, v_eval_type_id, v_domain_id, p.id,
    'ofs_l3_1_1_8', 'How mature is the organization''s process for conducting integrated geophysical studies (gravity, magnetics, EM, multi-attribute analysis) beyond core seismic imaging?', 'Determine whether geophysical studies are scoped against a specific technical question with documented conclusions, or performed opportunistically without a clear deliverable.', 'Review study terms of reference, integration of geophysical results with geological/petrophysical data, and the study close-out report.', 'Study terms of reference; integrated interpretation report; peer review comments; study close-out/recommendations memo.',
    'Flag if geophysical studies are commissioned without a documented terms of reference defining the question to be answered.', 'ofs_mm_l1_1', 'ofs_l3_1_1_8', 'ofs_l3_1_1_8', 8
  FROM processes p WHERE p.code = 'ofs_l2_1_1';

  INSERT INTO maturity_statements (maturity_model_id, domain_title, process_area,
    level_1_basic, level_2_developing, level_3_established, level_4_advanced, level_5_leading,
    assessor_instruction, evidence_examples, review_steps, alert_rule_hint, sort_order)
  VALUES ('ofs_mm_l1_1', 'Manage Geological & Geophysical Surveys', 'ofs_l3_1_1_8',
    'Studies are performed without a defined terms of reference or documented conclusions.', 'Terms of reference exist for major studies only; peer review is inconsistent.', 'All studies have a documented terms of reference, are peer-reviewed, and produce a close-out report with recommendations.', 'Study recommendations are tracked to implementation and their value (e.g., risk reduction, well placement improvement) is assessed.', 'Geophysical study practice is integrated into an organization-wide subsurface uncertainty reduction program with tracked value delivery.',
    'Ask for one recent geophysical study''s terms of reference and trace whether its recommendation was actioned.', 'Study terms of reference; integrated interpretation report; peer review comments; study close-out/recommendations memo.', 'Confirm peer review sign-off exists and recommendations are referenced in a subsequent decision document.', 'Flag if geophysical studies are commissioned without a documented terms of reference defining the question to be answered.', 8)
  ON CONFLICT (maturity_model_id, process_area) DO NOTHING;

  -- Q9: ofs_l3_1_1_9
  INSERT INTO questions (questionnaire_id, evaluation_type_id, domain_id, process_id,
    question_code, question_text, question_intent, instruction_text, evidence_examples,
    alert_rule_hint, mapped_maturity_model_id, mapped_maturity_statement_id, matched_process_area, sort_order)
  SELECT v_questionnaire_id, v_eval_type_id, v_domain_id, p.id,
    'ofs_l3_1_1_9', 'How mature is the organization''s use of remote sensing data (satellite imagery, aeromagnetic/aerogravity surveys) to support exploration and site planning?', 'Assess whether remote sensing data is systematically integrated into planning workflows or used only sporadically on an individual analyst''s initiative.', 'Review how remote sensing datasets are sourced, archived, and integrated with site planning, environmental baseline and exploration targeting workflows.', 'Remote sensing data inventory; integration reports with exploration/site-planning workflows; environmental baseline studies referencing remote sensing data.',
    'Flag if remote sensing data used for environmental baselining is not archived or traceable to a source/date.', 'ofs_mm_l1_1', 'ofs_l3_1_1_9', 'ofs_l3_1_1_9', 9
  FROM processes p WHERE p.code = 'ofs_l2_1_1';

  INSERT INTO maturity_statements (maturity_model_id, domain_title, process_area,
    level_1_basic, level_2_developing, level_3_established, level_4_advanced, level_5_leading,
    assessor_instruction, evidence_examples, review_steps, alert_rule_hint, sort_order)
  VALUES ('ofs_mm_l1_1', 'Manage Geological & Geophysical Surveys', 'ofs_l3_1_1_9',
    'Remote sensing data is used ad hoc by individuals with no archiving or documented integration.', 'Data is procured for specific projects but not systematically archived or reused.', 'A documented process defines when and how remote sensing data is acquired, archived and integrated into planning.', 'Remote sensing data quality and coverage are actively managed, with periodic refresh aligned to project needs.', 'Remote sensing is integrated into a broader geospatial data strategy with automated change-detection monitoring feeding site and environmental planning.',
    'Ask to see the remote sensing dataset used for the most recent site planning exercise and confirm its acquisition date and source are documented.', 'Remote sensing data inventory; integration reports with exploration/site-planning workflows; environmental baseline studies referencing remote sensing data.', 'Verify at least one example of remote sensing data directly informing a site-planning or exploration-targeting decision.', 'Flag if remote sensing data used for environmental baselining is not archived or traceable to a source/date.', 9)
  ON CONFLICT (maturity_model_id, process_area) DO NOTHING;

  -- Q10: ofs_l3_1_1_10
  INSERT INTO questions (questionnaire_id, evaluation_type_id, domain_id, process_id,
    question_code, question_text, question_intent, instruction_text, evidence_examples,
    alert_rule_hint, mapped_maturity_model_id, mapped_maturity_statement_id, matched_process_area, sort_order)
  SELECT v_questionnaire_id, v_eval_type_id, v_domain_id, p.id,
    'ofs_l3_1_1_10', 'How mature is the organization''s end-to-end quality control of the final seismic imaging product delivered to interpreters and decision-makers?', 'Distinguish this from ''Perform reservoir imaging'' (technical workflow) by focusing on the governance step: formal acceptance, distribution control and versioning of the final imaged product used across the organization.', 'Review the final imaging product acceptance checklist, distribution list/access control, and the linkage between the accepted version and downstream interpretation projects.', 'Final product acceptance checklist; distribution/access log; interpretation project references to a specific imaging version.',
    'Flag if more than one ''final'' version of an imaged volume circulates without a clear designation of the authoritative version.', 'ofs_mm_l1_1', 'ofs_l3_1_1_10', 'ofs_l3_1_1_10', 10
  FROM processes p WHERE p.code = 'ofs_l2_1_1';

  INSERT INTO maturity_statements (maturity_model_id, domain_title, process_area,
    level_1_basic, level_2_developing, level_3_established, level_4_advanced, level_5_leading,
    assessor_instruction, evidence_examples, review_steps, alert_rule_hint, sort_order)
  VALUES ('ofs_mm_l1_1', 'Manage Geological & Geophysical Surveys', 'ofs_l3_1_1_10',
    'No formal acceptance step exists; multiple untracked versions of imaged volumes circulate.', 'An acceptance step exists but is applied inconsistently; version control is informal.', 'A documented acceptance and distribution-control process ensures a single authoritative version is used downstream.', 'Version usage is tracked across interpretation projects, and outdated versions are actively retired from circulation.', 'Imaging product governance is integrated with the seismic data management system, with automated version control and usage analytics.',
    'Ask two different interpreters which imaging version they are currently using and confirm both reference the same authoritative version.', 'Final product acceptance checklist; distribution/access log; interpretation project references to a specific imaging version.', 'Check the distribution log for the most recent ''final'' volume and confirm prior versions were flagged as superseded.', 'Flag if more than one ''final'' version of an imaged volume circulates without a clear designation of the authoritative version.', 10)
  ON CONFLICT (maturity_model_id, process_area) DO NOTHING;

  -- Q11: ofs_l3_1_3_1
  INSERT INTO questions (questionnaire_id, evaluation_type_id, domain_id, process_id,
    question_code, question_text, question_intent, instruction_text, evidence_examples,
    alert_rule_hint, mapped_maturity_model_id, mapped_maturity_statement_id, matched_process_area, sort_order)
  SELECT v_questionnaire_id, v_eval_type_id, v_domain_id, p.id,
    'ofs_l3_1_3_1', 'How mature is the organization''s process for building and approving field/asset development plans integrating subsurface, drilling, facilities and economics?', 'Assess whether development plans are produced through a structured, cross-disciplinary, approved process, versus an informal document assembled by a single discipline.', 'Review the development plan template/standard, evidence of cross-functional input (subsurface, drilling, facilities, finance, HSE), and the formal approval/sign-off record.', 'Development plan document and template; cross-functional review comments; management approval record; plan revision history.',
    'Flag if the current development plan has no documented cross-functional review or approval date.', 'ofs_mm_l1_1', 'ofs_l3_1_3_1', 'ofs_l3_1_3_1', 1
  FROM processes p WHERE p.code = 'ofs_l2_1_3';

  INSERT INTO maturity_statements (maturity_model_id, domain_title, process_area,
    level_1_basic, level_2_developing, level_3_established, level_4_advanced, level_5_leading,
    assessor_instruction, evidence_examples, review_steps, alert_rule_hint, sort_order)
  VALUES ('ofs_mm_l1_1', 'Manage Geological & Geophysical Surveys', 'ofs_l3_1_3_1',
    'Development plans are informal, produced by one discipline with no cross-functional input.', 'A basic template exists; cross-functional input is sought inconsistently.', 'A documented process requires cross-functional review and management approval for every development plan.', 'Development plans are revisited on a defined cadence and revised based on new data/performance, with tracked revision history.', 'Development planning is integrated with portfolio and economic optimization tools, with scenario/sensitivity analysis routinely informing plan revisions.',
    'Request the approval record for the current development plan and confirm all required disciplines signed prior to approval date.', 'Development plan document and template; cross-functional review comments; management approval record; plan revision history.', 'Verify the plan''s revision history shows updates tied to specific triggers (new well data, price changes, performance review).', 'Flag if the current development plan has no documented cross-functional review or approval date.', 1)
  ON CONFLICT (maturity_model_id, process_area) DO NOTHING;

  -- Q12: ofs_l3_1_3_2
  INSERT INTO questions (questionnaire_id, evaluation_type_id, domain_id, process_id,
    question_code, question_text, question_intent, instruction_text, evidence_examples,
    alert_rule_hint, mapped_maturity_model_id, mapped_maturity_statement_id, matched_process_area, sort_order)
  SELECT v_questionnaire_id, v_eval_type_id, v_domain_id, p.id,
    'ofs_l3_1_3_2', 'How mature is the organization''s management of laboratory services (core analysis, fluid PVT, geochemistry) supporting subsurface evaluation?', 'Determine whether lab services are quality-managed (accreditation, chain of custody, QC) or operate without traceable quality controls.', 'Review lab accreditation/certification status, sample chain-of-custody records, and QC/calibration logs for lab equipment (internal lab or subcontracted).', 'Lab accreditation certificate; chain-of-custody forms; QC/calibration logs; lab results sign-off records.',
    'Flag if sample chain of custody cannot be reconstructed from receipt to reported result.', 'ofs_mm_l1_1', 'ofs_l3_1_3_2', 'ofs_l3_1_3_2', 2
  FROM processes p WHERE p.code = 'ofs_l2_1_3';

  INSERT INTO maturity_statements (maturity_model_id, domain_title, process_area,
    level_1_basic, level_2_developing, level_3_established, level_4_advanced, level_5_leading,
    assessor_instruction, evidence_examples, review_steps, alert_rule_hint, sort_order)
  VALUES ('ofs_mm_l1_1', 'Manage Geological & Geophysical Surveys', 'ofs_l3_1_3_2',
    'Lab work is commissioned with no chain-of-custody records or quality certification requirement.', 'Some chain-of-custody documentation exists but is incomplete or inconsistently applied.', 'Chain of custody, QC/calibration and accreditation requirements are documented and enforced for all lab work.', 'Lab performance (turnaround, QC pass rate, inter-lab comparison) is tracked and used in vendor selection.', 'Laboratory quality management is integrated into an organization-wide data quality program, with continuous inter-laboratory benchmarking.',
    'Request the chain-of-custody record for a recent core/fluid sample and trace it from field collection to final lab report.', 'Lab accreditation certificate; chain-of-custody forms; QC/calibration logs; lab results sign-off records.', 'Confirm lab accreditation certificates are current and cover the specific analyses being relied upon.', 'Flag if sample chain of custody cannot be reconstructed from receipt to reported result.', 2)
  ON CONFLICT (maturity_model_id, process_area) DO NOTHING;

  -- Q13: ofs_l3_1_3_3
  INSERT INTO questions (questionnaire_id, evaluation_type_id, domain_id, process_id,
    question_code, question_text, question_intent, instruction_text, evidence_examples,
    alert_rule_hint, mapped_maturity_model_id, mapped_maturity_statement_id, matched_process_area, sort_order)
  SELECT v_questionnaire_id, v_eval_type_id, v_domain_id, p.id,
    'ofs_l3_1_3_3', 'How mature is the organization''s process for delivering and controlling the quality of internal/external technical advisory input to E&P decisions?', 'Assess whether advisory input (internal experts or external consultants) is scoped, documented and tracked to decisions, versus informal, undocumented advice.', 'Review advisory engagement terms of reference, deliverable documentation, and traceability between advisory recommendations and subsequent decisions.', 'Advisory engagement scope/contract; advisory deliverable/report; decision record referencing advisory input.',
    'Flag if significant technical decisions reference undocumented or unattributed advisory input.', 'ofs_mm_l1_1', 'ofs_l3_1_3_3', 'ofs_l3_1_3_3', 3
  FROM processes p WHERE p.code = 'ofs_l2_1_3';

  INSERT INTO maturity_statements (maturity_model_id, domain_title, process_area,
    level_1_basic, level_2_developing, level_3_established, level_4_advanced, level_5_leading,
    assessor_instruction, evidence_examples, review_steps, alert_rule_hint, sort_order)
  VALUES ('ofs_mm_l1_1', 'Manage Geological & Geophysical Surveys', 'ofs_l3_1_3_3',
    'Advisory input is informal and undocumented; no scope or deliverable trail exists.', 'Formal engagements exist for major consultants but internal advisory input is not documented.', 'All significant advisory engagements (internal or external) have a documented scope and deliverable, referenced in decisions.', 'Advisory input quality/value is periodically assessed against decision outcomes.', 'Advisory sourcing is optimized through a maintained registry of internal/external expertise with performance tracking and knowledge capture.',
    'Ask for the terms of reference and deliverable of the most recent significant advisory engagement and confirm it is referenced in a decision record.', 'Advisory engagement scope/contract; advisory deliverable/report; decision record referencing advisory input.', 'Trace one major technical decision back to the advisory input that supported it.', 'Flag if significant technical decisions reference undocumented or unattributed advisory input.', 3)
  ON CONFLICT (maturity_model_id, process_area) DO NOTHING;

  -- Q14: ofs_l3_1_3_4
  INSERT INTO questions (questionnaire_id, evaluation_type_id, domain_id, process_id,
    question_code, question_text, question_intent, instruction_text, evidence_examples,
    alert_rule_hint, mapped_maturity_model_id, mapped_maturity_statement_id, matched_process_area, sort_order)
  SELECT v_questionnaire_id, v_eval_type_id, v_domain_id, p.id,
    'ofs_l3_1_3_4', 'How mature is the organization''s coordination of the broader set of reservoir engineering services (well test analysis, material balance, production forecasting) supporting field management?', 'Assess whether reservoir services are delivered through a coordinated, documented workflow linked to field management decisions, rather than isolated one-off analyses.', 'Review the reservoir services work program, linkage of well test/material balance outputs to production forecasts, and how forecasts are reconciled against actual production.', 'Reservoir services work program; well test/material balance reports; production forecast vs. actual reconciliation.',
    'Flag if production forecasts are not periodically reconciled against actual production data.', 'ofs_mm_l1_1', 'ofs_l3_1_3_4', 'ofs_l3_1_3_4', 4
  FROM processes p WHERE p.code = 'ofs_l2_1_3';

  INSERT INTO maturity_statements (maturity_model_id, domain_title, process_area,
    level_1_basic, level_2_developing, level_3_established, level_4_advanced, level_5_leading,
    assessor_instruction, evidence_examples, review_steps, alert_rule_hint, sort_order)
  VALUES ('ofs_mm_l1_1', 'Manage Geological & Geophysical Surveys', 'ofs_l3_1_3_4',
    'Reservoir services are performed reactively with no coordinated work program.', 'A work program exists but forecast-vs-actual reconciliation is infrequent or undocumented.', 'A documented work program coordinates reservoir services, with regular forecast reconciliation against actuals.', 'Forecast accuracy trends are tracked and used to refine reservoir models and service prioritization.', 'Reservoir services are fully integrated with production surveillance and asset planning, with predictive analytics driving proactive interventions.',
    'Ask for the latest production forecast reconciliation report and confirm variance analysis was documented and acted upon.', 'Reservoir services work program; well test/material balance reports; production forecast vs. actual reconciliation.', 'Confirm the reservoir services work program is reviewed and updated on a defined cadence (e.g., quarterly).', 'Flag if production forecasts are not periodically reconciled against actual production data.', 4)
  ON CONFLICT (maturity_model_id, process_area) DO NOTHING;
END $$;
