import 'package:drift/drift.dart';

class Clinics extends Table {
  UuidColumn get id => UuidColumn()();
  TextColumn get name => text()();
  TextColumn get email => text().unique()();
  TextColumn get phone => text().nullable()();
  TextColumn get address => text().nullable()();
  TextColumn get city => text().nullable()();
  TextColumn get country => text().nullable()();
  TextColumn get licenseNumber => text().unique().nullable()();
  BoolColumn get isActive => boolean().withDefault(const Constant(true))();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
  DateTimeColumn get updatedAt => dateTime().withDefault(currentDateAndTime)();

  @override
  Set<Column> get primaryKey => {id};
}

class Doctors extends Table {
  UuidColumn get id => UuidColumn()();
  UuidColumn get clinicId => UuidColumn()();
  TextColumn get firstName => text()();
  TextColumn get lastName => text()();
  TextColumn get email => text().unique()();
  TextColumn get phone => text().nullable()();
  TextColumn get specialty => text().nullable()();
  TextColumn get licenseNumber => text().unique()();
  TextColumn get qualification => text().nullable()();
  IntColumn get yearsExperience => integer().nullable()();
  BoolColumn get isActive => boolean().withDefault(const Constant(true))();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
  DateTimeColumn get updatedAt => dateTime().withDefault(currentDateAndTime)();

  @override
  Set<Column> get primaryKey => {id};
}

class Patients extends Table {
  UuidColumn get id => UuidColumn()();
  UuidColumn get clinicId => UuidColumn()();
  TextColumn get firstName => text()();
  TextColumn get lastName => text()();
  DateTimeColumn get dateOfBirth => dateTime()();
  TextColumn get gender => text().nullable()();
  TextColumn get phone => text()();
  TextColumn get email => text().nullable()();
  TextColumn get address => text().nullable()();
  TextColumn get city => text().nullable()();
  TextColumn get bloodType => text().nullable()();
  TextColumn get allergies => text().nullable()();
  TextColumn get emergencyContactName => text().nullable()();
  TextColumn get emergencyContactPhone => text().nullable()();
  BoolColumn get isActive => boolean().withDefault(const Constant(true))();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
  DateTimeColumn get updatedAt => dateTime().withDefault(currentDateAndTime)();

  @override
  Set<Column> get primaryKey => {id};
}

class Appointments extends Table {
  UuidColumn get id => UuidColumn()();
  UuidColumn get clinicId => UuidColumn()();
  UuidColumn get patientId => UuidColumn()();
  UuidColumn get doctorId => UuidColumn()();
  DateTimeColumn get appointmentTime => dateTime()();
  IntColumn get durationMinutes => integer().withDefault(const Constant(30))();
  TextColumn get status => text().withDefault(const Constant('scheduled'))();
  TextColumn get reasonForVisit => text().nullable()();
  TextColumn get notes => text().nullable()();
  BoolColumn get isCompleted => boolean().withDefault(const Constant(false))();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
  DateTimeColumn get updatedAt => dateTime().withDefault(currentDateAndTime)();

  @override
  Set<Column> get primaryKey => {id};
}

class MedicalRecords extends Table {
  UuidColumn get id => UuidColumn()();
  UuidColumn get clinicId => UuidColumn()();
  UuidColumn get patientId => UuidColumn()();
  UuidColumn get doctorId => UuidColumn()();
  UuidColumn get appointmentId => UuidColumn().nullable()();
  TextColumn get diagnosis => text().nullable()();
  TextColumn get symptoms => text().nullable()();
  TextColumn get treatmentPlan => text().nullable()();
  TextColumn get vitalSigns => text().nullable()();
  TextColumn get recordType => text().nullable()();
  BoolColumn get isConfidential => boolean().withDefault(const Constant(false))();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
  DateTimeColumn get updatedAt => dateTime().withDefault(currentDateAndTime)();

  @override
  Set<Column> get primaryKey => {id};
}

class Prescriptions extends Table {
  UuidColumn get id => UuidColumn()();
  UuidColumn get clinicId => UuidColumn()();
  UuidColumn get medicalRecordId => UuidColumn()();
  UuidColumn get patientId => UuidColumn()();
  UuidColumn get doctorId => UuidColumn()();
  TextColumn get medicationName => text()();
  TextColumn get dosage => text().nullable()();
  TextColumn get frequency => text().nullable()();
  IntColumn get durationDays => integer().nullable()();
  TextColumn get instructions => text().nullable()();
  BoolColumn get isActive => boolean().withDefault(const Constant(true))();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
  DateTimeColumn get updatedAt => dateTime().withDefault(currentDateAndTime)();

  @override
  Set<Column> get primaryKey => {id};
}

class BillingInvoices extends Table {
  UuidColumn get id => UuidColumn()();
  UuidColumn get clinicId => UuidColumn()();
  UuidColumn get patientId => UuidColumn()();
  UuidColumn get appointmentId => UuidColumn().nullable()();
  RealColumn get amount => real()();
  RealColumn get taxAmount => real().nullable()();
  RealColumn get totalAmount => real().nullable()();
  TextColumn get status => text().withDefault(const Constant('pending'))();
  TextColumn get paymentMethod => text().nullable()();
  DateTimeColumn get paymentDate => dateTime().nullable()();
  TextColumn get invoiceNumber => text().unique().nullable()();
  TextColumn get notes => text().nullable()();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
  DateTimeColumn get updatedAt => dateTime().withDefault(currentDateAndTime)();

  @override
  Set<Column> get primaryKey => {id};
}

class AuditLogs extends Table {
  UuidColumn get id => UuidColumn()();
  UuidColumn get clinicId => UuidColumn()();
  UuidColumn get userId => UuidColumn().nullable()();
  TextColumn get action => text()();
  TextColumn get entityType => text().nullable()();
  UuidColumn get entityId => UuidColumn().nullable()();
  TextColumn get oldValues => text().nullable()();
  TextColumn get newValues => text().nullable()();
  TextColumn get ipAddress => text().nullable()();
  TextColumn get userAgent => text().nullable()();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();

  @override
  Set<Column> get primaryKey => {id};
}

class Notifications extends Table {
  UuidColumn get id => UuidColumn()();
  UuidColumn get clinicId => UuidColumn()();
  UuidColumn get patientId => UuidColumn().nullable()();
  UuidColumn get doctorId => UuidColumn().nullable()();
  TextColumn get notificationType => text().nullable()();
  TextColumn get title => text()();
  TextColumn get message => text()();
  BoolColumn get isRead => boolean().withDefault(const Constant(false))();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
  DateTimeColumn get readAt => dateTime().nullable()();

  @override
  Set<Column> get primaryKey => {id};
}
