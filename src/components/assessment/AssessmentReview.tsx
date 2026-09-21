import { useState, useEffect } from 'react';
import { supabase } from '../../lib/supabase';
import { Shield, CheckCircle2, Clock, XCircle, Lock } from 'lucide-react';

const GATES = [
  { number: 1, name: 'Completeness', desc: 'All mandatory questions answered, N/A justified, mandatory evidence present.' },
  { number: 2, name: 'Quality Review', desc: 'Reviewer assigned, critical responses reviewed, inconsistencies corrected.' },
  { number: 3, name: 'Findings Validation', desc: 'Potential findings accepted/rejected, severity validated, causes documented.' },
  { number: 4, name: 'Action Plan Validation', desc: 'Each confirmed finding has an action with owner, deadline, and criteria.' },
  { number: 5, name: 'Final Approval', desc: 'Scores recalculated, report generated, final approver signed off.' },
];

interface Gate {
  id: string;
  gate_number: number;
  gate_name: string;
  status: string;
  checked_at: string | null;
  notes: string | null;
}

interface Props {
  assessmentId: string;
  assessment: { status: string; validation_progress: Record<string, boolean> | null };
}

export default function AssessmentReview({ assessmentId, assessment }: Props) {
  const [gates, setGates] = useState<Gate[]>([]);
  const [loading, setLoading] = useState(true);

  useEffect(() => { fetchGates(); }, [assessmentId]);

  async function fetchGates() {
    setLoading(true);
    const { data } = await supabase
      .from('assessment_validation_gates')
      .select('*')
      .eq('assessment_id', assessmentId)
      .order('gate_number');
    setGates(data || []);
    setLoading(false);
  }

  async function initializeGates() {
    const payload = GATES.map(g => ({
      assessment_id: assessmentId,
      gate_number: g.number,
      gate_name: g.name,
      status: 'pending',
    }));
    await supabase.from('assessment_validation_gates').upsert(payload, { onConflict: 'assessment_id,gate_number' });
    fetchGates();
  }

  async function updateGateStatus(gateNumber: number, status: string) {
    await supabase
      .from('assessment_validation_gates')
      .update({ status, checked_at: status === 'passed' ? new Date().toISOString() : null })
      .eq('assessment_id', assessmentId)
      .eq('gate_number', gateNumber);
    fetchGates();
  }

  const statusIcon = (status: string) => {
    if (status === 'passed') return <CheckCircle2 className="w-6 h-6 text-emerald-500" />;
    if (status === 'failed') return <XCircle className="w-6 h-6 text-red-500" />;
    if (status === 'in_progress') return <Clock className="w-6 h-6 text-amber-500" />;
    return <Clock className="w-6 h-6 text-gray-300" />;
  };

  const allPassed = gates.length === 5 && gates.every(g => g.status === 'passed');
  const canClose = allPassed && assessment.status !== 'closed';

  if (loading) return <div className="flex items-center justify-center h-48"><div className="animate-spin rounded-full h-6 w-6 border-b-2 border-emerald-600" /></div>;

  return (
    <div className="p-6 max-w-4xl mx-auto space-y-6">
      <div className="flex items-center justify-between">
        <h2 className="text-lg font-semibold text-gray-800 flex items-center gap-2">
          <Shield className="w-5 h-5 text-emerald-600" /> Review & Approval
        </h2>
        {assessment.status === 'closed' && (
          <span className="flex items-center gap-1.5 px-3 py-1 bg-emerald-100 text-emerald-700 rounded-full text-xs font-medium">
            <Lock className="w-3.5 h-3.5" /> Assessment Closed
          </span>
        )}
      </div>

      {gates.length === 0 ? (
        <div className="bg-white rounded-lg border p-8 text-center">
          <Shield className="w-10 h-10 mx-auto text-gray-300 mb-3" />
          <p className="text-gray-500 text-sm mb-4">Validation gates have not been initialized yet.</p>
          <button onClick={initializeGates}
            className="px-4 py-2 bg-emerald-600 text-white text-sm font-medium rounded-lg hover:bg-emerald-700">
            Initialize Validation Gates
          </button>
        </div>
      ) : (
        <div className="space-y-3">
          {GATES.map((gateInfo) => {
            const gate = gates.find(g => g.gate_number === gateInfo.number);
            const status = gate?.status || 'pending';
            const prevGate = gateInfo.number > 1 ? gates.find(g => g.gate_number === gateInfo.number - 1) : null;
            const isLocked = prevGate && prevGate.status !== 'passed';

            return (
              <div key={gateInfo.number} className={`bg-white rounded-lg border p-5 transition ${isLocked ? 'opacity-50' : ''}`}>
                <div className="flex items-start gap-4">
                  {statusIcon(status)}
                  <div className="flex-1">
                    <div className="flex items-center gap-2">
                      <h3 className="text-sm font-semibold text-gray-800">Gate {gateInfo.number}: {gateInfo.name}</h3>
                      <span className={`text-[10px] px-2 py-0.5 rounded-full font-medium ${
                        status === 'passed' ? 'bg-emerald-100 text-emerald-700' :
                        status === 'failed' ? 'bg-red-100 text-red-700' :
                        status === 'in_progress' ? 'bg-amber-100 text-amber-700' :
                        'bg-gray-100 text-gray-500'
                      }`}>
                        {status.replace(/_/g, ' ').toUpperCase()}
                      </span>
                    </div>
                    <p className="text-xs text-gray-500 mt-1">{gateInfo.desc}</p>
                    {gate?.notes && <p className="text-xs text-gray-600 mt-2 italic">Note: {gate.notes}</p>}
                    {gate?.checked_at && <p className="text-[10px] text-gray-400 mt-1">Checked: {new Date(gate.checked_at).toLocaleString()}</p>}
                  </div>
                  {!isLocked && status !== 'passed' && (
                    <div className="flex gap-2">
                      {status === 'pending' && (
                        <button onClick={() => updateGateStatus(gateInfo.number, 'in_progress')}
                          className="px-3 py-1.5 text-xs font-medium bg-blue-50 text-blue-600 rounded hover:bg-blue-100">
                          Start Review
                        </button>
                      )}
                      {status === 'in_progress' && (
                        <>
                          <button onClick={() => updateGateStatus(gateInfo.number, 'passed')}
                            className="px-3 py-1.5 text-xs font-medium bg-emerald-50 text-emerald-600 rounded hover:bg-emerald-100">
                            Pass
                          </button>
                          <button onClick={() => updateGateStatus(gateInfo.number, 'failed')}
                            className="px-3 py-1.5 text-xs font-medium bg-red-50 text-red-600 rounded hover:bg-red-100">
                            Fail
                          </button>
                        </>
                      )}
                      {status === 'failed' && (
                        <button onClick={() => updateGateStatus(gateInfo.number, 'in_progress')}
                          className="px-3 py-1.5 text-xs font-medium bg-amber-50 text-amber-600 rounded hover:bg-amber-100">
                          Retry
                        </button>
                      )}
                    </div>
                  )}
                </div>
              </div>
            );
          })}

          {/* Final action */}
          <div className="pt-4 border-t">
            {canClose ? (
              <div className="bg-emerald-50 border border-emerald-200 rounded-lg p-4 flex items-center justify-between">
                <div>
                  <p className="text-sm font-semibold text-emerald-700">All gates passed!</p>
                  <p className="text-xs text-emerald-600">The assessment is ready for final closure.</p>
                </div>
                <button
                  onClick={async () => {
                    await supabase
                      .from('assessments')
                      .update({ status: 'closed', approved_at: new Date().toISOString() })
                      .eq('id', assessmentId);
                    window.location.reload();
                  }}
                  className="px-4 py-2 bg-emerald-600 text-white text-sm font-medium rounded-lg hover:bg-emerald-700">
                  Close Assessment
                </button>
              </div>
            ) : (
              <p className="text-xs text-gray-500 text-center">
                All 5 validation gates must pass before the assessment can be closed.
              </p>
            )}
          </div>
        </div>
      )}
    </div>
  );
}
