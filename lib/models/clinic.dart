import 'package:json_annotation/json_annotation.dart';

part 'clinic.g.dart';

@JsonSerializable()
class Clinic {
  final String id;
  final String name;
  final String? address;
  final String? phone;
  final String? email;
  final String? registrationNumber;
  final String plan;
  final String status;
  final DateTime createdAt;
  final DateTime updatedAt;

  Clinic({required this.id, required this.name, this.address, this.phone, this.email, this.registrationNumber, this.plan = 'free', this.status = 'active', required this.createdAt, required this.updatedAt,});

  factory Clinic.fromJson(Map<String, dynamic> json) => _\(json);
  Map<String, dynamic> toJson() => _\(this);
}