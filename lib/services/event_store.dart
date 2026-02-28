import '../models/event.dart';
import '../data/demo_clinic.dart';

class EventStore {
  final List<Event> _events = [];

  EventStore() {
    _events.addAll(DemoClinic.seedEvents);
  }

  List<Event> get events => List.unmodifiable(_events);

  void append(Event event) {
    _events.add(event);
  }

  List<Event> eventsFor(String aggregateId) =>
      _events.where((e) => e.aggregateId == aggregateId).toList();
}
