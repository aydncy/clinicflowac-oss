import '../../domain/events/document_events.dart';
import '../../services/ovwi_client.dart';

class UploadDocumentRequest {
  final String appointmentId;
  final String uploadedBy;
  final String documentType;
  final String fileName;
  final String filePath;
  final int fileSize;

  UploadDocumentRequest({
    required this.appointmentId,
    required this.uploadedBy,
    required this.documentType,
    required this.fileName,
    required this.filePath,
    required this.fileSize,
  });
}

class UploadDocumentResponse {
  final String documentId;
  final String eventId;
  final Map<String, dynamic> proof;

  UploadDocumentResponse({
    required this.documentId,
    required this.eventId,
    required this.proof,
  });
}

class UploadDocumentUseCase {
  final OvwiClient ovwiClient;

  UploadDocumentUseCase({required this.ovwiClient});

  Future<UploadDocumentResponse> execute(UploadDocumentRequest request) async {
    final documentId = 'doc_${DateTime.now().millisecondsSinceEpoch}';

    final event = DocumentEvents.uploaded(
      documentId: documentId,
      appointmentId: request.appointmentId,
      documentType: request.documentType,
      fileName: request.fileName,
    );

    final proof = await ovwiClient.submitEvent(event);

    return UploadDocumentResponse(
      documentId: documentId,
      eventId: event.id,
      proof: {
        'hash': proof.hash,
        'signature': proof.signature,
        'sequence': proof.sequence,
      },
    );
  }
}
