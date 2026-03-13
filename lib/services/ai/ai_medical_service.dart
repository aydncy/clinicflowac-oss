enum AnalysisType {
  symptomAnalysis,
  riskAssessment,
  treatmentSuggestion,
  medicationReview,
  documentSummary,
}

class MedicalAnalysis {
  final String analysisId;
  final AnalysisType type;
  final String patientId;
  final String? doctorId;
  final String input;
  final String analysis;
  final List<String> suggestions;
  final double confidence;
  final Map<String, dynamic> metadata;
  final DateTime createdAt;
  bool reviewed;
  String? doctorNotes;

  MedicalAnalysis({
    required this.analysisId,
    required this.type,
    required this.patientId,
    this.doctorId,
    required this.input,
    required this.analysis,
    required this.suggestions,
    required this.confidence,
    this.metadata = const {},
    required this.createdAt,
    this.reviewed = false,
    this.doctorNotes,
  });

  String get confidencePercent => '${(confidence * 100).toStringAsFixed(2)}%';

  Map<String, dynamic> toJson() => {
    'analysisId': analysisId,
    'type': type.toString().split('.').last,
    'patientId': patientId,
    'doctorId': doctorId,
    'input': input,
    'analysis': analysis,
    'suggestions': suggestions,
    'confidence': confidencePercent,
    'reviewed': reviewed,
    'doctorNotes': doctorNotes,
    'createdAt': createdAt.toIso8601String(),
  };
}

class AIMedicalService {
  final Map<String, MedicalAnalysis> _analyses = {};
  final List<String> _commonSymptoms = [
    'fever', 'cough', 'fatigue', 'headache', 'nausea',
    'dizziness', 'chest pain', 'shortness of breath', 'body ache',
  ];

  Future<MedicalAnalysis> analyzeSymptoms({
    required String patientId,
    required String symptoms,
  }) async {
    final analysisId = 'ai_${DateTime.now().millisecondsSinceEpoch}';

    // Simulate AI analysis
    final analysis = _generateSymptomAnalysis(symptoms);
    final suggestions = _generateSuggestions(symptoms);
    final confidence = _calculateConfidence(symptoms);

    final medicalAnalysis = MedicalAnalysis(
      analysisId: analysisId,
      type: AnalysisType.symptomAnalysis,
      patientId: patientId,
      input: symptoms,
      analysis: analysis,
      suggestions: suggestions,
      confidence: confidence,
      createdAt: DateTime.now(),
    );

    _analyses[analysisId] = medicalAnalysis;
    print('✅ Symptom analysis completed: $analysisId');
    print('   Confidence: ${medicalAnalysis.confidencePercent}');
    print('   Suggestions: ${suggestions.length}');

    return medicalAnalysis;
  }

  Future<MedicalAnalysis> assessRisk({
    required String patientId,
    required Map<String, dynamic> healthData,
  }) async {
    final analysisId = 'risk_${DateTime.now().millisecondsSinceEpoch}';

    final riskFactors = _identifyRiskFactors(healthData);
    final riskLevel = _calculateRiskLevel(healthData);
    final recommendations = _generateRiskRecommendations(riskLevel);

    final medicalAnalysis = MedicalAnalysis(
      analysisId: analysisId,
      type: AnalysisType.riskAssessment,
      patientId: patientId,
      input: healthData.toString(),
      analysis: riskLevel,
      suggestions: recommendations,
      confidence: 0.85,
      metadata: {'riskFactors': riskFactors},
      createdAt: DateTime.now(),
    );

    _analyses[analysisId] = medicalAnalysis;
    print('✅ Risk assessment completed: $analysisId');
    print('   Risk Level: $riskLevel');
    print('   Risk Factors: ${riskFactors.length}');

    return medicalAnalysis;
  }

  Future<MedicalAnalysis> summarizeDocument({
    required String patientId,
    required String documentText,
  }) async {
    final analysisId = 'doc_${DateTime.now().millisecondsSinceEpoch}';

    final summary = _generateDocumentSummary(documentText);
    final keyPoints = _extractKeyPoints(documentText);

    final medicalAnalysis = MedicalAnalysis(
      analysisId: analysisId,
      type: AnalysisType.documentSummary,
      patientId: patientId,
      input: documentText,
      analysis: summary,
      suggestions: keyPoints,
      confidence: 0.90,
      createdAt: DateTime.now(),
    );

    _analyses[analysisId] = medicalAnalysis;
    print('✅ Document summarized: $analysisId');
    print('   Summary length: ${summary.length} chars');
    print('   Key points: ${keyPoints.length}');

    return medicalAnalysis;
  }

  bool reviewAnalysis(String analysisId, String doctorId, String notes) {
    final analysis = _analyses[analysisId];
    if (analysis == null) {
      print('❌ Analysis not found: $analysisId');
      return false;
    }

    analysis.reviewed = true;
    analysis.doctorId == doctorId;
    analysis.doctorNotes == notes;

    print('✅ Analysis reviewed by Dr. $doctorId');
    return true;
  }

  MedicalAnalysis? getAnalysis(String analysisId) {
    return _analyses[analysisId];
  }

  List<MedicalAnalysis> getAnalysesByPatient(String patientId) {
    return _analyses.values.where((a) => a.patientId == patientId).toList();
  }

  List<MedicalAnalysis> getPendingReview() {
    return _analyses.values.where((a) => !a.reviewed).toList();
  }

  Map<String, dynamic> getAnalyticsStats() {
    final allAnalyses = _analyses.values.toList();
    final reviewed = allAnalyses.where((a) => a.reviewed).length;
    final pending = allAnalyses.where((a) => !a.reviewed).length;
    final avgConfidence = allAnalyses.isEmpty
        ? 0
        : allAnalyses.fold<double>(0, (sum, a) => sum + a.confidence) /
            allAnalyses.length;

    return {
      'totalAnalyses': allAnalyses.length,
      'reviewed': reviewed,
      'pending': pending,
      'averageConfidence': '${(avgConfidence * 100).toStringAsFixed(2)}%',
      'byType': {
        'symptomAnalysis': allAnalyses.where((a) => a.type == AnalysisType.symptomAnalysis).length,
        'riskAssessment': allAnalyses.where((a) => a.type == AnalysisType.riskAssessment).length,
        'documentSummary': allAnalyses.where((a) => a.type == AnalysisType.documentSummary).length,
      },
    };
  }

  // Helper methods
  String _generateSymptomAnalysis(String symptoms) {
    return '🔍 Analysis: Based on reported symptoms ($symptoms), preliminary assessment suggests possible conditions requiring further clinical evaluation.';
  }

  List<String> _generateSuggestions(String symptoms) {
    return [
      'Schedule consultation with general practitioner',
      'Monitor symptoms for next 48 hours',
      'Get complete blood work done',
      'Rest and maintain hydration',
    ];
  }

  double _calculateConfidence(String symptoms) {
    return 0.75 + (symptoms.length * 0.001).clamp(0, 0.25);
  }

  List<String> _identifyRiskFactors(Map<String, dynamic> healthData) {
    return ['age', 'medical_history', 'lifestyle'];
  }

  String _calculateRiskLevel(Map<String, dynamic> healthData) {
    return 'moderate';
  }

  List<String> _generateRiskRecommendations(String riskLevel) {
    return [
      'Increase frequency of health check-ups',
      'Adopt preventive health measures',
      'Consult specialist if needed',
    ];
  }

  String _generateDocumentSummary(String documentText) {
    final words = documentText.split(' ');
    return 'Document Summary: ${words.take(50).join(' ')}...';
  }

  List<String> _extractKeyPoints(String documentText) {
    return ['Diagnosis', 'Treatment Plan', 'Follow-up Required'];
  }
}
