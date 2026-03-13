import '../../domain/models/patient.dart';

abstract class PatientRepository {
  Future<void> save(Patient patient);
  Future<Patient?> getById(String patientId);
  Future<Patient?> getByEmail(String email);
  Future<Patient?> getByPhone(String phone);
  Future<List<Patient>> getAll({int limit = 100, int offset = 0});
  Future<void> update(Patient patient);
  Future<void> delete(String patientId);
}

class InMemoryPatientRepository implements PatientRepository {
  final Map<String, Patient> _store = {};

  @override
  Future<void> save(Patient patient) async {
    _store[patient.id] = patient;
    print('✅ Patient saved: ${patient.id}');
  }

  @override
  Future<Patient?> getById(String patientId) async {
    return _store[patientId];
  }

  @override
  Future<Patient?> getByEmail(String email) async {
    try {
      return _store.values.firstWhere((p) => p.email == email);
    } catch (e) {
      return null;
    }
  }

  @override
  Future<Patient?> getByPhone(String phone) async {
    try {
      return _store.values.firstWhere((p) => p.phone == phone);
    } catch (e) {
      return null;
    }
  }

  @override
  Future<List<Patient>> getAll({int limit = 100, int offset = 0}) async {
    return _store.values.toList().skip(offset).take(limit).toList();
  }

  @override
  Future<void> update(Patient patient) async {
    _store[patient.id] = patient;
    print('✏️ Patient updated: ${patient.id}');
  }

  @override
  Future<void> delete(String patientId) async {
    _store.remove(patientId);
    print('🗑️ Patient deleted: $patientId');
  }

  Future<int> getCount() async => _store.length;
}
