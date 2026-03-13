enum DocumentStatus { pending, verified, rejected, archived }
enum DocumentType { patientId, insurance, medical, prescription, report }

class Document {
  final String id;
  final String appointmentId;
  final String uploadedBy;
  final DocumentType type;
  final String fileName;
  final String filePath;
  final int fileSize;
  final DocumentStatus status;
  final String? verificationNotes;
  final DateTime createdAt;
  final DateTime? verifiedAt;

  Document({
    required this.id,
    required this.appointmentId,
    required this.uploadedBy,
    required this.type,
    required this.fileName,
    required this.filePath,
    required this.fileSize,
    required this.status,
    this.verificationNotes,
    required this.createdAt,
    this.verifiedAt,
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'appointment_id': appointmentId,
    'uploaded_by': uploadedBy,
    'type': type.toString().split('.').last,
    'file_name': fileName,
    'file_path': filePath,
    'file_size': fileSize,
    'status': status.toString().split('.').last,
    'verification_notes': verificationNotes,
    'created_at': createdAt.toIso8601String(),
    'verified_at': verifiedAt?.toIso8601String(),
  };

  factory Document.fromJson(Map<String, dynamic> json) => Document(
    id: json['id'] as String,
    appointmentId: json['appointment_id'] as String,
    uploadedBy: json['uploaded_by'] as String,
    type: DocumentType.values.firstWhere(
      (e) => e.toString().split('.').last == json['type'],
    ),
    fileName: json['file_name'] as String,
    filePath: json['file_path'] as String,
    fileSize: json['file_size'] as int,
    status: DocumentStatus.values.firstWhere(
      (e) => e.toString().split('.').last == json['status'],
    ),
    verificationNotes: json['verification_notes'] as String?,
    createdAt: DateTime.parse(json['created_at'] as String),
    verifiedAt: json['verified_at'] != null
        ? DateTime.parse(json['verified_at'] as String)
        : null,
  );
}
