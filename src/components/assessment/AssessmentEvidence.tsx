import { useState, useEffect } from 'react';
import { supabase } from '../../lib/supabase';
import { FileText, CheckCircle2, Clock, XCircle, Plus, X } from 'lucide-react';

interface Evidence {
  id: string;
  evidence_name: string;
  evidence_type: string | null;
  evidence_category: string | null;
  validation_status: string | null;
  document_date: string | null;
  evidence_owner: string | null;
  created_at: string;
  assessment_responses?: { question_id: string; questions?: { question_code: string } | null } | null;
}

interface ResponseOption {
  id: string;
  question_code: string;
}

const EVIDENCE_TYPES = ['Document', 'Screenshot', 'Interview', 'Observation', 'Audit Trail', 'Other'];
const EVIDENCE_CATEGORIES = ['Policy', 'Procedure', 'Record', 'Report', 'Configuration', 'Communication', 'Other'];

export default function AssessmentEvidence({ assessmentId }: { assessmentId: string }) {
  const [evidence, setEvidence] = useState<Evidence[]>([]);
  const [loading, setLoading] = useState(true);
  const [showForm, setShowForm] = useState(false);
  const [responses, setResponses] = useState<ResponseOption[]>([]);
  const [saving, setSaving] = useState(false);
  const [formData, setFormData] = useState({
    assessment_response_id: '',
    evidence_name: '',
    evidence_type: '',
    evidence_category: '',
    evidence_owner: '',
    document_date: '',
  });

  useEffect(() => { fetchEvidence(); }, [assessmentId]);

  async function fetchEvidence() {
    setLoading(true);
    const { data } = await supabase
      .from('assessment_evidence')
      .select('id, evidence_name, evidence_type, evidence_category, validation_status, document_date, evidence_owner, created_at, assessment_responses!inner(question_id, questions(question_code))')
      .eq('assessment_responses.assessment_id', assessmentId)
      .order('created_at', { ascending: false });
    setEvidence((data as Evidence[]) || []);
    setLoading(false);
  }

  async function fetchResponses() {
    const { data } = await supabase
      .from('assessment_responses')
      .select('id, questions(question_code)')
      .eq('assessment_id', assessmentId)
      .order('created_at');
    setResponses(
      (data || []).map((r: any) => ({
        id: r.id,
        question_code: r.questions?.question_code || r.id.slice(0, 8),
      }))
    );
  }

  function openForm() {
    setFormData({ assessment_response_id: '', evidence_name: '', evidence_type: '', evidence_category: '', evidence_owner: '', document_date: '' });
    fetchResponses();
    setShowForm(true);
  }

  async function handleSubmit(e: React.FormEvent) {
    e.preventDefault();
    setSaving(true);
    const payload: Record<string, unknown> = {
      assessment_response_id: formData.assessment_response_id,
      evidence_name: formData.evidence_name,
    };
    if (formData.evidence_type) payload.evidence_type = formData.evidence_type;
    if (formData.evidence_category) payload.evidence_category = formData.evidence_category;
    if (formData.evidence_owner) payload.evidence_owner = formData.evidence_owner;
    if (formData.document_date) payload.document_date = formData.document_date;

    const { error } = await supabase.from('assessment_evidence').insert(payload);
    setSaving(false);
    if (!error) {
      setShowForm(false);
      fetchEvidence();
    }
  }

  const statusIcon = (status: string | null) => {
    if (status === 'validated') return <CheckCircle2 className="w-4 h-4 text-emerald-500" />;
    if (status === 'rejected') return <XCircle className="w-4 h-4 text-red-500" />;
    return <Clock className="w-4 h-4 text-gray-400" />;
  };

  if (loading) return <div className="flex items-center justify-center h-48"><div className="animate-spin rounded-full h-6 w-6 border-b-2 border-emerald-600" /></div>;

  return (
    <div className="p-6 max-w-5xl mx-auto space-y-4">
      <div className="flex items-center justify-between">
        <h2 className="text-lg font-semibold text-gray-800">Evidence Register</h2>
        <div className="flex items-center gap-3">
          <span className="text-sm text-gray-500">{evidence.length} items</span>
          <button onClick={openForm}
            className="flex items-center gap-1.5 px-3 py-1.5 text-xs font-medium bg-emerald-600 text-white rounded-md hover:bg-emerald-700">
            <Plus className="w-3.5 h-3.5" /> Add Evidence
          </button>
        </div>
      </div>

      {evidence.length === 0 ? (
        <div className="bg-white rounded-lg border p-10 text-center">
          <FileText className="w-10 h-10 mx-auto text-gray-300 mb-3" />
          <p className="text-gray-500 text-sm">No evidence attached yet. Click "Add Evidence" to get started.</p>
        </div>
      ) : (
        <div className="bg-white rounded-lg border overflow-hidden">
          <table className="w-full text-sm">
            <thead className="bg-gray-50 border-b">
              <tr>
                <th className="px-4 py-2.5 text-left font-medium text-gray-600">Status</th>
                <th className="px-4 py-2.5 text-left font-medium text-gray-600">Name</th>
                <th className="px-4 py-2.5 text-left font-medium text-gray-600">Type</th>
                <th className="px-4 py-2.5 text-left font-medium text-gray-600">Category</th>
                <th className="px-4 py-2.5 text-left font-medium text-gray-600">Question</th>
                <th className="px-4 py-2.5 text-left font-medium text-gray-600">Date</th>
              </tr>
            </thead>
            <tbody className="divide-y">
              {evidence.map((e) => (
                <tr key={e.id} className="hover:bg-gray-50">
                  <td className="px-4 py-2.5">{statusIcon(e.validation_status)}</td>
                  <td className="px-4 py-2.5 font-medium text-gray-800">{e.evidence_name}</td>
                  <td className="px-4 py-2.5 text-gray-600">{e.evidence_type || '—'}</td>
                  <td className="px-4 py-2.5 text-gray-600">{e.evidence_category || '—'}</td>
                  <td className="px-4 py-2.5 text-gray-500 font-mono text-xs">{(e.assessment_responses as any)?.questions?.question_code || '—'}</td>
                  <td className="px-4 py-2.5 text-gray-500 text-xs">{e.document_date || '—'}</td>
                </tr>
              ))}
            </tbody>
          </table>
        </div>
      )}

      {showForm && (
        <div className="fixed inset-0 bg-black/40 flex items-center justify-center z-50 p-4">
          <div className="bg-white rounded-xl shadow-2xl w-full max-w-md">
            <div className="flex items-center justify-between px-5 py-4 border-b">
              <h3 className="font-semibold text-gray-800">Add Evidence</h3>
              <button onClick={() => setShowForm(false)} className="text-gray-400 hover:text-gray-600"><X className="w-5 h-5" /></button>
            </div>
            <form onSubmit={handleSubmit} className="p-5 space-y-4">
              <div>
                <label className="block text-sm font-medium text-gray-700 mb-1">Question (Response)</label>
                <select required value={formData.assessment_response_id} onChange={(e) => setFormData({ ...formData, assessment_response_id: e.target.value })}
                  className="w-full px-3 py-2 border border-gray-200 rounded-lg text-sm focus:outline-none focus:ring-2 focus:ring-emerald-500">
                  <option value="">Select a question...</option>
                  {responses.map((r) => <option key={r.id} value={r.id}>{r.question_code}</option>)}
                </select>
              </div>
              <div>
                <label className="block text-sm font-medium text-gray-700 mb-1">Evidence Name</label>
                <input type="text" required value={formData.evidence_name} onChange={(e) => setFormData({ ...formData, evidence_name: e.target.value })}
                  className="w-full px-3 py-2 border border-gray-200 rounded-lg text-sm focus:outline-none focus:ring-2 focus:ring-emerald-500" placeholder="e.g. IT Security Policy v3.2" />
              </div>
              <div className="grid grid-cols-2 gap-3">
                <div>
                  <label className="block text-sm font-medium text-gray-700 mb-1">Type</label>
                  <select value={formData.evidence_type} onChange={(e) => setFormData({ ...formData, evidence_type: e.target.value })}
                    className="w-full px-3 py-2 border border-gray-200 rounded-lg text-sm focus:outline-none focus:ring-2 focus:ring-emerald-500">
                    <option value="">Select...</option>
                    {EVIDENCE_TYPES.map((t) => <option key={t} value={t}>{t}</option>)}
                  </select>
                </div>
                <div>
                  <label className="block text-sm font-medium text-gray-700 mb-1">Category</label>
                  <select value={formData.evidence_category} onChange={(e) => setFormData({ ...formData, evidence_category: e.target.value })}
                    className="w-full px-3 py-2 border border-gray-200 rounded-lg text-sm focus:outline-none focus:ring-2 focus:ring-emerald-500">
                    <option value="">Select...</option>
                    {EVIDENCE_CATEGORIES.map((c) => <option key={c} value={c}>{c}</option>)}
                  </select>
                </div>
              </div>
              <div className="grid grid-cols-2 gap-3">
                <div>
                  <label className="block text-sm font-medium text-gray-700 mb-1">Owner</label>
                  <input type="text" value={formData.evidence_owner} onChange={(e) => setFormData({ ...formData, evidence_owner: e.target.value })}
                    className="w-full px-3 py-2 border border-gray-200 rounded-lg text-sm focus:outline-none focus:ring-2 focus:ring-emerald-500" placeholder="e.g. John Doe" />
                </div>
                <div>
                  <label className="block text-sm font-medium text-gray-700 mb-1">Document Date</label>
                  <input type="date" value={formData.document_date} onChange={(e) => setFormData({ ...formData, document_date: e.target.value })}
                    className="w-full px-3 py-2 border border-gray-200 rounded-lg text-sm focus:outline-none focus:ring-2 focus:ring-emerald-500" />
                </div>
              </div>
              <div className="flex justify-end gap-2 pt-2">
                <button type="button" onClick={() => setShowForm(false)} className="px-3 py-1.5 text-xs text-gray-600 border rounded-md hover:bg-gray-50">Cancel</button>
                <button type="submit" disabled={saving} className="px-3 py-1.5 text-xs font-medium bg-emerald-600 text-white rounded-md hover:bg-emerald-700 disabled:opacity-50">
                  {saving ? 'Saving...' : 'Save Evidence'}
                </button>
              </div>
            </form>
          </div>
        </div>
      )}
    </div>
  );
}
