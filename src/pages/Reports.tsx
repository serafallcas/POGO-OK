import { useState, useEffect } from 'react';
import { supabase } from '../lib/supabase';
import {
  BarChart, Bar, XAxis, YAxis, Tooltip, ResponsiveContainer,
  RadarChart, Radar, PolarGrid, PolarAngleAxis,
} from 'recharts';
import { BarChart3, Download, FileSpreadsheet, Target, Radar as RadarIcon } from 'lucide-react';
import Papa from 'papaparse';

interface Org { id: string; name: string; }
interface EvalType { id: string; label: string; }
interface Assessment { id: string; title: string; status: string; organization_id: string; evaluation_type_id: string; assessment_period: string; }
interface Domain { id: string; label: string; }
interface RadarPoint { domain: string; current: number; target: number; }
interface DomainScore { domain: string; score: number; }
interface Finding { id: string; title: string; severity: string; status: string; condition_text: string | null; }

export default function Reports() {
  const [organizations, setOrganizations] = useState<Org[]>([]);
  const [evalTypes, setEvalTypes] = useState<EvalType[]>([]);
  const [assessments, setAssessments] = useState<Assessment[]>([]);
  const [selectedOrg, setSelectedOrg] = useState('');
  const [selectedType, setSelectedType] = useState('');
  const [selectedAssessment, setSelectedAssessment] = useState('');
  const [domains, setDomains] = useState<Domain[]>([]);
  const [radarData, setRadarData] = useState<RadarPoint[]>([]);
  const [domainScores, setDomainScores] = useState<DomainScore[]>([]);
  const [findings, setFindings] = useState<Finding[]>([]);
  const [evidencePercent, setEvidencePercent] = useState<number | null>(null);

  useEffect(() => {
    supabase.from('organizations').select('*').then(({ data }) => setOrganizations(data || []));
    supabase.from('evaluation_types').select('*').then(({ data }) => setEvalTypes(data || []));
    supabase.from('assessments').select('*').then(({ data }) => setAssessments(data || []));
    supabase.from('domains').select('*').then(({ data }) => setDomains(data || []));
  }, []);

  useEffect(() => {
    if (!selectedAssessment) {
      setRadarData([]);
      setDomainScores([]);
      setFindings([]);
      setEvidencePercent(null);
      return;
    }
    fetchReportData();
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, [selectedAssessment]);

  async function fetchReportData() {
    const { data: responses } = await supabase
      .from('assessment_responses')
      .select('*, questions(question_text, domain_id)')
      .eq('assessment_id', selectedAssessment)
      .eq('review_status', 'validated');

    if (responses && responses.length > 0) {
      const byDomain: Record<string, { scores: number[]; target: number }> = {};
      responses.forEach((r: { score: number | null; questions: { domain_id: string } | null; question_id: string }) => {
        const domainId = r.questions?.domain_id;
        const domain = domains.find((d) => d.id === domainId);
        const domainLabel = domain?.label || 'Unknown';
        if (!byDomain[domainLabel]) byDomain[domainLabel] = { scores: [], target: 4 };
        if (r.score != null) byDomain[domainLabel].scores.push(r.score);
      });

      setRadarData(Object.entries(byDomain).map(([name, d]) => ({
        domain: name.length > 20 ? name.substring(0, 20) + '...' : name,
        current: d.scores.length ? +(d.scores.reduce((a, b) => a + b, 0) / d.scores.length).toFixed(1) : 0,
        target: d.target,
      })));

      setDomainScores(Object.entries(byDomain).map(([name, d]) => ({
        domain: name.length > 25 ? name.substring(0, 25) + '...' : name,
        score: d.scores.length ? +(d.scores.reduce((a, b) => a + b, 0) / d.scores.length).toFixed(1) : 0,
      })));

      const { data: evidenceData } = await supabase
        .from('assessment_evidence')
        .select('assessment_response_id, assessment_responses!inner(question_id)')
        .eq('assessment_responses.assessment_id', selectedAssessment);

      const questionsWithEvidence = new Set(
        (evidenceData || []).map((e: any) => (e.assessment_responses as any)?.question_id).filter(Boolean)
      );
      const totalQuestionIds = new Set(responses.map((r: { question_id: string }) => r.question_id));
      setEvidencePercent(
        totalQuestionIds.size > 0
          ? Math.round((questionsWithEvidence.size / totalQuestionIds.size) * 100)
          : null
      );
    } else {
      setRadarData([]);
      setDomainScores([]);
      setEvidencePercent(null);
    }

    const { data: findingsData } = await supabase
      .from('assessment_findings_v2')
      .select('id, title, severity, status, condition_text')
      .eq('assessment_id', selectedAssessment)
      .order('severity', { ascending: false })
      .limit(10);
    setFindings(findingsData || []);
  }

  function exportAssessmentSummary() {
    const rows = domainScores.map((d) => ({ Domain: d.domain, 'Average Score': d.score }));
    const csv = Papa.unparse(rows);
    downloadCSV(csv, 'assessment_summary.csv');
  }

  function exportFindingsRegister() {
    const rows = findings.map((f) => ({
      Title: f.title || '',
      Severity: f.severity || '',
      Status: f.status || '',
      Condition: f.condition_text || '',
    }));
    const csv = Papa.unparse(rows);
    downloadCSV(csv, 'findings_register.csv');
  }

  function downloadCSV(csv: string, filename: string) {
    const blob = new Blob([csv], { type: 'text/csv;charset=utf-8;' });
    const url = URL.createObjectURL(blob);
    const a = document.createElement('a');
    a.href = url;
    a.download = filename;
    a.click();
    URL.revokeObjectURL(url);
  }

  const filteredAssessments = assessments.filter((a) => {
    if (selectedOrg && a.organization_id !== selectedOrg) return false;
    if (selectedType && a.evaluation_type_id !== selectedType) return false;
    return true;
  });

  const periods = [...new Set(assessments.map((a) => a.assessment_period).filter(Boolean))];

  return (
    <div className="space-y-6">
      <div className="flex items-center justify-between">
        <div className="flex items-center gap-2">
          <BarChart3 className="h-6 w-6 text-emerald-600" />
          <h1 className="text-2xl font-bold text-gray-900">Reports & Export</h1>
        </div>
        <div className="flex gap-2">
          <button onClick={exportAssessmentSummary} disabled={!domainScores.length} className="flex items-center gap-2 px-4 py-2 bg-emerald-600 text-white rounded-lg hover:bg-emerald-700 disabled:opacity-50 disabled:cursor-not-allowed text-sm font-medium">
            <Download className="h-4 w-4" /> Export Summary
          </button>
          <button onClick={exportFindingsRegister} disabled={!findings.length} className="flex items-center gap-2 px-4 py-2 bg-slate-700 text-white rounded-lg hover:bg-slate-800 disabled:opacity-50 disabled:cursor-not-allowed text-sm font-medium">
            <FileSpreadsheet className="h-4 w-4" /> Export Findings
          </button>
        </div>
      </div>

      {/* Filter Bar */}
      <div className="bg-white rounded-xl shadow-sm border border-gray-200 p-4">
        <div className="grid grid-cols-1 md:grid-cols-4 gap-4">
          <select value={selectedOrg} onChange={(e) => setSelectedOrg(e.target.value)} className="border border-gray-300 rounded-lg px-3 py-2 text-sm">
            <option value="">All Organizations</option>
            {organizations.map((o) => <option key={o.id} value={o.id}>{o.name}</option>)}
          </select>
          <select value={selectedType} onChange={(e) => setSelectedType(e.target.value)} className="border border-gray-300 rounded-lg px-3 py-2 text-sm">
            <option value="">All Evaluation Types</option>
            {evalTypes.map((t) => <option key={t.id} value={t.id}>{t.label}</option>)}
          </select>
          <select value={selectedAssessment} onChange={(e) => setSelectedAssessment(e.target.value)} className="border border-gray-300 rounded-lg px-3 py-2 text-sm">
            <option value="">Select Assessment</option>
            {filteredAssessments.map((a) => <option key={a.id} value={a.id}>{a.title || a.id}</option>)}
          </select>
          <select className="border border-gray-300 rounded-lg px-3 py-2 text-sm">
            <option value="">All Periods</option>
            {periods.map((p) => <option key={p} value={p}>{p}</option>)}
          </select>
        </div>
      </div>

      {!selectedAssessment ? (
        <div className="bg-white rounded-xl shadow-sm border border-gray-200 p-12 text-center">
          <RadarIcon className="h-12 w-12 text-gray-300 mx-auto mb-4" />
          <h3 className="text-lg font-medium text-gray-600">Select an assessment to view reports</h3>
          <p className="text-gray-400 mt-1">Use the filters above to choose an assessment</p>
        </div>
      ) : (
        <div className="grid grid-cols-1 lg:grid-cols-2 gap-6">
          {/* Maturity Radar Chart */}
          <div className="bg-white rounded-xl shadow-sm border border-gray-200 p-6">
            <div className="flex items-center gap-2 mb-4">
              <Target className="h-5 w-5 text-emerald-600" />
              <h2 className="text-lg font-semibold text-gray-900">Maturity Radar</h2>
            </div>
            {radarData.length ? (
              <ResponsiveContainer width="100%" height={280}>
                <RadarChart data={radarData}>
                  <PolarGrid />
                  <PolarAngleAxis dataKey="domain" tick={{ fontSize: 11 }} />
                  <Radar name="Current" dataKey="current" stroke="#10b981" fill="#10b981" fillOpacity={0.3} />
                  <Radar name="Target" dataKey="target" stroke="#f59e0b" fill="#f59e0b" fillOpacity={0.1} />
                  <Tooltip />
                </RadarChart>
              </ResponsiveContainer>
            ) : (
              <p className="text-gray-400 text-center py-12">No maturity data available</p>
            )}
          </div>

          {/* Score by Domain */}
          <div className="bg-white rounded-xl shadow-sm border border-gray-200 p-6">
            <div className="flex items-center gap-2 mb-4">
              <BarChart3 className="h-5 w-5 text-blue-600" />
              <h2 className="text-lg font-semibold text-gray-900">Score by Domain</h2>
            </div>
            {domainScores.length ? (
              <ResponsiveContainer width="100%" height={280}>
                <BarChart data={domainScores} layout="vertical" margin={{ left: 80 }}>
                  <XAxis type="number" domain={[0, 5]} />
                  <YAxis type="category" dataKey="domain" tick={{ fontSize: 11 }} width={75} />
                  <Tooltip />
                  <Bar dataKey="score" fill="#10b981" radius={[0, 4, 4, 0]} />
                </BarChart>
              </ResponsiveContainer>
            ) : (
              <p className="text-gray-400 text-center py-12">No score data available</p>
            )}
          </div>

          {/* Findings Summary */}
          <div className="bg-white rounded-xl shadow-sm border border-gray-200 p-6">
            <h2 className="text-lg font-semibold text-gray-900 mb-4">Findings Summary</h2>
            {findings.length ? (
              <div className="overflow-auto max-h-64">
                <table className="w-full text-sm">
                  <thead className="bg-gray-50">
                    <tr>
                      <th className="text-left px-3 py-2 font-medium text-gray-600">Title</th>
                      <th className="text-left px-3 py-2 font-medium text-gray-600">Severity</th>
                      <th className="text-left px-3 py-2 font-medium text-gray-600">Status</th>
                    </tr>
                  </thead>
                  <tbody className="divide-y divide-gray-100">
                    {findings.map((f) => (
                      <tr key={f.id}>
                        <td className="px-3 py-2 text-gray-800">{f.title}</td>
                        <td className="px-3 py-2">
                          <span className={`px-2 py-0.5 rounded-full text-xs font-medium ${f.severity === 'critical' ? 'bg-red-100 text-red-700' : f.severity === 'high' ? 'bg-orange-100 text-orange-700' : f.severity === 'medium' ? 'bg-yellow-100 text-yellow-700' : 'bg-gray-100 text-gray-700'}`}>
                            {f.severity}
                          </span>
                        </td>
                        <td className="px-3 py-2 text-gray-600">{f.status}</td>
                      </tr>
                    ))}
                  </tbody>
                </table>
              </div>
            ) : (
              <p className="text-gray-400 text-center py-12">No findings for this assessment</p>
            )}
          </div>

          {/* Evidence Completeness */}
          <div className="bg-white rounded-xl shadow-sm border border-gray-200 p-6">
            <h2 className="text-lg font-semibold text-gray-900 mb-4">Evidence Completeness</h2>
            {evidencePercent !== null ? (
              <div className="flex flex-col items-center justify-center py-8">
                <div className="relative w-32 h-32">
                  <svg className="w-full h-full -rotate-90" viewBox="0 0 36 36">
                    <path d="M18 2.0845a15.9155 15.9155 0 0 1 0 31.831a15.9155 15.9155 0 0 1 0-31.831" fill="none" stroke="#e5e7eb" strokeWidth="3" />
                    <path d="M18 2.0845a15.9155 15.9155 0 0 1 0 31.831a15.9155 15.9155 0 0 1 0-31.831" fill="none" stroke="#10b981" strokeWidth="3" strokeDasharray={`${evidencePercent}, 100`} />
                  </svg>
                  <span className="absolute inset-0 flex items-center justify-center text-2xl font-bold text-gray-800">{evidencePercent}%</span>
                </div>
                <p className="mt-4 text-sm text-gray-500">of questions have evidence attached</p>
              </div>
            ) : (
              <p className="text-gray-400 text-center py-12">No evidence data available</p>
            )}
          </div>
        </div>
      )}
    </div>
  );
}
