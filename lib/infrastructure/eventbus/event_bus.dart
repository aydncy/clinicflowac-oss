typedef EventCallback = Future<void> Function(dynamic event);

class EventBus {
  static final EventBus _instance = EventBus._internal();
  final Map<String, List<EventCallback>> _listeners = {};

  EventBus._internal();

  factory EventBus() {
    return _instance;
  }

  void on<T>(EventCallback callback) {
    final eventName = T.toString();
    if (!_listeners.containsKey(eventName)) {
      _listeners[eventName] = [];
    }
    _listeners[eventName]!.add(callback);
    print('📡 Listener registered for $eventName');
  }

  Future<void> emit<T>(T event) async {
    final eventName = T.toString();
    print('📤 Emitting event: $eventName');
    
    if (_listeners.containsKey(eventName)) {
      for (final callback in _listeners[eventName]!) {
        await callback(event);
      }
    }
  }

  void off<T>(EventCallback callback) {
    final eventName = T.toString();
    _listeners[eventName]?.remove(callback);
    print('📵 Listener unregistered for $eventName');
  }

  void clear() {
    _listeners.clear();
    print('🗑️ Event bus cleared');
  }

  int getListenerCount<T>() {
    final eventName = T.toString();
    return _listeners[eventName]?.length ?? 0;
  }
}
