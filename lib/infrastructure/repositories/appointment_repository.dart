import '../../domain/models/appointment.dart';

abstract class AppointmentRepository {
  Future<void> save(Appointment appointment);
  Future<Appointment?> getById(String appointmentId);
  Future<List<Appointment>> getByPatientId(String patientId);
  Future<List<Appointment>> getByClinicId(String clinicId);
  Future<List<Appointment>> getByDateRange(DateTime start, DateTime end);
  Future<void> update(Appointment appointment);
  Future<void> delete(String appointmentId);
}

class InMemoryAppointmentRepository implements AppointmentRepository {
  final Map<String, Appointment> _store = {};

  @override
  Future<void> save(Appointment appointment) async {
    _store[appointment.id] = appointment;
    print('✅ Appointment saved: ${appointment.id}');
  }

  @override
  Future<Appointment?> getById(String appointmentId) async {
    return _store[appointmentId];
  }

  @override
  Future<List<Appointment>> getByPatientId(String patientId) async {
    return _store.values.where((a) => a.patientId == patientId).toList();
  }

  @override
  Future<List<Appointment>> getByClinicId(String clinicId) async {
    return _store.values.where((a) => a.clinicId == clinicId).toList();
  }

  @override
  Future<List<Appointment>> getByDateRange(DateTime start, DateTime end) async {
    return _store.values
        .where((a) => a.scheduledTime.isAfter(start) && a.scheduledTime.isBefore(end))
        .toList();
  }

  @override
  Future<void> update(Appointment appointment) async {
    _store[appointment.id] = appointment;
    print('✏️ Appointment updated: ${appointment.id}');
  }

  @override
  Future<void> delete(String appointmentId) async {
    _store.remove(appointmentId);
    print('🗑️ Appointment deleted: $appointmentId');
  }

  Future<int> getCount() async => _store.length;
}
