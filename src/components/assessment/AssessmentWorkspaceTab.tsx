import { useState, useEffect, useCallback } from 'react';
import { supabase } from '../../lib/supabase';
import type { MaturityStatement } from '../../lib/types';
import {
  CheckCircle2, Circle, ChevronRight, ChevronDown,
  Save, AlertTriangle, BookOpen, Check, X, Flag
} from 'lucide-react';

const MATURITY_LABELS: Record<number, string> = {
  0: 'Non-Existent', 1: 'Initial', 2: 'Developing',
  3: 'Established', 4: 'Advanced', 5: 'Optimized'
};

const DECISION_TREE_NODES = [
  { key: 'practice_exists', question: 'Does the practice exist?', noMaxScore: 1 },
  { key: 'documented_approved', question: 'Is it documented and approved?', noMaxScore: 2 },
  { key: 'deployed_uniformly', question: 'Is it deployed uniformly?', noMaxScore: 2 },
  { key: 'execution_evidence', question: 'Are there execution evidence?', noMaxScore: 2 },
  { key: 'measured_kpi', question: 'Is it measured by KPIs?', noMaxScore: 3 },
  { key: 'continuous_improvement', question: 'Is continuous improvement demonstrated?', noMaxScore: 4 },
];

interface WorkspaceQuestion {
  id: string;
  question_code: string;
  question_text: string;
  instruction_text: string | null;
  evidence_examples: string | null;
  cmmi_reference: string | null;
  alert_rule_hint: string | null;
  sheet_name: string | null;
  sort_order: number;
  mapped_maturity_model_id: string | null;
  domain_id: string | null;
  process_id: string | null;
  domains?: { label: string } | null;
  processes?: { label: string } | null;
}

interface WorkspaceResponse {
  id?: string;
  question_id: string;
  score: number | null;
  compliance_status: string;
  evaluator_comment: string;
  auditee_comment: string;
  confidence_level: string;
  conclusion_text: string;
  finding_potential: boolean;
  score_cap: number | null;
  review_status: string;
}

interface DecisionAnswer {
  node_key: string;
  answer: 'yes' | 'no' | 'na' | 'partial';
  max_score_cap: number | null;
}

type SaveStatus = 'idle' | 'saving' | 'saved' | 'error';

interface Props {
  assessmentId: string;
  evaluationTypeId: string | null;
}

export default function AssessmentWorkspaceTab({ assessmentId, evaluationTypeId }: Props) {
  const [questions, setQuestions] = useState<WorkspaceQuestion[]>([]);
  const [responses, setResponses] = useState<Record<string, WorkspaceResponse>>({});
  const [activeQuestionId, setActiveQuestionId] = useState<string | null>(null);
  const [maturityStatements, setMaturityStatements] = useState<MaturityStatement[]>([]);
  const [decisionAnswers, setDecisionAnswers] = useState<Record<string, DecisionAnswer[]>>({});
  const [loading, setLoading] = useState(true);
  const [saveStatus, setSaveStatus] = useState<SaveStatus>('idle');
  const [treeCollapsed, setTreeCollapsed] = useState<Record<string, boolean>>({});
  const [filter, setFilter] = useState<'all' | 'unanswered' | 'flagged'>('all');

  useEffect(() => {
    if (evaluationTypeId) fetchData();
  }, [evaluationTypeId, assessmentId]);

  async function fetchData() {
    setLoading(true);
    const { data: qs } = await supabase
      .from('questions')
      .select('id, question_code, question_text, instruction_text, evidence_examples, cmmi_reference, alert_rule_hint, sheet_name, sort_order, mapped_maturity_model_id, domain_id, process_id, domains(label), processes(label)')
      .eq('evaluation_type_id', evaluationTypeId!)
      .eq('is_active', true)
      .order('sort_order');
    setQuestions((qs as WorkspaceQuestion[]) || []);
    if (qs && qs.length > 0) setActiveQuestionId(qs[0].id);

    const modelIds = [...new Set((qs || []).map((q: any) => q.mapped_maturity_model_id).filter(Boolean))] as string[];
    if (modelIds.length > 0) {
      const { data: stmts } = await supabase
        .from('maturity_statements').select('*').in('maturity_model_id', modelIds).eq('is_active', true);
      setMaturityStatements(stmts || []);
    }

    const { data: resps } = await supabase
      .from('assessment_responses')
      .select('id, question_id, score, compliance_status, evaluator_comment, auditee_comment, confidence_level, conclusion_text, finding_potential, score_cap, review_status')
      .eq('assessment_id', assessmentId);

    const respMap: Record<string, WorkspaceResponse> = {};
    (resps || []).forEach((r: any) => { respMap[r.question_id] = r; });
    setResponses(respMap);

    const { data: dtResps } = await supabase
      .from('decision_tree_responses').select('*')
      .in('assessment_response_id', (resps || []).map((r: any) => r.id).filter(Boolean));

    const dtMap: Record<string, DecisionAnswer[]> = {};
    (dtResps || []).forEach((dt: any) => {
      const respId = dt.assessment_response_id;
      const qId = (resps || []).find((r: any) => r.id === respId)?.question_id;
      if (qId) {
        if (!dtMap[qId]) dtMap[qId] = [];
        dtMap[qId].push({ node_key: dt.node_key, answer: dt.answer, max_score_cap: dt.max_score_cap });
      }
    });
    setDecisionAnswers(dtMap);
    setLoading(false);
  }

  const currentQuestion = questions.find(q => q.id === activeQuestionId);
  const emptyResponse: WorkspaceResponse = {
    question_id: activeQuestionId || '',
    score: null, compliance_status: '', evaluator_comment: '',
    auditee_comment: '', confidence_level: 'medium',
    conclusion_text: '', finding_potential: false, score_cap: null, review_status: 'draft',
  };
  const currentResponse: WorkspaceResponse = responses[activeQuestionId || ''] || emptyResponse;

  const computeScoreCap = (qId: string): number | null => {
    const answers = decisionAnswers[qId];
    if (!answers || answers.length === 0) return null;
    let cap: number | null = null;
    for (const node of DECISION_TREE_NODES) {
      const ans = answers.find(a => a.node_key === node.key);
      if (ans && ans.answer === 'no') {
        cap = cap === null ? node.noMaxScore : Math.min(cap, node.noMaxScore);
        break;
      }
    }
    return cap;
  };

  const updateResponse = (field: string, value: unknown) => {
    if (!activeQuestionId) return;
    setResponses(prev => ({
      ...prev,
      [activeQuestionId]: { ...currentResponse, question_id: activeQuestionId, [field]: value }
    }));
    setSaveStatus('idle');
  };

  const saveResponse = useCallback(async () => {
    if (!activeQuestionId) return;
    setSaveStatus('saving');
    const cap = computeScoreCap(activeQuestionId);
    const payload = {
      assessment_id: assessmentId,
      question_id: activeQuestionId,
      score: currentResponse.score,
      compliance_status: currentResponse.compliance_status || null,
      evaluator_comment: currentResponse.evaluator_comment || null,
      auditee_comment: currentResponse.auditee_comment || null,
      confidence_level: currentResponse.confidence_level || 'medium',
      conclusion_text: currentResponse.conclusion_text || null,
      finding_potential: currentResponse.finding_potential,
      score_cap: cap,
    };

    const { data, error } = await supabase
      .from('assessment_responses')
      .upsert(payload, { onConflict: 'assessment_id,question_id' })
      .select('id')
      .maybeSingle();

    if (error) {
      setSaveStatus('error');
    } else {
      if (data) {
        setResponses(prev => ({ ...prev, [activeQuestionId]: { ...prev[activeQuestionId], id: data.id } }));
      }
      setSaveStatus('saved');
      setTimeout(() => setSaveStatus(s => s === 'saved' ? 'idle' : s), 2000);
    }
  }, [activeQuestionId, currentResponse, assessmentId, decisionAnswers]);

  const handleDecisionAnswer = async (nodeKey: string, answer: 'yes' | 'no') => {
    if (!activeQuestionId || !currentResponse.id) return;
    const node = DECISION_TREE_NODES.find(n => n.key === nodeKey);
    const cap = answer === 'no' ? (node?.noMaxScore ?? null) : null;

    await supabase.from('decision_tree_responses').upsert(
      { assessment_response_id: currentResponse.id, node_key: nodeKey, answer, max_score_cap: cap },
      { onConflict: 'assessment_response_id,node_key' }
    );

    setDecisionAnswers(prev => {
      const existing = prev[activeQuestionId] || [];
      const filtered = existing.filter(a => a.node_key !== nodeKey);
      return { ...prev, [activeQuestionId]: [...filtered, { node_key: nodeKey, answer, max_score_cap: cap }] };
    });
  };

  const domainGroups = questions.reduce<Record<string, WorkspaceQuestion[]>>((acc, q) => {
    const key = q.domains?.label || q.sheet_name || 'General';
    if (!acc[key]) acc[key] = [];
    acc[key].push(q);
    return acc;
  }, {});

  const filteredQuestions = questions.filter(q => {
    if (filter === 'unanswered') return !responses[q.id] || responses[q.id]?.score === null;
    if (filter === 'flagged') return responses[q.id]?.finding_potential;
    return true;
  });

  const matchedStatements = currentQuestion?.mapped_maturity_model_id
    ? maturityStatements.filter(s => s.maturity_model_id === currentQuestion.mapped_maturity_model_id)
    : [];

  const getMaturityText = (stmt: MaturityStatement, level: number): string | null => {
    switch (level) {
      case 1: return stmt.level_1_basic;
      case 2: return stmt.level_2_developing;
      case 3: return stmt.level_3_established;
      case 4: return stmt.level_4_advanced;
      case 5: return stmt.level_5_leading;
      default: return null;
    }
  };

  const scoreCap = activeQuestionId ? computeScoreCap(activeQuestionId) : null;

  if (loading) {
    return <div className="flex items-center justify-center h-64"><div className="animate-spin rounded-full h-8 w-8 border-b-2 border-emerald-600" /></div>;
  }

  return (
    <div className="flex h-[calc(100vh-12rem)] overflow-hidden">
      {/* LEFT - Question Tree */}
      <aside className="w-72 bg-slate-900 text-slate-200 overflow-y-auto flex-shrink-0">
        <div className="p-3 border-b border-slate-700/50 space-y-2">
          <select value={filter} onChange={e => setFilter(e.target.value as any)}
            className="w-full text-xs bg-slate-800 text-slate-200 border border-slate-700 rounded px-2 py-1.5">
            <option value="all">All Questions ({questions.length})</option>
            <option value="unanswered">Unanswered ({questions.filter(q => !responses[q.id] || responses[q.id]?.score === null).length})</option>
            <option value="flagged">Flagged ({questions.filter(q => responses[q.id]?.finding_potential).length})</option>
          </select>
        </div>
        <div className="p-2">
          {Object.entries(domainGroups).map(([domain, qs]) => {
            const collapsed = treeCollapsed[domain];
            const domainQs = filter === 'all' ? qs : qs.filter(q => filteredQuestions.includes(q));
            if (domainQs.length === 0) return null;
            return (
              <div key={domain} className="mb-2">
                <button onClick={() => setTreeCollapsed(prev => ({ ...prev, [domain]: !prev[domain] }))}
                  className="w-full flex items-center gap-1.5 px-2 py-1.5 text-xs font-semibold uppercase tracking-wider text-slate-400 hover:text-white">
                  {collapsed ? <ChevronRight className="w-3 h-3" /> : <ChevronDown className="w-3 h-3" />}
                  <span className="truncate">{domain}</span>
                  <span className="ml-auto text-[10px] text-slate-500">{domainQs.length}</span>
                </button>
                {!collapsed && domainQs.map((q) => {
                  const isActive = q.id === activeQuestionId;
                  const resp = responses[q.id];
                  const isAnswered = resp?.score !== null && resp?.score !== undefined;
                  const isFlagged = resp?.finding_potential;
                  return (
                    <button key={q.id} onClick={() => setActiveQuestionId(q.id)}
                      className={`w-full flex items-center gap-2 px-3 py-1.5 rounded text-left text-xs transition ${
                        isActive ? 'bg-emerald-600/20 text-emerald-300 border border-emerald-500/30' : 'hover:bg-slate-800 text-slate-300'
                      }`}>
                      {isAnswered ? <CheckCircle2 className="w-3.5 h-3.5 text-emerald-400 flex-shrink-0" /> : <Circle className="w-3.5 h-3.5 text-slate-600 flex-shrink-0" />}
                      <span className="truncate flex-1">{q.question_code}</span>
                      {isFlagged && <Flag className="w-3 h-3 text-amber-400 flex-shrink-0" />}
                    </button>
                  );
                })}
              </div>
            );
          })}
        </div>
      </aside>

      {/* CENTER - Response Form */}
      <main className="flex-1 overflow-y-auto bg-white p-6">
        {currentQuestion ? (
          <div className="max-w-2xl mx-auto space-y-5">
            {/* Question */}
            <div className="bg-blue-50 border border-blue-200 rounded-lg p-4">
              <p className="text-sm font-medium text-gray-800">{currentQuestion.question_text}</p>
              <p className="text-xs text-gray-500 mt-1 font-mono">{currentQuestion.question_code}</p>
            </div>

            {/* Decision Tree */}
            <div className="bg-slate-50 border rounded-lg p-4 space-y-2">
              <h4 className="text-xs font-bold text-slate-600 uppercase">Decision Tree</h4>
              {DECISION_TREE_NODES.map((node, idx) => {
                const answers = decisionAnswers[activeQuestionId || ''] || [];
                const existing = answers.find(a => a.node_key === node.key);
                const prevNodes = DECISION_TREE_NODES.slice(0, idx);
                const blocked = prevNodes.some(pn => {
                  const pAns = answers.find(a => a.node_key === pn.key);
                  return pAns?.answer === 'no';
                });
                if (blocked) return null;
                return (
                  <div key={node.key} className="flex items-center gap-3 py-1">
                    <span className="text-xs text-gray-600 flex-1">{node.question}</span>
                    <div className="flex gap-1">
                      <button onClick={() => handleDecisionAnswer(node.key, 'yes')}
                        className={`px-2 py-0.5 text-xs rounded font-medium transition ${existing?.answer === 'yes' ? 'bg-emerald-100 text-emerald-700 ring-1 ring-emerald-300' : 'bg-gray-100 text-gray-500 hover:bg-emerald-50'}`}>
                        Yes
                      </button>
                      <button onClick={() => handleDecisionAnswer(node.key, 'no')}
                        className={`px-2 py-0.5 text-xs rounded font-medium transition ${existing?.answer === 'no' ? 'bg-red-100 text-red-700 ring-1 ring-red-300' : 'bg-gray-100 text-gray-500 hover:bg-red-50'}`}>
                        No
                      </button>
                    </div>
                    {existing?.answer === 'no' && (
                      <span className="text-[10px] text-red-500 font-medium">Cap: {node.noMaxScore}</span>
                    )}
                  </div>
                );
              })}
              {scoreCap !== null && (
                <div className="mt-2 px-3 py-2 bg-amber-50 border border-amber-200 rounded text-xs text-amber-700 font-medium">
                  Score capped at {scoreCap} based on decision tree answers
                </div>
              )}
            </div>

            {/* Score */}
            <div>
              <label className="block text-xs font-medium text-gray-700 mb-2">Score (0-5)</label>
              <div className="flex gap-1.5 flex-wrap">
                {[0, 1, 2, 3, 4, 5].map(n => {
                  const isCapped = scoreCap !== null && n > scoreCap;
                  return (
                    <button key={n} onClick={() => !isCapped && updateResponse('score', n)}
                      disabled={isCapped}
                      className={`px-3 py-2 rounded-lg border text-xs font-medium transition ${
                        currentResponse.score === n ? 'bg-emerald-600 text-white border-emerald-600' :
                        isCapped ? 'bg-gray-100 text-gray-300 border-gray-200 cursor-not-allowed' :
                        'bg-white border-gray-300 hover:border-emerald-400'
                      }`}>
                      {n} - {MATURITY_LABELS[n]}
                    </button>
                  );
                })}
              </div>
            </div>

            {/* Compliance */}
            <div>
              <label className="block text-xs font-medium text-gray-700 mb-1">Compliance</label>
              <select value={currentResponse.compliance_status} onChange={e => updateResponse('compliance_status', e.target.value)}
                className="w-full border border-gray-300 rounded-lg px-3 py-2 text-sm">
                <option value="">Select...</option>
                <option value="compliant">Compliant</option>
                <option value="partially_compliant">Partially Compliant</option>
                <option value="non_compliant">Non-Compliant</option>
                <option value="not_applicable">N/A</option>
              </select>
            </div>

            {/* Conclusion */}
            <div>
              <label className="block text-xs font-medium text-gray-700 mb-1">Conclusion</label>
              <textarea value={currentResponse.conclusion_text} onChange={e => updateResponse('conclusion_text', e.target.value)}
                onBlur={saveResponse} rows={3}
                className="w-full border border-gray-300 rounded-lg px-3 py-2 text-sm" placeholder="Structured conclusion..." />
            </div>

            {/* Comments */}
            <div className="grid grid-cols-2 gap-4">
              <div>
                <label className="block text-xs font-medium text-gray-700 mb-1">Evaluator Comment</label>
                <textarea value={currentResponse.evaluator_comment} onChange={e => updateResponse('evaluator_comment', e.target.value)}
                  onBlur={saveResponse} rows={2} className="w-full border border-gray-300 rounded-lg px-3 py-2 text-sm" />
              </div>
              <div>
                <label className="block text-xs font-medium text-gray-700 mb-1">Auditee Comment</label>
                <textarea value={currentResponse.auditee_comment} onChange={e => updateResponse('auditee_comment', e.target.value)}
                  onBlur={saveResponse} rows={2} className="w-full border border-gray-300 rounded-lg px-3 py-2 text-sm" />
              </div>
            </div>

            {/* Confidence + Finding flag */}
            <div className="flex items-center gap-6">
              <div>
                <label className="block text-xs font-medium text-gray-700 mb-1">Confidence</label>
                <div className="flex gap-2">
                  {['low', 'medium', 'high'].map(l => (
                    <label key={l} className="flex items-center gap-1 text-xs cursor-pointer capitalize">
                      <input type="radio" name="confidence" checked={currentResponse.confidence_level === l}
                        onChange={() => updateResponse('confidence_level', l)} className="text-emerald-600" />
                      {l}
                    </label>
                  ))}
                </div>
              </div>
              <div className="pt-4">
                <label className="flex items-center gap-2 text-xs cursor-pointer">
                  <input type="checkbox" checked={currentResponse.finding_potential}
                    onChange={e => updateResponse('finding_potential', e.target.checked)}
                    className="rounded text-amber-600" />
                  <Flag className="w-3.5 h-3.5 text-amber-500" />
                  Flag as potential finding
                </label>
              </div>
            </div>

            {/* Save */}
            <div className="flex items-center gap-3">
              <button onClick={saveResponse} disabled={saveStatus === 'saving'}
                className="flex items-center gap-2 px-5 py-2 bg-emerald-600 text-white rounded-lg text-sm font-medium hover:bg-emerald-700 disabled:opacity-50">
                <Save className="w-4 h-4" />{saveStatus === 'saving' ? 'Saving...' : 'Save'}
              </button>
              {saveStatus === 'saved' && <span className="text-xs text-emerald-600 flex items-center gap-1"><Check className="w-3.5 h-3.5" /> Saved</span>}
              {saveStatus === 'error' && <span className="text-xs text-red-600 flex items-center gap-1"><X className="w-3.5 h-3.5" /> Error</span>}
            </div>
          </div>
        ) : (
          <div className="text-center py-16 text-gray-400">Select a question from the left panel</div>
        )}
      </main>

      {/* RIGHT - Guidance */}
      <aside className="w-80 bg-gray-50 border-l overflow-y-auto flex-shrink-0 p-4 space-y-4">
        <h2 className="text-xs font-bold text-gray-600 uppercase tracking-wider flex items-center gap-1.5">
          <BookOpen className="w-4 h-4" /> Expert Guidance
        </h2>

        {currentQuestion?.instruction_text && (
          <div className="bg-white rounded-lg border p-3">
            <h3 className="text-[10px] font-bold text-gray-500 uppercase mb-1">Instructions</h3>
            <p className="text-xs text-gray-700 whitespace-pre-line leading-relaxed">{currentQuestion.instruction_text}</p>
          </div>
        )}

        {currentQuestion?.evidence_examples && (
          <div className="bg-white rounded-lg border p-3">
            <h3 className="text-[10px] font-bold text-gray-500 uppercase mb-1">Expected Evidence</h3>
            <p className="text-xs text-gray-700 whitespace-pre-line leading-relaxed">{currentQuestion.evidence_examples}</p>
          </div>
        )}

        {matchedStatements.length > 0 && (
          <div className="bg-emerald-50 border border-emerald-200 rounded-lg p-3 space-y-2">
            <h3 className="text-[10px] font-bold text-emerald-700 uppercase">Scoring Criteria (Maturity Levels)</h3>
            {[1, 2, 3, 4, 5].map(level => {
              const texts = matchedStatements.map(s => getMaturityText(s, level)).filter(Boolean);
              if (texts.length === 0) return null;
              const isCurrentLevel = currentResponse.score === level;
              return (
                <div key={level} className={`px-2 py-1.5 rounded ${isCurrentLevel ? 'bg-emerald-100 ring-1 ring-emerald-300' : ''}`}>
                  <p className="text-[10px] font-bold text-emerald-600">{level} - {MATURITY_LABELS[level]}</p>
                  {texts.map((t, i) => <p key={i} className="text-xs text-emerald-800 mt-0.5">{t}</p>)}
                </div>
              );
            })}
          </div>
        )}

        {currentQuestion?.cmmi_reference && (
          <div className="bg-white rounded-lg border p-3">
            <h3 className="text-[10px] font-bold text-gray-500 uppercase mb-1">CMMI Reference</h3>
            <p className="text-xs text-gray-600 font-mono">{currentQuestion.cmmi_reference}</p>
          </div>
        )}

        {currentQuestion?.alert_rule_hint && (
          <div className="bg-amber-50 border border-amber-200 rounded-lg p-3">
            <h3 className="text-[10px] font-bold text-amber-700 uppercase mb-1 flex items-center gap-1">
              <AlertTriangle className="w-3 h-3" /> Alert Rules
            </h3>
            <p className="text-xs text-amber-800">{currentQuestion.alert_rule_hint}</p>
          </div>
        )}
      </aside>
    </div>
  );
}
