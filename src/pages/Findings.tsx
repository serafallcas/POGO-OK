import { useState, useEffect } from 'react';
import { Search, Filter, FileWarning, ChevronRight, Clock, AlertCircle, CheckCircle2, XCircle, GitMerge, ArrowRight } from 'lucide-react';
import { supabase } from '../lib/supabase';
import { useNavigate } from 'react-router-dom';

interface FindingV2 {
  id: string;
  title: string;
  severity: string;
  status: string;
  likelihood: string;
  impact_level: string;
  condition_text: string | null;
  root_cause: string | null;
  created_at: string;
  assessment_id: string;
  assessments: { title: string } | null;
}

const STATUS_CONFIG: Record<string, { color: string; icon: typeof Clock }> = {
  'Potential': { color: 'bg-amber-50 text-amber-700 border-amber-200', icon: Clock },
  'Under Review': { color: 'bg-blue-50 text-blue-700 border-blue-200', icon: Search },
  'Confirmed': { color: 'bg-red-50 text-red-700 border-red-200', icon: AlertCircle },
  'Rejected': { color: 'bg-gray-50 text-gray-500 border-gray-200', icon: XCircle },
  'Merged': { color: 'bg-purple-50 text-purple-600 border-purple-200', icon: GitMerge },
  'Management Response': { color: 'bg-orange-50 text-orange-700 border-orange-200', icon: ArrowRight },
  'Action Plan Defined': { color: 'bg-teal-50 text-teal-700 border-teal-200', icon: CheckCircle2 },
  'Closed': { color: 'bg-green-50 text-green-700 border-green-200', icon: CheckCircle2 },
};

const SEVERITY_COLORS: Record<string, string> = {
  Critical: 'bg-red-100 text-red-700',
  High: 'bg-orange-100 text-orange-700',
  Medium: 'bg-amber-100 text-amber-700',
  Low: 'bg-blue-100 text-blue-700',
};

export default function Findings() {
  const [findings, setFindings] = useState<FindingV2[]>([]);
  const [loading, setLoading] = useState(true);
  const [searchTerm, setSearchTerm] = useState('');
  const [filterSeverity, setFilterSeverity] = useState('');
  const [filterStatus, setFilterStatus] = useState('');
  const [showFilters, setShowFilters] = useState(false);
  const navigate = useNavigate();

  useEffect(() => {
    fetchFindings();
  }, []);

  async function fetchFindings() {
    setLoading(true);
    const { data, error } = await supabase
      .from('assessment_findings_v2')
      .select('id, title, severity, status, likelihood, impact_level, condition_text, root_cause, created_at, assessment_id, assessments(title)')
      .order('created_at', { ascending: false });

    if (error) {
      console.error('Error fetching findings:', error);
    } else if (data) {
      setFindings(data as FindingV2[]);
    }
    setLoading(false);
  }

  const filteredFindings = findings.filter((f) => {
    const matchesSearch =
      f.title?.toLowerCase().includes(searchTerm.toLowerCase()) ||
      f.root_cause?.toLowerCase().includes(searchTerm.toLowerCase());
    const matchesSeverity = !filterSeverity || f.severity === filterSeverity;
    const matchesStatus = !filterStatus || f.status === filterStatus;
    return matchesSearch && matchesSeverity && matchesStatus;
  });

  const statusCounts = findings.reduce((acc, f) => {
    acc[f.status] = (acc[f.status] || 0) + 1;
    return acc;
  }, {} as Record<string, number>);

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
          <FileWarning className="h-7 w-7 text-emerald-600" />
          <div>
            <h1 className="text-2xl font-bold text-slate-800">Findings Register</h1>
            <p className="text-sm text-slate-500">{findings.length} findings across all assessments</p>
          </div>
        </div>
      </div>

      {/* Status summary cards */}
      <div className="grid grid-cols-2 sm:grid-cols-4 lg:grid-cols-8 gap-2 mb-6">
        {Object.entries(STATUS_CONFIG).map(([status, cfg]) => {
          const count = statusCounts[status] || 0;
          const Icon = cfg.icon;
          return (
            <button key={status} onClick={() => setFilterStatus(filterStatus === status ? '' : status)}
              className={`flex flex-col items-center p-2.5 rounded-lg border transition-all ${filterStatus === status ? 'ring-2 ring-emerald-400 ' + cfg.color : 'bg-white border-gray-200 hover:border-gray-300'}`}>
              <Icon className="w-4 h-4 mb-1 text-gray-500" />
              <span className="text-lg font-bold text-gray-800">{count}</span>
              <span className="text-[10px] text-gray-500 text-center leading-tight">{status}</span>
            </button>
          );
        })}
      </div>

      {/* Search & Filters */}
      <div className="bg-white rounded-lg shadow-sm border border-slate-200 p-4 mb-6">
        <div className="flex items-center gap-4">
          <div className="relative flex-1">
            <Search className="absolute left-3 top-1/2 -translate-y-1/2 h-4 w-4 text-slate-400" />
            <input
              type="text"
              placeholder="Search findings by title or root cause..."
              value={searchTerm}
              onChange={(e) => setSearchTerm(e.target.value)}
              className="w-full pl-10 pr-4 py-2 border border-slate-300 rounded-lg text-sm focus:outline-none focus:ring-2 focus:ring-emerald-500 focus:border-emerald-500"
            />
          </div>
          <button
            onClick={() => setShowFilters(!showFilters)}
            className={`flex items-center gap-2 px-4 py-2 rounded-lg text-sm font-medium transition-colors ${showFilters ? 'bg-emerald-100 text-emerald-700 border border-emerald-300' : 'bg-slate-100 text-slate-600 border border-slate-300 hover:bg-slate-200'}`}>
            <Filter className="h-4 w-4" />
            Filters
          </button>
        </div>

        {showFilters && (
          <div className="flex items-center gap-4 mt-4 pt-4 border-t border-slate-200">
            <div className="flex-1">
              <label className="block text-xs font-medium text-slate-500 mb-1">Severity</label>
              <select value={filterSeverity} onChange={(e) => setFilterSeverity(e.target.value)}
                className="w-full px-3 py-2 border border-slate-300 rounded-lg text-sm focus:outline-none focus:ring-2 focus:ring-emerald-500">
                <option value="">All Severities</option>
                <option value="Low">Low</option>
                <option value="Medium">Medium</option>
                <option value="High">High</option>
                <option value="Critical">Critical</option>
              </select>
            </div>
            <div className="flex-1">
              <label className="block text-xs font-medium text-slate-500 mb-1">Status</label>
              <select value={filterStatus} onChange={(e) => setFilterStatus(e.target.value)}
                className="w-full px-3 py-2 border border-slate-300 rounded-lg text-sm focus:outline-none focus:ring-2 focus:ring-emerald-500">
                <option value="">All Statuses</option>
                {Object.keys(STATUS_CONFIG).map(s => <option key={s} value={s}>{s}</option>)}
              </select>
            </div>
            <button onClick={() => { setFilterSeverity(''); setFilterStatus(''); }}
              className="self-end px-3 py-2 text-sm text-slate-500 hover:text-slate-700">
              Clear
            </button>
          </div>
        )}
      </div>

      {/* Table */}
      <div className="bg-white rounded-lg shadow-sm border border-slate-200 overflow-hidden">
        <div className="overflow-x-auto">
          <table className="w-full text-sm">
            <thead className="bg-slate-50">
              <tr>
                <th className="text-left px-4 py-3 font-semibold text-slate-600">Severity</th>
                <th className="text-left px-4 py-3 font-semibold text-slate-600">Title</th>
                <th className="text-left px-4 py-3 font-semibold text-slate-600">Assessment</th>
                <th className="text-left px-4 py-3 font-semibold text-slate-600">Status</th>
                <th className="text-left px-4 py-3 font-semibold text-slate-600">Created</th>
                <th className="text-left px-4 py-3 font-semibold text-slate-600"></th>
              </tr>
            </thead>
            <tbody className="divide-y divide-slate-100">
              {filteredFindings.map((f) => {
                const cfg = STATUS_CONFIG[f.status] || STATUS_CONFIG['Potential'];
                return (
                  <tr key={f.id} className="hover:bg-slate-50 transition-colors cursor-pointer"
                    onClick={() => navigate(`/assessments/${f.assessment_id}`)}>
                    <td className="px-4 py-3">
                      <span className={`inline-block px-2 py-0.5 rounded text-xs font-medium ${SEVERITY_COLORS[f.severity] || 'bg-slate-100 text-slate-600'}`}>
                        {f.severity}
                      </span>
                    </td>
                    <td className="px-4 py-3 font-medium text-slate-800 max-w-[300px] truncate">{f.title}</td>
                    <td className="px-4 py-3 text-slate-600">{f.assessments?.title || '-'}</td>
                    <td className="px-4 py-3">
                      <span className={`inline-flex items-center px-2 py-0.5 rounded text-xs font-medium border ${cfg.color}`}>
                        {f.status}
                      </span>
                    </td>
                    <td className="px-4 py-3 text-slate-500">
                      {new Date(f.created_at).toLocaleDateString('en-US', { year: 'numeric', month: 'short', day: 'numeric' })}
                    </td>
                    <td className="px-4 py-3">
                      <ChevronRight className="w-4 h-4 text-slate-400" />
                    </td>
                  </tr>
                );
              })}
            </tbody>
          </table>

          {filteredFindings.length === 0 && (
            <div className="text-center py-12 text-slate-500">
              <FileWarning className="h-8 w-8 mx-auto mb-2 text-slate-300" />
              <p>No findings found matching your criteria.</p>
            </div>
          )}
        </div>
      </div>
    </div>
  );
}
