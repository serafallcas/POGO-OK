import { useState, useEffect } from 'react';
import { AlertTriangle, Filter, Search, X } from 'lucide-react';
import { supabase } from '../lib/supabase';

interface Alert {
  id: string;
  severity: 'low' | 'medium' | 'high' | 'critical';
  title: string;
  message: string;
  status: 'open' | 'acknowledged' | 'resolved';
  due_date: string;
  created_at: string;
  assessment_id: string;
  question_id: string;
  assessments: { title: string } | null;
  questions: { question_text: string } | null;
}

const severityColors: Record<string, string> = {
  low: 'bg-slate-100 text-slate-700',
  medium: 'bg-amber-100 text-amber-700',
  high: 'bg-orange-100 text-orange-700',
  critical: 'bg-rose-100 text-rose-700',
};

const statusColors: Record<string, string> = {
  open: 'bg-red-100 text-red-700',
  acknowledged: 'bg-amber-100 text-amber-700',
  resolved: 'bg-emerald-100 text-emerald-700',
};

export default function Alerts() {
  const [alerts, setAlerts] = useState<Alert[]>([]);
  const [loading, setLoading] = useState(true);
  const [searchTerm, setSearchTerm] = useState('');
  const [filterSeverity, setFilterSeverity] = useState('');
  const [filterStatus, setFilterStatus] = useState('');
  const [showFilters, setShowFilters] = useState(false);
  const [selectedAlert, setSelectedAlert] = useState<Alert | null>(null);

  useEffect(() => {
    fetchAlerts();
  }, []);

  async function fetchAlerts() {
    setLoading(true);
    const { data, error } = await supabase
      .from('assessment_alerts')
      .select('*, assessments(title), questions(question_text)')
      .order('created_at', { ascending: false });

    if (error) {
      console.error('Error fetching alerts:', error);
    } else if (data) {
      setAlerts(data as Alert[]);
    }
    setLoading(false);
  }

  const filteredAlerts = alerts.filter((alert) => {
    const matchesSearch =
      alert.title?.toLowerCase().includes(searchTerm.toLowerCase()) ||
      alert.message?.toLowerCase().includes(searchTerm.toLowerCase());
    const matchesSeverity = !filterSeverity || alert.severity === filterSeverity;
    const matchesStatus = !filterStatus || alert.status === filterStatus;
    return matchesSearch && matchesSeverity && matchesStatus;
  });

  function formatDate(dateStr: string): string {
    if (!dateStr) return '—';
    return new Date(dateStr).toLocaleDateString('en-US', {
      year: 'numeric',
      month: 'short',
      day: 'numeric',
    });
  }

  if (loading) {
    return (
      <div className="flex items-center justify-center h-64">
        <div className="animate-spin rounded-full h-8 w-8 border-b-2 border-emerald-600"></div>
      </div>
    );
  }

  return (
    <div className="p-6 max-w-7xl mx-auto">
      {/* Header */}
      <div className="flex items-center justify-between mb-6">
        <div className="flex items-center gap-3">
          <AlertTriangle className="h-7 w-7 text-emerald-600" />
          <h1 className="text-2xl font-bold text-slate-800">Alert Register</h1>
        </div>
        <span className="text-sm text-slate-500">
          {filteredAlerts.length} of {alerts.length} alerts
        </span>
      </div>

      {/* Search & Filters */}
      <div className="bg-white rounded-lg shadow-sm border border-slate-200 p-4 mb-6">
        <div className="flex items-center gap-4">
          <div className="relative flex-1">
            <Search className="absolute left-3 top-1/2 -translate-y-1/2 h-4 w-4 text-slate-400" />
            <input
              type="text"
              placeholder="Search alerts by title or message..."
              value={searchTerm}
              onChange={(e) => setSearchTerm(e.target.value)}
              className="w-full pl-10 pr-4 py-2 border border-slate-300 rounded-lg text-sm focus:outline-none focus:ring-2 focus:ring-emerald-500 focus:border-emerald-500"
            />
          </div>
          <button
            onClick={() => setShowFilters(!showFilters)}
            className={`flex items-center gap-2 px-4 py-2 rounded-lg text-sm font-medium transition-colors ${
              showFilters
                ? 'bg-emerald-100 text-emerald-700 border border-emerald-300'
                : 'bg-slate-100 text-slate-600 border border-slate-300 hover:bg-slate-200'
            }`}
          >
            <Filter className="h-4 w-4" />
            Filters
          </button>
        </div>

        {showFilters && (
          <div className="flex items-center gap-4 mt-4 pt-4 border-t border-slate-200">
            <div className="flex-1">
              <label className="block text-xs font-medium text-slate-500 mb-1">Severity</label>
              <select
                value={filterSeverity}
                onChange={(e) => setFilterSeverity(e.target.value)}
                className="w-full px-3 py-2 border border-slate-300 rounded-lg text-sm focus:outline-none focus:ring-2 focus:ring-emerald-500"
              >
                <option value="">All Severities</option>
                <option value="low">Low</option>
                <option value="medium">Medium</option>
                <option value="high">High</option>
                <option value="critical">Critical</option>
              </select>
            </div>
            <div className="flex-1">
              <label className="block text-xs font-medium text-slate-500 mb-1">Status</label>
              <select
                value={filterStatus}
                onChange={(e) => setFilterStatus(e.target.value)}
                className="w-full px-3 py-2 border border-slate-300 rounded-lg text-sm focus:outline-none focus:ring-2 focus:ring-emerald-500"
              >
                <option value="">All Statuses</option>
                <option value="open">Open</option>
                <option value="acknowledged">Acknowledged</option>
                <option value="resolved">Resolved</option>
              </select>
            </div>
            <button
              onClick={() => {
                setFilterSeverity('');
                setFilterStatus('');
              }}
              className="self-end px-3 py-2 text-sm text-slate-500 hover:text-slate-700"
            >
              Clear
            </button>
          </div>
        )}
      </div>

      {/* Table */}
      <div className="bg-white rounded-lg shadow-sm border border-slate-200 overflow-hidden">
        <div className="overflow-x-auto">
          <table className="w-full text-sm">
            <thead className="bg-slate-100">
              <tr>
                <th className="text-left px-4 py-3 font-semibold text-slate-600">Severity</th>
                <th className="text-left px-4 py-3 font-semibold text-slate-600">Title</th>
                <th className="text-left px-4 py-3 font-semibold text-slate-600">Assessment</th>
                <th className="text-left px-4 py-3 font-semibold text-slate-600">Question</th>
                <th className="text-left px-4 py-3 font-semibold text-slate-600">Status</th>
                <th className="text-left px-4 py-3 font-semibold text-slate-600">Due Date</th>
              </tr>
            </thead>
            <tbody className="divide-y divide-slate-100">
              {filteredAlerts.map((alert) => (
                <tr
                  key={alert.id}
                  onClick={() => setSelectedAlert(alert)}
                  className="hover:bg-slate-50 transition-colors cursor-pointer"
                >
                  <td className="px-4 py-3">
                    <span
                      className={`inline-block px-2 py-0.5 rounded text-xs font-medium capitalize ${
                        severityColors[alert.severity] || 'bg-slate-100 text-slate-600'
                      }`}
                    >
                      {alert.severity}
                    </span>
                  </td>
                  <td className="px-4 py-3 font-medium text-slate-800">{alert.title}</td>
                  <td className="px-4 py-3 text-slate-600">
                    {alert.assessments?.title || '—'}
                  </td>
                  <td className="px-4 py-3 text-slate-600 max-w-[200px] truncate">
                    {alert.questions?.question_text || '—'}
                  </td>
                  <td className="px-4 py-3">
                    <span
                      className={`inline-block px-2 py-0.5 rounded text-xs font-medium capitalize ${
                        statusColors[alert.status] || 'bg-slate-100 text-slate-600'
                      }`}
                    >
                      {alert.status}
                    </span>
                  </td>
                  <td className="px-4 py-3 text-slate-600">{formatDate(alert.due_date)}</td>
                </tr>
              ))}
            </tbody>
          </table>

          {filteredAlerts.length === 0 && (
            <div className="text-center py-12 text-slate-500">
              <AlertTriangle className="h-8 w-8 mx-auto mb-2 text-slate-300" />
              <p>No alerts found matching your criteria.</p>
            </div>
          )}
        </div>
      </div>

      {/* Alert Detail Modal */}
      {selectedAlert && (
        <div className="fixed inset-0 z-50 flex items-center justify-center">
          <div className="absolute inset-0 bg-black/50" onClick={() => setSelectedAlert(null)} />
          <div className="relative bg-white rounded-xl shadow-xl w-full max-w-lg mx-4">
            <div className="flex items-center justify-between px-6 py-4 border-b border-slate-200">
              <h2 className="text-lg font-semibold text-slate-800">Alert Details</h2>
              <button
                onClick={() => setSelectedAlert(null)}
                className="p-1 text-slate-400 hover:text-slate-600 rounded"
              >
                <X className="h-5 w-5" />
              </button>
            </div>

            <div className="px-6 py-4 space-y-4">
              <div className="flex items-center gap-3">
                <span
                  className={`inline-block px-2.5 py-1 rounded text-xs font-medium capitalize ${
                    severityColors[selectedAlert.severity]
                  }`}
                >
                  {selectedAlert.severity}
                </span>
                <span
                  className={`inline-block px-2.5 py-1 rounded text-xs font-medium capitalize ${
                    statusColors[selectedAlert.status]
                  }`}
                >
                  {selectedAlert.status}
                </span>
              </div>

              <div>
                <h3 className="text-sm font-semibold text-slate-500 uppercase mb-1">Title</h3>
                <p className="text-sm text-slate-800">{selectedAlert.title}</p>
              </div>

              <div>
                <h3 className="text-sm font-semibold text-slate-500 uppercase mb-1">Message</h3>
                <p className="text-sm text-slate-700">{selectedAlert.message || 'N/A'}</p>
              </div>

              <div className="grid grid-cols-2 gap-4">
                <div>
                  <h3 className="text-sm font-semibold text-slate-500 uppercase mb-1">Assessment</h3>
                  <p className="text-sm text-slate-700">
                    {selectedAlert.assessments?.title || '—'}
                  </p>
                </div>
                <div>
                  <h3 className="text-sm font-semibold text-slate-500 uppercase mb-1">Question</h3>
                  <p className="text-sm text-slate-700">
                    {selectedAlert.questions?.question_text || '—'}
                  </p>
                </div>
              </div>

              <div className="grid grid-cols-2 gap-4">
                <div>
                  <h3 className="text-sm font-semibold text-slate-500 uppercase mb-1">Due Date</h3>
                  <p className="text-sm text-slate-700">{formatDate(selectedAlert.due_date)}</p>
                </div>
                <div>
                  <h3 className="text-sm font-semibold text-slate-500 uppercase mb-1">Created</h3>
                  <p className="text-sm text-slate-700">{formatDate(selectedAlert.created_at)}</p>
                </div>
              </div>
            </div>

            <div className="flex items-center justify-end px-6 py-4 border-t border-slate-200">
              <button
                onClick={() => setSelectedAlert(null)}
                className="px-4 py-2 text-sm font-medium text-slate-600 hover:text-slate-800 transition-colors"
              >
                Close
              </button>
            </div>
          </div>
        </div>
      )}
    </div>
  );
}
