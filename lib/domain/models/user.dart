enum UserRole { admin, clinic, patient, staff }

class User {
  final String id;
  final String email;
  final String name;
  final UserRole role;
  final String? clinicId;
  final DateTime createdAt;
  final DateTime? lastLoginAt;
  final bool isActive;

  User({
    required this.id,
    required this.email,
    required this.name,
    required this.role,
    this.clinicId,
    required this.createdAt,
    this.lastLoginAt,
    required this.isActive,
  });

  
    'id': id,
    'email': email,
    'name': name,
    'role': role.toString().split('.').last,
    'clinic_id': clinicId,
    'created_at': createdAt.toIso8601String(),
    'last_login_at': lastLoginAt?.toIso8601String(),
    'is_active': isActive,
  };

  
    id: json['id'] as String,
    email: json['email'] as String,
    name: json['name'] as String,
    role: UserRole.values.firstWhere(
      (e) => e.toString().split('.').last == json['role'],
    ),
    clinicId: json['clinic_id'] as String?,
    createdAt: DateTime.parse(json['created_at'] as String),
    lastLoginAt: json['last_login_at'] != null
        ? DateTime.parse(json['last_login_at'] as String)
        : null,
    isActive: json['is_active'] as bool? ?? true,
  );
}
