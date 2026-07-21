import { useState, useEffect } from 'react';
import { supabase } from '../../lib/supabase';
import { Layers, CheckCircle2, Circle, Plus } from 'lucide-react';

interface ScopeItem {
  id: string;
  domain_id: string;
  process_id: string | null;
  included: boolean;
  domains?: { label: string; code: string };
  processes?: { label: string; code: string } | null;
}

interface Props {
  assessmentId: string;
  evaluationTypeId: string | null;
}

export default function AssessmentScope({ assessmentId, evaluationTypeId }: Props) {
  const [scopeItems, setScopeItems] = useState<ScopeItem[]>([]);
  const [loading, setLoading] = useState(true);
  const [adding, setAdding] = useState(false);

  useEffect(() => { fetchScope(); }, [assessmentId]);

  async function fetchScope() {
    setLoading(true);
    const { data } = await supabase
      .from('assessment_scope_items')
      .select('*, domains(label, code), processes(label, code)')
      .eq('assessment_id', assessmentId)
      .order('created_at');
    setScopeItems((data as ScopeItem[]) || []);
    setLoading(false);
  }

  async function autoPopulateScope() {
    if (!evaluationTypeId) return;
    setAdding(true);

    const { data: domains } = await supabase
      .from('domains')
      .select('id')
      .eq('evaluation_type_id', evaluationTypeId)
      .eq('is_active', true);

    if (domains && domains.length > 0) {
      const items = domains.map(d => ({
        assessment_id: assessmentId,
        domain_id: d.id,
        included: true,
      }));
      await supabase.from('assessment_scope_items').upsert(items, { onConflict: 'assessment_id,domain_id,process_id' });
      await fetchScope();
    }
    setAdding(false);
  }

  const grouped = scopeItems.reduce<Record<string, ScopeItem[]>>((acc, item) => {
    const domainLabel = item.domains?.label || 'Unknown';
    if (!acc[domainLabel]) acc[domainLabel] = [];
    acc[domainLabel].push(item);
    return acc;
  }, {});

  if (loading) {
    return <div className="flex items-center justify-center h-48"><div className="animate-spin rounded-full h-6 w-6 border-b-2 border-emerald-600" /></div>;
  }

  if (scopeItems.length === 0) {
    return (
      <div className="p-6 max-w-4xl mx-auto">
        <div className="bg-white rounded-lg border p-10 text-center">
          <Layers className="w-12 h-12 mx-auto text-gray-300 mb-3" />
          <h3 className="text-lg font-semibold text-gray-700 mb-1">No Scope Defined</h3>
          <p className="text-sm text-gray-500 mb-4">Define the domains and processes included in this assessment.</p>
          <button onClick={autoPopulateScope} disabled={adding || !evaluationTypeId}
            className="inline-flex items-center gap-2 px-4 py-2 bg-emerald-600 text-white text-sm font-medium rounded-lg hover:bg-emerald-700 disabled:opacity-50">
            <Plus className="w-4 h-4" />{adding ? 'Adding...' : 'Auto-populate from Evaluation Type'}
          </button>
        </div>
      </div>
    );
  }

  return (
    <div className="p-6 max-w-4xl mx-auto space-y-4">
      <div className="flex items-center justify-between">
        <h2 className="text-lg font-semibold text-gray-800">Assessment Scope</h2>
        <span className="text-sm text-gray-500">{scopeItems.filter(i => i.included).length} items included</span>
      </div>

      {Object.entries(grouped).map(([domain, items]) => (
        <div key={domain} className="bg-white rounded-lg border overflow-hidden">
          <div className="bg-gray-50 px-4 py-3 border-b flex items-center gap-2">
            <Layers className="w-4 h-4 text-emerald-600" />
            <h3 className="text-sm font-semibold text-gray-700">{domain}</h3>
            <span className="ml-auto text-xs text-gray-500">{items.length} item{items.length > 1 ? 's' : ''}</span>
          </div>
          <div className="divide-y">
            {items.map((item) => (
              <div key={item.id} className="px-4 py-2.5 flex items-center gap-3">
                {item.included ? (
                  <CheckCircle2 className="w-4 h-4 text-emerald-500" />
                ) : (
                  <Circle className="w-4 h-4 text-gray-300" />
                )}
                <span className="text-sm text-gray-700">{item.processes?.label || 'All processes'}</span>
                <span className="text-xs text-gray-400 font-mono">{item.processes?.code || item.domains?.code}</span>
              </div>
            ))}
          </div>
        </div>
      ))}
    </div>
  );
}
