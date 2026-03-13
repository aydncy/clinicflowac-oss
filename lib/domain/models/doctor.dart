enum DoctorSpecialty { general, cardiology, pediatrics, orthopedics, dentistry, psychiatry }

class Doctor {
  final String id;
  final String firstName;
  final String lastName;
  final String email;
  final String phone;
  final String licenseNumber;
  final DoctorSpecialty specialty;
  final String clinicId;
  final String? biography;
  final double? rating;
  final int? totalPatients;
  final bool isAvailable;
  final DateTime createdAt;

  Doctor({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.phone,
    required this.licenseNumber,
    required this.specialty,
    required this.clinicId,
    this.biography,
    this.rating,
    this.totalPatients,
    required this.isAvailable,
    required this.createdAt,
  });

  String get fullName => '$firstName $lastName';
  String get specialtyName => specialty.toString().split('.').last;

  Map<String, dynamic> toJson() => {
    'id': id,
    'first_name': firstName,
    'last_name': lastName,
    'email': email,
    'phone': phone,
    'license_number': licenseNumber,
    'specialty': specialtyName,
    'clinic_id': clinicId,
    'biography': biography,
    'rating': rating,
    'total_patients': totalPatients,
    'is_available': isAvailable,
    'created_at': createdAt.toIso8601String(),
  };

  factory Doctor.fromJson(Map<String, dynamic> json) => Doctor(
    id: json['id'] as String,
    firstName: json['first_name'] as String,
    lastName: json['last_name'] as String,
    email: json['email'] as String,
    phone: json['phone'] as String,
    licenseNumber: json['license_number'] as String,
    specialty: DoctorSpecialty.values.firstWhere(
      (e) => e.toString().split('.').last == json['specialty'],
    ),
    clinicId: json['clinic_id'] as String,
    biography: json['biography'] as String?,
    rating: json['rating'] as double?,
    totalPatients: json['total_patients'] as int?,
    isAvailable: json['is_available'] as bool? ?? true,
    createdAt: DateTime.parse(json['created_at'] as String),
  );
}
