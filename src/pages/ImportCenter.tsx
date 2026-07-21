import { useState, useCallback } from 'react';
import { supabase } from '../lib/supabase';
import Papa from 'papaparse';
import { Upload, FileText, CheckCircle, XCircle, AlertCircle, Download } from 'lucide-react';

const TABLES = ['evaluation_types', 'domains', 'processes', 'questions', 'maturity_models', 'maturity_statements'] as const;
type TableName = (typeof TABLES)[number];

const COLUMN_MAPS: Record<TableName, Record<string, string>> = {
  evaluation_types: { id: 'source_id', code: 'code', name: 'label', description: 'description', source_workbook: 'source_workbook' },
  domains: { code: 'code', evaluation_type_code: 'evaluation_type_code', name: 'label', description: 'description', mapped_maturity_model_id: 'mapped_maturity_model_id', has_maturity_model: 'has_maturity_model' },
  processes: { code: 'code', evaluation_type_code: 'evaluation_type_code', domain_code: 'domain_code', name: 'label', description: 'description', sort_order: 'sort_order', sheet_name: 'sheet_name' },
  questions: { question_code: 'question_code', evaluation_type_code: 'evaluation_type_code', domain_code: 'domain_code', process_code: 'process_code', question_text: 'question_text', instruction_text: 'instruction_text', evidence_examples: 'evidence_examples', cmmi_reference: 'cmmi_reference', alert_rule_hint: 'alert_rule_hint', source_cell: 'source_cell', sheet_name: 'sheet_name', weight: 'weight', is_mandatory: 'is_mandatory' },
  maturity_models: { code: 'code', label: 'label', domain_code: 'domain_code', mapped_domain_name: 'mapped_domain_name', source_workbook: 'source_workbook', version: 'version' },
  maturity_statements: { maturity_model_code: 'maturity_model_code', domain_title: 'domain_title', process_area: 'process_area', level_1_basic: 'level_1_basic', level_2_developing: 'level_2_developing', level_3_established: 'level_3_established', level_4_advanced: 'level_4_advanced', level_5_leading: 'level_5_leading', assessor_instruction: 'assessor_instruction', evidence_examples: 'evidence_examples' },
};

const CONFLICT_KEYS: Record<TableName, string> = {
  evaluation_types: 'code', domains: 'code', processes: 'code', questions: 'question_code',
  maturity_models: 'code', maturity_statements: 'id',
};

interface ImportResult { imported: number; skipped: number; errors: string[]; }
interface HistoryEntry { table: string; file: string; timestamp: Date; result: ImportResult; }

async function resolveCodeToUUID(table: string, codeColumn: string, code: string): Promise<string | null> {
  if (!code) return null;
  const { data } = await supabase.from(table).select('id').eq(codeColumn, code).maybeSingle();
  return data?.id ?? null;
}

async function resolveRow(table: TableName, row: Record<string, unknown>): Promise<{ resolved: Record<string, unknown>; errors: string[] }> {
  const resolved = { ...row };
  const errors: string[] = [];

  if (table === 'domains') {
    if (resolved.evaluation_type_code) {
      const uuid = await resolveCodeToUUID('evaluation_types', 'code', String(resolved.evaluation_type_code));
      if (uuid) { resolved.evaluation_type_id = uuid; } else { errors.push(`evaluation_type_code "${resolved.evaluation_type_code}" not found`); }
      delete resolved.evaluation_type_code;
    }
  }

  if (table === 'processes') {
    if (resolved.evaluation_type_code) {
      const uuid = await resolveCodeToUUID('evaluation_types', 'code', String(resolved.evaluation_type_code));
      if (uuid) { resolved.evaluation_type_id = uuid; } else { errors.push(`evaluation_type_code "${resolved.evaluation_type_code}" not found`); }
      delete resolved.evaluation_type_code;
    }
    if (resolved.domain_code) {
      const uuid = await resolveCodeToUUID('domains', 'code', String(resolved.domain_code));
      if (uuid) { resolved.domain_id = uuid; } else { errors.push(`domain_code "${resolved.domain_code}" not found`); }
      delete resolved.domain_code;
    }
  }

  if (table === 'questions') {
    if (resolved.evaluation_type_code) {
      const uuid = await resolveCodeToUUID('evaluation_types', 'code', String(resolved.evaluation_type_code));
      if (uuid) { resolved.evaluation_type_id = uuid; } else { errors.push(`evaluation_type_code "${resolved.evaluation_type_code}" not found`); }
      delete resolved.evaluation_type_code;
    }
    if (resolved.domain_code) {
      const uuid = await resolveCodeToUUID('domains', 'code', String(resolved.domain_code));
      if (uuid) { resolved.domain_id = uuid; } else { errors.push(`domain_code "${resolved.domain_code}" not found`); }
      delete resolved.domain_code;
    }
    if (resolved.process_code) {
      const uuid = await resolveCodeToUUID('processes', 'code', String(resolved.process_code));
      if (uuid) { resolved.process_id = uuid; } else { errors.push(`process_code "${resolved.process_code}" not found`); }
      delete resolved.process_code;
    }
  }

  if (table === 'maturity_models') {
    if (resolved.domain_code) {
      const uuid = await resolveCodeToUUID('domains', 'code', String(resolved.domain_code));
      if (uuid) { resolved.domain_id = uuid; resolved.mapped_domain_id = uuid; } else { errors.push(`domain_code "${resolved.domain_code}" not found`); }
      delete resolved.domain_code;
    }
  }

  if (table === 'maturity_statements') {
    if (resolved.maturity_model_code) {
      const uuid = await resolveCodeToUUID('maturity_models', 'code', String(resolved.maturity_model_code));
      if (uuid) { resolved.maturity_model_id = uuid; } else { errors.push(`maturity_model_code "${resolved.maturity_model_code}" not found`); }
      delete resolved.maturity_model_code;
    }
  }

  return { resolved, errors };
}

export default function ImportCenter() {
  const [table, setTable] = useState<TableName>('evaluation_types');
  const [file, setFile] = useState<File | null>(null);
  const [rawData, setRawData] = useState<Record<string, unknown>[]>([]);
  const [importing, setImporting] = useState(false);
  const [progress, setProgress] = useState(0);
  const [result, setResult] = useState<ImportResult | null>(null);
  const [warnings, setWarnings] = useState<string[]>([]);
  const [history, setHistory] = useState<HistoryEntry[]>([]);
  const [dragOver, setDragOver] = useState(false);
  const [dryRun, setDryRun] = useState(false);

  const columnMap = COLUMN_MAPS[table];
  const sourceColumns = Object.keys(columnMap);
  const targetColumns = Object.values(columnMap);

  const parseFile = useCallback((f: File) => {
    setFile(f);
    setResult(null);
    setWarnings([]);
    const ext = f.name.split('.').pop()?.toLowerCase();

    if (ext === 'csv') {
      Papa.parse(f, {
        header: true, skipEmptyLines: true,
        complete: (res) => {
          setRawData(res.data as Record<string, unknown>[]);
          validateData(res.data as Record<string, unknown>[]);
        },
      });
    } else if (ext === 'json') {
      const reader = new FileReader();
      reader.onload = (e) => {
        try {
          const parsed = JSON.parse(e.target?.result as string);
          const arr = Array.isArray(parsed) ? parsed : [parsed];
          setRawData(arr);
          validateData(arr);
        } catch { setWarnings(['Invalid JSON file']); }
      };
      reader.readAsText(f);
    }
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, [table]);

  const validateData = (data: Record<string, unknown>[]) => {
    const w: string[] = [];
    const requiredTarget = targetColumns.slice(0, 2);
    data.slice(0, 50).forEach((row, i) => {
      requiredTarget.forEach((col) => {
        const srcKey = sourceColumns[targetColumns.indexOf(col)];
        if (!row[srcKey] && row[srcKey] !== 0) w.push(`Row ${i + 1}: missing "${srcKey}"`);
      });
    });
    if (w.length > 10) setWarnings([...w.slice(0, 10), `...and ${w.length - 10} more`]);
    else setWarnings(w);
  };

  const mapRow = (row: Record<string, unknown>) => {
    const mapped: Record<string, unknown> = {};
    for (const [src, tgt] of Object.entries(columnMap)) {
      if (row[src] !== undefined && row[src] !== '') mapped[tgt] = row[src];
    }
    return mapped;
  };

  const handleImport = async () => {
    if (!rawData.length) return;
    setImporting(true);
    setProgress(0);
    const res: ImportResult = { imported: 0, skipped: 0, errors: [] };
    const batchSize = 50;
    const total = rawData.length;
    const needsResolution = ['domains', 'processes', 'questions', 'maturity_models', 'maturity_statements'].includes(table);

    for (let i = 0; i < total; i += batchSize) {
      const rawBatch = rawData.slice(i, i + batchSize).map(mapRow);
      let batch: Record<string, unknown>[] = [];

      if (needsResolution) {
        for (const row of rawBatch) {
          const { resolved, errors } = await resolveRow(table, row);
          if (errors.length > 0) {
            res.errors.push(...errors.map(e => `Row ~${i + rawBatch.indexOf(row) + 1}: ${e}`));
            res.skipped += 1;
          } else {
            batch.push(resolved);
          }
        }
      } else {
        batch = rawBatch;
      }

      if (batch.length === 0 || dryRun) {
        setProgress(Math.min(100, Math.round(((i + batchSize) / total) * 100)));
        if (dryRun) res.imported += batch.length;
        continue;
      }

      const { error, data } = await supabase.from(table).upsert(batch, { onConflict: CONFLICT_KEYS[table] }).select();
      if (error) {
        res.errors.push(`Batch ${Math.floor(i / batchSize) + 1}: ${error.message}`);
        res.skipped += batch.length;
      } else {
        res.imported += data?.length ?? batch.length;
      }
      setProgress(Math.min(100, Math.round(((i + batchSize) / total) * 100)));
    }

    setResult(res);
    setImporting(false);
    setHistory((h) => [{ table, file: file!.name, timestamp: new Date(), result: res }, ...h.slice(0, 9)]);
  };

  const handleDrop = (e: React.DragEvent) => { e.preventDefault(); setDragOver(false); if (e.dataTransfer.files[0]) parseFile(e.dataTransfer.files[0]); };

  const previewRows = rawData.slice(0, 8);
  const previewCols = rawData.length ? Object.keys(rawData[0]).slice(0, 8) : [];

  return (
    <div className="max-w-6xl mx-auto p-6 space-y-6">
      <div className="flex items-center gap-3 mb-2">
        <Download className="w-7 h-7 text-blue-600" />
        <h1 className="text-2xl font-bold text-gray-900">Import Center</h1>
      </div>

      {/* Step 1: Table Selection */}
      <section className="bg-white rounded-lg shadow p-5 space-y-3">
        <h2 className="font-semibold text-gray-700 flex items-center gap-2"><span className="bg-blue-100 text-blue-700 rounded-full w-6 h-6 flex items-center justify-center text-sm font-bold">1</span> Select Target Table</h2>
        <select value={table} onChange={(e) => { setTable(e.target.value as TableName); setRawData([]); setFile(null); setResult(null); }} className="border rounded-md px-3 py-2 w-full max-w-sm">
          {TABLES.map((t) => <option key={t} value={t}>{t.replace(/_/g, ' ')}</option>)}
        </select>
        <p className="text-xs text-gray-500">
          {table === 'evaluation_types' && 'Use columns: code, name, description, source_workbook'}
          {table === 'domains' && 'Use columns: code, evaluation_type_code (text), name, description'}
          {table === 'processes' && 'Use columns: code, evaluation_type_code, domain_code, name, description'}
          {table === 'questions' && 'Use columns: question_code, evaluation_type_code, domain_code, process_code, question_text, ...'}
          {table === 'maturity_models' && 'Use columns: code, label, domain_code, version, source_workbook'}
          {table === 'maturity_statements' && 'Use columns: maturity_model_code, domain_title, process_area, level_1_basic...level_5_leading'}
        </p>
      </section>

      {/* Step 2: File Upload */}
      <section className="bg-white rounded-lg shadow p-5 space-y-3">
        <h2 className="font-semibold text-gray-700 flex items-center gap-2"><span className="bg-blue-100 text-blue-700 rounded-full w-6 h-6 flex items-center justify-center text-sm font-bold">2</span> Upload File</h2>
        <div
          onDragOver={(e) => { e.preventDefault(); setDragOver(true); }}
          onDragLeave={() => setDragOver(false)}
          onDrop={handleDrop}
          className={`border-2 border-dashed rounded-lg p-8 text-center cursor-pointer transition ${dragOver ? 'border-blue-500 bg-blue-50' : 'border-gray-300 hover:border-gray-400'}`}
          onClick={() => document.getElementById('file-input')?.click()}
        >
          <Upload className="mx-auto w-10 h-10 text-gray-400 mb-2" />
          <p className="text-gray-600">{file ? file.name : 'Drag & drop a .csv or .json file, or click to browse'}</p>
          <input id="file-input" type="file" accept=".csv,.json" className="hidden" onChange={(e) => e.target.files?.[0] && parseFile(e.target.files[0])} />
        </div>
      </section>

      {/* Column Mapping */}
      {rawData.length > 0 && (
        <section className="bg-white rounded-lg shadow p-5 space-y-3">
          <h2 className="font-semibold text-gray-700 flex items-center gap-2"><span className="bg-blue-100 text-blue-700 rounded-full w-6 h-6 flex items-center justify-center text-sm font-bold">3</span> Column Mapping</h2>
          <div className="grid grid-cols-2 md:grid-cols-3 gap-2 text-sm">
            {sourceColumns.map((src) => (
              <div key={src} className="flex items-center gap-1 bg-gray-50 rounded px-2 py-1">
                <span className="text-gray-500">{src}</span><span className="text-blue-600">&rarr;</span><span className="font-medium">{columnMap[src]}</span>
              </div>
            ))}
          </div>
        </section>
      )}

      {/* Preview */}
      {previewRows.length > 0 && (
        <section className="bg-white rounded-lg shadow p-5 space-y-3 overflow-x-auto">
          <h2 className="font-semibold text-gray-700 flex items-center gap-2"><FileText className="w-4 h-4" /> Data Preview ({rawData.length} rows total)</h2>
          {warnings.length > 0 && (
            <div className="bg-yellow-50 border border-yellow-200 rounded p-3 text-sm space-y-1">
              {warnings.map((w, i) => <p key={i} className="flex items-center gap-1 text-yellow-700"><AlertCircle className="w-3 h-3" />{w}</p>)}
            </div>
          )}
          <table className="w-full text-xs border">
            <thead><tr className="bg-gray-100">{previewCols.map((c) => <th key={c} className="px-2 py-1 text-left border-b">{c}</th>)}</tr></thead>
            <tbody>{previewRows.map((row, i) => <tr key={i} className="border-b hover:bg-gray-50">{previewCols.map((c) => <td key={c} className="px-2 py-1 truncate max-w-[200px]">{String(row[c] ?? '')}</td>)}</tr>)}</tbody>
          </table>
        </section>
      )}

      {/* Import Button */}
      {rawData.length > 0 && (
        <section className="bg-white rounded-lg shadow p-5 space-y-3">
          <h2 className="font-semibold text-gray-700 flex items-center gap-2"><span className="bg-blue-100 text-blue-700 rounded-full w-6 h-6 flex items-center justify-center text-sm font-bold">4</span> Import</h2>
          <div className="flex items-center gap-4">
            <label className="flex items-center gap-2 text-sm">
              <input type="checkbox" checked={dryRun} onChange={(e) => setDryRun(e.target.checked)} className="rounded" />
              Dry Run (validate without writing)
            </label>
          </div>
          <button onClick={handleImport} disabled={importing} className="bg-blue-600 text-white px-6 py-2 rounded-md hover:bg-blue-700 disabled:opacity-50 flex items-center gap-2">
            {importing ? 'Importing...' : (dryRun ? 'Validate' : 'Start Import')} <Upload className="w-4 h-4" />
          </button>
          {importing && (
            <div className="w-full bg-gray-200 rounded-full h-2.5">
              <div className="bg-blue-600 h-2.5 rounded-full transition-all" style={{ width: `${progress}%` }} />
            </div>
          )}
        </section>
      )}

      {/* Results */}
      {result && (
        <section className="bg-white rounded-lg shadow p-5 space-y-3">
          <h2 className="font-semibold text-gray-700">Import Results {dryRun && '(Dry Run)'}</h2>
          <div className="flex gap-6 text-sm">
            <span className="flex items-center gap-1 text-green-700"><CheckCircle className="w-4 h-4" /> {dryRun ? 'Valid' : 'Imported'}: {result.imported}</span>
            <span className="flex items-center gap-1 text-yellow-700"><AlertCircle className="w-4 h-4" /> Skipped: {result.skipped}</span>
            <span className="flex items-center gap-1 text-red-700"><XCircle className="w-4 h-4" /> Errors: {result.errors.length}</span>
          </div>
          {result.errors.length > 0 && (
            <div className="bg-red-50 border border-red-200 rounded p-3 text-sm space-y-1 max-h-60 overflow-y-auto">
              {result.errors.map((err, i) => <p key={i} className="text-red-700">{err}</p>)}
            </div>
          )}
        </section>
      )}

      {/* History */}
      {history.length > 0 && (
        <section className="bg-white rounded-lg shadow p-5 space-y-3">
          <h2 className="font-semibold text-gray-700">Recent Imports</h2>
          <div className="divide-y text-sm">
            {history.map((h, i) => (
              <div key={i} className="py-2 flex justify-between items-center">
                <div><span className="font-medium">{h.table}</span> <span className="text-gray-500">&larr; {h.file}</span></div>
                <div className="flex gap-3 text-xs">
                  <span className="text-green-600">{h.result.imported} imported</span>
                  {h.result.errors.length > 0 && <span className="text-red-600">{h.result.errors.length} errors</span>}
                  <span className="text-gray-400">{h.timestamp.toLocaleTimeString()}</span>
                </div>
              </div>
            ))}
          </div>
        </section>
      )}
    </div>
  );
}
