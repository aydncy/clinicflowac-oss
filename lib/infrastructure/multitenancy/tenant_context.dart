class TenantContext {
  final String tenantId;
  final String clinicId;
  final String clinicName;
  final String region;
  final DateTime createdAt;
  bool active;
  final Map<String, dynamic> metadata;
  final String databaseName;
  final String schemaName;

  TenantContext({
    required this.tenantId,
    required this.clinicId,
    required this.clinicName,
    required this.region,
    required this.createdAt,
    this.active = true,
    this.metadata = const {},
    this.databaseName = 'default_db',
    this.schemaName = 'public',
  });

  Map<String, dynamic> toJson() {
    return {
      'tenantId': tenantId,
      'clinicId': clinicId,
      'clinicName': clinicName,
      'region': region,
      'createdAt': createdAt.toIso8601String(),
      'active': active,
      'databaseName': databaseName,
      'schemaName': schemaName,
      'metadata': metadata,
    };
  }
}
