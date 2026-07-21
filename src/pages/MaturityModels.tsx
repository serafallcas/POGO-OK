import { useState, useEffect } from 'react';
import { TrendingUp, Eye, ArrowLeft } from 'lucide-react';
import { supabase } from '../lib/supabase';

interface MaturityModel {
  id: string;
  code: string;
  label: string;
  domain_id: string;
  mapped_domain_name: string;
  version: string;
  source_workbook: string;
}

interface MaturityStatement {
  id: string;
  maturity_model_id: string;
  process_area: string;
  domain_title: string;
  level_1_basic: string;
  level_2_developing: string;
  level_3_established: string;
  level_4_advanced: string;
  level_5_leading: string;
  sort_order: number;
}

const LEVEL_KEYS: { key: keyof MaturityStatement; label: string; color: string }[] = [
  { key: 'level_1_basic', label: 'Level 1 - Basic', color: 'bg-red-100 text-red-700' },
  { key: 'level_2_developing', label: 'Level 2 - Developing', color: 'bg-orange-100 text-orange-700' },
  { key: 'level_3_established', label: 'Level 3 - Established', color: 'bg-yellow-100 text-yellow-700' },
  { key: 'level_4_advanced', label: 'Level 4 - Advanced', color: 'bg-emerald-100 text-emerald-700' },
  { key: 'level_5_leading', label: 'Level 5 - Leading', color: 'bg-blue-100 text-blue-700' },
];

export default function MaturityModels() {
  const [models, setModels] = useState<MaturityModel[]>([]);
  const [loading, setLoading] = useState(true);
  const [selectedModel, setSelectedModel] = useState<MaturityModel | null>(null);
  const [statements, setStatements] = useState<MaturityStatement[]>([]);
  const [statementsLoading, setStatementsLoading] = useState(false);

  useEffect(() => {
    fetchModels();
  }, []);

  async function fetchModels() {
    setLoading(true);
    const { data, error } = await supabase
      .from('maturity_models')
      .select('*')
      .order('code', { ascending: true });

    if (error) {
      console.error('Error fetching maturity models:', error);
    } else if (data) {
      setModels(data);
    }
    setLoading(false);
  }

  async function fetchStatements(modelCode: string) {
    setStatementsLoading(true);
    const { data, error } = await supabase
      .from('maturity_statements')
      .select('*')
      .eq('maturity_model_id', modelCode)
      .order('sort_order', { ascending: true });

    if (error) {
      console.error('Error fetching maturity statements:', error);
    } else if (data) {
      setStatements(data);
    }
    setStatementsLoading(false);
  }

  function handleViewStatements(model: MaturityModel) {
    setSelectedModel(model);
    fetchStatements(model.code);
  }

  function handleBack() {
    setSelectedModel(null);
    setStatements([]);
  }

  if (loading) {
    return (
      <div className="flex items-center justify-center h-64">
        <div className="animate-spin rounded-full h-8 w-8 border-b-2 border-emerald-600"></div>
      </div>
    );
  }

  if (selectedModel) {
    return (
      <div className="space-y-6">
        <div className="flex items-center gap-3">
          <button
            onClick={handleBack}
            className="flex items-center gap-2 px-3 py-2 text-sm text-slate-600 hover:text-slate-800 hover:bg-slate-100 rounded-lg transition-colors"
          >
            <ArrowLeft className="h-4 w-4" />
            Back
          </button>
          <div className="h-6 w-px bg-slate-300" />
          <TrendingUp className="h-6 w-6 text-emerald-600" />
          <div>
            <h1 className="text-xl font-bold text-slate-800">
              {selectedModel.label}
            </h1>
            <p className="text-sm text-slate-500">
              {selectedModel.code} {selectedModel.mapped_domain_name ? `- ${selectedModel.mapped_domain_name}` : ''} {selectedModel.version ? `- v${selectedModel.version}` : ''}
            </p>
          </div>
        </div>

        {statementsLoading ? (
          <div className="flex items-center justify-center h-32">
            <div className="animate-spin rounded-full h-6 w-6 border-b-2 border-emerald-600"></div>
          </div>
        ) : statements.length === 0 ? (
          <div className="bg-white rounded-lg shadow-sm border border-slate-200 p-12 text-center">
            <p className="text-slate-500">No maturity statements found for this model.</p>
          </div>
        ) : (
          <div className="space-y-4">
            {statements.map((statement) => (
              <div
                key={statement.id}
                className="bg-white rounded-lg shadow-sm border border-slate-200 overflow-hidden"
              >
                <div className="px-4 py-3 bg-slate-50 border-b border-slate-200 flex items-center justify-between">
                  <span className="font-medium text-sm text-slate-700">
                    {statement.process_area || 'Statement'}
                  </span>
                  {statement.domain_title && (
                    <span className="text-xs px-2 py-0.5 bg-emerald-100 text-emerald-700 rounded">
                      {statement.domain_title}
                    </span>
                  )}
                </div>
                <div className="p-4">
                  <div className="grid grid-cols-1 md:grid-cols-5 gap-3">
                    {LEVEL_KEYS.map(({ key, label, color }) => {
                      const text = statement[key] as string;
                      return (
                        <div key={key} className="flex flex-col">
                          <div className={`text-xs font-semibold mb-1 px-2 py-1 rounded text-center ${color}`}>
                            {label}
                          </div>
                          <p className="text-xs text-slate-600 mt-1 leading-relaxed">
                            {text || 'Not defined'}
                          </p>
                        </div>
                      );
                    })}
                  </div>
                </div>
              </div>
            ))}
          </div>
        )}
      </div>
    );
  }

  return (
    <div className="space-y-6">
      <div className="flex items-center gap-3">
        <TrendingUp className="h-7 w-7 text-emerald-600" />
        <h1 className="text-2xl font-bold text-slate-800">Maturity Models</h1>
        <span className="ml-auto text-sm text-slate-500">{models.length} models</span>
      </div>

      <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-4">
        {models.map((model) => (
          <div
            key={model.id}
            className="bg-white rounded-lg shadow-sm border border-slate-200 hover:shadow-md hover:border-emerald-200 transition-all duration-200"
          >
            <div className="p-5">
              <div className="flex items-start justify-between mb-3">
                <div>
                  <h3 className="font-semibold text-slate-800">{model.label}</h3>
                  <p className="text-xs font-mono text-slate-500 mt-0.5">{model.code}</p>
                </div>
                {model.version && (
                  <span className="text-xs px-2 py-0.5 bg-slate-100 text-slate-600 rounded">
                    v{model.version}
                  </span>
                )}
              </div>

              <div className="space-y-2 mb-4">
                <div className="flex items-center justify-between text-sm">
                  <span className="text-slate-500">Domain</span>
                  <span className="text-slate-700 font-medium truncate max-w-[180px]">
                    {model.mapped_domain_name || '—'}
                  </span>
                </div>
                <div className="flex items-center justify-between text-sm">
                  <span className="text-slate-500">Source</span>
                  <span className="text-slate-700 text-xs truncate max-w-[180px]">
                    {model.source_workbook || 'N/A'}
                  </span>
                </div>
              </div>

              <button
                onClick={() => handleViewStatements(model)}
                className="w-full flex items-center justify-center gap-2 px-4 py-2 bg-emerald-600 text-white text-sm font-medium rounded-lg hover:bg-emerald-700 transition-colors"
              >
                <Eye className="h-4 w-4" />
                View Statements
              </button>
            </div>
          </div>
        ))}
      </div>

      {models.length === 0 && (
        <div className="bg-white rounded-lg shadow-sm border border-slate-200 p-12 text-center">
          <TrendingUp className="h-8 w-8 mx-auto mb-2 text-slate-300" />
          <p className="text-slate-500">No maturity models found.</p>
        </div>
      )}
    </div>
  );
}
