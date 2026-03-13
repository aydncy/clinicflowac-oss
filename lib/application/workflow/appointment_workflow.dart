import '../usecases/create_appointment_usecase.dart';
import '../usecases/record_consent_usecase.dart';
import '../usecases/upload_document_usecase.dart';

class AppointmentWorkflow {
  final CreateAppointmentUseCase createAppointmentUseCase;
  final RecordConsentUseCase recordConsentUseCase;
  final UploadDocumentUseCase uploadDocumentUseCase;

  AppointmentWorkflow({
    required this.createAppointmentUseCase,
    required this.recordConsentUseCase,
    required this.uploadDocumentUseCase,
  });

  Future<Map<String, dynamic>> executeFullWorkflow({
    required String patientId,
    required String clinicId,
    required DateTime scheduledTime,
    required Map<String, bool> consentFields,
    required List<Map<String, dynamic>> documents,
  }) async {
    print('🔄 Starting appointment workflow...');

    final aptResponse = await createAppointmentUseCase.execute(
      CreateAppointmentRequest(
        patientId: patientId,
        clinicId: clinicId,
        scheduledTime: scheduledTime,
      ),
    );
    print('✅ Appointment created: ${aptResponse.appointmentId}');

    final consentResponse = await recordConsentUseCase.execute(
      RecordConsentRequest(
        appointmentId: aptResponse.appointmentId,
        patientId: patientId,
        consentFields: consentFields,
      ),
    );
    print('✅ Consent recorded: ${consentResponse.consentId}');

    final uploadedDocuments = <Map<String, dynamic>>[];
    for (final doc in documents) {
      final docResponse = await uploadDocumentUseCase.execute(
        UploadDocumentRequest(
          appointmentId: aptResponse.appointmentId,
          uploadedBy: patientId,
          documentType: doc['type'] as String,
          fileName: doc['file_name'] as String,
          filePath: doc['file_path'] as String,
          fileSize: doc['file_size'] as int,
        ),
      );
      uploadedDocuments.add({
        'document_id': docResponse.documentId,
        'proof': docResponse.proof,
      });
      print('✅ Document uploaded: ${docResponse.documentId}');
    }

    print('🎉 Workflow completed!');

    return {
      'appointment': {
        'id': aptResponse.appointmentId,
        'proof': aptResponse.proof,
      },
      'consent': {
        'id': consentResponse.consentId,
        'proof': consentResponse.proof,
      },
      'documents': uploadedDocuments,
      'timestamp': DateTime.now().toIso8601String(),
    };
  }
}
