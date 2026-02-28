import 'package:clinicflowac/models/event.dart';

class EventStore {
  final List<Event> _events = [];

  List<Event> get events => List.unmodifiable(_events);

  void append(Event event) {
    _events.add(event);
  }

  List<Event> queryByType(String type) {
    return _events.where((e) => e.type == type).toList();
  }

  List<Event> queryByEntity(String kind, String id) {
    return _events.where((e) => e.entityKind == kind && e.entityId == id).toList();
  }

  Map<String, dynamic> generateProofPack(String kind, String id) {
    final events = queryByEntity(kind, id);
    return {
      'entity_kind': kind,
      'entity_id': id,
      'events': events.map((e) => {
        'id': e.id,
        'type': e.type,
        'timestamp': e.timestamp.toIso8601String(),
        'actor': e.actor,
      }).toList(),
      'generated_at': DateTime.now().toIso8601String(),
    };
  }
}
