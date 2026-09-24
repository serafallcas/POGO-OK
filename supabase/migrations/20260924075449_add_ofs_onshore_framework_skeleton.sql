/*
# Add OFS Onshore Framework Skeleton

1. Purpose
   - Insert the EY "Process model framework for Oil & Gas Oil Field Services
     Organizations - Onshore" Level 1-3 structural skeleton.
   - Purely additive: no drops, no deletes, no modifications to existing data.

2. New Data
   - 1 evaluation_type: ofs_onshore
   - 4 category-level domains (Evaluation and Drilling, Completion and Production,
     Management processes, Business support processes)
   - 22 Level-1 domains (1.0 through 22.0), each parented under a category
   - 144 Level-2 processes across all 22 Level-1 domains

3. Security
   - No schema changes; existing RLS policies apply.
*/

DO $$
DECLARE
  v_eval_type_id uuid;
  v_cat_evaluation_and_drilling_id uuid;
  v_cat_completion_and_production_id uuid;
  v_cat_management_processes_id uuid;
  v_cat_business_support_processes_id uuid;
  v_l1_1_0_manage_geological_geophysical_surveys_id uuid;
  v_l1_2_0_prepare_sites_and_infrastructure_id uuid;
  v_l1_3_0_drill_the_well_id uuid;
  v_l1_4_0_complete_the_well_id uuid;
  v_l1_5_0_install_production_equipment_and_maintain_production_id uuid;
  v_l1_6_0_conduct_well_interventions_and_workover_activities_id uuid;
  v_l1_7_0_plug_and_abandon_id uuid;
  v_l1_8_0_develop_vision_and_strategy_id uuid;
  v_l1_9_0_manage_service_portfolio_id uuid;
  v_l1_10_0_manage_new_business_development_and_intellectual_proper_id uuid;
  v_l1_11_0_manage_governance_risk_and_compliance_id uuid;
  v_l1_12_0_manage_service_quality_and_health_safety_and_environmen_id uuid;
  v_l1_13_0_manage_external_relationships_id uuid;
  v_l1_14_0_manage_supply_chain_id uuid;
  v_l1_15_0_manage_financial_resources_id uuid;
  v_l1_16_0_develop_and_manage_human_capital_id uuid;
  v_l1_17_0_manage_yard_and_support_facilities_id uuid;
  v_l1_18_0_manage_information_technology_id uuid;
  v_l1_19_0_manage_legal_id uuid;
  v_l1_20_0_develop_and_manage_research_and_development_id uuid;
  v_l1_21_0_manage_knowledge_improvement_and_change_structure_id uuid;
  v_l1_22_0_manage_engineering_and_pre_sales_id uuid;
BEGIN
  -- evaluation_type
  INSERT INTO evaluation_types (code, label, description, category, source_workbook, sort_order)
  VALUES ('ofs_onshore', 'Oil Field Services – Onshore', 'EY Process model framework for Oil & Gas Oil Field Services Organizations - Onshore (Level 1-3)', 'Oil Field Services', 'POGO-OFS_Level_1-3_framework.pptx', 100)
  RETURNING id INTO v_eval_type_id;

  -- 4 category domains
  INSERT INTO domains (evaluation_type_id, code, label, sort_order)
  VALUES (v_eval_type_id, 'ofs_cat_evaluation_and_drilling', 'Evaluation and Drilling', 1)
  RETURNING id INTO v_cat_evaluation_and_drilling_id;

  INSERT INTO domains (evaluation_type_id, code, label, sort_order)
  VALUES (v_eval_type_id, 'ofs_cat_completion_and_production', 'Completion and Production', 2)
  RETURNING id INTO v_cat_completion_and_production_id;

  INSERT INTO domains (evaluation_type_id, code, label, sort_order)
  VALUES (v_eval_type_id, 'ofs_cat_management_processes', 'Management processes', 3)
  RETURNING id INTO v_cat_management_processes_id;

  INSERT INTO domains (evaluation_type_id, code, label, sort_order)
  VALUES (v_eval_type_id, 'ofs_cat_business_support_processes', 'Business support processes', 4)
  RETURNING id INTO v_cat_business_support_processes_id;

  -- 22 Level-1 domains
  INSERT INTO domains (evaluation_type_id, parent_domain_id, code, label, sort_order)
  VALUES (v_eval_type_id, v_cat_evaluation_and_drilling_id, 'ofs_l1_1', '1.0 Manage Geological & Geophysical Surveys', 1)
  RETURNING id INTO v_l1_1_0_manage_geological_geophysical_surveys_id;

  INSERT INTO domains (evaluation_type_id, parent_domain_id, code, label, sort_order)
  VALUES (v_eval_type_id, v_cat_evaluation_and_drilling_id, 'ofs_l1_2', '2.0 Prepare Sites And Infrastructure', 2)
  RETURNING id INTO v_l1_2_0_prepare_sites_and_infrastructure_id;

  INSERT INTO domains (evaluation_type_id, parent_domain_id, code, label, sort_order)
  VALUES (v_eval_type_id, v_cat_evaluation_and_drilling_id, 'ofs_l1_3', '3.0 Drill The Well', 3)
  RETURNING id INTO v_l1_3_0_drill_the_well_id;

  INSERT INTO domains (evaluation_type_id, parent_domain_id, code, label, sort_order)
  VALUES (v_eval_type_id, v_cat_completion_and_production_id, 'ofs_l1_4', '4.0 Complete The Well', 4)
  RETURNING id INTO v_l1_4_0_complete_the_well_id;

  INSERT INTO domains (evaluation_type_id, parent_domain_id, code, label, sort_order)
  VALUES (v_eval_type_id, v_cat_completion_and_production_id, 'ofs_l1_5', '5.0 Install Production Equipment And Maintain Production', 5)
  RETURNING id INTO v_l1_5_0_install_production_equipment_and_maintain_production_id;

  INSERT INTO domains (evaluation_type_id, parent_domain_id, code, label, sort_order)
  VALUES (v_eval_type_id, v_cat_completion_and_production_id, 'ofs_l1_6', '6.0 Conduct Well Interventions and Workover Activities', 6)
  RETURNING id INTO v_l1_6_0_conduct_well_interventions_and_workover_activities_id;

  INSERT INTO domains (evaluation_type_id, parent_domain_id, code, label, sort_order)
  VALUES (v_eval_type_id, v_cat_completion_and_production_id, 'ofs_l1_7', '7.0 Plug And Abandon', 7)
  RETURNING id INTO v_l1_7_0_plug_and_abandon_id;

  INSERT INTO domains (evaluation_type_id, parent_domain_id, code, label, sort_order)
  VALUES (v_eval_type_id, v_cat_management_processes_id, 'ofs_l1_8', '8.0 Develop Vision And Strategy', 8)
  RETURNING id INTO v_l1_8_0_develop_vision_and_strategy_id;

  INSERT INTO domains (evaluation_type_id, parent_domain_id, code, label, sort_order)
  VALUES (v_eval_type_id, v_cat_management_processes_id, 'ofs_l1_9', '9.0 Manage Service Portfolio', 9)
  RETURNING id INTO v_l1_9_0_manage_service_portfolio_id;

  INSERT INTO domains (evaluation_type_id, parent_domain_id, code, label, sort_order)
  VALUES (v_eval_type_id, v_cat_management_processes_id, 'ofs_l1_10', '10.0 Manage New Business Development And Intellectual Property', 10)
  RETURNING id INTO v_l1_10_0_manage_new_business_development_and_intellectual_proper_id;

  INSERT INTO domains (evaluation_type_id, parent_domain_id, code, label, sort_order)
  VALUES (v_eval_type_id, v_cat_management_processes_id, 'ofs_l1_11', '11.0 Manage Governance, Risk And Compliance', 11)
  RETURNING id INTO v_l1_11_0_manage_governance_risk_and_compliance_id;

  INSERT INTO domains (evaluation_type_id, parent_domain_id, code, label, sort_order)
  VALUES (v_eval_type_id, v_cat_management_processes_id, 'ofs_l1_12', '12.0 Manage Service Quality And Health, Safety  And Environment', 12)
  RETURNING id INTO v_l1_12_0_manage_service_quality_and_health_safety_and_environmen_id;

  INSERT INTO domains (evaluation_type_id, parent_domain_id, code, label, sort_order)
  VALUES (v_eval_type_id, v_cat_management_processes_id, 'ofs_l1_13', '13.0 Manage External Relationships', 13)
  RETURNING id INTO v_l1_13_0_manage_external_relationships_id;

  INSERT INTO domains (evaluation_type_id, parent_domain_id, code, label, sort_order)
  VALUES (v_eval_type_id, v_cat_business_support_processes_id, 'ofs_l1_14', '14.0 Manage Supply Chain', 14)
  RETURNING id INTO v_l1_14_0_manage_supply_chain_id;

  INSERT INTO domains (evaluation_type_id, parent_domain_id, code, label, sort_order)
  VALUES (v_eval_type_id, v_cat_business_support_processes_id, 'ofs_l1_15', '15.0 Manage Financial Resources', 15)
  RETURNING id INTO v_l1_15_0_manage_financial_resources_id;

  INSERT INTO domains (evaluation_type_id, parent_domain_id, code, label, sort_order)
  VALUES (v_eval_type_id, v_cat_business_support_processes_id, 'ofs_l1_16', '16.0 Develop And Manage Human Capital', 16)
  RETURNING id INTO v_l1_16_0_develop_and_manage_human_capital_id;

  INSERT INTO domains (evaluation_type_id, parent_domain_id, code, label, sort_order)
  VALUES (v_eval_type_id, v_cat_business_support_processes_id, 'ofs_l1_17', '17.0 Manage Yard And Support Facilities', 17)
  RETURNING id INTO v_l1_17_0_manage_yard_and_support_facilities_id;

  INSERT INTO domains (evaluation_type_id, parent_domain_id, code, label, sort_order)
  VALUES (v_eval_type_id, v_cat_business_support_processes_id, 'ofs_l1_18', '18.0 Manage Information Technology', 18)
  RETURNING id INTO v_l1_18_0_manage_information_technology_id;

  INSERT INTO domains (evaluation_type_id, parent_domain_id, code, label, sort_order)
  VALUES (v_eval_type_id, v_cat_business_support_processes_id, 'ofs_l1_19', '19.0 Manage Legal', 19)
  RETURNING id INTO v_l1_19_0_manage_legal_id;

  INSERT INTO domains (evaluation_type_id, parent_domain_id, code, label, sort_order)
  VALUES (v_eval_type_id, v_cat_business_support_processes_id, 'ofs_l1_20', '20.0 Develop And Manage Research And Development', 20)
  RETURNING id INTO v_l1_20_0_develop_and_manage_research_and_development_id;

  INSERT INTO domains (evaluation_type_id, parent_domain_id, code, label, sort_order)
  VALUES (v_eval_type_id, v_cat_business_support_processes_id, 'ofs_l1_21', '21.0 Manage Knowledge, Improvement And Change Structure', 21)
  RETURNING id INTO v_l1_21_0_manage_knowledge_improvement_and_change_structure_id;

  INSERT INTO domains (evaluation_type_id, parent_domain_id, code, label, sort_order)
  VALUES (v_eval_type_id, v_cat_business_support_processes_id, 'ofs_l1_22', '22.0 Manage Engineering And Pre Sales', 22)
  RETURNING id INTO v_l1_22_0_manage_engineering_and_pre_sales_id;

  -- 144 Level-2 processes
  INSERT INTO processes (domain_id, evaluation_type_id, code, label, sort_order) VALUES
    (v_l1_1_0_manage_geological_geophysical_surveys_id, v_eval_type_id, 'ofs_l2_1_1', 'Acquire & analyse seismic data', 1),
    (v_l1_1_0_manage_geological_geophysical_surveys_id, v_eval_type_id, 'ofs_l2_1_2', 'Perform reservoir studies', 2),
    (v_l1_1_0_manage_geological_geophysical_surveys_id, v_eval_type_id, 'ofs_l2_1_3', 'Planning and support management', 3),
    (v_l1_2_0_prepare_sites_and_infrastructure_id, v_eval_type_id, 'ofs_l2_2_1', 'Conduct and manage pre-drilling preparation', 1),
    (v_l1_2_0_prepare_sites_and_infrastructure_id, v_eval_type_id, 'ofs_l2_2_2', 'Design/engineer design', 2),
    (v_l1_2_0_prepare_sites_and_infrastructure_id, v_eval_type_id, 'ofs_l2_2_3', 'Design and prepare support infrastructure', 3),
    (v_l1_3_0_drill_the_well_id, v_eval_type_id, 'ofs_l2_3_1', 'Management of associated materials/ equipment', 1),
    (v_l1_3_0_drill_the_well_id, v_eval_type_id, 'ofs_l2_3_2', 'Planning and geological studies', 2),
    (v_l1_3_0_drill_the_well_id, v_eval_type_id, 'ofs_l2_3_3', 'Perform chemical treatment and analyses', 3),
    (v_l1_3_0_drill_the_well_id, v_eval_type_id, 'ofs_l2_3_4', 'Perform vertical/ directional/ horizontal drilling', 4),
    (v_l1_3_0_drill_the_well_id, v_eval_type_id, 'ofs_l2_3_5', 'Perform fishing services', 5),
    (v_l1_3_0_drill_the_well_id, v_eval_type_id, 'ofs_l2_3_6', 'Perform measurement while drilling/ logging while drilling', 6),
    (v_l1_3_0_drill_the_well_id, v_eval_type_id, 'ofs_l2_3_7', 'Perform cementing operations', 7),
    (v_l1_3_0_drill_the_well_id, v_eval_type_id, 'ofs_l2_3_8', 'Prepare drilling fluid and reserve pit', 8),
    (v_l1_3_0_drill_the_well_id, v_eval_type_id, 'ofs_l2_3_9', 'Install casings', 9),
    (v_l1_4_0_complete_the_well_id, v_eval_type_id, 'ofs_l2_4_1', 'Manage perforating', 1),
    (v_l1_4_0_complete_the_well_id, v_eval_type_id, 'ofs_l2_4_2', 'Install sand control', 2),
    (v_l1_4_0_complete_the_well_id, v_eval_type_id, 'ofs_l2_4_3', 'Install completion tools', 3),
    (v_l1_4_0_complete_the_well_id, v_eval_type_id, 'ofs_l2_4_4', 'Test well integrity', 4),
    (v_l1_4_0_complete_the_well_id, v_eval_type_id, 'ofs_l2_4_5', 'Manage oilfield water', 5),
    (v_l1_4_0_complete_the_well_id, v_eval_type_id, 'ofs_l2_4_6', 'Process and pump cement', 6),
    (v_l1_4_0_complete_the_well_id, v_eval_type_id, 'ofs_l2_4_7', 'Prepare completion fluids', 7),
    (v_l1_4_0_complete_the_well_id, v_eval_type_id, 'ofs_l2_4_8', 'Perform hydraulic fracturing', 8),
    (v_l1_4_0_complete_the_well_id, v_eval_type_id, 'ofs_l2_4_9', 'Install well head assembly', 9),
    (v_l1_4_0_complete_the_well_id, v_eval_type_id, 'ofs_l2_4_10', 'Perform acidulation', 10),
    (v_l1_5_0_install_production_equipment_and_maintain_production_id, v_eval_type_id, 'ofs_l2_5_1', 'Perform production logging', 1),
    (v_l1_5_0_install_production_equipment_and_maintain_production_id, v_eval_type_id, 'ofs_l2_5_2', 'Design pipeline engineering', 2),
    (v_l1_5_0_install_production_equipment_and_maintain_production_id, v_eval_type_id, 'ofs_l2_5_3', 'Apply artificial lift', 3),
    (v_l1_5_0_install_production_equipment_and_maintain_production_id, v_eval_type_id, 'ofs_l2_5_4', 'Monitor production chemicals', 4),
    (v_l1_5_0_install_production_equipment_and_maintain_production_id, v_eval_type_id, 'ofs_l2_5_5', 'Install pipelines', 5),
    (v_l1_5_0_install_production_equipment_and_maintain_production_id, v_eval_type_id, 'ofs_l2_5_6', 'Install production equipment', 6),
    (v_l1_5_0_install_production_equipment_and_maintain_production_id, v_eval_type_id, 'ofs_l2_5_7', 'Perform well servicing activities', 7),
    (v_l1_5_0_install_production_equipment_and_maintain_production_id, v_eval_type_id, 'ofs_l2_5_8', 'Deploy corrosion inhibition', 8),
    (v_l1_5_0_install_production_equipment_and_maintain_production_id, v_eval_type_id, 'ofs_l2_5_9', 'Shut in and stop production', 9),
    (v_l1_5_0_install_production_equipment_and_maintain_production_id, v_eval_type_id, 'ofs_l2_5_10', 'Perform compression servicing', 10),
    (v_l1_5_0_install_production_equipment_and_maintain_production_id, v_eval_type_id, 'ofs_l2_5_11', 'Monitor pipelines', 11),
    (v_l1_6_0_conduct_well_interventions_and_workover_activities_id, v_eval_type_id, 'ofs_l2_6_1', 'Perform re-hydraulic fracturing', 1),
    (v_l1_6_0_conduct_well_interventions_and_workover_activities_id, v_eval_type_id, 'ofs_l2_6_2', 'Perform re-acidulation', 2),
    (v_l1_6_0_conduct_well_interventions_and_workover_activities_id, v_eval_type_id, 'ofs_l2_6_3', 'Perform coiled tubing services', 3),
    (v_l1_6_0_conduct_well_interventions_and_workover_activities_id, v_eval_type_id, 'ofs_l2_6_4', 'Manage workover rig', 4),
    (v_l1_6_0_conduct_well_interventions_and_workover_activities_id, v_eval_type_id, 'ofs_l2_6_5', 'Perform re-completions operations', 5),
    (v_l1_6_0_conduct_well_interventions_and_workover_activities_id, v_eval_type_id, 'ofs_l2_6_6', 'Perform tubing reclamation', 6),
    (v_l1_7_0_plug_and_abandon_id, v_eval_type_id, 'ofs_l2_7_1', 'Evaluate business case for plug and abandon', 1),
    (v_l1_7_0_plug_and_abandon_id, v_eval_type_id, 'ofs_l2_7_2', 'Install plug', 2),
    (v_l1_7_0_plug_and_abandon_id, v_eval_type_id, 'ofs_l2_7_3', 'Complete closeout and remediation', 3),
    (v_l1_7_0_plug_and_abandon_id, v_eval_type_id, 'ofs_l2_7_4', 'Remove production support materials', 4),
    (v_l1_7_0_plug_and_abandon_id, v_eval_type_id, 'ofs_l2_7_5', 'Conduct well intervention and remove completion equipment', 5),
    (v_l1_8_0_develop_vision_and_strategy_id, v_eval_type_id, 'ofs_l2_8_1', 'Develop corporate vision and strategy', 1),
    (v_l1_8_0_develop_vision_and_strategy_id, v_eval_type_id, 'ofs_l2_8_2', 'Define the business concept and long-term vision', 2),
    (v_l1_8_0_develop_vision_and_strategy_id, v_eval_type_id, 'ofs_l2_8_3', 'Develop business strategy', 3),
    (v_l1_8_0_develop_vision_and_strategy_id, v_eval_type_id, 'ofs_l2_8_4', 'Manage strategic initiatives', 4),
    (v_l1_8_0_develop_vision_and_strategy_id, v_eval_type_id, 'ofs_l2_8_5', 'Develop business plan/policies', 5),
    (v_l1_8_0_develop_vision_and_strategy_id, v_eval_type_id, 'ofs_l2_8_6', 'Develop marketing and sales strategy', 6),
    (v_l1_9_0_manage_service_portfolio_id, v_eval_type_id, 'ofs_l2_9_1', 'Develop financial objectives', 1),
    (v_l1_9_0_manage_service_portfolio_id, v_eval_type_id, 'ofs_l2_9_2', 'Manage  reserve/resource asset development', 2),
    (v_l1_9_0_manage_service_portfolio_id, v_eval_type_id, 'ofs_l2_9_3', 'Identify & develop value proposition', 3),
    (v_l1_9_0_manage_service_portfolio_id, v_eval_type_id, 'ofs_l2_9_4', 'Determine service portfolio targets to meet financial objectives', 4),
    (v_l1_9_0_manage_service_portfolio_id, v_eval_type_id, 'ofs_l2_9_5', 'Manage service portfolio', 5),
    (v_l1_9_0_manage_service_portfolio_id, v_eval_type_id, 'ofs_l2_9_6', 'Evaluate service portfolio performance', 6),
    (v_l1_9_0_manage_service_portfolio_id, v_eval_type_id, 'ofs_l2_9_7', 'Determine reserve/resource and prospect portfolio targets', 7),
    (v_l1_9_0_manage_service_portfolio_id, v_eval_type_id, 'ofs_l2_9_8', 'Develop services', 8),
    (v_l1_9_0_manage_service_portfolio_id, v_eval_type_id, 'ofs_l2_9_9', 'Evaluate reserve/resource and prospect portfolio performance', 9),
    (v_l1_9_0_manage_service_portfolio_id, v_eval_type_id, 'ofs_l2_9_10', 'Determine reserve/resource  and prospect asset portfolio strategies', 10),
    (v_l1_9_0_manage_service_portfolio_id, v_eval_type_id, 'ofs_l2_9_11', 'Select service development strategy', 11),
    (v_l1_10_0_manage_new_business_development_and_intellectual_proper_id, v_eval_type_id, 'ofs_l2_10_1', 'Establish marketing strategy', 1),
    (v_l1_10_0_manage_new_business_development_and_intellectual_proper_id, v_eval_type_id, 'ofs_l2_10_2', 'Execute marketing strategy', 2),
    (v_l1_10_0_manage_new_business_development_and_intellectual_proper_id, v_eval_type_id, 'ofs_l2_10_3', 'Negotiate contracts', 3),
    (v_l1_10_0_manage_new_business_development_and_intellectual_proper_id, v_eval_type_id, 'ofs_l2_10_4', 'Complete sale', 4),
    (v_l1_10_0_manage_new_business_development_and_intellectual_proper_id, v_eval_type_id, 'ofs_l2_10_5', 'Identify opportunities', 5),
    (v_l1_10_0_manage_new_business_development_and_intellectual_proper_id, v_eval_type_id, 'ofs_l2_10_6', 'Deliver proposal', 6),
    (v_l1_11_0_manage_governance_risk_and_compliance_id, v_eval_type_id, 'ofs_l2_11_1', 'Manage corporate governance', 1),
    (v_l1_11_0_manage_governance_risk_and_compliance_id, v_eval_type_id, 'ofs_l2_11_2', 'Manage internal audit', 2),
    (v_l1_11_0_manage_governance_risk_and_compliance_id, v_eval_type_id, 'ofs_l2_11_3', 'Develop and manage business resiliency and continuity', 3),
    (v_l1_11_0_manage_governance_risk_and_compliance_id, v_eval_type_id, 'ofs_l2_11_4', 'Manage internal controls', 4),
    (v_l1_11_0_manage_governance_risk_and_compliance_id, v_eval_type_id, 'ofs_l2_11_5', 'Manage regulatory compliance', 5),
    (v_l1_11_0_manage_governance_risk_and_compliance_id, v_eval_type_id, 'ofs_l2_11_6', 'Manage cyber security', 6),
    (v_l1_11_0_manage_governance_risk_and_compliance_id, v_eval_type_id, 'ofs_l2_11_7', 'Develop and manage enterprise risks/risk framework', 7),
    (v_l1_12_0_manage_service_quality_and_health_safety_and_environmen_id, v_eval_type_id, 'ofs_l2_12_1', 'Develop HSE policies and procedures', 1),
    (v_l1_12_0_manage_service_quality_and_health_safety_and_environmen_id, v_eval_type_id, 'ofs_l2_12_2', 'Develop and administer service quality program', 2),
    (v_l1_12_0_manage_service_quality_and_health_safety_and_environmen_id, v_eval_type_id, 'ofs_l2_12_3', 'Manage HSE risks, impactsand mitigations', 3),
    (v_l1_12_0_manage_service_quality_and_health_safety_and_environmen_id, v_eval_type_id, 'ofs_l2_12_4', 'Monitor HSE performance and compliance', 4),
    (v_l1_12_0_manage_service_quality_and_health_safety_and_environmen_id, v_eval_type_id, 'ofs_l2_12_5', 'Develop and deliver HSE program', 5),
    (v_l1_12_0_manage_service_quality_and_health_safety_and_environmen_id, v_eval_type_id, 'ofs_l2_12_6', 'Deliver HSE education and training', 6),
    (v_l1_13_0_manage_external_relationships_id, v_eval_type_id, 'ofs_l2_13_1', 'Build and manage investor relationships', 1),
    (v_l1_13_0_manage_external_relationships_id, v_eval_type_id, 'ofs_l2_13_2', 'Manage public relations program', 2),
    (v_l1_13_0_manage_external_relationships_id, v_eval_type_id, 'ofs_l2_13_3', 'Manage government industry and regulatory relationships', 3),
    (v_l1_13_0_manage_external_relationships_id, v_eval_type_id, 'ofs_l2_13_4', 'Manage local communities and social obligations', 4),
    (v_l1_13_0_manage_external_relationships_id, v_eval_type_id, 'ofs_l2_13_5', 'Manage project and JV partner relationships', 5),
    (v_l1_13_0_manage_external_relationships_id, v_eval_type_id, 'ofs_l2_13_6', 'Manage relationships with board of directors', 6),
    (v_l1_14_0_manage_supply_chain_id, v_eval_type_id, 'ofs_l2_14_1', 'Plan', 1),
    (v_l1_14_0_manage_supply_chain_id, v_eval_type_id, 'ofs_l2_14_2', 'Manage inventory and warehouse', 2),
    (v_l1_14_0_manage_supply_chain_id, v_eval_type_id, 'ofs_l2_14_3', 'Source', 3),
    (v_l1_14_0_manage_supply_chain_id, v_eval_type_id, 'ofs_l2_14_4', 'Manage supplier contracts', 4),
    (v_l1_14_0_manage_supply_chain_id, v_eval_type_id, 'ofs_l2_14_5', 'Purchase', 5),
    (v_l1_14_0_manage_supply_chain_id, v_eval_type_id, 'ofs_l2_14_6', 'Manage supplier relationships', 6),
    (v_l1_14_0_manage_supply_chain_id, v_eval_type_id, 'ofs_l2_14_7', 'Manage logistics', 7),
    (v_l1_15_0_manage_financial_resources_id, v_eval_type_id, 'ofs_l2_15_1', 'Perform planning', 1),
    (v_l1_15_0_manage_financial_resources_id, v_eval_type_id, 'ofs_l2_15_2', 'Perform asset accounting', 2),
    (v_l1_15_0_manage_financial_resources_id, v_eval_type_id, 'ofs_l2_15_3', 'Perform accounts receivable', 3),
    (v_l1_15_0_manage_financial_resources_id, v_eval_type_id, 'ofs_l2_15_4', 'Perform accounts payable and expense reimbursements', 4),
    (v_l1_15_0_manage_financial_resources_id, v_eval_type_id, 'ofs_l2_15_5', 'Perform AFE/project accounting', 5),
    (v_l1_15_0_manage_financial_resources_id, v_eval_type_id, 'ofs_l2_15_6', 'Perform general accounting', 6),
    (v_l1_15_0_manage_financial_resources_id, v_eval_type_id, 'ofs_l2_15_7', 'Manage taxes', 7),
    (v_l1_15_0_manage_financial_resources_id, v_eval_type_id, 'ofs_l2_15_8', 'Manage treasury operations', 8),
    (v_l1_15_0_manage_financial_resources_id, v_eval_type_id, 'ofs_l2_15_9', 'Perform financial reporting', 9),
    (v_l1_15_0_manage_financial_resources_id, v_eval_type_id, 'ofs_l2_15_10', 'Perform revenue accounting', 10),
    (v_l1_15_0_manage_financial_resources_id, v_eval_type_id, 'ofs_l2_15_11', 'Manage US - tax/regulatory', 11),
    (v_l1_16_0_develop_and_manage_human_capital_id, v_eval_type_id, 'ofs_l2_16_1', 'Develop and manage HR planning, policies, and strategies', 1),
    (v_l1_16_0_develop_and_manage_human_capital_id, v_eval_type_id, 'ofs_l2_16_2', 'Re-deploy and retire employees', 2),
    (v_l1_16_0_develop_and_manage_human_capital_id, v_eval_type_id, 'ofs_l2_16_3', 'Manage employee information', 3),
    (v_l1_16_0_develop_and_manage_human_capital_id, v_eval_type_id, 'ofs_l2_16_4', 'Recruit, source, and select employees', 4),
    (v_l1_16_0_develop_and_manage_human_capital_id, v_eval_type_id, 'ofs_l2_16_5', 'Develop and counsel employees', 5),
    (v_l1_16_0_develop_and_manage_human_capital_id, v_eval_type_id, 'ofs_l2_16_6', 'Reward and retain employees', 6),
    (v_l1_17_0_manage_yard_and_support_facilities_id, v_eval_type_id, 'ofs_l2_17_1', 'Determine facility plan', 1),
    (v_l1_17_0_manage_yard_and_support_facilities_id, v_eval_type_id, 'ofs_l2_17_2', 'Managing facility purchase and disposal', 2),
    (v_l1_17_0_manage_yard_and_support_facilities_id, v_eval_type_id, 'ofs_l2_17_3', 'Maintain facilities', 3),
    (v_l1_17_0_manage_yard_and_support_facilities_id, v_eval_type_id, 'ofs_l2_17_4', 'Manage asset allocation and facilities', 4),
    (v_l1_18_0_manage_information_technology_id, v_eval_type_id, 'ofs_l2_18_1', 'Manage solutions and services', 1),
    (v_l1_18_0_manage_information_technology_id, v_eval_type_id, 'ofs_l2_18_2', 'Manage sourcing and vendors', 2),
    (v_l1_18_0_manage_information_technology_id, v_eval_type_id, 'ofs_l2_18_3', 'Manage programs and projects', 3),
    (v_l1_18_0_manage_information_technology_id, v_eval_type_id, 'ofs_l2_18_4', 'Conduct portfolio management', 4),
    (v_l1_18_0_manage_information_technology_id, v_eval_type_id, 'ofs_l2_18_5', 'Manage information security', 5),
    (v_l1_19_0_manage_legal_id, v_eval_type_id, 'ofs_l2_19_1', 'Resolve commercial disputes and litigations', 1),
    (v_l1_19_0_manage_legal_id, v_eval_type_id, 'ofs_l2_19_2', 'Manage external counsel', 2),
    (v_l1_19_0_manage_legal_id, v_eval_type_id, 'ofs_l2_19_3', 'Manage legal entities', 3),
    (v_l1_19_0_manage_legal_id, v_eval_type_id, 'ofs_l2_19_4', 'Protect intellectual property and brands', 4),
    (v_l1_19_0_manage_legal_id, v_eval_type_id, 'ofs_l2_19_5', 'Support contract negotiations', 5),
    (v_l1_20_0_develop_and_manage_research_and_development_id, v_eval_type_id, 'ofs_l2_20_1', 'Define technology requirements', 1),
    (v_l1_20_0_develop_and_manage_research_and_development_id, v_eval_type_id, 'ofs_l2_20_2', 'Conduct technology pilots', 2),
    (v_l1_20_0_develop_and_manage_research_and_development_id, v_eval_type_id, 'ofs_l2_20_3', 'Perform market and discovery research', 3),
    (v_l1_20_0_develop_and_manage_research_and_development_id, v_eval_type_id, 'ofs_l2_20_4', 'Manage technology life cycle', 4),
    (v_l1_20_0_develop_and_manage_research_and_development_id, v_eval_type_id, 'ofs_l2_20_5', 'Confirm technology alignment with strategy', 5),
    (v_l1_20_0_develop_and_manage_research_and_development_id, v_eval_type_id, 'ofs_l2_20_6', 'Provide field engineering support', 6),
    (v_l1_20_0_develop_and_manage_research_and_development_id, v_eval_type_id, 'ofs_l2_20_7', 'Manage request for technical assistance (RTA)', 7),
    (v_l1_21_0_manage_knowledge_improvement_and_change_structure_id, v_eval_type_id, 'ofs_l2_21_1', 'Develop knowledge management strategy', 1),
    (v_l1_21_0_manage_knowledge_improvement_and_change_structure_id, v_eval_type_id, 'ofs_l2_21_2', 'Manage knowledge', 2),
    (v_l1_21_0_manage_knowledge_improvement_and_change_structure_id, v_eval_type_id, 'ofs_l2_21_3', 'Identify and prioritise improvement projects', 3),
    (v_l1_21_0_manage_knowledge_improvement_and_change_structure_id, v_eval_type_id, 'ofs_l2_21_4', 'Manage business change', 4),
    (v_l1_22_0_manage_engineering_and_pre_sales_id, v_eval_type_id, 'ofs_l2_22_1', 'Sustaining', 1),
    (v_l1_22_0_manage_engineering_and_pre_sales_id, v_eval_type_id, 'ofs_l2_22_2', 'Project management', 2),
    (v_l1_22_0_manage_engineering_and_pre_sales_id, v_eval_type_id, 'ofs_l2_22_3', 'Manufacturing', 3),
    (v_l1_22_0_manage_engineering_and_pre_sales_id, v_eval_type_id, 'ofs_l2_22_4', 'Field', 4),
    (v_l1_22_0_manage_engineering_and_pre_sales_id, v_eval_type_id, 'ofs_l2_22_5', 'Research and development', 5),
    (v_l1_22_0_manage_engineering_and_pre_sales_id, v_eval_type_id, 'ofs_l2_22_6', 'Design', 6);
END $$;
