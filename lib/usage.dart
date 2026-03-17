class UsageTracker {
  final Map<String, int> _usage = {};

  void track(String clinicId, String event) {
    final key = "${clinicId}_${event}";
    _usage[key] = (_usage[key] ?? 0) + 1;

    print("USAGE: $key = ${_usage[key]}");
  }

  int getUsage(String clinicId, String event) {
    return _usage["${clinicId}_${event}"] ?? 0;
  }
}