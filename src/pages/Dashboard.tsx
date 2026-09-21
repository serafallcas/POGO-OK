import { useEffect, useState } from 'react';
import { supabase } from '../lib/supabase';
import {
  ClipboardList,
  Layers,
  Activity,
  AlertTriangle,
  CheckCircle2,
  BarChart3,
  TrendingUp,
  FileText,
} from 'lucide-react';
import {
  BarChart,
  Bar,
  XAxis,
  YAxis,
  CartesianGrid,
  Tooltip,
  ResponsiveContainer,
  PieChart,
  Pie,
  Cell,
  Legend,
} from 'recharts';

interface DashboardStats {
  totalQuestions: number;
  totalDomains: number;
  activeAssessments: number;
  criticalAlerts: number;
  completionRate: number;
  avgMaturityScore: number;
}

interface Assessment {
  id: string;
  title: string;
  status: string;
  created_at: string;
  overall_score: number | null;
}

const MATURITY_SCALE = [
  { level: 0, label: 'Non-Existent', color: 'bg-slate-600' },
  { level: 1, label: 'Initial', color: 'bg-rose-500' },
  { level: 2, label: 'Repeatable', color: 'bg-amber-500' },
  { level: 3, label: 'Defined', color: 'bg-yellow-500' },
  { level: 4, label: 'Managed', color: 'bg-emerald-500' },
  { level: 5, label: 'Optimized', color: 'bg-emerald-400' },
];

const PIE_COLORS = ['#10b981', '#f59e0b', '#3b82f6', '#ef4444', '#64748b'];

export default function Dashboard() {
  const [stats, setStats] = useState<DashboardStats>({
    totalQuestions: 0,
    totalDomains: 0,
    activeAssessments: 0,
    criticalAlerts: 0,
    completionRate: 0,
    avgMaturityScore: 0,
  });
  const [recentAssessments, setRecentAssessments] = useState<Assessment[]>([]);
  const [domainScores, setDomainScores] = useState<{ name: string; score: number }[]>([]);
  const [statusBreakdown, setStatusBreakdown] = useState<{ name: string; value: number }[]>([]);
  const [loading, setLoading] = useState(true);

  useEffect(() => {
    fetchDashboardData();
  }, []);

  async function fetchDashboardData() {
    try {
      const [
        questionsRes,
        domainsRes,
        assessmentsRes,
        alertsRes,
      ] = await Promise.all([
        supabase.from('questions').select('*', { count: 'exact', head: true }),
        supabase.from('domains').select('*', { count: 'exact', head: true }),
        supabase.from('assessments').select('*'),
        supabase.from('assessment_alerts').select('*', { count: 'exact', head: true }).eq('severity', 'critical'),
      ]);

      const totalQuestions = questionsRes.count ?? 0;
      const totalDomains = domainsRes.count ?? 0;
      const criticalAlerts = alertsRes.count ?? 0;

      const assessments = assessmentsRes.data ?? [];
      const activeAssessments = assessments.filter(
        (a) => a.status === 'in_progress' || a.status === 'draft'
      ).length;

      const completedAssessments = assessments.filter(
        (a) => a.status === 'approved' || a.status === 'closed'
      ).length;
      const completionRate =
        assessments.length > 0
          ? Math.round((completedAssessments / assessments.length) * 100)
          : 0;

      const scoredAssessments = assessments.filter(
        (a) => a.overall_score != null
      );
      const avgMaturityScore =
        scoredAssessments.length > 0
          ? parseFloat(
              (
                scoredAssessments.reduce(
                  (sum, a) => sum + (a.overall_score ?? 0),
                  0
                ) / scoredAssessments.length
              ).toFixed(1)
            )
          : 0;

      setStats({
        totalQuestions,
        totalDomains,
        activeAssessments,
        criticalAlerts,
        completionRate,
        avgMaturityScore,
      });

      const sorted = [...assessments]
        .sort(
          (a, b) =>
            new Date(b.created_at).getTime() - new Date(a.created_at).getTime()
        )
        .slice(0, 5);
      setRecentAssessments(sorted);

      const statusCounts: Record<string, number> = {};
      assessments.forEach((a) => {
        const status = a.status || 'unknown';
        statusCounts[status] = (statusCounts[status] || 0) + 1;
      });
      setStatusBreakdown(
        Object.entries(statusCounts).map(([name, value]) => ({ name, value }))
      );

      const { data: domainData } = await supabase
        .from('domains')
        .select('id, label')
        .order('label')
        .limit(10);

      if (domainData && domainData.length > 0) {
        const { data: respData } = await supabase
          .from('assessment_responses')
          .select('score, question_id, questions!inner(domain_id)')
          .not('score', 'is', null)
          .eq('review_status', 'validated');

        const domainScoreMap: Record<string, { total: number; count: number }> = {};
        (respData || []).forEach((r: any) => {
          const domainId = r.questions?.domain_id;
          if (domainId && r.score != null) {
            if (!domainScoreMap[domainId]) domainScoreMap[domainId] = { total: 0, count: 0 };
            domainScoreMap[domainId].total += r.score;
            domainScoreMap[domainId].count += 1;
          }
        });

        setDomainScores(
          domainData.map((d) => {
            const stats = domainScoreMap[d.id];
            const avgScore = stats ? parseFloat((stats.total / stats.count).toFixed(1)) : 0;
            return {
              name: d.label && d.label.length > 20 ? d.label.substring(0, 20) + '...' : (d.label || 'Unknown'),
              score: avgScore,
            };
          })
        );
      }
    } catch (err) {
      console.error('Error fetching dashboard data:', err);
    } finally {
      setLoading(false);
    }
  }

  if (loading) {
    return (
      <div className="flex items-center justify-center h-64">
        <div className="text-center">
          <div className="w-8 h-8 border-2 border-emerald-500/30 border-t-emerald-500 rounded-full animate-spin mx-auto mb-4" />
          <p className="text-slate-500 text-sm">Loading dashboard...</p>
        </div>
      </div>
    );
  }

  const kpiCards = [
    {
      label: 'Total Questions',
      value: stats.totalQuestions,
      icon: ClipboardList,
      color: 'text-blue-600',
      bgColor: 'bg-blue-50',
      borderColor: 'border-blue-200',
    },
    {
      label: 'Domains',
      value: stats.totalDomains,
      icon: Layers,
      color: 'text-teal-600',
      bgColor: 'bg-teal-50',
      borderColor: 'border-teal-200',
    },
    {
      label: 'Active Assessments',
      value: stats.activeAssessments,
      icon: Activity,
      color: 'text-emerald-600',
      bgColor: 'bg-emerald-50',
      borderColor: 'border-emerald-200',
    },
    {
      label: 'Critical Alerts',
      value: stats.criticalAlerts,
      icon: AlertTriangle,
      color: 'text-rose-600',
      bgColor: 'bg-rose-50',
      borderColor: 'border-rose-200',
    },
    {
      label: 'Completion Rate',
      value: `${stats.completionRate}%`,
      icon: CheckCircle2,
      color: 'text-amber-600',
      bgColor: 'bg-amber-50',
      borderColor: 'border-amber-200',
    },
    {
      label: 'Avg Maturity Score',
      value: stats.avgMaturityScore,
      icon: TrendingUp,
      color: 'text-emerald-600',
      bgColor: 'bg-emerald-50',
      borderColor: 'border-emerald-200',
    },
  ];

  return (
    <div className="space-y-6">
      <div className="flex items-center justify-between">
        <div>
          <h1 className="text-2xl font-bold text-gray-900">Dashboard</h1>
          <p className="text-gray-500 text-sm mt-1">
            POGO Evaluation Tool — Assessment Overview
          </p>
        </div>
        <div className="flex items-center gap-2 text-xs text-gray-400">
          <BarChart3 className="w-4 h-4" />
          Last updated: {new Date().toLocaleDateString()}
        </div>
      </div>

      <div className="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-3 xl:grid-cols-6 gap-4">
        {kpiCards.map((card) => (
          <div
            key={card.label}
            className={`${card.bgColor} border ${card.borderColor} rounded-xl p-4 transition-transform hover:scale-[1.02]`}
          >
            <div className="flex items-center gap-2 mb-2">
              <card.icon className={`w-4 h-4 ${card.color}`} />
              <span className="text-xs text-gray-500 truncate">
                {card.label}
              </span>
            </div>
            <p className={`text-2xl font-bold ${card.color}`}>{card.value}</p>
          </div>
        ))}
      </div>

      <div className="grid grid-cols-1 lg:grid-cols-2 gap-6">
        <div className="bg-white border border-gray-200 rounded-xl p-6 shadow-sm">
          <h3 className="text-gray-900 font-semibold mb-4 flex items-center gap-2">
            <BarChart3 className="w-4 h-4 text-emerald-600" />
            Domains Overview
          </h3>
          {domainScores.length > 0 ? (
            <ResponsiveContainer width="100%" height={260}>
              <BarChart data={domainScores}>
                <CartesianGrid strokeDasharray="3 3" stroke="#e5e7eb" />
                <XAxis
                  dataKey="name"
                  stroke="#6b7280"
                  fontSize={11}
                  angle={-20}
                  textAnchor="end"
                  height={60}
                />
                <YAxis stroke="#6b7280" fontSize={11} />
                <Tooltip
                  contentStyle={{
                    backgroundColor: '#ffffff',
                    border: '1px solid #e5e7eb',
                    borderRadius: '8px',
                    color: '#1f2937',
                  }}
                />
                <Bar dataKey="score" fill="#10b981" radius={[4, 4, 0, 0]} />
              </BarChart>
            </ResponsiveContainer>
          ) : (
            <div className="h-[260px] flex items-center justify-center text-gray-400 text-sm">
              <div className="text-center">
                <Layers className="w-8 h-8 mx-auto mb-2 opacity-50" />
                <p>No domain data available yet</p>
              </div>
            </div>
          )}
        </div>

        <div className="bg-white border border-gray-200 rounded-xl p-6 shadow-sm">
          <h3 className="text-gray-900 font-semibold mb-4 flex items-center gap-2">
            <Activity className="w-4 h-4 text-amber-500" />
            Assessment Status Breakdown
          </h3>
          {statusBreakdown.length > 0 ? (
            <ResponsiveContainer width="100%" height={260}>
              <PieChart>
                <Pie
                  data={statusBreakdown}
                  cx="50%"
                  cy="50%"
                  innerRadius={55}
                  outerRadius={90}
                  paddingAngle={4}
                  dataKey="value"
                  label={({ name, value }) => `${name} (${value})`}
                  labelLine={false}
                >
                  {statusBreakdown.map((_, index) => (
                    <Cell
                      key={`cell-${index}`}
                      fill={PIE_COLORS[index % PIE_COLORS.length]}
                    />
                  ))}
                </Pie>
                <Tooltip
                  contentStyle={{
                    backgroundColor: '#ffffff',
                    border: '1px solid #e5e7eb',
                    borderRadius: '8px',
                    color: '#1f2937',
                  }}
                />
                <Legend
                  wrapperStyle={{ color: '#6b7280', fontSize: '12px' }}
                />
              </PieChart>
            </ResponsiveContainer>
          ) : (
            <div className="h-[260px] flex items-center justify-center text-gray-400 text-sm">
              <div className="text-center">
                <Activity className="w-8 h-8 mx-auto mb-2 opacity-50" />
                <p>No assessments created yet</p>
              </div>
            </div>
          )}
        </div>
      </div>

      <div className="grid grid-cols-1 lg:grid-cols-3 gap-6">
        <div className="lg:col-span-2 bg-white border border-gray-200 rounded-xl p-6 shadow-sm">
          <h3 className="text-gray-900 font-semibold mb-4 flex items-center gap-2">
            <FileText className="w-4 h-4 text-blue-600" />
            Recent Assessments
          </h3>
          {recentAssessments.length > 0 ? (
            <div className="overflow-x-auto">
              <table className="w-full text-sm">
                <thead>
                  <tr className="border-b border-gray-200">
                    <th className="text-left py-2 px-3 text-gray-500 font-medium">Title</th>
                    <th className="text-left py-2 px-3 text-gray-500 font-medium">Status</th>
                    <th className="text-left py-2 px-3 text-gray-500 font-medium">Score</th>
                    <th className="text-left py-2 px-3 text-gray-500 font-medium">Date</th>
                  </tr>
                </thead>
                <tbody>
                  {recentAssessments.map((assessment) => (
                    <tr
                      key={assessment.id}
                      className="border-b border-gray-100 hover:bg-gray-50 transition-colors"
                    >
                      <td className="py-2.5 px-3 text-gray-900">
                        {assessment.title || 'Untitled'}
                      </td>
                      <td className="py-2.5 px-3">
                        <StatusBadge status={assessment.status} />
                      </td>
                      <td className="py-2.5 px-3 text-gray-700">
                        {assessment.overall_score != null
                          ? assessment.overall_score.toFixed(1)
                          : '—'}
                      </td>
                      <td className="py-2.5 px-3 text-gray-500">
                        {new Date(assessment.created_at).toLocaleDateString()}
                      </td>
                    </tr>
                  ))}
                </tbody>
              </table>
            </div>
          ) : (
            <div className="py-12 text-center text-gray-400 text-sm">
              <FileText className="w-8 h-8 mx-auto mb-2 opacity-50" />
              <p>No assessments found</p>
              <p className="text-xs mt-1">Create your first assessment to see it here</p>
            </div>
          )}
        </div>

        <div className="bg-white border border-gray-200 rounded-xl p-6 shadow-sm">
          <h3 className="text-gray-900 font-semibold mb-4 flex items-center gap-2">
            <TrendingUp className="w-4 h-4 text-emerald-600" />
            Maturity Scale
          </h3>
          <div className="space-y-3">
            {MATURITY_SCALE.map((item) => (
              <div key={item.level} className="flex items-center gap-3">
                <div
                  className={`w-8 h-8 rounded-lg ${item.color} flex items-center justify-center text-white text-sm font-bold shrink-0`}
                >
                  {item.level}
                </div>
                <div>
                  <p className="text-gray-900 text-sm font-medium">{item.label}</p>
                  <p className="text-gray-400 text-xs">Level {item.level}</p>
                </div>
              </div>
            ))}
          </div>
        </div>
      </div>
    </div>
  );
}

function StatusBadge({ status }: { status: string }) {
  const styles: Record<string, string> = {
    approved: 'bg-emerald-100 text-emerald-700 border-emerald-200',
    closed: 'bg-gray-100 text-gray-700 border-gray-200',
    in_progress: 'bg-amber-100 text-amber-700 border-amber-200',
    under_review: 'bg-blue-100 text-blue-700 border-blue-200',
    draft: 'bg-slate-100 text-slate-600 border-slate-200',
  };

  const style = styles[status] || styles.draft;

  return (
    <span
      className={`inline-flex items-center px-2 py-0.5 rounded-md text-xs font-medium border ${style}`}
    >
      {status?.replace('_', ' ') || 'unknown'}
    </span>
  );
}
