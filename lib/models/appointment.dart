import 'package:json_annotation/json_annotation.dart';

part 'appointment.g.dart';

@JsonSerializable()
class Appointment {
  final String id;
  final String clinicId;
  final String doctorId;
  final String patientId;
  final DateTime appointmentDate;
  final int durationMinutes;
  final String? reason;
  final String? notes;
  final String status;
  final DateTime createdAt;

  Appointment({required this.id, required this.clinicId, required this.doctorId, required this.patientId, required this.appointmentDate, this.durationMinutes = 30, this.reason, this.notes, this.status = 'scheduled', required this.createdAt,});

  factory Appointment.fromJson(Map<String, dynamic> json) => _\(json);
  Map<String, dynamic> toJson() => _\(this);
}