import React, { useState, useEffect } from 'react';
import { Plus, Pencil, Search, ToggleLeft, ToggleRight, Workflow } from 'lucide-react';
import { supabase } from '../lib/supabase';
import { useAuth } from '../contexts/AuthContext';

interface Domain {
  id: string;
  code: string;
  label: string;
}

interface Process {
  id: string;
  code: string;
  label: string;
  domain_id: string;
  description: string | null;
  is_active: boolean;
  domains: Domain | null;
}

interface FormData {
  code: string;
  label: string;
  domain_id: string;
  description: string;
  is_active: boolean;
}

const defaultFormData: FormData = {
  code: '',
  label: '',
  domain_id: '',
  description: '',
  is_active: true,
};

export default function Processes() {
  const { isAdmin } = useAuth();
  const [processes, setProcesses] = useState<Process[]>([]);
  const [domains, setDomains] = useState<Domain[]>([]);
  const [loading, setLoading] = useState(true);
  const [searchTerm, setSearchTerm] = useState('');
  const [filterDomain, setFilterDomain] = useState('');
  const [showModal, setShowModal] = useState(false);
  const [editingItem, setEditingItem] = useState<Process | null>(null);
  const [formData, setFormData] = useState<FormData>(defaultFormData);
  const [saving, setSaving] = useState(false);

  useEffect(() => {
    fetchProcesses();
    fetchDomains();
  }, []);

  async function fetchProcesses() {
    setLoading(true);
    const { data, error } = await supabase
      .from('processes')
      .select('*, domains(id, code, label)')
      .order('code', { ascending: true });

    if (error) {
      console.error('Error fetching processes:', error);
    } else {
      setProcesses(data || []);
    }
    setLoading(false);
  }

  async function fetchDomains() {
    const { data, error } = await supabase
      .from('domains')
      .select('id, code, label')
      .eq('is_active', true)
      .order('code', { ascending: true });

    if (error) {
      console.error('Error fetching domains:', error);
    } else {
      setDomains(data || []);
    }
  }

  async function handleSubmit(e: React.FormEvent) {
    e.preventDefault();
    setSaving(true);

    const payload = {
      code: formData.code,
      label: formData.label,
      domain_id: formData.domain_id,
      description: formData.description || null,
      is_active: formData.is_active,
    };

    let error;
    if (editingItem) {
      ({ error } = await supabase
        .from('processes')
        .update(payload)
        .eq('id', editingItem.id));
    } else {
      ({ error } = await supabase.from('processes').insert(payload));
    }

    if (error) {
      console.error('Error saving process:', error);
    } else {
      setShowModal(false);
      setEditingItem(null);
      setFormData(defaultFormData);
      fetchProcesses();
    }
    setSaving(false);
  }

  async function toggleActive(item: Process) {
    const { error } = await supabase
      .from('processes')
      .update({ is_active: !item.is_active })
      .eq('id', item.id);

    if (error) {
      console.error('Error toggling active status:', error);
    } else {
      fetchProcesses();
    }
  }

  function openAddModal() {
    setEditingItem(null);
    setFormData(defaultFormData);
    setShowModal(true);
  }

  function openEditModal(item: Process) {
    setEditingItem(item);
    setFormData({
      code: item.code,
      label: item.label,
      domain_id: item.domain_id,
      description: item.description || '',
      is_active: item.is_active,
    });
    setShowModal(true);
  }

  const filteredProcesses = processes.filter((item) => {
    const matchesSearch =
      item.code.toLowerCase().includes(searchTerm.toLowerCase()) ||
      item.label.toLowerCase().includes(searchTerm.toLowerCase()) ||
      (item.description || '').toLowerCase().includes(searchTerm.toLowerCase());
    const matchesFilter = filterDomain ? item.domain_id === filterDomain : true;
    return matchesSearch && matchesFilter;
  });

  return (
    <div className="p-6 max-w-7xl mx-auto">
      {/* Header */}
      <div className="mb-6">
        <div className="flex items-center gap-3 mb-2">
          <Workflow className="h-8 w-8 text-emerald-600" />
          <h1 className="text-2xl font-bold text-slate-800">Processes</h1>
        </div>
        <p className="text-slate-500">Manage process definitions</p>
      </div>

      {/* Toolbar */}
      <div className="flex flex-col sm:flex-row gap-4 mb-6">
        <div className="relative flex-1">
          <Search className="absolute left-3 top-1/2 -translate-y-1/2 h-4 w-4 text-slate-400" />
          <input
            type="text"
            placeholder="Search processes..."
            value={searchTerm}
            onChange={(e) => setSearchTerm(e.target.value)}
            className="w-full pl-10 pr-4 py-2 border border-slate-200 rounded-lg focus:outline-none focus:ring-2 focus:ring-emerald-500 focus:border-transparent"
          />
        </div>
        <select
          value={filterDomain}
          onChange={(e) => setFilterDomain(e.target.value)}
          className="px-4 py-2 border border-slate-200 rounded-lg focus:outline-none focus:ring-2 focus:ring-emerald-500 text-sm text-slate-700"
        >
          <option value="">All Domains</option>
          {domains.map((domain) => (
            <option key={domain.id} value={domain.id}>
              {domain.label}
            </option>
          ))}
        </select>
        {isAdmin && (
          <button
            onClick={openAddModal}
            className="inline-flex items-center gap-2 px-4 py-2 bg-emerald-600 text-white rounded-lg hover:bg-emerald-700 transition-colors font-medium"
          >
            <Plus className="h-4 w-4" />
            Add Process
          </button>
        )}
      </div>

      {/* Table */}
      <div className="bg-white rounded-xl shadow-sm border border-slate-200 overflow-hidden">
        <div className="overflow-x-auto">
          <table className="w-full">
            <thead>
              <tr className="bg-slate-50 border-b border-slate-200">
                <th className="text-left px-6 py-3 text-xs font-semibold text-slate-600 uppercase tracking-wider">Code</th>
                <th className="text-left px-6 py-3 text-xs font-semibold text-slate-600 uppercase tracking-wider">Label</th>
                <th className="text-left px-6 py-3 text-xs font-semibold text-slate-600 uppercase tracking-wider">Domain</th>
                <th className="text-left px-6 py-3 text-xs font-semibold text-slate-600 uppercase tracking-wider">Description</th>
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
              ) : filteredProcesses.length === 0 ? (
                <tr>
                  <td colSpan={6} className="px-6 py-12 text-center text-slate-400">
                    No processes found.
                  </td>
                </tr>
              ) : (
                filteredProcesses.map((item) => (
                  <tr key={item.id} className="hover:bg-slate-50 transition-colors">
                    <td className="px-6 py-4 text-sm font-mono font-medium text-slate-800">{item.code}</td>
                    <td className="px-6 py-4 text-sm text-slate-700">{item.label}</td>
                    <td className="px-6 py-4 text-sm">
                      {item.domains ? (
                        <span className="inline-flex items-center px-2.5 py-0.5 rounded-full text-xs font-medium bg-emerald-50 text-emerald-700">
                          {item.domains.label}
                        </span>
                      ) : (
                        <span className="text-slate-400">—</span>
                      )}
                    </td>
                    <td className="px-6 py-4 text-sm text-slate-500 max-w-xs truncate">{item.description || '—'}</td>
                    <td className="px-6 py-4 text-center">
                      {isAdmin ? (
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
                      ) : (
                        item.is_active ? <ToggleRight className="h-6 w-6 text-emerald-600 opacity-50" /> : <ToggleLeft className="h-6 w-6 text-slate-300 opacity-50" />
                      )}
                    </td>
                    <td className="px-6 py-4 text-center">
                      {isAdmin && (
                        <button
                          onClick={() => openEditModal(item)}
                          className="inline-flex items-center gap-1 px-3 py-1.5 text-sm text-slate-600 hover:text-emerald-600 hover:bg-emerald-50 rounded-md transition-colors"
                        >
                          <Pencil className="h-3.5 w-3.5" />
                          Edit
                        </button>
                      )}
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
              {editingItem ? 'Edit Process' : 'Add Process'}
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
                <label className="block text-sm font-medium text-slate-700 mb-1">Domain</label>
                <select
                  required
                  value={formData.domain_id}
                  onChange={(e) => setFormData({ ...formData, domain_id: e.target.value })}
                  className="w-full px-3 py-2 border border-slate-200 rounded-lg focus:outline-none focus:ring-2 focus:ring-emerald-500"
                >
                  <option value="">Select domain...</option>
                  {domains.map((domain) => (
                    <option key={domain.id} value={domain.id}>
                      {domain.label}
                    </option>
                  ))}
                </select>
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
              <div className="flex items-center gap-2">
                <input
                  type="checkbox"
                  id="process_is_active"
                  checked={formData.is_active}
                  onChange={(e) => setFormData({ ...formData, is_active: e.target.checked })}
                  className="h-4 w-4 rounded border-slate-300 text-emerald-600 focus:ring-emerald-500"
                />
                <label htmlFor="process_is_active" className="text-sm text-slate-700">Active</label>
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
