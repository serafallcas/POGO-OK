import { useState, useEffect } from 'react';
import { Link } from 'react-router-dom';
import { ClipboardCheck, Plus, Filter, Search, ChevronRight, X } from 'lucide-react';
import { supabase } from '../lib/supabase';

interface EvaluationType {
  id: string;
  code: string;
  label: string;
}

interface Organization {
  id: string;
  name: string;
  code: string;
}

interface Domain {
  id: string;
  code: string;
  label: string;
  evaluation_type_id: string | null;
}

interface Assessment {
  id: string;
  title: string;
  description: string | null;
  assessment_period: string | null;
  status: string;
  overall_score: number | null;
  current_maturity_score: number | null;
  target_maturity_score: number | null;
  start_date: string | null;
  end_date: string | null;
  created_at: string | null;
  organization_id: string | null;
  evaluation_type_id: string | null;
  domain_id: string | null;
  organizations: { name: string } | null;
  evaluation_types: { label: string } | null;
}

interface AssessmentFormData {
  title: string;
  description: string;
  organization_id: string;
  evaluation_type_id: string;
  domain_id: string;
  assessment_period: string;
  target_maturity_score: number;
  start_date: string;
  end_date: string;
}

const emptyForm: AssessmentFormData = {
  title: '',
  description: '',
  organization_id: '',
  evaluation_type_id: '',
  domain_id: '',
  assessment_period: '',
  target_maturity_score: 3,
  start_date: '',
  end_date: '',
};

const STATUS_BADGES: Record<string, { bg: string; text: string }> = {
  draft: { bg: 'bg-slate-100', text: 'text-slate-700' },
  in_progress: { bg: 'bg-blue-100', text: 'text-blue-700' },
  under_review: { bg: 'bg-amber-100', text: 'text-amber-700' },
  approved: { bg: 'bg-emerald-100', text: 'text-emerald-700' },
  closed: { bg: 'bg-gray-100', text: 'text-gray-600' },
};

function getStatusBadge(status: string) {
  const badge = STATUS_BADGES[status] || STATUS_BADGES.draft;
  return badge;
}

function formatStatus(status: string) {
  return status
    .replace(/_/g, ' ')
    .replace(/\b\w/g, (c) => c.toUpperCase());
}

export default function Assessments() {
  const [assessments, setAssessments] = useState<Assessment[]>([]);
  const [organizations, setOrganizations] = useState<Organization[]>([]);
  const [evaluationTypes, setEvaluationTypes] = useState<EvaluationType[]>([]);
  const [domains, setDomains] = useState<Domain[]>([]);
  const [loading, setLoading] = useState(true);
  const [searchTerm, setSearchTerm] = useState('');
  const [filterStatus, setFilterStatus] = useState('');
  const [filterEvalType, setFilterEvalType] = useState('');
  const [showFilters, setShowFilters] = useState(false);
  const [showModal, setShowModal] = useState(false);
  const [formData, setFormData] = useState<AssessmentFormData>(emptyForm);
  const [saving, setSaving] = useState(false);
  const [wizardStep, setWizardStep] = useState(1);

  useEffect(() => {
    fetchAssessments();
    fetchOrganizations();
    fetchEvaluationTypes();
    fetchDomains();
  }, []);

  async function fetchAssessments() {
    setLoading(true);
    const { data, error } = await supabase
      .from('assessments')
      .select(`
        *,
        organizations ( name ),
        evaluation_types ( label )
      `)
      .order('created_at', { ascending: false });

    if (error) {
      console.error('Error fetching assessments:', error);
    } else if (data) {
      setAssessments(data as Assessment[]);
    }
    setLoading(false);
  }

  async function fetchOrganizations() {
    const { data } = await supabase
      .from('organizations')
      .select('id, name, code')
      .eq('status', 'active')
      .order('name');
    if (data) setOrganizations(data);
  }

  async function fetchEvaluationTypes() {
    const { data } = await supabase
      .from('evaluation_types')
      .select('id, code, label')
      .eq('is_active', true)
      .order('sort_order');
    if (data) setEvaluationTypes(data);
  }

  async function fetchDomains() {
    const { data } = await supabase
      .from('domains')
      .select('id, code, label, evaluation_type_id')
      .eq('is_active', true)
      .order('sort_order');
    if (data) setDomains(data);
  }

  async function handleCreate() {
    setSaving(true);

    const payload: Record<string, unknown> = {
      title: formData.title,
      description: formData.description || null,
      organization_id: formData.organization_id || null,
      evaluation_type_id: formData.evaluation_type_id || null,
      domain_id: formData.domain_id || null,
      assessment_period: formData.assessment_period || null,
      target_maturity_score: formData.target_maturity_score,
      start_date: formData.start_date || null,
      end_date: formData.end_date || null,
      status: 'draft',
    };

    const { error } = await supabase.from('assessments').insert([payload]);

    if (error) {
      console.error('Error creating assessment:', error);
    } else {
      setShowModal(false);
      setFormData(emptyForm);
      setWizardStep(1);
      fetchAssessments();
    }
    setSaving(false);
  }

  function handleCloseModal() {
    setShowModal(false);
    setFormData(emptyForm);
    setWizardStep(1);
  }

  function handleOpenCreate() {
    setFormData(emptyForm);
    setWizardStep(1);
    setShowModal(true);
  }

  // Filter domains by selected evaluation type
  const filteredDomains = formData.evaluation_type_id
    ? domains.filter((d) => d.evaluation_type_id === formData.evaluation_type_id)
    : domains;

  // Filter assessments
  const filteredAssessments = assessments.filter((a) => {
    const matchesSearch = !searchTerm || a.title.toLowerCase().includes(searchTerm.toLowerCase());
    const matchesStatus = !filterStatus || a.status === filterStatus;
    const matchesEvalType = !filterEvalType || a.evaluation_type_id === filterEvalType;
    return matchesSearch && matchesStatus && matchesEvalType;
  });

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
          <ClipboardCheck className="h-7 w-7 text-emerald-600" />
          <h1 className="text-2xl font-bold text-slate-800">Assessments</h1>
        </div>
        <button
          onClick={handleOpenCreate}
          className="flex items-center gap-2 px-4 py-2 bg-emerald-600 text-white text-sm font-medium rounded-lg hover:bg-emerald-700 transition-colors"
        >
          <Plus className="h-4 w-4" />
          Create Assessment
        </button>
      </div>

      {/* Search & Filters */}
      <div className="bg-white rounded-lg shadow-sm border border-slate-200 p-4 mb-6">
        <div className="flex items-center gap-3">
          <div className="relative flex-1">
            <Search className="absolute left-3 top-1/2 -translate-y-1/2 h-4 w-4 text-slate-400" />
            <input
              type="text"
              placeholder="Search assessments by title..."
              value={searchTerm}
              onChange={(e) => setSearchTerm(e.target.value)}
              className="w-full pl-10 pr-4 py-2 border border-slate-300 rounded-lg text-sm focus:outline-none focus:ring-2 focus:ring-emerald-500 focus:border-emerald-500"
            />
          </div>
          <button
            onClick={() => setShowFilters(!showFilters)}
            className={`flex items-center gap-2 px-3 py-2 text-sm font-medium rounded-lg border transition-colors ${
              showFilters || filterStatus || filterEvalType
                ? 'border-emerald-300 bg-emerald-50 text-emerald-700'
                : 'border-slate-300 text-slate-600 hover:bg-slate-50'
            }`}
          >
            <Filter className="h-4 w-4" />
            Filters
            {(filterStatus || filterEvalType) && (
              <span className="ml-1 px-1.5 py-0.5 text-xs bg-emerald-600 text-white rounded-full">
                {(filterStatus ? 1 : 0) + (filterEvalType ? 1 : 0)}
              </span>
            )}
          </button>
        </div>

        {showFilters && (
          <div className="mt-4 pt-4 border-t border-slate-200 flex items-center gap-4">
            <div className="flex-1">
              <label className="block text-xs font-medium text-slate-500 mb-1">Status</label>
              <select
                value={filterStatus}
                onChange={(e) => setFilterStatus(e.target.value)}
                className="w-full px-3 py-2 border border-slate-300 rounded-lg text-sm focus:outline-none focus:ring-2 focus:ring-emerald-500 focus:border-emerald-500"
              >
                <option value="">All Statuses</option>
                <option value="draft">Draft</option>
                <option value="in_progress">In Progress</option>
                <option value="under_review">Under Review</option>
                <option value="approved">Approved</option>
                <option value="closed">Closed</option>
              </select>
            </div>
            <div className="flex-1">
              <label className="block text-xs font-medium text-slate-500 mb-1">Evaluation Type</label>
              <select
                value={filterEvalType}
                onChange={(e) => setFilterEvalType(e.target.value)}
                className="w-full px-3 py-2 border border-slate-300 rounded-lg text-sm focus:outline-none focus:ring-2 focus:ring-emerald-500 focus:border-emerald-500"
              >
                <option value="">All Types</option>
                {evaluationTypes.map((et) => (
                  <option key={et.id} value={et.id}>
                    {et.label}
                  </option>
                ))}
              </select>
            </div>
            {(filterStatus || filterEvalType) && (
              <button
                onClick={() => {
                  setFilterStatus('');
                  setFilterEvalType('');
                }}
                className="mt-5 px-3 py-2 text-xs text-slate-500 hover:text-slate-700 transition-colors"
              >
                Clear
              </button>
            )}
          </div>
        )}
      </div>

      {/* Table */}
      <div className="bg-white rounded-lg shadow-sm border border-slate-200 overflow-hidden">
        <div className="overflow-x-auto">
          <table className="w-full text-sm">
            <thead className="bg-slate-100">
              <tr>
                <th className="text-left px-4 py-3 font-semibold text-slate-600">Title</th>
                <th className="text-left px-4 py-3 font-semibold text-slate-600">Organization</th>
                <th className="text-left px-4 py-3 font-semibold text-slate-600">Evaluation Type</th>
                <th className="text-left px-4 py-3 font-semibold text-slate-600">Period</th>
                <th className="text-left px-4 py-3 font-semibold text-slate-600">Status</th>
                <th className="text-left px-4 py-3 font-semibold text-slate-600">Score</th>
                <th className="text-left px-4 py-3 font-semibold text-slate-600">Created</th>
                <th className="text-right px-4 py-3 font-semibold text-slate-600"></th>
              </tr>
            </thead>
            <tbody className="divide-y divide-slate-100">
              {filteredAssessments.map((assessment) => {
                const badge = getStatusBadge(assessment.status);
                return (
                  <tr key={assessment.id} className="hover:bg-slate-50 transition-colors group">
                    <td className="px-4 py-3">
                      <Link
                        to={`/assessments/${assessment.id}`}
                        className="font-medium text-slate-800 hover:text-emerald-600 transition-colors"
                      >
                        {assessment.title}
                      </Link>
                    </td>
                    <td className="px-4 py-3 text-slate-600">
                      {assessment.organizations?.name || '—'}
                    </td>
                    <td className="px-4 py-3 text-slate-600">
                      {assessment.evaluation_types?.label || '—'}
                    </td>
                    <td className="px-4 py-3 text-slate-600">
                      {assessment.assessment_period || '—'}
                    </td>
                    <td className="px-4 py-3">
                      <span
                        className={`inline-block px-2 py-0.5 rounded text-xs font-medium ${badge.bg} ${badge.text}`}
                      >
                        {formatStatus(assessment.status)}
                      </span>
                    </td>
                    <td className="px-4 py-3 text-slate-600">
                      {assessment.overall_score != null
                        ? assessment.overall_score.toFixed(1)
                        : assessment.current_maturity_score != null
                        ? assessment.current_maturity_score.toFixed(1)
                        : '—'}
                    </td>
                    <td className="px-4 py-3 text-slate-500 text-xs">
                      {assessment.created_at
                        ? new Date(assessment.created_at).toLocaleDateString()
                        : '—'}
                    </td>
                    <td className="px-4 py-3 text-right">
                      <Link
                        to={`/assessments/${assessment.id}`}
                        className="inline-flex items-center text-slate-400 hover:text-emerald-600 transition-colors opacity-0 group-hover:opacity-100"
                      >
                        <ChevronRight className="h-4 w-4" />
                      </Link>
                    </td>
                  </tr>
                );
              })}
            </tbody>
          </table>

          {filteredAssessments.length === 0 && (
            <div className="text-center py-12 text-slate-500">
              <ClipboardCheck className="h-8 w-8 mx-auto mb-2 text-slate-300" />
              <p>No assessments found.</p>
              {(searchTerm || filterStatus || filterEvalType) && (
                <p className="text-xs mt-1 text-slate-400">Try adjusting your search or filters.</p>
              )}
            </div>
          )}
        </div>
      </div>

      {/* Create Assessment Modal/Wizard */}
      {showModal && (
        <div className="fixed inset-0 z-50 flex items-center justify-center">
          <div className="absolute inset-0 bg-black/50" onClick={handleCloseModal} />
          <div className="relative bg-white rounded-xl shadow-xl w-full max-w-lg mx-4 max-h-[90vh] overflow-y-auto">
            {/* Modal Header */}
            <div className="flex items-center justify-between px-6 py-4 border-b border-slate-200 sticky top-0 bg-white rounded-t-xl">
              <div>
                <h2 className="text-lg font-semibold text-slate-800">Create Assessment</h2>
                <p className="text-xs text-slate-500 mt-0.5">
                  Step {wizardStep} of 3
                </p>
              </div>
              <button
                onClick={handleCloseModal}
                className="p-1 text-slate-400 hover:text-slate-600 rounded"
              >
                <X className="h-5 w-5" />
              </button>
            </div>

            {/* Step Indicator */}
            <div className="px-6 pt-4">
              <div className="flex items-center gap-2">
                {[1, 2, 3].map((step) => (
                  <div key={step} className="flex-1 flex items-center">
                    <div
                      className={`h-2 rounded-full flex-1 transition-colors ${
                        step <= wizardStep ? 'bg-emerald-500' : 'bg-slate-200'
                      }`}
                    />
                  </div>
                ))}
              </div>
              <div className="flex justify-between mt-1">
                <span className="text-xs text-slate-500">Basic Info</span>
                <span className="text-xs text-slate-500">Configuration</span>
                <span className="text-xs text-slate-500">Schedule</span>
              </div>
            </div>

            {/* Step 1: Basic Info */}
            {wizardStep === 1 && (
              <div className="px-6 py-4 space-y-4">
                <div>
                  <label className="block text-sm font-medium text-slate-700 mb-1">
                    Title <span className="text-red-500">*</span>
                  </label>
                  <input
                    type="text"
                    value={formData.title}
                    onChange={(e) => setFormData({ ...formData, title: e.target.value })}
                    className="w-full px-3 py-2 border border-slate-300 rounded-lg text-sm focus:outline-none focus:ring-2 focus:ring-emerald-500 focus:border-emerald-500"
                    placeholder="e.g. Q1 2024 IT Governance Assessment"
                  />
                </div>
                <div>
                  <label className="block text-sm font-medium text-slate-700 mb-1">Description</label>
                  <textarea
                    value={formData.description}
                    onChange={(e) => setFormData({ ...formData, description: e.target.value })}
                    rows={3}
                    className="w-full px-3 py-2 border border-slate-300 rounded-lg text-sm focus:outline-none focus:ring-2 focus:ring-emerald-500 focus:border-emerald-500 resize-none"
                    placeholder="Brief description of the assessment scope and objectives..."
                  />
                </div>
                <div>
                  <label className="block text-sm font-medium text-slate-700 mb-1">
                    Organization <span className="text-red-500">*</span>
                  </label>
                  <select
                    value={formData.organization_id}
                    onChange={(e) => setFormData({ ...formData, organization_id: e.target.value })}
                    className="w-full px-3 py-2 border border-slate-300 rounded-lg text-sm focus:outline-none focus:ring-2 focus:ring-emerald-500 focus:border-emerald-500"
                  >
                    <option value="">Select an organization</option>
                    {organizations.map((org) => (
                      <option key={org.id} value={org.id}>
                        {org.name}
                      </option>
                    ))}
                  </select>
                </div>
              </div>
            )}

            {/* Step 2: Configuration */}
            {wizardStep === 2 && (
              <div className="px-6 py-4 space-y-4">
                <div>
                  <label className="block text-sm font-medium text-slate-700 mb-1">
                    Evaluation Type <span className="text-red-500">*</span>
                  </label>
                  <select
                    value={formData.evaluation_type_id}
                    onChange={(e) =>
                      setFormData({ ...formData, evaluation_type_id: e.target.value, domain_id: '' })
                    }
                    className="w-full px-3 py-2 border border-slate-300 rounded-lg text-sm focus:outline-none focus:ring-2 focus:ring-emerald-500 focus:border-emerald-500"
                  >
                    <option value="">Select evaluation type</option>
                    {evaluationTypes.map((et) => (
                      <option key={et.id} value={et.id}>
                        {et.label}
                      </option>
                    ))}
                  </select>
                </div>
                <div>
                  <label className="block text-sm font-medium text-slate-700 mb-1">
                    Domain Scope{' '}
                    <span className="text-slate-400 font-normal">(optional)</span>
                  </label>
                  <select
                    value={formData.domain_id}
                    onChange={(e) => setFormData({ ...formData, domain_id: e.target.value })}
                    className="w-full px-3 py-2 border border-slate-300 rounded-lg text-sm focus:outline-none focus:ring-2 focus:ring-emerald-500 focus:border-emerald-500"
                    disabled={!formData.evaluation_type_id}
                  >
                    <option value="">All domains (full evaluation)</option>
                    {filteredDomains.map((d) => (
                      <option key={d.id} value={d.id}>
                        {d.label}
                      </option>
                    ))}
                  </select>
                  {!formData.evaluation_type_id && (
                    <p className="text-xs text-slate-400 mt-1">
                      Select an evaluation type first to filter domains.
                    </p>
                  )}
                </div>
                <div>
                  <label className="block text-sm font-medium text-slate-700 mb-1">
                    Assessment Period
                  </label>
                  <input
                    type="text"
                    value={formData.assessment_period}
                    onChange={(e) => setFormData({ ...formData, assessment_period: e.target.value })}
                    className="w-full px-3 py-2 border border-slate-300 rounded-lg text-sm focus:outline-none focus:ring-2 focus:ring-emerald-500 focus:border-emerald-500"
                    placeholder="e.g. Q1 2024, FY2024, Jan-Mar 2024"
                  />
                </div>
                <div>
                  <label className="block text-sm font-medium text-slate-700 mb-1">
                    Target Maturity Score (0–5)
                  </label>
                  <div className="flex items-center gap-4">
                    <input
                      type="range"
                      min={0}
                      max={5}
                      step={0.5}
                      value={formData.target_maturity_score}
                      onChange={(e) =>
                        setFormData({ ...formData, target_maturity_score: parseFloat(e.target.value) })
                      }
                      className="flex-1 h-2 bg-slate-200 rounded-lg appearance-none cursor-pointer accent-emerald-600"
                    />
                    <span className="text-sm font-semibold text-slate-700 w-8 text-center">
                      {formData.target_maturity_score}
                    </span>
                  </div>
                </div>
              </div>
            )}

            {/* Step 3: Schedule */}
            {wizardStep === 3 && (
              <div className="px-6 py-4 space-y-4">
                <div>
                  <label className="block text-sm font-medium text-slate-700 mb-1">Start Date</label>
                  <input
                    type="date"
                    value={formData.start_date}
                    onChange={(e) => setFormData({ ...formData, start_date: e.target.value })}
                    className="w-full px-3 py-2 border border-slate-300 rounded-lg text-sm focus:outline-none focus:ring-2 focus:ring-emerald-500 focus:border-emerald-500"
                  />
                </div>
                <div>
                  <label className="block text-sm font-medium text-slate-700 mb-1">End Date</label>
                  <input
                    type="date"
                    value={formData.end_date}
                    onChange={(e) => setFormData({ ...formData, end_date: e.target.value })}
                    className="w-full px-3 py-2 border border-slate-300 rounded-lg text-sm focus:outline-none focus:ring-2 focus:ring-emerald-500 focus:border-emerald-500"
                  />
                </div>

                {/* Summary */}
                <div className="mt-4 p-4 bg-slate-50 rounded-lg border border-slate-200">
                  <h4 className="text-sm font-semibold text-slate-700 mb-2">Summary</h4>
                  <dl className="space-y-1 text-xs">
                    <div className="flex justify-between">
                      <dt className="text-slate-500">Title:</dt>
                      <dd className="text-slate-700 font-medium">{formData.title || '—'}</dd>
                    </div>
                    <div className="flex justify-between">
                      <dt className="text-slate-500">Organization:</dt>
                      <dd className="text-slate-700 font-medium">
                        {organizations.find((o) => o.id === formData.organization_id)?.name || '—'}
                      </dd>
                    </div>
                    <div className="flex justify-between">
                      <dt className="text-slate-500">Evaluation Type:</dt>
                      <dd className="text-slate-700 font-medium">
                        {evaluationTypes.find((et) => et.id === formData.evaluation_type_id)?.label || '—'}
                      </dd>
                    </div>
                    <div className="flex justify-between">
                      <dt className="text-slate-500">Period:</dt>
                      <dd className="text-slate-700 font-medium">{formData.assessment_period || '—'}</dd>
                    </div>
                    <div className="flex justify-between">
                      <dt className="text-slate-500">Target Score:</dt>
                      <dd className="text-slate-700 font-medium">{formData.target_maturity_score}</dd>
                    </div>
                    <div className="flex justify-between">
                      <dt className="text-slate-500">Dates:</dt>
                      <dd className="text-slate-700 font-medium">
                        {formData.start_date || '—'} → {formData.end_date || '—'}
                      </dd>
                    </div>
                  </dl>
                </div>
              </div>
            )}

            {/* Modal Footer */}
            <div className="flex items-center justify-between px-6 py-4 border-t border-slate-200 sticky bottom-0 bg-white rounded-b-xl">
              <button
                onClick={() => {
                  if (wizardStep > 1) setWizardStep(wizardStep - 1);
                  else handleCloseModal();
                }}
                className="px-4 py-2 text-sm font-medium text-slate-600 hover:text-slate-800 transition-colors"
              >
                {wizardStep === 1 ? 'Cancel' : 'Back'}
              </button>
              <div className="flex items-center gap-2">
                {wizardStep < 3 ? (
                  <button
                    onClick={() => setWizardStep(wizardStep + 1)}
                    disabled={
                      (wizardStep === 1 && (!formData.title || !formData.organization_id)) ||
                      (wizardStep === 2 && !formData.evaluation_type_id)
                    }
                    className="px-4 py-2 bg-emerald-600 text-white text-sm font-medium rounded-lg hover:bg-emerald-700 disabled:opacity-50 disabled:cursor-not-allowed transition-colors"
                  >
                    Next
                  </button>
                ) : (
                  <button
                    onClick={handleCreate}
                    disabled={saving || !formData.title || !formData.organization_id || !formData.evaluation_type_id}
                    className="px-4 py-2 bg-emerald-600 text-white text-sm font-medium rounded-lg hover:bg-emerald-700 disabled:opacity-50 disabled:cursor-not-allowed transition-colors"
                  >
                    {saving ? 'Creating...' : 'Create Assessment'}
                  </button>
                )}
              </div>
            </div>
          </div>
        </div>
      )}
    </div>
  );
}
