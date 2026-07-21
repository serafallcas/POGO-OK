import { useState, useEffect } from 'react';
import { supabase } from '../../lib/supabase';
import { AlertTriangle, Bell, CheckCircle2 } from 'lucide-react';

interface Alert {
  id: string;
  severity: string;
  title: string;
  message: string | null;
  status: string;
  due_date: string | null;
  created_at: string;
}

const SEVERITY_COLORS: Record<string, string> = {
  critical: 'bg-red-100 text-red-700',
  high: 'bg-orange-100 text-orange-700',
  medium: 'bg-amber-100 text-amber-700',
  low: 'bg-blue-100 text-blue-700',
};

export default function AssessmentAlerts({ assessmentId }: { assessmentId: string }) {
  const [alerts, setAlerts] = useState<Alert[]>([]);
  const [loading, setLoading] = useState(true);

  useEffect(() => { fetchAlerts(); }, [assessmentId]);

  async function fetchAlerts() {
    setLoading(true);
    const { data } = await supabase
      .from('assessment_alerts')
      .select('id, severity, title, message, status, due_date, created_at')
      .eq('assessment_id', assessmentId)
      .order('created_at', { ascending: false });
    setAlerts(data || []);
    setLoading(false);
  }

  if (loading) return <div className="flex items-center justify-center h-48"><div className="animate-spin rounded-full h-6 w-6 border-b-2 border-emerald-600" /></div>;

  const open = alerts.filter(a => a.status !== 'resolved');
  const resolved = alerts.filter(a => a.status === 'resolved');

  return (
    <div className="p-6 max-w-5xl mx-auto space-y-4">
      <div className="flex items-center justify-between">
        <h2 className="text-lg font-semibold text-gray-800">Alerts</h2>
        <div className="flex gap-3 text-sm">
          <span className="text-amber-600 font-medium">{open.length} open</span>
          <span className="text-gray-400">{resolved.length} resolved</span>
        </div>
      </div>

      {alerts.length === 0 ? (
        <div className="bg-white rounded-lg border p-10 text-center">
          <Bell className="w-10 h-10 mx-auto text-gray-300 mb-3" />
          <p className="text-gray-500 text-sm">No alerts for this assessment.</p>
        </div>
      ) : (
        <div className="space-y-2">
          {open.map((a) => (
            <div key={a.id} className="bg-white rounded-lg border p-4 flex items-start gap-3">
              <AlertTriangle className="w-5 h-5 text-amber-500 flex-shrink-0 mt-0.5" />
              <div className="flex-1 min-w-0">
                <div className="flex items-center gap-2">
                  <span className={`inline-flex px-2 py-0.5 rounded text-[10px] font-bold uppercase ${SEVERITY_COLORS[a.severity] || SEVERITY_COLORS.medium}`}>
                    {a.severity}
                  </span>
                  <h4 className="text-sm font-medium text-gray-800">{a.title}</h4>
                </div>
                {a.message && <p className="text-xs text-gray-600 mt-1">{a.message}</p>}
              </div>
              <span className="text-xs text-gray-400">{new Date(a.created_at).toLocaleDateString()}</span>
            </div>
          ))}
          {resolved.length > 0 && (
            <div className="pt-4">
              <h3 className="text-xs font-semibold text-gray-500 uppercase mb-2">Resolved ({resolved.length})</h3>
              {resolved.map((a) => (
                <div key={a.id} className="bg-gray-50 rounded border p-3 flex items-center gap-3 mb-1 opacity-60">
                  <CheckCircle2 className="w-4 h-4 text-emerald-500" />
                  <span className="text-xs text-gray-600">{a.title}</span>
                </div>
              ))}
            </div>
          )}
        </div>
      )}
    </div>
  );
}
