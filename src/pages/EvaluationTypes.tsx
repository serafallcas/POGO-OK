import React, { useState, useEffect } from 'react';
import { Plus, Pencil, Layers, Search, ToggleLeft, ToggleRight } from 'lucide-react';
import { supabase } from '../lib/supabase';

interface EvaluationType {
  id: string;
  code: string;
  label: string;
  description: string | null;
  source: string | null;
  is_active: boolean;
  sort_order: number;
}

interface FormData {
  code: string;
  label: string;
  description: string;
  source: string;
  is_active: boolean;
  sort_order: number;
}

const defaultFormData: FormData = {
  code: '',
  label: '',
  description: '',
  source: '',
  is_active: true,
  sort_order: 0,
};

export default function EvaluationTypes() {
  const [evaluationTypes, setEvaluationTypes] = useState<EvaluationType[]>([]);
  const [loading, setLoading] = useState(true);
  const [searchTerm, setSearchTerm] = useState('');
  const [showModal, setShowModal] = useState(false);
  const [editingItem, setEditingItem] = useState<EvaluationType | null>(null);
  const [formData, setFormData] = useState<FormData>(defaultFormData);
  const [saving, setSaving] = useState(false);

  useEffect(() => {
    fetchEvaluationTypes();
  }, []);

  async function fetchEvaluationTypes() {
    setLoading(true);
    const { data, error } = await supabase
      .from('evaluation_types')
      .select('*')
      .order('sort_order', { ascending: true });

    if (error) {
      console.error('Error fetching evaluation types:', error);
    } else {
      setEvaluationTypes(data || []);
    }
    setLoading(false);
  }

  async function handleSubmit(e: React.FormEvent) {
    e.preventDefault();
    setSaving(true);

    const payload = {
      code: formData.code,
      label: formData.label,
      description: formData.description || null,
      source: formData.source || null,
      is_active: formData.is_active,
      sort_order: formData.sort_order,
    };

    let error;
    if (editingItem) {
      ({ error } = await supabase
        .from('evaluation_types')
        .update(payload)
        .eq('id', editingItem.id));
    } else {
      ({ error } = await supabase.from('evaluation_types').insert(payload));
    }

    if (error) {
      console.error('Error saving evaluation type:', error);
    } else {
      setShowModal(false);
      setEditingItem(null);
      setFormData(defaultFormData);
      fetchEvaluationTypes();
    }
    setSaving(false);
  }

  async function toggleActive(item: EvaluationType) {
    const { error } = await supabase
      .from('evaluation_types')
      .update({ is_active: !item.is_active })
      .eq('id', item.id);

    if (error) {
      console.error('Error toggling active status:', error);
    } else {
      fetchEvaluationTypes();
    }
  }

  function openAddModal() {
    setEditingItem(null);
    setFormData(defaultFormData);
    setShowModal(true);
  }

  function openEditModal(item: EvaluationType) {
    setEditingItem(item);
    setFormData({
      code: item.code,
      label: item.label,
      description: item.description || '',
      source: item.source || '',
      is_active: item.is_active,
      sort_order: item.sort_order,
    });
    setShowModal(true);
  }

  const filteredTypes = evaluationTypes.filter(
    (item) =>
      item.code.toLowerCase().includes(searchTerm.toLowerCase()) ||
      item.label.toLowerCase().includes(searchTerm.toLowerCase()) ||
      (item.description || '').toLowerCase().includes(searchTerm.toLowerCase()) ||
      (item.source || '').toLowerCase().includes(searchTerm.toLowerCase())
  );

  return (
    <div className="p-6 max-w-7xl mx-auto">
      {/* Header */}
      <div className="mb-6">
        <div className="flex items-center gap-3 mb-2">
          <Layers className="h-8 w-8 text-emerald-600" />
          <h1 className="text-2xl font-bold text-slate-800">Evaluation Types</h1>
        </div>
        <p className="text-slate-500">Manage evaluation type reference data</p>
      </div>

      {/* Toolbar */}
      <div className="flex flex-col sm:flex-row gap-4 mb-6">
        <div className="relative flex-1">
          <Search className="absolute left-3 top-1/2 -translate-y-1/2 h-4 w-4 text-slate-400" />
          <input
            type="text"
            placeholder="Search evaluation types..."
            value={searchTerm}
            onChange={(e) => setSearchTerm(e.target.value)}
            className="w-full pl-10 pr-4 py-2 border border-slate-200 rounded-lg focus:outline-none focus:ring-2 focus:ring-emerald-500 focus:border-transparent"
          />
        </div>
        <button
          onClick={openAddModal}
          className="inline-flex items-center gap-2 px-4 py-2 bg-emerald-600 text-white rounded-lg hover:bg-emerald-700 transition-colors font-medium"
        >
          <Plus className="h-4 w-4" />
          Add Type
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
                <th className="text-left px-6 py-3 text-xs font-semibold text-slate-600 uppercase tracking-wider">Description</th>
                <th className="text-left px-6 py-3 text-xs font-semibold text-slate-600 uppercase tracking-wider">Source</th>
                <th className="text-center px-6 py-3 text-xs font-semibold text-slate-600 uppercase tracking-wider">Active</th>
                <th className="text-center px-6 py-3 text-xs font-semibold text-slate-600 uppercase tracking-wider">Sort Order</th>
                <th className="text-center px-6 py-3 text-xs font-semibold text-slate-600 uppercase tracking-wider">Actions</th>
              </tr>
            </thead>
            <tbody className="divide-y divide-slate-100">
              {loading ? (
                <tr>
                  <td colSpan={7} className="px-6 py-12 text-center text-slate-400">
                    Loading...
                  </td>
                </tr>
              ) : filteredTypes.length === 0 ? (
                <tr>
                  <td colSpan={7} className="px-6 py-12 text-center text-slate-400">
                    No evaluation types found.
                  </td>
                </tr>
              ) : (
                filteredTypes.map((item) => (
                  <tr key={item.id} className="hover:bg-slate-50 transition-colors">
                    <td className="px-6 py-4 text-sm font-mono font-medium text-slate-800">{item.code}</td>
                    <td className="px-6 py-4 text-sm text-slate-700">{item.label}</td>
                    <td className="px-6 py-4 text-sm text-slate-500 max-w-xs truncate">{item.description || '—'}</td>
                    <td className="px-6 py-4 text-sm text-slate-500">{item.source || '—'}</td>
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
                    <td className="px-6 py-4 text-center text-sm text-slate-600">{item.sort_order}</td>
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
              {editingItem ? 'Edit Evaluation Type' : 'Add Evaluation Type'}
            </h2>
            <form onSubmit={handleSubmit} className="space-y-4">
              <div className="grid grid-cols-2 gap-4">
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
                  <label className="block text-sm font-medium text-slate-700 mb-1">Sort Order</label>
                  <input
                    type="number"
                    value={formData.sort_order}
                    onChange={(e) => setFormData({ ...formData, sort_order: parseInt(e.target.value) || 0 })}
                    className="w-full px-3 py-2 border border-slate-200 rounded-lg focus:outline-none focus:ring-2 focus:ring-emerald-500"
                  />
                </div>
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
                <label className="block text-sm font-medium text-slate-700 mb-1">Description</label>
                <textarea
                  value={formData.description}
                  onChange={(e) => setFormData({ ...formData, description: e.target.value })}
                  rows={3}
                  className="w-full px-3 py-2 border border-slate-200 rounded-lg focus:outline-none focus:ring-2 focus:ring-emerald-500"
                />
              </div>
              <div>
                <label className="block text-sm font-medium text-slate-700 mb-1">Source</label>
                <input
                  type="text"
                  value={formData.source}
                  onChange={(e) => setFormData({ ...formData, source: e.target.value })}
                  className="w-full px-3 py-2 border border-slate-200 rounded-lg focus:outline-none focus:ring-2 focus:ring-emerald-500"
                />
              </div>
              <div className="flex items-center gap-2">
                <input
                  type="checkbox"
                  id="is_active"
                  checked={formData.is_active}
                  onChange={(e) => setFormData({ ...formData, is_active: e.target.checked })}
                  className="h-4 w-4 rounded border-slate-300 text-emerald-600 focus:ring-emerald-500"
                />
                <label htmlFor="is_active" className="text-sm text-slate-700">Active</label>
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
