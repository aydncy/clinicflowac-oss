class DashboardMetrics {
  final int totalAppointments;
  final int completedAppointments;
  final int pendingAppointments;
  final int totalPatients;
  final int newPatientsThisMonth;
  final double averageRating;
  final double revenue;
  final DateTime lastUpdated;

  DashboardMetrics({
    required this.totalAppointments,
    required this.completedAppointments,
    required this.pendingAppointments,
    required this.totalPatients,
    required this.newPatientsThisMonth,
    required this.averageRating,
    required this.revenue,
    required this.lastUpdated,
  });

  double get completionRate => totalAppointments == 0 
    ? 0 
    : (completedAppointments / totalAppointments) * 100;

  double get appointmentUtilization => totalAppointments == 0
    ? 0
    : ((totalAppointments - pendingAppointments) / totalAppointments) * 100;

  Map<String, dynamic> toJson() => {
    'totalAppointments': totalAppointments,
    'completedAppointments': completedAppointments,
    'pendingAppointments': pendingAppointments,
    'totalPatients': totalPatients,
    'newPatientsThisMonth': newPatientsThisMonth,
    'averageRating': averageRating,
    'revenue': revenue,
    'completionRate': completionRate,
    'appointmentUtilization': appointmentUtilization,
    'lastUpdated': lastUpdated.toIso8601String(),
  };
}

class ClinicDashboardService {
  final Map<String, DashboardMetrics> _metrics = {};

  DashboardMetrics generateDashboard(String clinicId) {
    final metrics = DashboardMetrics(
      totalAppointments: 150,
      completedAppointments: 120,
      pendingAppointments: 30,
      totalPatients: 450,
      newPatientsThisMonth: 25,
      averageRating: 4.8,
      revenue: 15000.50,
      lastUpdated: DateTime.now(),
    );

    _metrics[clinicId] = metrics;
    print('✅ Dashboard generated for clinic: $clinicId');
    return metrics;
  }

  DashboardMetrics? getDashboard(String clinicId) {
    return _metrics[clinicId];
  }

  Map<String, dynamic> getDetailedAnalytics(String clinicId) {
    final metrics = _metrics[clinicId];
    if (metrics == null) return {};

    return {
      'clinic_id': clinicId,
      'overview': {
        'totalAppointments': metrics.totalAppointments,
        'completedAppointments': metrics.completedAppointments,
        'completionRate': '${metrics.completionRate.toStringAsFixed(2)}%',
      },
      'patients': {
        'totalPatients': metrics.totalPatients,
        'newThisMonth': metrics.newPatientsThisMonth,
        'growthRate': '${(metrics.newPatientsThisMonth / metrics.totalPatients * 100).toStringAsFixed(2)}%',
      },
      'performance': {
        'appointmentUtilization': '${metrics.appointmentUtilization.toStringAsFixed(2)}%',
        'averageRating': metrics.averageRating,
        'revenue': '\$${metrics.revenue.toStringAsFixed(2)}',
      },
      'lastUpdated': metrics.lastUpdated.toIso8601String(),
    };
  }

  Map<String, dynamic> getComparisonWithPreviousMonth(String clinicId) {
    final currentMetrics = _metrics[clinicId];
    if (currentMetrics == null) return {};

    return {
      'clinic_id': clinicId,
      'appointments': {
        'current': currentMetrics.totalAppointments,
        'previous': 140,
        'change': '+${currentMetrics.totalAppointments - 140}',
        'percentageChange': '+7.14%',
      },
      'patients': {
        'current': currentMetrics.totalPatients,
        'previous': 425,
        'change': '+${currentMetrics.totalPatients - 425}',
        'percentageChange': '+5.88%',
      },
      'revenue': {
        'current': currentMetrics.revenue,
        'previous': 14200.00,
        'change': '+${(currentMetrics.revenue - 14200).toStringAsFixed(2)}',
        'percentageChange': '+5.62%',
      },
    };
  }

  void refreshDashboard(String clinicId) {
    generateDashboard(clinicId);
    print('🔄 Dashboard refreshed for clinic: $clinicId');
  }

  Map<String, DashboardMetrics> getAllDashboards() {
    return Map.from(_metrics);
  }
}
