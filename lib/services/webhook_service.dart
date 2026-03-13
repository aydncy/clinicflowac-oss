enum WebhookEvent {
  appointmentCreated,
  appointmentConfirmed,
  appointmentCompleted,
  consentRecorded,
  documentUploaded,
  documentVerified,
}

class WebhookSubscription {
  final String id;
  final String url;
  final List<WebhookEvent> events;
  final String? secret;
  final bool isActive;
  final DateTime createdAt;

  WebhookSubscription({
    required this.id,
    required this.url,
    required this.events,
    this.secret,
    required this.isActive,
    required this.createdAt,
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'url': url,
    'events': events.map((e) => e.toString().split('.').last).toList(),
    'secret': secret != null ? '***' : null,
    'is_active': isActive,
    'created_at': createdAt.toIso8601String(),
  };
}

class WebhookService {
  final List<WebhookSubscription> _subscriptions = [];

  Future<WebhookSubscription> subscribe(
    String url,
    List<WebhookEvent> events, {
    String? secret,
  }) async {
    final subscription = WebhookSubscription(
      id: 'webhook_${DateTime.now().millisecondsSinceEpoch}',
      url: url,
      events: events,
      secret: secret,
      isActive: true,
      createdAt: DateTime.now(),
    );

    _subscriptions.add(subscription);
    print('🪝 Webhook subscribed: ${subscription.id} → $url');
    return subscription;
  }

  Future<void> trigger(WebhookEvent event, Map<String, dynamic> payload) async {
    final matchingSubscriptions = _subscriptions
        .where((s) => s.isActive && s.events.contains(event))
        .toList();

    print('📤 Triggering ${matchingSubscriptions.length} webhooks for ${event.toString().split('.').last}');

    for (final subscription in matchingSubscriptions) {
      try {
        await _sendWebhook(subscription, event, payload);
      } catch (e) {
        print('❌ Webhook failed: ${subscription.id} - $e');
      }
    }
  }

  Future<void> _sendWebhook(
    WebhookSubscription subscription,
    WebhookEvent event,
    Map<String, dynamic> payload,
  ) async {
    // In production: use http client


  Future<void> unsubscribe(String subscriptionId) async {
    _subscriptions.removeWhere((s) => s.id == subscriptionId);
    print('🗑️ Webhook unsubscribed: $subscriptionId');
  }

  List<WebhookSubscription> listSubscriptions() {
    return _subscriptions;
  }
}
