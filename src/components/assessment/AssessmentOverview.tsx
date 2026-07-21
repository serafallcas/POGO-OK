import { CheckCircle2, Clock, AlertTriangle, FileText, Target, TrendingUp } from 'lucide-react';

interface Props {
  assessment: {
    title: string;
    description: string | null;
    status: string;
    overall_score: number | null;
    target_maturity_score: number | null;
    assessment_period: string | null;
    start_date: string | null;
    end_date: string | null;
    created_at: string;
    validation_progress: Record<string, boolean> | null;
    organizations?: { name: string } | null;
    evaluation_types?: { label: string } | null;
  };
  stats: { total: number; answered: number; alerts: number; findings: number };
  progress: number;
}

const GATES = [
  { key: 'gate1', label: 'Completeness', desc: 'All mandatory questions answered' },
  { key: 'gate2', label: 'Quality Review', desc: 'Critical responses reviewed' },
  { key: 'gate3', label: 'Findings Validation', desc: 'All findings accepted/rejected' },
  { key: 'gate4', label: 'Action Plan', desc: 'All findings have actions' },
  { key: 'gate5', label: 'Final Approval', desc: 'Scores recalculated & approved' },
];

export default function AssessmentOverview({ assessment, stats, progress }: Props) {
  const vp = assessment.validation_progress || {};

  return (
    <div className="p-6 max-w-6xl mx-auto space-y-6">
      {/* KPI Row */}
      <div className="grid grid-cols-2 md:grid-cols-4 gap-4">
        <KpiCard icon={<Target className="w-5 h-5 text-emerald-600" />} label="Progress" value={`${progress}%`} sub={`${stats.answered}/${stats.total} questions`} />
        <KpiCard icon={<TrendingUp className="w-5 h-5 text-blue-600" />} label="Current Score" value={assessment.overall_score?.toFixed(1) || '—'} sub={`Target: ${assessment.target_maturity_score || '—'}`} />
        <KpiCard icon={<AlertTriangle className="w-5 h-5 text-amber-600" />} label="Open Alerts" value={String(stats.alerts)} sub="Active warnings" />
        <KpiCard icon={<FileText className="w-5 h-5 text-red-600" />} label="Open Findings" value={String(stats.findings)} sub="Require action" />
      </div>

      {/* Description */}
      {assessment.description && (
        <div className="bg-white rounded-lg border p-5">
          <h3 className="text-sm font-semibold text-gray-700 mb-1">Description</h3>
          <p className="text-sm text-gray-600 whitespace-pre-line">{assessment.description}</p>
        </div>
      )}

      {/* Details Grid */}
      <div className="grid md:grid-cols-2 gap-4">
        <div className="bg-white rounded-lg border p-5 space-y-3">
          <h3 className="text-sm font-semibold text-gray-700">Details</h3>
          <dl className="space-y-2 text-sm">
            <DetailRow label="Organization" value={assessment.organizations?.name} />
            <DetailRow label="Evaluation Type" value={assessment.evaluation_types?.label} />
            <DetailRow label="Period" value={assessment.assessment_period} />
            <DetailRow label="Start Date" value={assessment.start_date} />
            <DetailRow label="End Date" value={assessment.end_date} />
            <DetailRow label="Created" value={assessment.created_at ? new Date(assessment.created_at).toLocaleDateString() : null} />
          </dl>
        </div>

        {/* Validation Gates */}
        <div className="bg-white rounded-lg border p-5 space-y-3">
          <h3 className="text-sm font-semibold text-gray-700">Validation Gates</h3>
          <div className="space-y-2.5">
            {GATES.map((gate) => {
              const passed = vp[gate.key] === true;
              return (
                <div key={gate.key} className="flex items-center gap-3">
                  {passed ? (
                    <CheckCircle2 className="w-5 h-5 text-emerald-500 flex-shrink-0" />
                  ) : (
                    <Clock className="w-5 h-5 text-gray-300 flex-shrink-0" />
                  )}
                  <div className="flex-1 min-w-0">
                    <p className={`text-sm font-medium ${passed ? 'text-emerald-700' : 'text-gray-700'}`}>{gate.label}</p>
                    <p className="text-xs text-gray-500">{gate.desc}</p>
                  </div>
                </div>
              );
            })}
          </div>
        </div>
      </div>

      {/* Progress Bar */}
      <div className="bg-white rounded-lg border p-5">
        <div className="flex items-center justify-between mb-2">
          <h3 className="text-sm font-semibold text-gray-700">Completion Progress</h3>
          <span className="text-sm font-bold text-emerald-600">{progress}%</span>
        </div>
        <div className="w-full bg-gray-200 rounded-full h-3">
          <div className="bg-emerald-500 h-3 rounded-full transition-all duration-500" style={{ width: `${progress}%` }} />
        </div>
      </div>
    </div>
  );
}

function KpiCard({ icon, label, value, sub }: { icon: React.ReactNode; label: string; value: string; sub: string }) {
  return (
    <div className="bg-white rounded-lg border p-4">
      <div className="flex items-center gap-2 mb-2">{icon}<span className="text-xs text-gray-500 font-medium">{label}</span></div>
      <p className="text-2xl font-bold text-gray-900">{value}</p>
      <p className="text-xs text-gray-500 mt-0.5">{sub}</p>
    </div>
  );
}

function DetailRow({ label, value }: { label: string; value: string | null | undefined }) {
  return (
    <div className="flex justify-between">
      <dt className="text-gray-500">{label}</dt>
      <dd className="text-gray-800 font-medium">{value || '—'}</dd>
    </div>
  );
}
