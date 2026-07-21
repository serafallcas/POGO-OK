import { useState, useEffect, useCallback } from 'react';
import { supabase } from '../../lib/supabase';
import {
  Search, AlertCircle, ChevronRight, Plus, BookOpen, ArrowRight,
  CheckCircle2, XCircle, GitMerge, Clock, Filter, Shield
} from 'lucide-react';

interface FindingV2 {
  id: string;
  title: string;
  criteria: string | null;
  condition_text: string | null;
  root_cause: string | null;
  impact_text: string | null;
  likelihood: string;
  impact_level: string;
  severity: string;
  status: string;
  finding_template_id: string | null;
  merged_into_id: string | null;
  residual_risk_accepted: boolean;
  residual_risk_justification: string | null;
  created_at: string;
  updated_at: string;
}

interface Recommendation {
  id: string;
  recommendation_code: string;
  category: string;
  title: string;
  recommendation_text: string;
  priority_default: string;
  implementation_horizon: string;
}

interface FindingRec {
  id: string;
  recommendation_id: string;
  override_text: string | null;
  is_primary: boolean;
  recommendation: Recommendation;
}

const WORKFLOW_STEPS = [
  'Potential', 'Under Review', 'Confirmed', 'Rejected', 'Merged',
  'Management Response', 'Action Plan Defined', 'Closed'
] as const;

const STATUS_CONFIG: Record<string, { color: string; icon: typeof Clock; label: string }> = {
  'Potential': { color: 'bg-amber-50 text-amber-700 border-amber-200', icon: Clock, label: 'Potential' },
  'Under Review': { color: 'bg-blue-50 text-blue-700 border-blue-200', icon: Search, label: 'Under Review' },
  'Confirmed': { color: 'bg-red-50 text-red-700 border-red-200', icon: AlertCircle, label: 'Confirmed' },
  'Rejected': { color: 'bg-gray-50 text-gray-500 border-gray-200', icon: XCircle, label: 'Rejected' },
  'Merged': { color: 'bg-purple-50 text-purple-600 border-purple-200', icon: GitMerge, label: 'Merged' },
  'Management Response': { color: 'bg-orange-50 text-orange-700 border-orange-200', icon: ArrowRight, label: 'Mgmt Response' },
  'Action Plan Defined': { color: 'bg-teal-50 text-teal-700 border-teal-200', icon: CheckCircle2, label: 'Action Plan' },
  'Closed': { color: 'bg-green-50 text-green-700 border-green-200', icon: CheckCircle2, label: 'Closed' },
};

const SEVERITY_COLORS: Record<string, string> = {
  Critical: 'bg-red-100 text-red-700 border-red-200',
  High: 'bg-orange-100 text-orange-700 border-orange-200',
  Medium: 'bg-amber-100 text-amber-700 border-amber-200',
  Low: 'bg-blue-100 text-blue-700 border-blue-200',
};

export default function AssessmentFindings({ assessmentId }: { assessmentId: string }) {
  const [findings, setFindings] = useState<FindingV2[]>([]);
  const [findingRecs, setFindingRecs] = useState<Record<string, FindingRec[]>>({});
  const [loading, setLoading] = useState(true);
  const [expanded, setExpanded] = useState<string | null>(null);
  const [statusFilter, setStatusFilter] = useState<string>('all');
  const [showRecommendationLibrary, setShowRecommendationLibrary] = useState(false);
  const [recommendations, setRecommendations] = useState<Recommendation[]>([]);
  const [showGenerateModal, setShowGenerateModal] = useState(false);
  const [generating, setGenerating] = useState(false);

  const fetchFindings = useCallback(async () => {
    setLoading(true);
    const { data } = await supabase
      .from('assessment_findings_v2')
      .select('*')
      .eq('assessment_id', assessmentId)
      .order('created_at', { ascending: false });
    setFindings((data as FindingV2[]) || []);

    if (data && data.length > 0) {
      const findingIds = data.map((f: FindingV2) => f.id);
      const { data: recs } = await supabase
        .from('finding_recommendations')
        .select('id, finding_id, recommendation_id, override_text, is_primary, recommendation:recommendation_library(id, recommendation_code, category, title, recommendation_text, priority_default, implementation_horizon)')
        .in('finding_id', findingIds);

      const grouped: Record<string, FindingRec[]> = {};
      (recs || []).forEach((r: any) => {
        if (!grouped[r.finding_id]) grouped[r.finding_id] = [];
        grouped[r.finding_id].push({
          id: r.id,
          recommendation_id: r.recommendation_id,
          override_text: r.override_text,
          is_primary: r.is_primary,
          recommendation: r.recommendation,
        });
      });
      setFindingRecs(grouped);
    }
    setLoading(false);
  }, [assessmentId]);

  useEffect(() => { fetchFindings(); }, [fetchFindings]);

  async function fetchRecommendationLibrary() {
    const { data } = await supabase
      .from('recommendation_library')
      .select('id, recommendation_code, category, title, recommendation_text, priority_default, implementation_horizon')
      .eq('status', 'Approved')
      .order('recommendation_code');
    setRecommendations((data as Recommendation[]) || []);
    setShowRecommendationLibrary(true);
  }

  async function updateFindingStatus(findingId: string, newStatus: string) {
    await supabase
      .from('assessment_findings_v2')
      .update({ status: newStatus, updated_at: new Date().toISOString() })
      .eq('id', findingId);
    fetchFindings();
  }

  async function generatePotentialFindings() {
    setGenerating(true);
    const { data: responses } = await supabase
      .from('assessment_responses')
      .select('id, question_id, score, questions(code, target_score)')
      .eq('assessment_id', assessmentId);

    if (!responses || responses.length === 0) {
      setGenerating(false);
      setShowGenerateModal(false);
      return;
    }

    const existingTemplateCodes = findings
      .filter(f => f.finding_template_id)
      .map(f => f.finding_template_id);

    const { data: existingTemplates } = await supabase
      .from('finding_templates')
      .select('id, template_code')
      .in('id', existingTemplateCodes.filter(Boolean) as string[]);

    const usedTemplateIds = new Set((existingTemplates || []).map(t => t.id));

    let generated = 0;
    for (const resp of responses as any[]) {
      const questionCode = resp.questions?.code;
      if (!questionCode) continue;

      const score = resp.score ?? 0;
      const targetScore = resp.questions?.target_score ?? 3;
      const gap = targetScore - score;

      const shouldTrigger = score <= 2 || gap >= 2;
      if (!shouldTrigger) continue;

      const { data: mappings } = await supabase
        .from('question_finding_mappings')
        .select('finding_template_id, finding_templates(id, template_code, title, criteria, condition_template, root_cause_template, impact_template, likelihood_default, impact_default, severity_default, recommendation_id)')
        .eq('question_code', questionCode)
        .limit(1);

      if (!mappings || mappings.length === 0) continue;
      const tpl = (mappings[0] as any).finding_templates;
      if (!tpl || usedTemplateIds.has(tpl.id)) continue;

      const { data: session } = await supabase.auth.getSession();
      const userId = session?.session?.user?.id;

      await supabase.from('assessment_findings_v2').insert({
        assessment_id: assessmentId,
        finding_template_id: tpl.id,
        title: tpl.title,
        criteria: tpl.criteria,
        condition_text: tpl.condition_template,
        root_cause: tpl.root_cause_template,
        impact_text: tpl.impact_template,
        likelihood: tpl.likelihood_default,
        impact_level: tpl.impact_default,
        severity: tpl.severity_default,
        status: 'Potential',
        created_by: userId || null,
      });

      usedTemplateIds.add(tpl.id);
      generated++;
    }

    setGenerating(false);
    setShowGenerateModal(false);
    fetchFindings();
  }

  function getNextStatuses(current: string): string[] {
    switch (current) {
      case 'Potential': return ['Under Review', 'Rejected'];
      case 'Under Review': return ['Confirmed', 'Rejected', 'Merged'];
      case 'Confirmed': return ['Management Response'];
      case 'Management Response': return ['Action Plan Defined'];
      case 'Action Plan Defined': return ['Closed'];
      case 'Rejected': return [];
      case 'Merged': return [];
      case 'Closed': return [];
      default: return [];
    }
  }

  const filteredFindings = statusFilter === 'all'
    ? findings
    : findings.filter(f => f.status === statusFilter);

  const statusCounts = findings.reduce((acc, f) => {
    acc[f.status] = (acc[f.status] || 0) + 1;
    return acc;
  }, {} as Record<string, number>);

  if (loading) return <div className="flex items-center justify-center h-48"><div className="animate-spin rounded-full h-6 w-6 border-b-2 border-emerald-600" /></div>;

  return (
    <div className="p-6 max-w-6xl mx-auto space-y-5">
      {/* Header */}
      <div className="flex items-center justify-between">
        <div>
          <h2 className="text-lg font-semibold text-gray-800">Findings Register</h2>
          <p className="text-xs text-gray-500 mt-0.5">
            {findings.length} finding{findings.length !== 1 ? 's' : ''} &middot; Workflow: Potential &rarr; Under Review &rarr; Confirmed &rarr; Action Plan &rarr; Closed
          </p>
        </div>
        <div className="flex gap-2">
          <button onClick={fetchRecommendationLibrary}
            className="flex items-center gap-1.5 px-3 py-1.5 text-xs font-medium border border-gray-200 rounded-md hover:bg-gray-50 text-gray-600">
            <BookOpen className="w-3.5 h-3.5" /> Recommendations
          </button>
          <button onClick={() => setShowGenerateModal(true)}
            className="flex items-center gap-1.5 px-3 py-1.5 text-xs font-medium bg-emerald-600 text-white rounded-md hover:bg-emerald-700">
            <Plus className="w-3.5 h-3.5" /> Generate Findings
          </button>
        </div>
      </div>

      {/* Status pills */}
      <div className="flex flex-wrap gap-1.5">
        <button onClick={() => setStatusFilter('all')}
          className={`px-2.5 py-1 rounded-full text-[11px] font-medium border transition-colors ${statusFilter === 'all' ? 'bg-gray-800 text-white border-gray-800' : 'bg-white text-gray-600 border-gray-200 hover:bg-gray-50'}`}>
          All ({findings.length})
        </button>
        {WORKFLOW_STEPS.filter(s => statusCounts[s]).map(s => {
          const cfg = STATUS_CONFIG[s];
          return (
            <button key={s} onClick={() => setStatusFilter(s)}
              className={`px-2.5 py-1 rounded-full text-[11px] font-medium border transition-colors ${statusFilter === s ? 'ring-2 ring-offset-1 ring-emerald-400 ' + cfg.color : cfg.color + ' opacity-80 hover:opacity-100'}`}>
              {cfg.label} ({statusCounts[s]})
            </button>
          );
        })}
      </div>

      {/* Findings list */}
      {filteredFindings.length === 0 ? (
        <div className="bg-white rounded-lg border p-10 text-center">
          <Shield className="w-10 h-10 mx-auto text-gray-300 mb-3" />
          <p className="text-gray-500 text-sm">
            {findings.length === 0
              ? 'No findings yet. Use "Generate Findings" to auto-detect potential findings from scored responses.'
              : 'No findings match this filter.'}
          </p>
        </div>
      ) : (
        <div className="space-y-2">
          {filteredFindings.map((f) => {
            const cfg = STATUS_CONFIG[f.status] || STATUS_CONFIG['Potential'];
            const StatusIcon = cfg.icon;
            const recs = findingRecs[f.id] || [];
            const nextStatuses = getNextStatuses(f.status);

            return (
              <div key={f.id} className="bg-white rounded-lg border overflow-hidden">
                <button onClick={() => setExpanded(expanded === f.id ? null : f.id)}
                  className="w-full px-4 py-3 flex items-center gap-3 text-left hover:bg-gray-50">
                  <StatusIcon className="w-4 h-4 text-gray-400 flex-shrink-0" />
                  <span className={`inline-flex px-2 py-0.5 rounded text-[10px] font-bold border ${SEVERITY_COLORS[f.severity] || SEVERITY_COLORS.Medium}`}>
                    {f.severity}
                  </span>
                  <span className="text-sm font-medium text-gray-800 flex-1 truncate">{f.title}</span>
                  <span className={`inline-flex items-center px-2 py-0.5 rounded text-[10px] font-medium border ${cfg.color}`}>
                    {cfg.label}
                  </span>
                  <ChevronRight className={`w-4 h-4 text-gray-400 transition-transform ${expanded === f.id ? 'rotate-90' : ''}`} />
                </button>

                {expanded === f.id && (
                  <div className="px-4 pb-4 pt-2 border-t space-y-3 text-sm">
                    {/* Finding details */}
                    <div className="grid grid-cols-1 md:grid-cols-2 gap-3">
                      {f.criteria && (
                        <div className="bg-gray-50 rounded p-2.5">
                          <span className="font-medium text-gray-500 text-xs block mb-0.5">Criteria</span>
                          <span className="text-gray-700 text-xs">{f.criteria}</span>
                        </div>
                      )}
                      {f.condition_text && (
                        <div className="bg-gray-50 rounded p-2.5">
                          <span className="font-medium text-gray-500 text-xs block mb-0.5">Condition</span>
                          <span className="text-gray-700 text-xs">{f.condition_text}</span>
                        </div>
                      )}
                      {f.root_cause && (
                        <div className="bg-gray-50 rounded p-2.5">
                          <span className="font-medium text-gray-500 text-xs block mb-0.5">Root Cause</span>
                          <span className="text-gray-700 text-xs">{f.root_cause}</span>
                        </div>
                      )}
                      {f.impact_text && (
                        <div className="bg-gray-50 rounded p-2.5">
                          <span className="font-medium text-gray-500 text-xs block mb-0.5">Impact</span>
                          <span className="text-gray-700 text-xs">{f.impact_text}</span>
                        </div>
                      )}
                    </div>

                    {/* Risk assessment row */}
                    <div className="flex gap-4 text-xs">
                      <span className="text-gray-500">Likelihood: <span className="font-medium text-gray-700">{f.likelihood}</span></span>
                      <span className="text-gray-500">Impact: <span className="font-medium text-gray-700">{f.impact_level}</span></span>
                      <span className="text-gray-500">Severity: <span className="font-medium text-gray-700">{f.severity}</span></span>
                    </div>

                    {/* Recommendations */}
                    {recs.length > 0 && (
                      <div className="border-t pt-2">
                        <span className="text-xs font-medium text-gray-500 block mb-1.5">Recommendations</span>
                        {recs.map(r => (
                          <div key={r.id} className="bg-emerald-50 border border-emerald-100 rounded p-2.5 mb-1.5">
                            <div className="flex items-center gap-2 mb-1">
                              <span className="text-[10px] font-bold text-emerald-700 bg-emerald-100 px-1.5 py-0.5 rounded">{r.recommendation.recommendation_code}</span>
                              <span className="text-xs font-medium text-emerald-800">{r.recommendation.title}</span>
                              {r.is_primary && <span className="text-[9px] bg-emerald-200 text-emerald-700 px-1 rounded">Primary</span>}
                            </div>
                            <p className="text-xs text-gray-700">{r.override_text || r.recommendation.recommendation_text}</p>
                            <div className="flex gap-3 mt-1 text-[10px] text-gray-500">
                              <span>Priority: {r.recommendation.priority_default}</span>
                              <span>Horizon: {r.recommendation.implementation_horizon}</span>
                            </div>
                          </div>
                        ))}
                      </div>
                    )}

                    {/* Residual risk */}
                    {f.residual_risk_accepted && (
                      <div className="bg-amber-50 border border-amber-200 rounded p-2.5 text-xs">
                        <span className="font-medium text-amber-700">Residual risk accepted</span>
                        {f.residual_risk_justification && <p className="text-gray-600 mt-0.5">{f.residual_risk_justification}</p>}
                      </div>
                    )}

                    {/* Workflow actions */}
                    {nextStatuses.length > 0 && (
                      <div className="border-t pt-2 flex items-center gap-2">
                        <span className="text-xs text-gray-500">Advance to:</span>
                        {nextStatuses.map(ns => (
                          <button key={ns} onClick={() => updateFindingStatus(f.id, ns)}
                            className="px-2.5 py-1 text-xs font-medium border rounded-md hover:bg-gray-50 text-gray-700">
                            {ns}
                          </button>
                        ))}
                      </div>
                    )}

                    <div className="text-[10px] text-gray-400 pt-1">
                      Created {new Date(f.created_at).toLocaleDateString()} &middot; Updated {new Date(f.updated_at).toLocaleDateString()}
                    </div>
                  </div>
                )}
              </div>
            );
          })}
        </div>
      )}

      {/* Recommendation Library Modal */}
      {showRecommendationLibrary && (
        <div className="fixed inset-0 bg-black/40 flex items-center justify-center z-50 p-4">
          <div className="bg-white rounded-xl shadow-2xl w-full max-w-3xl max-h-[80vh] flex flex-col">
            <div className="flex items-center justify-between px-5 py-4 border-b">
              <div>
                <h3 className="font-semibold text-gray-800">Recommendation Library</h3>
                <p className="text-xs text-gray-500 mt-0.5">{recommendations.length} reusable recommendations</p>
              </div>
              <button onClick={() => setShowRecommendationLibrary(false)} className="text-gray-400 hover:text-gray-600 text-lg">&times;</button>
            </div>
            <div className="overflow-y-auto flex-1 p-5 space-y-3">
              {recommendations.map(r => (
                <div key={r.id} className="border rounded-lg p-3 hover:border-emerald-200 transition-colors">
                  <div className="flex items-center gap-2 mb-1">
                    <span className="text-[10px] font-bold text-emerald-700 bg-emerald-50 px-1.5 py-0.5 rounded border border-emerald-200">{r.recommendation_code}</span>
                    <span className="text-xs font-medium text-gray-400">{r.category}</span>
                  </div>
                  <h4 className="text-sm font-medium text-gray-800 mb-1">{r.title}</h4>
                  <p className="text-xs text-gray-600">{r.recommendation_text}</p>
                  <div className="flex gap-3 mt-2 text-[10px] text-gray-500">
                    <span>Priority: {r.priority_default}</span>
                    <span>Horizon: {r.implementation_horizon}</span>
                  </div>
                </div>
              ))}
            </div>
          </div>
        </div>
      )}

      {/* Generate Findings Modal */}
      {showGenerateModal && (
        <div className="fixed inset-0 bg-black/40 flex items-center justify-center z-50 p-4">
          <div className="bg-white rounded-xl shadow-2xl w-full max-w-md p-6">
            <h3 className="font-semibold text-gray-800 mb-2">Generate Potential Findings</h3>
            <p className="text-sm text-gray-600 mb-4">
              This will scan all scored responses and create potential findings where:
            </p>
            <ul className="text-xs text-gray-600 space-y-1 mb-5 list-disc pl-4">
              <li>Validated score is &le; 2</li>
              <li>Gap with target is &ge; 2</li>
              <li>A matching finding template exists</li>
              <li>No duplicate finding has already been generated</li>
            </ul>
            <p className="text-xs text-amber-600 bg-amber-50 rounded p-2 mb-4">
              Generated findings start as "Potential" and require reviewer confirmation before becoming "Confirmed".
            </p>
            <div className="flex justify-end gap-2">
              <button onClick={() => setShowGenerateModal(false)} className="px-3 py-1.5 text-xs text-gray-600 border rounded-md hover:bg-gray-50">
                Cancel
              </button>
              <button onClick={generatePotentialFindings} disabled={generating}
                className="px-3 py-1.5 text-xs font-medium bg-emerald-600 text-white rounded-md hover:bg-emerald-700 disabled:opacity-50">
                {generating ? 'Generating...' : 'Generate'}
              </button>
            </div>
          </div>
        </div>
      )}
    </div>
  );
}
