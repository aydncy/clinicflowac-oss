class Clinic {
  final String id;
  final String name;
  final String address;
  final String city;
  final String country;
  final String phone;
  final String email;
  final String? website;
  final DateTime createdAt;
  final bool isActive;

  Clinic({
    required this.id,
    required this.name,
    required this.address,
    required this.city,
    required this.country,
    required this.phone,
    required this.email,
    this.website,
    required this.createdAt,
    required this.isActive,
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'address': address,
    'city': city,
    'country': country,
    'phone': phone,
    'email': email,
    'website': website,
    'created_at': createdAt.toIso8601String(),
    'is_active': isActive,
  };

  factory Clinic.fromJson(Map<String, dynamic> json) => Clinic(
    id: json['id'] as String,
    name: json['name'] as String,
    address: json['address'] as String,
    city: json['city'] as String,
    country: json['country'] as String,
    phone: json['phone'] as String,
    email: json['email'] as String,
    website: json['website'] as String?,
    createdAt: DateTime.parse(json['created_at'] as String),
    isActive: json['is_active'] as bool? ?? true,
  );
}
