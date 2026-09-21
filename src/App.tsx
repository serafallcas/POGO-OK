import { BrowserRouter, Routes, Route, Navigate } from 'react-router-dom';
import { AuthProvider, useAuth } from './contexts/AuthContext';
import Layout from './components/Layout';
import Login from './pages/Login';
import Dashboard from './pages/Dashboard';
import Assessments from './pages/Assessments';
import Assessment360 from './pages/Assessment360';
import Organizations from './pages/Organizations';
import EvaluationTypes from './pages/EvaluationTypes';
import Domains from './pages/Domains';
import Processes from './pages/Processes';
import MaturityModels from './pages/MaturityModels';
import Questions from './pages/Questions';
import ImportCenter from './pages/ImportCenter';
import Findings from './pages/Findings';
import ActionPlans from './pages/ActionPlans';
import Reports from './pages/Reports';
import Alerts from './pages/Alerts';

function ProtectedRoute({ children }: { children: React.ReactNode }) {
  const { user, loading } = useAuth();

  if (loading) {
    return (
      <div className="min-h-screen flex items-center justify-center bg-slate-50">
        <div className="flex flex-col items-center gap-4">
          <div className="w-12 h-12 border-4 border-emerald-500 border-t-transparent rounded-full animate-spin" />
          <p className="text-slate-600 font-medium">Loading POGO...</p>
        </div>
      </div>
    );
  }

  if (!user) {
    return <Navigate to="/login" replace />;
  }

  return <>{children}</>;
}

function AppRoutes() {
  const { user, loading } = useAuth();

  if (loading) {
    return (
      <div className="min-h-screen flex items-center justify-center bg-slate-50">
        <div className="w-12 h-12 border-4 border-emerald-500 border-t-transparent rounded-full animate-spin" />
      </div>
    );
  }

  return (
    <Routes>
      <Route path="/login" element={user ? <Navigate to="/" replace /> : <Login />} />
      <Route
        path="/"
        element={
          <ProtectedRoute>
            <Layout />
          </ProtectedRoute>
        }
      >
        <Route index element={<Dashboard />} />
        <Route path="assessments" element={<Assessments />} />
        <Route path="assessments/:id" element={<Assessment360 />} />
        <Route path="organizations" element={<Organizations />} />
        <Route path="evaluation-types" element={<EvaluationTypes />} />
        <Route path="domains" element={<Domains />} />
        <Route path="processes" element={<Processes />} />
        <Route path="maturity-models" element={<MaturityModels />} />
        <Route path="questions" element={<Questions />} />
        <Route path="import" element={<ImportCenter />} />
        <Route path="findings" element={<Findings />} />
        <Route path="action-plans" element={<ActionPlans />} />
        <Route path="alerts" element={<Alerts />} />
        <Route path="reports" element={<Reports />} />
      </Route>
    </Routes>
  );
}

export default function App() {
  return (
    <BrowserRouter>
      <AuthProvider>
        <AppRoutes />
      </AuthProvider>
    </BrowserRouter>
  );
}
