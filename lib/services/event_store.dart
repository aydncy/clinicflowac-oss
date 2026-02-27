// lib/services/event_store.dart
import '../models/event.dart';
import '../data/demo_clinic.dart';

class EventStore {
  List<Event> _events = [];
  
  /// Get all events (append-only, never modified)
  List<Event> get events => List.unmodifiable(_events);
  
  /// Append new event (never overwrites)
  void append(Event event
