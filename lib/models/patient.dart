import 'package:json_annotation/json_annotation.dart';

part 'patient.g.dart';

@JsonSerializable()
class Patient {
  final String id;
  final String clinicId;
  final String firstName;
  final String lastName;
  final DateTime? dateOfBirth;
  final String? gender;
  final String? email;
  final String? phone;
  final String? address;
  final String? emergencyContact;
  final String? emergencyPhone;
  final String? medicalHistory;
  final String? allergies;
  final String status;
  final DateTime createdAt;

  Patient({required this.id, required this.clinicId, required this.firstName, required this.lastName, this.dateOfBirth, this.gender, this.email, this.phone, this.address, this.emergencyContact, this.emergencyPhone, this.medicalHistory, this.allergies, this.status = 'active', required this.createdAt,});

  factory Patient.fromJson(Map<String, dynamic> json) => _\(json);
  Map<String, dynamic> toJson() => _\(this);
}