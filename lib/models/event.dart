class Event {
  final String id;
  final String type;
  final DateTime timestamp;
  final String actor;
  final String entityKind;
  final String entityId;
  final Map<String, dynamic> data;

  Event({
    required this.id,
    required this.type,
    required this.timestamp,
    required this.actor,
    required this.entityKind,
    required this.entityId,
    required this.data,
  });

  @override
  String toString() => 'Event(id: $id, type: $type)';
}
