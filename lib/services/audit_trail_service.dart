class AuditLog {
  final String id;
  final String userId;
  final String action;
  final String resourceType;
  final String resourceId;
  final Map<String, dynamic>? changes;
  final String? reason;
  final DateTime timestamp;
  final String ipAddress;

  AuditLog({
    required this.id,
    required this.userId,
    required this.action,
    required this.resourceType,
    required this.resourceId,
    this.changes,
    this.reason,
    required this.timestamp,
    required this.ipAddress,
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'user_id': userId,
    'action': action,
    'resource_type': resourceType,
    'resource_id': resourceId,
    'changes': changes,
    'reason': reason,
    'timestamp': timestamp.toIso8601String(),
    'ip_address': ipAddress,
  };
}

class AuditTrailService {
  final List<AuditLog> _logs = [];
  final int _maxLogs = 100000;

  Future<void> log({
    required String userId,
    required String action,
    required String resourceType,
    required String resourceId,
    Map<String, dynamic>? changes,
    String? reason,
    String? ipAddress,
  }) async {
    final auditLog = AuditLog(
      id: 'audit_${DateTime.now().millisecondsSinceEpoch}',
      userId: userId,
      action: action,
      resourceType: resourceType,
      resourceId: resourceId,
      changes: changes,
      reason: reason,
      timestamp: DateTime.now(),
      ipAddress: ipAddress ?? 'unknown',
    );

    _logs.add(auditLog);
    print('📝 Audit: $userId $action $resourceType:$resourceId');

    if (_logs.length > _maxLogs) {
      // Archive old logs to database
      final logsToArchive = _logs.sublist(0, _logs.length - _maxLogs);
      await _archiveLogs(logsToArchive);
      _logs.removeRange(0, logsToArchive.length);
    }
  }

  Future<List<AuditLog>> getLogsForResource(
    String resourceType,
    String resourceId,
  ) async {
    return _logs
        .where((l) => l.resourceType == resourceType && l.resourceId == resourceId)
        .toList();
  }

  Future<List<AuditLog>> getLogsForUser(String userId) async {
    return _logs.where((l) => l.userId == userId).toList();
  }

  Future<void> _archiveLogs(List<AuditLog> logs) async {
    print('🗃️ Archiving ${logs.length} audit logs');
    // In production: write to cold storage / database
  }
}
