import '../../domain/models/doctor.dart';

abstract class DoctorRepository {
  Future<void> save(Doctor doctor);
  Future<Doctor?> getById(String doctorId);
  Future<List<Doctor>> getByClinicId(String clinicId);
  Future<List<Doctor>> getBySpecialty(String specialty);
  Future<List<Doctor>> getAvailable();
  Future<void> update(Doctor doctor);
  Future<void> delete(String doctorId);
}

class InMemoryDoctorRepository implements DoctorRepository {
  final Map<String, Doctor> _store = {};

  @override
  Future<void> save(Doctor doctor) async {
    _store[doctor.id] = doctor;
    print('✅ Doctor saved: ${doctor.id}');
  }

  @override
  Future<Doctor?> getById(String doctorId) async {
    return _store[doctorId];
  }

  @override
  Future<List<Doctor>> getByClinicId(String clinicId) async {
    return _store.values.where((d) => d.clinicId == clinicId).toList();
  }

  @override
  Future<List<Doctor>> getBySpecialty(String specialty) async {
    return _store.values.where((d) => d.specialtyName == specialty).toList();
  }

  @override
  Future<List<Doctor>> getAvailable() async {
    return _store.values.where((d) => d.isAvailable).toList();
  }

  @override
  Future<void> update(Doctor doctor) async {
    _store[doctor.id] = doctor;
    print('✏️ Doctor updated: ${doctor.id}');
  }

  @override
  Future<void> delete(String doctorId) async {
    _store.remove(doctorId);
    print('🗑️ Doctor deleted: $doctorId');
  }

  Future<int> getCount() async => _store.length;
}
