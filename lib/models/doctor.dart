import 'package:json_annotation/json_annotation.dart';

part 'doctor.g.dart';

@JsonSerializable()
class Doctor {
  final String id;
  final String clinicId;
  final String name;
  final String? email;
  final String? phone;
  final String? specialization;
  final String? licenseNumber;
  final String status;
  final DateTime createdAt;

  Doctor({required this.id, required this.clinicId, required this.name, this.email, this.phone, this.specialization, this.licenseNumber, this.status = 'active', required this.createdAt,});

  factory Doctor.fromJson(Map<String, dynamic> json) => _\(json);
  Map<String, dynamic> toJson() => _\(this);
}