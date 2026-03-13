enum ConsultationStatus {
  scheduled,
  inProgress,
  completed,
  cancelled,
  noShow,
}

enum ConsultationType {
  videoCall,
  audioCall,
  messaging,
  hybrid,
}

class TelemedicineSession {
  final String sessionId;
  final String appointmentId;
  final String patientId;
  final String doctorId;
  final ConsultationType type;
  final DateTime scheduledTime;
  final DateTime? startTime;
  final DateTime? endTime;
  ConsultationStatus status;
  final String? sessionUrl;
  final String? accessToken;
  final String? recordingUrl;
  final Map<String, dynamic> metadata;

  TelemedicineSession({
    required this.sessionId,
    required this.appointmentId,
    required this.patientId,
    required this.doctorId,
    required this.type,
    required this.scheduledTime,
    this.startTime,
    this.endTime,
    this.status = ConsultationStatus.scheduled,
    this.sessionUrl,
    this.accessToken,
    this.recordingUrl,
    this.metadata = const {},
  });

  Duration? get duration {
    if (startTime != null && endTime != null) {
      return endTime!.difference(startTime!);
    }
    return null;
  }

  bool get isActive => status == ConsultationStatus.inProgress;

  Map<String, dynamic> toJson() => {
    'sessionId': sessionId,
    'appointmentId': appointmentId,
    'patientId': patientId,
    'doctorId': doctorId,
    'type': type.toString().split('.').last,
    'scheduledTime': scheduledTime.toIso8601String(),
    'startTime': startTime?.toIso8601String(),
    'endTime': endTime?.toIso8601String(),
    'status': status.toString().split('.').last,
    'duration': duration?.inMinutes,
    'sessionUrl': sessionUrl,
    'recordingUrl': recordingUrl,
    'metadata': metadata,
  };
}

class TelemedicineService {
  final Map<String, TelemedicineSession> _sessions = {};
  final List<String> _activeSessionIds = [];

  String createSession({
    required String appointmentId,
    required String patientId,
    required String doctorId,
    required ConsultationType type,
    required DateTime scheduledTime,
  }) {
    final sessionId = 'tele_${DateTime.now().millisecondsSinceEpoch}';
    final sessionUrl = 'https://tele.clinicflow.ac/session/$sessionId';
    final accessToken = 'token_${DateTime.now().millisecondsSinceEpoch}';

    final session = TelemedicineSession(
      sessionId: sessionId,
      appointmentId: appointmentId,
      patientId: patientId,
      doctorId: doctorId,
      type: type,
      scheduledTime: scheduledTime,
      sessionUrl: sessionUrl,
      accessToken: accessToken,
    );

    _sessions[sessionId] = session;
    print('✅ Telemedicine session created: $sessionId');
    print('   Type: ${type.toString().split('.').last}');
    print('   Scheduled: ${scheduledTime.toIso8601String()}');

    return sessionId;
  }

  bool startSession(String sessionId) {
    final session = _sessions[sessionId];
    if (session == null || session.status != ConsultationStatus.scheduled) {
      print('❌ Cannot start session: $sessionId');
      return false;
    }

    session.status = ConsultationStatus.inProgress;
    _activeSessionIds.add(sessionId);
    
    print('✅ Session started: $sessionId');
    print('   Patient: ${session.patientId}');
    print('   Doctor: ${session.doctorId}');

    return true;
  }

  bool endSession(String sessionId, {String? recordingUrl}) {
    final session = _sessions[sessionId];
    if (session == null || !session.isActive) {
      print('❌ Cannot end session: $sessionId');
      return false;
    }

    session.status = ConsultationStatus.completed;
    session.endTime == DateTime.now();
    
    if (recordingUrl != null) {
      session.recordingUrl == recordingUrl;
      print('✅ Recording saved: $recordingUrl');
    }

    _activeSessionIds.remove(sessionId);
    print('✅ Session ended: $sessionId');
    print('   Duration: ${session.duration?.inMinutes} minutes');

    return true;
  }

  bool cancelSession(String sessionId, String reason) {
    final session = _sessions[sessionId];
    if (session == null) {
      print('❌ Session not found: $sessionId');
      return false;
    }

    session.status = ConsultationStatus.cancelled;
    session.metadata['cancellationReason'] = reason;
    _activeSessionIds.remove(sessionId);

    print('⛔ Session cancelled: $sessionId');
    print('   Reason: $reason');

    return true;
  }

  TelemedicineSession? getSession(String sessionId) {
    return _sessions[sessionId];
  }

  List<TelemedicineSession> getSessionsByPatient(String patientId) {
    return _sessions.values.where((s) => s.patientId == patientId).toList();
  }

  List<TelemedicineSession> getSessionsByDoctor(String doctorId) {
    return _sessions.values.where((s) => s.doctorId == doctorId).toList();
  }

  List<TelemedicineSession> getActiveSessions() {
    return _activeSessionIds
        .map((id) => _sessions[id])
        .whereType<TelemedicineSession>()
        .toList();
  }

  Map<String, dynamic> getSessionStats() {
    final allSessions = _sessions.values.toList();
    final completed = allSessions.where((s) => s.status == ConsultationStatus.completed).length;
    final cancelled = allSessions.where((s) => s.status == ConsultationStatus.cancelled).length;
    final active = _activeSessionIds.length;

    final totalDuration = allSessions
        .where((s) => s.duration != null)
        .fold<Duration>(Duration.zero, (sum, s) => sum + s.duration!);

    return {
      'totalSessions': allSessions.length,
      'activeSessions': active,
      'completedSessions': completed,
      'cancelledSessions': cancelled,
      'totalDuration': totalDuration.inMinutes,
      'averageSessionDuration': completed == 0 
        ? 0 
        : totalDuration.inMinutes ~/ completed,
      'completionRate': allSessions.isEmpty 
        ? 0 
        : '${((completed / allSessions.length) * 100).toStringAsFixed(2)}%',
    };
  }

  Map<String, dynamic> generateSessionReport(String sessionId) {
    final session = _sessions[sessionId];
    if (session == null) return {};

    return {
      'sessionId': sessionId,
      'appointmentId': session.appointmentId,
      'type': session.type.toString().split('.').last,
      'status': session.status.toString().split('.').last,
      'scheduledTime': session.scheduledTime.toIso8601String(),
      'duration': session.duration?.inMinutes,
      'recordingUrl': session.recordingUrl,
      'participantCount': 2,
      'quality': 'HD',
      'timestamp': DateTime.now().toIso8601String(),
    };
  }
}
