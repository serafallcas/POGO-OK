import { useState, useEffect } from 'react';
import { HelpCircle, Filter, Search, ChevronDown, ChevronUp } from 'lucide-react';
import { supabase } from '../lib/supabase';

interface Domain {
  id: string;
  label: string;
}

interface EvalType {
  id: string;
  label: string;
}

interface Question {
  id: string;
  question_code: string;
  question_text: string;
  instruction_text: string;
  evidence_examples: string;
  cmmi_reference: string;
  alert_rule_hint: string;
  evaluation_type_id: string;
  domain_id: string;
  is_mandatory: boolean;
  weight: number;
  mapped_maturity_model_id: string;
  sheet_name: string;
}

export default function Questions() {
  const [questions, setQuestions] = useState<Question[]>([]);
  const [loading, setLoading] = useState(true);
  const [expandedId, setExpandedId] = useState<string | null>(null);
  const [searchTerm, setSearchTerm] = useState('');
  const [filterDomain, setFilterDomain] = useState('');
  const [filterEvalType, setFilterEvalType] = useState('');
  const [domains, setDomains] = useState<Domain[]>([]);
  const [evalTypes, setEvalTypes] = useState<EvalType[]>([]);
  const [showFilters, setShowFilters] = useState(false);

  useEffect(() => {
    fetchQuestions();
    fetchFilters();
  }, []);

  async function fetchQuestions() {
    setLoading(true);
    const { data, error } = await supabase
      .from('questions')
      .select('*')
      .order('question_code', { ascending: true });

    if (error) {
      console.error('Error fetching questions:', error);
    } else if (data) {
      setQuestions(data);
    }
    setLoading(false);
  }

  async function fetchFilters() {
    const { data: domainsData } = await supabase
      .from('domains')
      .select('id, label')
      .order('label');
    if (domainsData) setDomains(domainsData);

    const { data: evalData } = await supabase
      .from('evaluation_types')
      .select('id, label')
      .order('label');
    if (evalData) setEvalTypes(evalData);
  }

  const filteredQuestions = questions.filter((q) => {
    const matchesSearch = q.question_text?.toLowerCase().includes(searchTerm.toLowerCase());
    const matchesDomain = !filterDomain || q.domain_id === filterDomain;
    const matchesEvalType = !filterEvalType || q.evaluation_type_id === filterEvalType;
    return matchesSearch && matchesDomain && matchesEvalType;
  });

  function getDomainLabel(domainId: string): string {
    const domain = domains.find((d) => d.id === domainId);
    return domain?.label || domainId?.substring(0, 8) || '—';
  }

  function truncateText(text: string, maxLength: number = 80): string {
    if (!text) return '';
    return text.length > maxLength ? text.substring(0, maxLength) + '...' : text;
  }

  function toggleExpand(id: string) {
    setExpandedId(expandedId === id ? null : id);
  }

  if (loading) {
    return (
      <div className="flex items-center justify-center h-64">
        <div className="animate-spin rounded-full h-8 w-8 border-b-2 border-emerald-600"></div>
      </div>
    );
  }

  return (
    <div className="space-y-6">
      <div className="flex items-center justify-between">
        <div className="flex items-center gap-3">
          <HelpCircle className="h-7 w-7 text-emerald-600" />
          <h1 className="text-2xl font-bold text-slate-800">Questions Management</h1>
        </div>
        <span className="text-sm text-slate-500">
          {filteredQuestions.length} of {questions.length} questions
        </span>
      </div>

      <div className="bg-white rounded-lg shadow-sm border border-slate-200 p-4">
        <div className="flex items-center gap-4">
          <div className="relative flex-1">
            <Search className="absolute left-3 top-1/2 -translate-y-1/2 h-4 w-4 text-slate-400" />
            <input
              type="text"
              placeholder="Search questions..."
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
              <label className="block text-xs font-medium text-slate-500 mb-1">Domain</label>
              <select
                value={filterDomain}
                onChange={(e) => setFilterDomain(e.target.value)}
                className="w-full px-3 py-2 border border-slate-300 rounded-lg text-sm focus:outline-none focus:ring-2 focus:ring-emerald-500"
              >
                <option value="">All Domains</option>
                {domains.map((domain) => (
                  <option key={domain.id} value={domain.id}>
                    {domain.label}
                  </option>
                ))}
              </select>
            </div>
            <div className="flex-1">
              <label className="block text-xs font-medium text-slate-500 mb-1">Evaluation Type</label>
              <select
                value={filterEvalType}
                onChange={(e) => setFilterEvalType(e.target.value)}
                className="w-full px-3 py-2 border border-slate-300 rounded-lg text-sm focus:outline-none focus:ring-2 focus:ring-emerald-500"
              >
                <option value="">All Types</option>
                {evalTypes.map((type) => (
                  <option key={type.id} value={type.id}>
                    {type.label}
                  </option>
                ))}
              </select>
            </div>
            <button
              onClick={() => {
                setFilterDomain('');
                setFilterEvalType('');
              }}
              className="self-end px-3 py-2 text-sm text-slate-500 hover:text-slate-700"
            >
              Clear
            </button>
          </div>
        )}
      </div>

      <div className="bg-white rounded-lg shadow-sm border border-slate-200 overflow-hidden">
        <div className="overflow-x-auto max-h-[calc(100vh-320px)] overflow-y-auto">
          <table className="w-full text-sm">
            <thead className="bg-slate-100 sticky top-0">
              <tr>
                <th className="text-left px-4 py-3 font-semibold text-slate-600">Code</th>
                <th className="text-left px-4 py-3 font-semibold text-slate-600">Question Text</th>
                <th className="text-left px-4 py-3 font-semibold text-slate-600">Domain</th>
                <th className="text-center px-4 py-3 font-semibold text-slate-600">Mandatory</th>
                <th className="text-center px-4 py-3 font-semibold text-slate-600">Weight</th>
                <th className="text-center px-4 py-3 font-semibold text-slate-600"></th>
              </tr>
            </thead>
            <tbody className="divide-y divide-slate-100">
              {filteredQuestions.map((question) => (
                <tr key={question.id}>
                  <td colSpan={6} className="p-0">
                    <div
                      className="flex items-center cursor-pointer hover:bg-slate-50 transition-colors"
                      onClick={() => toggleExpand(question.id)}
                    >
                      <div className="px-4 py-3 w-[140px] font-mono text-xs text-slate-700">
                        {question.question_code}
                      </div>
                      <div className="px-4 py-3 flex-1 text-slate-700">
                        {truncateText(question.question_text)}
                      </div>
                      <div className="px-4 py-3 w-[140px]">
                        <span className="inline-block px-2 py-0.5 bg-slate-100 text-slate-600 rounded text-xs">
                          {getDomainLabel(question.domain_id)}
                        </span>
                      </div>
                      <div className="px-4 py-3 w-[100px] text-center">
                        {question.is_mandatory ? (
                          <span className="inline-block px-2 py-0.5 bg-red-100 text-red-700 rounded text-xs font-medium">
                            Yes
                          </span>
                        ) : (
                          <span className="inline-block px-2 py-0.5 bg-slate-100 text-slate-500 rounded text-xs">
                            No
                          </span>
                        )}
                      </div>
                      <div className="px-4 py-3 w-[80px] text-center font-medium text-slate-700">
                        {question.weight}
                      </div>
                      <div className="px-4 py-3 w-[40px] text-center">
                        {expandedId === question.id ? (
                          <ChevronUp className="h-4 w-4 text-slate-400" />
                        ) : (
                          <ChevronDown className="h-4 w-4 text-slate-400" />
                        )}
                      </div>
                    </div>

                    {expandedId === question.id && (
                      <div className="px-6 py-4 bg-slate-50 border-t border-slate-200">
                        <div className="grid grid-cols-1 md:grid-cols-2 gap-4">
                          <div>
                            <h4 className="text-xs font-semibold text-slate-500 uppercase mb-1">
                              Instruction Text
                            </h4>
                            <p className="text-sm text-slate-700">
                              {question.instruction_text || 'N/A'}
                            </p>
                          </div>
                          <div>
                            <h4 className="text-xs font-semibold text-slate-500 uppercase mb-1">
                              Evidence Examples
                            </h4>
                            <p className="text-sm text-slate-700">
                              {question.evidence_examples || 'N/A'}
                            </p>
                          </div>
                          <div>
                            <h4 className="text-xs font-semibold text-slate-500 uppercase mb-1">
                              CMMI Reference
                            </h4>
                            <p className="text-sm text-slate-700">
                              {question.cmmi_reference || 'N/A'}
                            </p>
                          </div>
                          <div>
                            <h4 className="text-xs font-semibold text-slate-500 uppercase mb-1">
                              Alert Rule Hint
                            </h4>
                            <p className="text-sm text-slate-700">
                              {question.alert_rule_hint || 'N/A'}
                            </p>
                          </div>
                        </div>
                      </div>
                    )}
                  </td>
                </tr>
              ))}
            </tbody>
          </table>

          {filteredQuestions.length === 0 && (
            <div className="text-center py-12 text-slate-500">
              <HelpCircle className="h-8 w-8 mx-auto mb-2 text-slate-300" />
              <p>No questions found matching your criteria.</p>
            </div>
          )}
        </div>
      </div>
    </div>
  );
}
