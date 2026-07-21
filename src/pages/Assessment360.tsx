import { useState, useEffect } from 'react';
import { useParams, useNavigate } from 'react-router-dom';
import { supabase } from '../lib/supabase';
import {
  ArrowLeft, Eye, Target, Briefcase, FileText, AlertTriangle,
  Search, ListChecks, CheckCircle2, Clock, Shield,
} from 'lucide-react';
import AssessmentOverview from '../components/assessment/AssessmentOverview';
import AssessmentScope from '../components/assessment/AssessmentScope';
import AssessmentWorkspaceTab from '../components/assessment/AssessmentWorkspaceTab';
import AssessmentEvidence from '../components/assessment/AssessmentEvidence';
import AssessmentAlerts from '../components/assessment/AssessmentAlerts';
import AssessmentFindings from '../components/assessment/AssessmentFindings';
import AssessmentActionPlans from '../components/assessment/AssessmentActionPlans';
import AssessmentReview from '../components/assessment/AssessmentReview';

const TABS = [
  { id: 'overview', label: 'Overview', icon: Eye },
  { id: 'scope', label: 'Scope', icon: Target },
  { id: 'workspace', label: 'Workspace', icon: Briefcase },
  { id: 'evidence', label: 'Evidence', icon: FileText },
  { id: 'alerts', label: 'Alerts', icon: AlertTriangle },
  { id: 'findings', label: 'Findings', icon: Search },
  { id: 'actions', label: 'Action Plans', icon: ListChecks },
  { id: 'review', label: 'Review & Approval', icon: Shield },
] as const;

type TabId = (typeof TABS)[number]['id'];

const STATUS_COLORS: Record<string, string> = {
  draft: 'bg-slate-100 text-slate-700',
  in_progress: 'bg-blue-100 text-blue-700',
  under_review: 'bg-amber-100 text-amber-700',
  approved: 'bg-emerald-100 text-emerald-700',
  closed: 'bg-gray-100 text-gray-600',
};

interface AssessmentDetail {
  id: string;
  title: string;
  description: string | null;
  status: string;
  overall_score: number | null;
  target_maturity_score: number | null;
  assessment_period: string | null;
  start_date: string | null;
  end_date: string | null;
  evaluation_type_id: string | null;
  organization_id: string | null;
  created_at: string;
  validation_progress: Record<string, boolean> | null;
  organizations?: { name: string } | null;
  evaluation_types?: { label: string } | null;
}

export default function Assessment360() {
  const { id } = useParams<{ id: string }>();
  const navigate = useNavigate();
  const [assessment, setAssessment] = useState<AssessmentDetail | null>(null);
  const [activeTab, setActiveTab] = useState<TabId>('overview');
  const [loading, setLoading] = useState(true);
  const [stats, setStats] = useState({ total: 0, answered: 0, alerts: 0, findings: 0 });

  useEffect(() => {
    if (id) fetchAssessment();
  }, [id]);

  async function fetchAssessment() {
    setLoading(true);
    const { data, error } = await supabase
      .from('assessments')
      .select('*, organizations(name), evaluation_types(label)')
      .eq('id', id!)
      .maybeSingle();

    if (error || !data) {
      setLoading(false);
      return;
    }
    setAssessment(data as AssessmentDetail);

    const [respResult, alertResult, findingResult] = await Promise.all([
      supabase.from('assessment_responses').select('id, score', { count: 'exact' }).eq('assessment_id', id!),
      supabase.from('assessment_alerts').select('id', { count: 'exact' }).eq('assessment_id', id!).in('status', ['open', 'in_progress']),
      supabase.from('assessment_findings_v2').select('id', { count: 'exact' }).eq('assessment_id', id!).not('status', 'in', '("Rejected","Closed","Merged")'),
    ]);

    const totalResp = respResult.count || 0;
    const answeredResp = (respResult.data || []).filter(r => r.score !== null).length;

    setStats({
      total: totalResp,
      answered: answeredResp,
      alerts: alertResult.count || 0,
      findings: findingResult.count || 0,
    });
    setLoading(false);
  }

  if (loading) {
    return (
      <div className="flex items-center justify-center h-64">
        <div className="animate-spin rounded-full h-8 w-8 border-b-2 border-emerald-600" />
      </div>
    );
  }

  if (!assessment) {
    return (
      <div className="text-center py-16">
        <p className="text-gray-500">Assessment not found.</p>
        <button onClick={() => navigate('/assessments')} className="mt-4 text-emerald-600 hover:underline text-sm">
          Back to Assessments
        </button>
      </div>
    );
  }

  const progress = stats.total > 0 ? Math.round((stats.answered / stats.total) * 100) : 0;

  return (
    <div className="-m-6 h-[calc(100vh-3.5rem)] flex flex-col overflow-hidden">
      {/* Header */}
      <div className="bg-white border-b px-6 py-4 flex items-center gap-4 flex-shrink-0">
        <button onClick={() => navigate('/assessments')} className="p-1.5 rounded-lg hover:bg-gray-100 text-gray-500">
          <ArrowLeft className="w-5 h-5" />
        </button>
        <div className="flex-1 min-w-0">
          <div className="flex items-center gap-3">
            <h1 className="text-xl font-bold text-gray-900 truncate">{assessment.title}</h1>
            <span className={`inline-flex items-center px-2.5 py-0.5 rounded-full text-xs font-medium ${STATUS_COLORS[assessment.status] || STATUS_COLORS.draft}`}>
              {assessment.status.replace(/_/g, ' ').replace(/\b\w/g, c => c.toUpperCase())}
            </span>
          </div>
          <div className="flex items-center gap-4 mt-1 text-xs text-gray-500">
            {assessment.organizations?.name && <span>{assessment.organizations.name}</span>}
            {assessment.evaluation_types?.label && <span>{assessment.evaluation_types.label}</span>}
            {assessment.assessment_period && <span>{assessment.assessment_period}</span>}
          </div>
        </div>

        {/* Mini stats */}
        <div className="hidden md:flex items-center gap-5 text-xs">
          <div className="text-center">
            <div className="text-lg font-bold text-emerald-600">{progress}%</div>
            <div className="text-gray-500">Complete</div>
          </div>
          <div className="text-center">
            <div className="text-lg font-bold text-gray-700">{assessment.overall_score?.toFixed(1) || '—'}</div>
            <div className="text-gray-500">Score</div>
          </div>
          <div className="text-center">
            <div className="text-lg font-bold text-gray-700">{assessment.target_maturity_score || '—'}</div>
            <div className="text-gray-500">Target</div>
          </div>
          {stats.alerts > 0 && (
            <div className="text-center">
              <div className="text-lg font-bold text-amber-600">{stats.alerts}</div>
              <div className="text-gray-500">Alerts</div>
            </div>
          )}
        </div>
      </div>

      {/* Tabs */}
      <div className="bg-white border-b px-6 flex-shrink-0 overflow-x-auto">
        <div className="flex gap-0 min-w-max">
          {TABS.map((tab) => {
            const isActive = activeTab === tab.id;
            const Icon = tab.icon;
            let badgeCount: number | null = null;
            if (tab.id === 'alerts' && stats.alerts > 0) badgeCount = stats.alerts;
            if (tab.id === 'findings' && stats.findings > 0) badgeCount = stats.findings;

            return (
              <button
                key={tab.id}
                onClick={() => setActiveTab(tab.id)}
                className={`flex items-center gap-1.5 px-4 py-3 text-sm font-medium border-b-2 transition-colors whitespace-nowrap ${
                  isActive
                    ? 'border-emerald-600 text-emerald-600'
                    : 'border-transparent text-gray-500 hover:text-gray-700 hover:border-gray-300'
                }`}
              >
                <Icon className="w-4 h-4" />
                {tab.label}
                {badgeCount && (
                  <span className="ml-1 px-1.5 py-0.5 text-[10px] font-bold rounded-full bg-amber-100 text-amber-700">
                    {badgeCount}
                  </span>
                )}
              </button>
            );
          })}
        </div>
      </div>

      {/* Tab Content */}
      <div className="flex-1 overflow-y-auto">
        {activeTab === 'overview' && <AssessmentOverview assessment={assessment} stats={stats} progress={progress} />}
        {activeTab === 'scope' && <AssessmentScope assessmentId={id!} evaluationTypeId={assessment.evaluation_type_id} />}
        {activeTab === 'workspace' && <AssessmentWorkspaceTab assessmentId={id!} evaluationTypeId={assessment.evaluation_type_id} />}
        {activeTab === 'evidence' && <AssessmentEvidence assessmentId={id!} />}
        {activeTab === 'alerts' && <AssessmentAlerts assessmentId={id!} />}
        {activeTab === 'findings' && <AssessmentFindings assessmentId={id!} />}
        {activeTab === 'actions' && <AssessmentActionPlans assessmentId={id!} />}
        {activeTab === 'review' && <AssessmentReview assessmentId={id!} assessment={assessment} />}
      </div>
    </div>
  );
}
