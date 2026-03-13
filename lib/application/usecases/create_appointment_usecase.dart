import '../../domain/models/appointment.dart';
import '../../domain/events/appointment_events.dart';
import '../../infrastructure/repositories/appointment_repository.dart';
import '../../services/ovwi_client.dart';

class CreateAppointmentRequest {
  final String patientId;
  final String clinicId;
  final String? doctorId;
  final DateTime scheduledTime;
  final String? reason;

  CreateAppointmentRequest({
    required this.patientId,
    required this.clinicId,
    this.doctorId,
    required this.scheduledTime,
    this.reason,
  });
}

class CreateAppointmentResponse {
  final String appointmentId;
  final String eventId;
  final Map<String, dynamic> proof;

  CreateAppointmentResponse({
    required this.appointmentId,
    required this.eventId,
    required this.proof,
  });
}

class CreateAppointmentUseCase {
  final AppointmentRepository appointmentRepository;
  final OvwiClient ovwiClient;

  CreateAppointmentUseCase({
    required this.appointmentRepository,
    required this.ovwiClient,
  });

  Future<CreateAppointmentResponse> execute(CreateAppointmentRequest request) async {
    final appointmentId = 'apt_${DateTime.now().millisecondsSinceEpoch}';

    final appointment = Appointment(
      id: appointmentId,
      patientId: request.patientId,
      clinicId: request.clinicId,
      doctorId: request.doctorId,
      scheduledTime: request.scheduledTime,
      status: AppointmentStatus.scheduled,
      reason: request.reason,
      createdAt: DateTime.now(),
    );

    await appointmentRepository.save(appointment);

    final event = AppointmentEvents.created(
      appointmentId: appointmentId,
      patientId: request.patientId,
      clinicId: request.clinicId,
      scheduledTime: request.scheduledTime,
    );

    final proof = await ovwiClient.submitEvent(event);

    return CreateAppointmentResponse(
      appointmentId: appointmentId,
      eventId: event.id,
      proof: {
        'hash': proof.hash,
        'signature': proof.signature,
        'sequence': proof.sequence,
      },
    );
  }
}
