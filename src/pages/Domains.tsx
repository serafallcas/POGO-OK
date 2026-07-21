import React, { useState, useEffect } from 'react';
import { Plus, Pencil, Search, ToggleLeft, ToggleRight, Grid3X3 } from 'lucide-react';
import { supabase } from '../lib/supabase';

interface EvaluationType {
  id: string;
  code: string;
  label: string;
}

interface Domain {
  id: string;
  code: string;
  label: string;
  evaluation_type_id: string;
  has_maturity_model: boolean;
  is_active: boolean;
  evaluation_types: EvaluationType | null;
}

interface FormData {
  code: string;
  label: string;
  evaluation_type_id: string;
  has_maturity_model: boolean;
  is_active: boolean;
}

const defaultFormData: FormData = {
  code: '',
  label: '',
  evaluation_type_id: '',
  has_maturity_model: false,
  is_active: true,
};

export default function Domains() {
  const [domains, setDomains] = useState<Domain[]>([]);
  const [evaluationTypes, setEvaluationTypes] = useState<EvaluationType[]>([]);
  const [loading, setLoading] = useState(true);
  const [searchTerm, setSearchTerm] = useState('');
  const [filterType, setFilterType] = useState('');
  const [showModal, setShowModal] = useState(false);
  const [editingItem, setEditingItem] = useState<Domain | null>(null);
  const [formData, setFormData] = useState<FormData>(defaultFormData);
  const [saving, setSaving] = useState(false);

  useEffect(() => {
    fetchDomains();
    fetchEvaluationTypes();
  }, []);

  async function fetchDomains() {
    setLoading(true);
    const { data, error } = await supabase
      .from('domains')
      .select('*, evaluation_types(id, code, label)')
      .order('code', { ascending: true });

    if (error) {
      console.error('Error fetching domains:', error);
    } else {
      setDomains(data || []);
    }
    setLoading(false);
  }

  async function fetchEvaluationTypes() {
    const { data, error } = await supabase
      .from('evaluation_types')
      .select('id, code, label')
      .eq('is_active', true)
      .order('sort_order', { ascending: true });

    if (error) {
      console.error('Error fetching evaluation types:', error);
    } else {
      setEvaluationTypes(data || []);
    }
  }

  async function handleSubmit(e: React.FormEvent) {
    e.preventDefault();
    setSaving(true);

    const payload = {
      code: formData.code,
      label: formData.label,
      evaluation_type_id: formData.evaluation_type_id,
      has_maturity_model: formData.has_maturity_model,
      is_active: formData.is_active,
    };

    let error;
    if (editingItem) {
      ({ error } = await supabase
        .from('domains')
        .update(payload)
        .eq('id', editingItem.id));
    } else {
      ({ error } = await supabase.from('domains').insert(payload));
    }

    if (error) {
      console.error('Error saving domain:', error);
    } else {
      setShowModal(false);
      setEditingItem(null);
      setFormData(defaultFormData);
      fetchDomains();
    }
    setSaving(false);
  }

  async function toggleActive(item: Domain) {
    const { error } = await supabase
      .from('domains')
      .update({ is_active: !item.is_active })
      .eq('id', item.id);

    if (error) {
      console.error('Error toggling active status:', error);
    } else {
      fetchDomains();
    }
  }

  function openAddModal() {
    setEditingItem(null);
    setFormData(defaultFormData);
    setShowModal(true);
  }

  function openEditModal(item: Domain) {
    setEditingItem(item);
    setFormData({
      code: item.code,
      label: item.label,
      evaluation_type_id: item.evaluation_type_id,
      has_maturity_model: item.has_maturity_model,
      is_active: item.is_active,
    });
    setShowModal(true);
  }

  const filteredDomains = domains.filter((item) => {
    const matchesSearch =
      item.code.toLowerCase().includes(searchTerm.toLowerCase()) ||
      item.label.toLowerCase().includes(searchTerm.toLowerCase());
    const matchesFilter = filterType ? item.evaluation_type_id === filterType : true;
    return matchesSearch && matchesFilter;
  });

  return (
    <div className="p-6 max-w-7xl mx-auto">
      {/* Header */}
      <div className="mb-6">
        <div className="flex items-center gap-3 mb-2">
          <Grid3X3 className="h-8 w-8 text-emerald-600" />
          <h1 className="text-2xl font-bold text-slate-800">Domains</h1>
        </div>
        <p className="text-slate-500">Manage domain reference data</p>
      </div>

      {/* Toolbar */}
      <div className="flex flex-col sm:flex-row gap-4 mb-6">
        <div className="relative flex-1">
          <Search className="absolute left-3 top-1/2 -translate-y-1/2 h-4 w-4 text-slate-400" />
          <input
            type="text"
            placeholder="Search domains..."
            value={searchTerm}
            onChange={(e) => setSearchTerm(e.target.value)}
            className="w-full pl-10 pr-4 py-2 border border-slate-200 rounded-lg focus:outline-none focus:ring-2 focus:ring-emerald-500 focus:border-transparent"
          />
        </div>
        <select
          value={filterType}
          onChange={(e) => setFilterType(e.target.value)}
          className="px-4 py-2 border border-slate-200 rounded-lg focus:outline-none focus:ring-2 focus:ring-emerald-500 text-sm text-slate-700"
        >
          <option value="">All Evaluation Types</option>
          {evaluationTypes.map((type) => (
            <option key={type.id} value={type.id}>
              {type.label}
            </option>
          ))}
        </select>
        <button
          onClick={openAddModal}
          className="inline-flex items-center gap-2 px-4 py-2 bg-emerald-600 text-white rounded-lg hover:bg-emerald-700 transition-colors font-medium"
        >
          <Plus className="h-4 w-4" />
          Add Domain
        </button>
      </div>

      {/* Table */}
      <div className="bg-white rounded-xl shadow-sm border border-slate-200 overflow-hidden">
        <div className="overflow-x-auto">
          <table className="w-full">
            <thead>
              <tr className="bg-slate-50 border-b border-slate-200">
                <th className="text-left px-6 py-3 text-xs font-semibold text-slate-600 uppercase tracking-wider">Code</th>
                <th className="text-left px-6 py-3 text-xs font-semibold text-slate-600 uppercase tracking-wider">Label</th>
                <th className="text-left px-6 py-3 text-xs font-semibold text-slate-600 uppercase tracking-wider">Evaluation Type</th>
                <th className="text-center px-6 py-3 text-xs font-semibold text-slate-600 uppercase tracking-wider">Has Maturity Model</th>
                <th className="text-center px-6 py-3 text-xs font-semibold text-slate-600 uppercase tracking-wider">Active</th>
                <th className="text-center px-6 py-3 text-xs font-semibold text-slate-600 uppercase tracking-wider">Actions</th>
              </tr>
            </thead>
            <tbody className="divide-y divide-slate-100">
              {loading ? (
                <tr>
                  <td colSpan={6} className="px-6 py-12 text-center text-slate-400">
                    Loading...
                  </td>
                </tr>
              ) : filteredDomains.length === 0 ? (
                <tr>
                  <td colSpan={6} className="px-6 py-12 text-center text-slate-400">
                    No domains found.
                  </td>
                </tr>
              ) : (
                filteredDomains.map((item) => (
                  <tr key={item.id} className="hover:bg-slate-50 transition-colors">
                    <td className="px-6 py-4 text-sm font-mono font-medium text-slate-800">{item.code}</td>
                    <td className="px-6 py-4 text-sm text-slate-700">{item.label}</td>
                    <td className="px-6 py-4 text-sm">
                      {item.evaluation_types ? (
                        <span className="inline-flex items-center px-2.5 py-0.5 rounded-full text-xs font-medium bg-emerald-50 text-emerald-700">
                          {item.evaluation_types.label}
                        </span>
                      ) : (
                        <span className="text-slate-400">—</span>
                      )}
                    </td>
                    <td className="px-6 py-4 text-center">
                      {item.has_maturity_model ? (
                        <span className="inline-flex items-center px-2 py-0.5 rounded text-xs font-medium bg-blue-50 text-blue-700">Yes</span>
                      ) : (
                        <span className="inline-flex items-center px-2 py-0.5 rounded text-xs font-medium bg-slate-100 text-slate-500">No</span>
                      )}
                    </td>
                    <td className="px-6 py-4 text-center">
                      <button
                        onClick={() => toggleActive(item)}
                        className="inline-flex items-center"
                        title={item.is_active ? 'Deactivate' : 'Activate'}
                      >
                        {item.is_active ? (
                          <ToggleRight className="h-6 w-6 text-emerald-600" />
                        ) : (
                          <ToggleLeft className="h-6 w-6 text-slate-300" />
                        )}
                      </button>
                    </td>
                    <td className="px-6 py-4 text-center">
                      <button
                        onClick={() => openEditModal(item)}
                        className="inline-flex items-center gap-1 px-3 py-1.5 text-sm text-slate-600 hover:text-emerald-600 hover:bg-emerald-50 rounded-md transition-colors"
                      >
                        <Pencil className="h-3.5 w-3.5" />
                        Edit
                      </button>
                    </td>
                  </tr>
                ))
              )}
            </tbody>
          </table>
        </div>
      </div>

      {/* Modal */}
      {showModal && (
        <div className="fixed inset-0 z-50 flex items-center justify-center p-4">
          <div className="fixed inset-0 bg-black/50" onClick={() => setShowModal(false)} />
          <div className="relative bg-white rounded-xl shadow-xl w-full max-w-lg p-6">
            <h2 className="text-lg font-semibold text-slate-800 mb-4">
              {editingItem ? 'Edit Domain' : 'Add Domain'}
            </h2>
            <form onSubmit={handleSubmit} className="space-y-4">
              <div>
                <label className="block text-sm font-medium text-slate-700 mb-1">Code</label>
                <input
                  type="text"
                  required
                  value={formData.code}
                  onChange={(e) => setFormData({ ...formData, code: e.target.value })}
                  className="w-full px-3 py-2 border border-slate-200 rounded-lg focus:outline-none focus:ring-2 focus:ring-emerald-500"
                />
              </div>
              <div>
                <label className="block text-sm font-medium text-slate-700 mb-1">Label</label>
                <input
                  type="text"
                  required
                  value={formData.label}
                  onChange={(e) => setFormData({ ...formData, label: e.target.value })}
                  className="w-full px-3 py-2 border border-slate-200 rounded-lg focus:outline-none focus:ring-2 focus:ring-emerald-500"
                />
              </div>
              <div>
                <label className="block text-sm font-medium text-slate-700 mb-1">Evaluation Type</label>
                <select
                  required
                  value={formData.evaluation_type_id}
                  onChange={(e) => setFormData({ ...formData, evaluation_type_id: e.target.value })}
                  className="w-full px-3 py-2 border border-slate-200 rounded-lg focus:outline-none focus:ring-2 focus:ring-emerald-500"
                >
                  <option value="">Select evaluation type...</option>
                  {evaluationTypes.map((type) => (
                    <option key={type.id} value={type.id}>
                      {type.label}
                    </option>
                  ))}
                </select>
              </div>
              <div className="flex items-center gap-4">
                <div className="flex items-center gap-2">
                  <input
                    type="checkbox"
                    id="has_maturity_model"
                    checked={formData.has_maturity_model}
                    onChange={(e) => setFormData({ ...formData, has_maturity_model: e.target.checked })}
                    className="h-4 w-4 rounded border-slate-300 text-emerald-600 focus:ring-emerald-500"
                  />
                  <label htmlFor="has_maturity_model" className="text-sm text-slate-700">Has Maturity Model</label>
                </div>
                <div className="flex items-center gap-2">
                  <input
                    type="checkbox"
                    id="domain_is_active"
                    checked={formData.is_active}
                    onChange={(e) => setFormData({ ...formData, is_active: e.target.checked })}
                    className="h-4 w-4 rounded border-slate-300 text-emerald-600 focus:ring-emerald-500"
                  />
                  <label htmlFor="domain_is_active" className="text-sm text-slate-700">Active</label>
                </div>
              </div>
              <div className="flex justify-end gap-3 pt-4 border-t border-slate-100">
                <button
                  type="button"
                  onClick={() => setShowModal(false)}
                  className="px-4 py-2 text-sm font-medium text-slate-700 hover:bg-slate-100 rounded-lg transition-colors"
                >
                  Cancel
                </button>
                <button
                  type="submit"
                  disabled={saving}
                  className="px-4 py-2 text-sm font-medium text-white bg-emerald-600 hover:bg-emerald-700 rounded-lg transition-colors disabled:opacity-50"
                >
                  {saving ? 'Saving...' : editingItem ? 'Update' : 'Create'}
                </button>
              </div>
            </form>
          </div>
        </div>
      )}
    </div>
  );
}
