class WorkflowEvent {
  final String id;
  final String type;
  final DateTime timestamp;
  final String actor;
  final String entityKind;
  final String entityId;
  final Map<String, dynamic> data;

  WorkflowEvent({
    required this.id,
    required this.type,
    required this.timestamp,
    required this.actor,
    required this.entityKind,
    required this.entityId,
    required this.data,
  });
}
