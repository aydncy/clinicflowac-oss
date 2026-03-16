class Invoice {
  final String id;
  final String clinicId;
  final int amount;
  final String status;
  final DateTime createdAt;

  Invoice({
    required this.id,
    required this.clinicId,
    required this.amount,
    required this.status,
    required this.createdAt,
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'clinic_id': clinicId,
    'amount': amount,
    'status': status,
    'created_at': createdAt.toIso8601String(),
  };
}