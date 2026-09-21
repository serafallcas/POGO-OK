import { useState } from 'react';
import { Outlet, NavLink, useNavigate } from 'react-router-dom';
import {
  LayoutDashboard, ClipboardCheck, Building2, Layers, Network, GitBranch,
  TrendingUp, HelpCircle, Upload, BarChart3, Menu, X, LogOut, Shield,
  ChevronDown, User, Search, ListChecks, Library,
} from 'lucide-react';
import { useAuth } from '../contexts/AuthContext';

const NAV_SECTIONS = [
  {
    title: null,
    items: [
      { name: 'Dashboard', path: '/', icon: LayoutDashboard },
      { name: 'Assessments', path: '/assessments', icon: ClipboardCheck },
      { name: 'Findings & Actions', path: '/findings', icon: Search },
      { name: 'Alerts', path: '/alerts', icon: ListChecks },
      { name: 'Action Plans', path: '/action-plans', icon: Library },
    ],
  },
  {
    title: 'Reference Library',
    items: [
      { name: 'Evaluation Types', path: '/evaluation-types', icon: Layers },
      { name: 'Domains', path: '/domains', icon: Network },
      { name: 'Processes', path: '/processes', icon: GitBranch },
      { name: 'Maturity Models', path: '/maturity-models', icon: TrendingUp },
      { name: 'Questions', path: '/questions', icon: HelpCircle },
    ],
  },
  {
    title: 'Tools',
    items: [
      { name: 'Import Center', path: '/import', icon: Upload },
      { name: 'Reports', path: '/reports', icon: BarChart3 },
    ],
  },
  {
    title: 'Administration',
    items: [
      { name: 'Organizations', path: '/organizations', icon: Building2 },
    ],
  },
];

export default function Layout() {
  const [sidebarOpen, setSidebarOpen] = useState(false);
  const [userMenuOpen, setUserMenuOpen] = useState(false);
  const { user, signOut } = useAuth();
  const navigate = useNavigate();

  const handleLogout = async () => {
    await signOut();
    navigate('/login');
  };

  return (
    <div className="flex h-screen overflow-hidden bg-gray-50">
      {sidebarOpen && (
        <div className="fixed inset-0 z-40 bg-black/50 lg:hidden" onClick={() => setSidebarOpen(false)} />
      )}

      <aside className={`fixed inset-y-0 left-0 z-50 w-64 transform bg-slate-900 transition-transform duration-200 ease-in-out lg:relative lg:translate-x-0 ${sidebarOpen ? 'translate-x-0' : '-translate-x-full'}`}>
        <div className="flex h-16 items-center justify-between px-4 border-b border-slate-700/50">
          <div className="flex items-center gap-2.5">
            <div className="flex h-9 w-9 items-center justify-center rounded-lg bg-emerald-600/20 border border-emerald-500/30">
              <Shield className="h-5 w-5 text-emerald-400" />
            </div>
            <div>
              <h1 className="text-lg font-bold text-white tracking-tight">POGO</h1>
              <p className="text-[10px] font-medium text-slate-400 -mt-0.5 uppercase tracking-wider">Evaluation Tool</p>
            </div>
          </div>
          <button onClick={() => setSidebarOpen(false)} className="rounded-md p-1 text-slate-400 hover:text-white lg:hidden">
            <X className="h-5 w-5" />
          </button>
        </div>

        <nav className="flex-1 overflow-y-auto px-3 py-4 space-y-4">
          {NAV_SECTIONS.map((section, idx) => (
            <div key={idx}>
              {section.title && (
                <p className="px-3 mb-1.5 text-[10px] font-semibold uppercase tracking-wider text-slate-500">{section.title}</p>
              )}
              <div className="space-y-0.5">
                {section.items.map((item) => (
                  <NavLink
                    key={item.path}
                    to={item.path}
                    end={item.path === '/'}
                    onClick={() => setSidebarOpen(false)}
                    className={({ isActive }) =>
                      `flex items-center gap-3 rounded-lg px-3 py-2 text-sm font-medium transition-colors duration-150 ${
                        isActive
                          ? 'bg-emerald-600/20 text-emerald-400 border border-emerald-500/20'
                          : 'text-slate-300 hover:bg-slate-800 hover:text-white border border-transparent'
                      }`
                    }
                  >
                    <item.icon className="h-[18px] w-[18px] flex-shrink-0" />
                    <span>{item.name}</span>
                  </NavLink>
                ))}
              </div>
            </div>
          ))}
        </nav>

        <div className="border-t border-slate-700/50 p-3">
          <div className="flex items-center gap-3 rounded-lg px-3 py-2 text-xs text-slate-500">
            <div className="h-2 w-2 rounded-full bg-emerald-400 animate-pulse" />
            <span>System Online</span>
          </div>
        </div>
      </aside>

      <div className="flex flex-1 flex-col overflow-hidden">
        <header className="flex h-14 items-center justify-between border-b border-gray-200 bg-white px-4 shadow-sm">
          <div className="flex items-center gap-3">
            <button onClick={() => setSidebarOpen(true)} className="rounded-md p-2 text-gray-500 hover:bg-gray-100 hover:text-gray-700 lg:hidden">
              <Menu className="h-5 w-5" />
            </button>
          </div>

          <div className="relative flex items-center gap-3">
            <button onClick={() => setUserMenuOpen(!userMenuOpen)}
              className="flex items-center gap-2 rounded-lg px-3 py-1.5 text-sm text-gray-700 hover:bg-gray-100 transition-colors">
              <div className="flex h-7 w-7 items-center justify-center rounded-full bg-emerald-100 text-emerald-700">
                <User className="h-3.5 w-3.5" />
              </div>
              <span className="hidden sm:block font-medium text-xs">{user?.email || 'User'}</span>
              <ChevronDown className="h-3.5 w-3.5 text-gray-400" />
            </button>

            {userMenuOpen && (
              <>
                <div className="fixed inset-0 z-30" onClick={() => setUserMenuOpen(false)} />
                <div className="absolute right-0 top-full z-40 mt-1 w-52 rounded-lg border border-gray-200 bg-white py-1 shadow-lg">
                  <div className="border-b border-gray-100 px-4 py-2">
                    <p className="text-xs font-medium text-gray-900 truncate">{user?.email || 'User'}</p>
                  </div>
                  <button onClick={handleLogout}
                    className="flex w-full items-center gap-2 px-4 py-2 text-sm text-red-600 hover:bg-red-50 transition-colors">
                    <LogOut className="h-4 w-4" /><span>Sign out</span>
                  </button>
                </div>
              </>
            )}
          </div>
        </header>

        <main className="flex-1 overflow-y-auto bg-gray-50 p-6">
          <Outlet />
        </main>
      </div>
    </div>
  );
}
