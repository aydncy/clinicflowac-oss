// lib/services/event_store.dart

import '../domain/events/event_envelope.dart';

class EventStore {
  final List<WorkflowEvent> _events = [];

  List<WorkflowEvent> get events => List.unmodifiable(_events);

  void append(WorkflowEvent event) {
    _events.add(event);
  }

  List<WorkflowEvent> loadByEntity({
    required String kind,
    required String id,
  }) {
    final result = _events
        .where((e) => e.entity.kind == kind && e.entity.id == id)
        .toList()
      ..sort((a, b) => a.ts.compareTo(b.ts));

    return result;
  }
}
