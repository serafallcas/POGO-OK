import { useState, useEffect } from 'react';
import { supabase } from '../../lib/supabase';
import { ListChecks, Clock, CheckCircle2, AlertTriangle } from 'lucide-react';

interface Action {
  id: string;
  title: string;
  priority: string;
  status: string;
  due_date: string | null;
  progress_pct: number;
  finding: { title: string; severity: string } | null;
}

const PRIORITY_COLORS: Record<string, string> = {
  Critical: 'text-red-600',
  High: 'text-orange-600',
  Medium: 'text-amber-600',
  Low: 'text-blue-600',
};

export default function AssessmentActionPlans({ assessmentId }: { assessmentId: string }) {
  const [actions, setActions] = useState<Action[]>([]);
  const [loading, setLoading] = useState(true);

  useEffect(() => { fetchActions(); }, [assessmentId]);

  async function fetchActions() {
    setLoading(true);
    const { data: findings } = await supabase
      .from('assessment_findings_v2')
      .select('id')
      .eq('assessment_id', assessmentId);

    if (!findings || findings.length === 0) {
      setActions([]);
      setLoading(false);
      return;
    }

    const findingIds = findings.map(f => f.id);
    const { data } = await supabase
      .from('finding_action_plans')
      .select('id, title, priority, status, due_date, progress_pct, finding:assessment_findings_v2(title, severity)')
      .in('finding_id', findingIds)
      .order('due_date');
    setActions((data as Action[]) || []);
    setLoading(false);
  }

  if (loading) return <div className="flex items-center justify-center h-48"><div className="animate-spin rounded-full h-6 w-6 border-b-2 border-emerald-600" /></div>;

  return (
    <div className="p-6 max-w-5xl mx-auto space-y-4">
      <div className="flex items-center justify-between">
        <h2 className="text-lg font-semibold text-gray-800">Action Plans</h2>
        <span className="text-sm text-gray-500">{actions.length} actions</span>
      </div>

      {actions.length === 0 ? (
        <div className="bg-white rounded-lg border p-10 text-center">
          <ListChecks className="w-10 h-10 mx-auto text-gray-300 mb-3" />
          <p className="text-gray-500 text-sm">No action plans yet. Actions are created from confirmed findings.</p>
        </div>
      ) : (
        <div className="space-y-2">
          {actions.map((a) => {
            const isOverdue = a.due_date && new Date(a.due_date) < new Date() && a.status !== 'Closed';
            return (
              <div key={a.id} className="bg-white rounded-lg border p-4">
                <div className="flex items-center gap-3">
                  {a.status === 'Closed' ? (
                    <CheckCircle2 className="w-5 h-5 text-emerald-500 flex-shrink-0" />
                  ) : isOverdue ? (
                    <AlertTriangle className="w-5 h-5 text-red-500 flex-shrink-0" />
                  ) : (
                    <Clock className="w-5 h-5 text-gray-400 flex-shrink-0" />
                  )}
                  <div className="flex-1 min-w-0">
                    <h4 className="text-sm font-medium text-gray-800">{a.title}</h4>
                    {a.finding && (
                      <p className="text-xs text-gray-500 mt-0.5">Finding: {a.finding.title}</p>
                    )}
                  </div>
                  <span className={`text-xs font-medium ${PRIORITY_COLORS[a.priority] || 'text-gray-500'}`}>
                    {a.priority}
                  </span>
                  <span className="text-xs text-gray-400">{a.status}</span>
                </div>
                <div className="mt-2 flex items-center gap-3">
                  <div className="flex-1 bg-gray-200 rounded-full h-1.5">
                    <div className="bg-emerald-500 h-1.5 rounded-full" style={{ width: `${a.progress_pct}%` }} />
                  </div>
                  <span className="text-xs text-gray-500">{a.progress_pct}%</span>
                  {a.due_date && (
                    <span className={`text-xs ${isOverdue ? 'text-red-600 font-medium' : 'text-gray-400'}`}>
                      Due: {new Date(a.due_date).toLocaleDateString()}
                    </span>
                  )}
                </div>
              </div>
            );
          })}
        </div>
      )}
    </div>
  );
}
