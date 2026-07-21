import { useState, useEffect } from 'react';
import { supabase } from '../../lib/supabase';
import { FileText, CheckCircle2, Clock, XCircle } from 'lucide-react';

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

export default function AssessmentEvidence({ assessmentId }: { assessmentId: string }) {
  const [evidence, setEvidence] = useState<Evidence[]>([]);
  const [loading, setLoading] = useState(true);

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
        <span className="text-sm text-gray-500">{evidence.length} items</span>
      </div>

      {evidence.length === 0 ? (
        <div className="bg-white rounded-lg border p-10 text-center">
          <FileText className="w-10 h-10 mx-auto text-gray-300 mb-3" />
          <p className="text-gray-500 text-sm">No evidence attached yet. Add evidence from the Workspace tab.</p>
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
    </div>
  );
}
