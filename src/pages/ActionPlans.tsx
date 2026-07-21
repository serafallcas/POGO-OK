import { useState, useEffect } from 'react';
import { ListChecks, Plus, Filter, Search, X, CalendarClock, AlertTriangle } from 'lucide-react';
import { supabase } from '../lib/supabase';

interface ActionPlan {
  id: string;
  title: string;
  description: string | null;
  owner: string | null;
  due_date: string | null;
  priority: string;
  status: string;
  progress_pct: number;
  finding_id: string;
  created_at: string;
  finding: { title: string; severity: string; assessment_id: string } | null;
}

interface ActionFormData {
  title: string;
  description: string;
  owner: string;
  priority: string;
  due_date: string;
  finding_id: string;
}

const emptyForm: ActionFormData = {
  title: '',
  description: '',
  owner: '',
  priority: 'Medium',
  due_date: '',
  finding_id: '',
};

const priorityColors: Record<string, string> = {
  Low: 'bg-slate-100 text-slate-700',
  Medium: 'bg-amber-100 text-amber-700',
  High: 'bg-orange-100 text-orange-700',
  Critical: 'bg-rose-100 text-rose-700',
};

const statusColors: Record<string, string> = {
  Draft: 'bg-slate-100 text-slate-600',
  'Management Review': 'bg-blue-100 text-blue-700',
  Accepted: 'bg-sky-100 text-sky-700',
  'In Progress': 'bg-indigo-100 text-indigo-700',
  'Evidence Submitted': 'bg-violet-100 text-violet-700',
  'Closure Review': 'bg-teal-100 text-teal-700',
  Closed: 'bg-emerald-100 text-emerald-700',
  Reopened: 'bg-red-100 text-red-700',
};

function getProgressColor(percent: number): string {
  if (percent >= 75) return 'bg-emerald-500';
  if (percent >= 50) return 'bg-blue-500';
  if (percent >= 25) return 'bg-amber-500';
  return 'bg-red-500';
}

export default function ActionPlans() {
  const [actions, setActions] = useState<ActionPlan[]>([]);
  const [confirmedFindings, setConfirmedFindings] = useState<{ id: string; title: string }[]>([]);
  const [loading, setLoading] = useState(true);
  const [searchTerm, setSearchTerm] = useState('');
  const [filterPriority, setFilterPriority] = useState('');
  const [filterStatus, setFilterStatus] = useState('');
  const [showFilters, setShowFilters] = useState(false);
  const [showModal, setShowModal] = useState(false);
  const [formData, setFormData] = useState<ActionFormData>(emptyForm);
  const [saving, setSaving] = useState(false);

  useEffect(() => {
    fetchActions();
  }, []);

  async function fetchActions() {
    setLoading(true);
    const { data, error } = await supabase
      .from('finding_action_plans')
      .select('*, finding:assessment_findings_v2(title, severity, assessment_id)')
      .order('created_at', { ascending: false });

    if (error) {
      console.error('Error fetching action plans:', error);
    } else if (data) {
      setActions(data as ActionPlan[]);
    }
    setLoading(false);
  }

  async function fetchConfirmedFindings() {
    const { data } = await supabase
      .from('assessment_findings_v2')
      .select('id, title')
      .in('status', ['Confirmed', 'Management Response', 'Action Plan Defined'])
      .order('title');
    setConfirmedFindings(data || []);
  }

  function openModal() {
    fetchConfirmedFindings();
    setShowModal(true);
  }

  async function handleSave() {
    if (!formData.title || !formData.finding_id) return;
    setSaving(true);
    const { error } = await supabase.from('finding_action_plans').insert([
      {
        finding_id: formData.finding_id,
        title: formData.title,
        description: formData.description || null,
        owner: formData.owner || null,
        due_date: formData.due_date || null,
        priority: formData.priority,
        status: 'Draft',
        progress_pct: 0,
      },
    ]);

    if (error) {
      console.error('Error creating action plan:', error);
    } else {
      await supabase
        .from('assessment_findings_v2')
        .update({ status: 'Action Plan Defined', updated_at: new Date().toISOString() })
        .eq('id', formData.finding_id)
        .in('status', ['Confirmed', 'Management Response']);
    }

    setSaving(false);
    setShowModal(false);
    setFormData(emptyForm);
    fetchActions();
  }

  function handleCloseModal() {
    setShowModal(false);
    setFormData(emptyForm);
  }

  const filteredActions = actions.filter((action) => {
    const matchesSearch =
      action.title?.toLowerCase().includes(searchTerm.toLowerCase()) ||
      action.description?.toLowerCase().includes(searchTerm.toLowerCase()) ||
      action.owner?.toLowerCase().includes(searchTerm.toLowerCase());
    const matchesPriority = !filterPriority || action.priority === filterPriority;
    const matchesStatus = !filterStatus || action.status === filterStatus;
    return matchesSearch && matchesPriority && matchesStatus;
  });

  const overdueCount = actions.filter(a => a.due_date && new Date(a.due_date) < new Date() && a.status !== 'Closed').length;
  const inProgressCount = actions.filter(a => a.status === 'In Progress').length;
  const closedCount = actions.filter(a => a.status === 'Closed').length;

  function formatDate(dateStr: string | null): string {
    if (!dateStr) return '--';
    return new Date(dateStr).toLocaleDateString('en-US', { year: 'numeric', month: 'short', day: 'numeric' });
  }

  function isOverdue(action: ActionPlan): boolean {
    return !!action.due_date && new Date(action.due_date) < new Date() && action.status !== 'Closed';
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
          <ListChecks className="h-7 w-7 text-emerald-600" />
          <div>
            <h1 className="text-2xl font-bold text-slate-800">Action Plans</h1>
            <p className="text-sm text-slate-500">{actions.length} actions linked to confirmed findings</p>
          </div>
        </div>
        <button
          onClick={openModal}
          className="flex items-center gap-2 px-4 py-2 bg-emerald-600 text-white text-sm font-medium rounded-lg hover:bg-emerald-700 transition-colors"
        >
          <Plus className="h-4 w-4" />
          New Action Plan
        </button>
      </div>

      {/* Summary cards */}
      <div className="grid grid-cols-3 gap-4 mb-6">
        <div className="bg-white rounded-lg border p-4">
          <div className="flex items-center gap-2 mb-1">
            <CalendarClock className="w-4 h-4 text-blue-500" />
            <span className="text-xs text-slate-500">In Progress</span>
          </div>
          <span className="text-2xl font-bold text-slate-800">{inProgressCount}</span>
        </div>
        <div className="bg-white rounded-lg border p-4">
          <div className="flex items-center gap-2 mb-1">
            <AlertTriangle className="w-4 h-4 text-red-500" />
            <span className="text-xs text-slate-500">Overdue</span>
          </div>
          <span className="text-2xl font-bold text-red-600">{overdueCount}</span>
        </div>
        <div className="bg-white rounded-lg border p-4">
          <div className="flex items-center gap-2 mb-1">
            <ListChecks className="w-4 h-4 text-emerald-500" />
            <span className="text-xs text-slate-500">Closed</span>
          </div>
          <span className="text-2xl font-bold text-emerald-600">{closedCount}</span>
        </div>
      </div>

      {/* Search & Filters */}
      <div className="bg-white rounded-lg shadow-sm border border-slate-200 p-4 mb-6">
        <div className="flex items-center gap-4">
          <div className="relative flex-1">
            <Search className="absolute left-3 top-1/2 -translate-y-1/2 h-4 w-4 text-slate-400" />
            <input
              type="text"
              placeholder="Search actions by title, description, or owner..."
              value={searchTerm}
              onChange={(e) => setSearchTerm(e.target.value)}
              className="w-full pl-10 pr-4 py-2 border border-slate-300 rounded-lg text-sm focus:outline-none focus:ring-2 focus:ring-emerald-500 focus:border-emerald-500"
            />
          </div>
          <button
            onClick={() => setShowFilters(!showFilters)}
            className={`flex items-center gap-2 px-4 py-2 rounded-lg text-sm font-medium transition-colors ${showFilters ? 'bg-emerald-100 text-emerald-700 border border-emerald-300' : 'bg-slate-100 text-slate-600 border border-slate-300 hover:bg-slate-200'}`}
          >
            <Filter className="h-4 w-4" />
            Filters
          </button>
        </div>

        {showFilters && (
          <div className="flex items-center gap-4 mt-4 pt-4 border-t border-slate-200">
            <div className="flex-1">
              <label className="block text-xs font-medium text-slate-500 mb-1">Priority</label>
              <select value={filterPriority} onChange={(e) => setFilterPriority(e.target.value)}
                className="w-full px-3 py-2 border border-slate-300 rounded-lg text-sm focus:outline-none focus:ring-2 focus:ring-emerald-500">
                <option value="">All Priorities</option>
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
                {Object.keys(statusColors).map(s => <option key={s} value={s}>{s}</option>)}
              </select>
            </div>
            <button onClick={() => { setFilterPriority(''); setFilterStatus(''); }}
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
                <th className="text-left px-4 py-3 font-semibold text-slate-600">Title</th>
                <th className="text-left px-4 py-3 font-semibold text-slate-600">Related Finding</th>
                <th className="text-left px-4 py-3 font-semibold text-slate-600">Priority</th>
                <th className="text-left px-4 py-3 font-semibold text-slate-600">Owner</th>
                <th className="text-left px-4 py-3 font-semibold text-slate-600">Due Date</th>
                <th className="text-left px-4 py-3 font-semibold text-slate-600">Status</th>
                <th className="text-left px-4 py-3 font-semibold text-slate-600 w-[140px]">Progress</th>
              </tr>
            </thead>
            <tbody className="divide-y divide-slate-100">
              {filteredActions.map((action) => (
                <tr key={action.id} className={`hover:bg-slate-50 transition-colors ${isOverdue(action) ? 'bg-red-50/50' : ''}`}>
                  <td className="px-4 py-3 font-medium text-slate-800">
                    <div className="flex items-center gap-1.5">
                      {isOverdue(action) && <AlertTriangle className="w-3.5 h-3.5 text-red-500 flex-shrink-0" />}
                      {action.title}
                    </div>
                  </td>
                  <td className="px-4 py-3 text-slate-600 max-w-[200px] truncate">
                    {action.finding?.title || '--'}
                  </td>
                  <td className="px-4 py-3">
                    <span className={`inline-block px-2 py-0.5 rounded text-xs font-medium ${priorityColors[action.priority] || 'bg-slate-100 text-slate-600'}`}>
                      {action.priority}
                    </span>
                  </td>
                  <td className="px-4 py-3 text-slate-600">{action.owner || '--'}</td>
                  <td className={`px-4 py-3 ${isOverdue(action) ? 'text-red-600 font-medium' : 'text-slate-600'}`}>
                    {formatDate(action.due_date)}
                  </td>
                  <td className="px-4 py-3">
                    <span className={`inline-block px-2 py-0.5 rounded text-xs font-medium ${statusColors[action.status] || 'bg-slate-100 text-slate-600'}`}>
                      {action.status}
                    </span>
                  </td>
                  <td className="px-4 py-3">
                    <div className="flex items-center gap-2">
                      <div className="flex-1 h-2 bg-slate-200 rounded-full overflow-hidden">
                        <div
                          className={`h-full rounded-full transition-all ${getProgressColor(action.progress_pct)}`}
                          style={{ width: `${action.progress_pct}%` }}
                        />
                      </div>
                      <span className="text-xs text-slate-500 w-[32px] text-right">{action.progress_pct}%</span>
                    </div>
                  </td>
                </tr>
              ))}
            </tbody>
          </table>

          {filteredActions.length === 0 && (
            <div className="text-center py-12 text-slate-500">
              <ListChecks className="h-8 w-8 mx-auto mb-2 text-slate-300" />
              <p>No action plans found. Create one from a confirmed finding.</p>
            </div>
          )}
        </div>
      </div>

      {/* Add Action Modal */}
      {showModal && (
        <div className="fixed inset-0 z-50 flex items-center justify-center">
          <div className="absolute inset-0 bg-black/50" onClick={handleCloseModal} />
          <div className="relative bg-white rounded-xl shadow-xl w-full max-w-md mx-4">
            <div className="flex items-center justify-between px-6 py-4 border-b border-slate-200">
              <h2 className="text-lg font-semibold text-slate-800">New Action Plan</h2>
              <button onClick={handleCloseModal} className="p-1 text-slate-400 hover:text-slate-600 rounded">
                <X className="h-5 w-5" />
              </button>
            </div>

            <div className="px-6 py-4 space-y-4">
              <div>
                <label className="block text-sm font-medium text-slate-700 mb-1">Confirmed Finding *</label>
                <select value={formData.finding_id} onChange={(e) => setFormData({ ...formData, finding_id: e.target.value })}
                  className="w-full px-3 py-2 border border-slate-300 rounded-lg text-sm focus:outline-none focus:ring-2 focus:ring-emerald-500">
                  <option value="">Select a confirmed finding...</option>
                  {confirmedFindings.map(f => (
                    <option key={f.id} value={f.id}>{f.title}</option>
                  ))}
                </select>
                {confirmedFindings.length === 0 && (
                  <p className="text-xs text-amber-600 mt-1">No confirmed findings available. Findings must be confirmed before action plans can be created.</p>
                )}
              </div>
              <div>
                <label className="block text-sm font-medium text-slate-700 mb-1">Title *</label>
                <input type="text" value={formData.title} onChange={(e) => setFormData({ ...formData, title: e.target.value })}
                  className="w-full px-3 py-2 border border-slate-300 rounded-lg text-sm focus:outline-none focus:ring-2 focus:ring-emerald-500"
                  placeholder="Action plan title" />
              </div>
              <div>
                <label className="block text-sm font-medium text-slate-700 mb-1">Description</label>
                <textarea value={formData.description} onChange={(e) => setFormData({ ...formData, description: e.target.value })}
                  rows={3}
                  className="w-full px-3 py-2 border border-slate-300 rounded-lg text-sm focus:outline-none focus:ring-2 focus:ring-emerald-500"
                  placeholder="Describe the action plan..." />
              </div>
              <div className="grid grid-cols-2 gap-3">
                <div>
                  <label className="block text-sm font-medium text-slate-700 mb-1">Priority</label>
                  <select value={formData.priority} onChange={(e) => setFormData({ ...formData, priority: e.target.value })}
                    className="w-full px-3 py-2 border border-slate-300 rounded-lg text-sm focus:outline-none focus:ring-2 focus:ring-emerald-500">
                    <option value="Low">Low</option>
                    <option value="Medium">Medium</option>
                    <option value="High">High</option>
                    <option value="Critical">Critical</option>
                  </select>
                </div>
                <div>
                  <label className="block text-sm font-medium text-slate-700 mb-1">Due Date</label>
                  <input type="date" value={formData.due_date} onChange={(e) => setFormData({ ...formData, due_date: e.target.value })}
                    className="w-full px-3 py-2 border border-slate-300 rounded-lg text-sm focus:outline-none focus:ring-2 focus:ring-emerald-500" />
                </div>
              </div>
              <div>
                <label className="block text-sm font-medium text-slate-700 mb-1">Owner</label>
                <input type="text" value={formData.owner} onChange={(e) => setFormData({ ...formData, owner: e.target.value })}
                  className="w-full px-3 py-2 border border-slate-300 rounded-lg text-sm focus:outline-none focus:ring-2 focus:ring-emerald-500"
                  placeholder="Responsible person or role" />
              </div>
            </div>

            <div className="flex items-center justify-end gap-3 px-6 py-4 border-t border-slate-200">
              <button onClick={handleCloseModal}
                className="px-4 py-2 text-sm font-medium text-slate-600 hover:text-slate-800 transition-colors">
                Cancel
              </button>
              <button onClick={handleSave} disabled={saving || !formData.title || !formData.finding_id}
                className="px-4 py-2 bg-emerald-600 text-white text-sm font-medium rounded-lg hover:bg-emerald-700 disabled:opacity-50 disabled:cursor-not-allowed transition-colors">
                {saving ? 'Saving...' : 'Create Action Plan'}
              </button>
            </div>
          </div>
        </div>
      )}
    </div>
  );
}
