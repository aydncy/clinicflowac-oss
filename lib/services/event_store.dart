// lib/services/event_store.dart
import '../models/event.dart';
import '../data/demo_clinic.dart';

class EventStore {
  final List<Event> _events = [];

  EventStore() {
    // Load demo seed events on startup
    _events.addAll(DemoClinic.seedEvents);
  }

  /// All events - immutable (append-only)
  List<Event> get events => List.unmodifiable(_events);

  /// Append a new event - never overwrites
  void append(Event event) {
    _events.add(event);
  }

  /// Filter by aggregateId
  List<Event> eventsFor(String aggregateId) =>
      _events.where((e) => e.aggregateId == aggregateId).toList();
}
