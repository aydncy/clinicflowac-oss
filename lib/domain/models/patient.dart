class Patient {
  final String id;
  final String firstName;
  final String lastName;
  final String email;
  final String phone;
  final DateTime dateOfBirth;
  final String gender;
  final String address;
  final String city;
  final String country;
  final String? medicalNumber;
  final String? emergencyContact;
  final String? emergencyPhone;
  final DateTime createdAt;
  final DateTime? lastVisit;

  Patient({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.phone,
    required this.dateOfBirth,
    required this.gender,
    required this.address,
    required this.city,
    required this.country,
    this.medicalNumber,
    this.emergencyContact,
    this.emergencyPhone,
    required this.createdAt,
    this.lastVisit,
  });

  String get fullName => '$firstName $lastName';

  int get age {
    final now = DateTime.now();
    int age = now.year - dateOfBirth.year;
    if (now.month < dateOfBirth.month ||
        (now.month == dateOfBirth.month && now.day < dateOfBirth.day)) {
      age--;
    }
    return age;
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'first_name': firstName,
    'last_name': lastName,
    'email': email,
    'phone': phone,
    'date_of_birth': dateOfBirth.toIso8601String(),
    'gender': gender,
    'address': address,
    'city': city,
    'country': country,
    'medical_number': medicalNumber,
    'emergency_contact': emergencyContact,
    'emergency_phone': emergencyPhone,
    'created_at': createdAt.toIso8601String(),
    'last_visit': lastVisit?.toIso8601String(),
  };

  factory Patient.fromJson(Map<String, dynamic> json) => Patient(
    id: json['id'] as String,
    firstName: json['first_name'] as String,
    lastName: json['last_name'] as String,
    email: json['email'] as String,
    phone: json['phone'] as String,
    dateOfBirth: DateTime.parse(json['date_of_birth'] as String),
    gender: json['gender'] as String,
    address: json['address'] as String,
    city: json['city'] as String,
    country: json['country'] as String,
    medicalNumber: json['medical_number'] as String?,
    emergencyContact: json['emergency_contact'] as String?,
    emergencyPhone: json['emergency_phone'] as String?,
    createdAt: DateTime.parse(json['created_at'] as String),
    lastVisit: json['last_visit'] != null
        ? DateTime.parse(json['last_visit'] as String)
        : null,
  );
}
