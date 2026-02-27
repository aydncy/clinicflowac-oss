import 'package:flutter/material.dart';
import 'services/event_store.dart';
import 'data/demo_clinic.dart';

void main() {
  runApp(const ClinicFlowApp());
}

class ClinicFlowApp extends StatelessWidget {
  const ClinicFlowApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ClinicFlow AC - WhatsApp Klinik Akışı',
      theme: ThemeData(
        primarySwatch: Colors.teal,
        useMaterial3: true,
      ),
      home: const EventListScreen(),
    );
  }
}

class EventListScreen extends StatefulWidget {
  const EventListScreen({super.key});

  @override
  State<EventListScreen> createState() => _EventListScreenState();
}

class _EventListScreenState extends State<EventListScreen> {
  final EventStore _eventStore = EventStore();
  
  @override
  void initState() {
    super.initState();
    // Demo events yükle
    _loadDemoEvents();
  }
  
  void _loadDemoEvents() {
    // demo_clinic.dart'tan mevcut events
    _eventStore.append(demoEvents.first);  // Örnek
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('ClinicFlow Events'),
        backgroundColor: Colors.teal,
        foregroundColor: Colors.white,
      ),
      body: Column(
        children: [
          // WhatsApp Simülasyon Butonları
          Container(
            padding: const EdgeInsets.all(16),
            color: Colors.green.shade50,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton.icon(
                  onPressed: () => _simulateWhatsApp('Hasta randevu almak istiyor'),
                  icon: Image.asset('assets/whatsapp.png', width: 20),  // İsteğe bağlı
                  label: const Text('Randevu İsteği'),
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
                ),
                ElevatedButton.icon(
                  onPressed: () => _simulateWhatsApp('Randevuyu iptal et'),
                  icon: const Icon(Icons.cancel, color: Colors.white),
                  label: const Text('İptal'),
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                ),
              ],
            ),
          ),
          // Event Listesi
          Expanded(
            child: StreamBuilder<List<Event>>(
              stream: Stream.periodic(const Duration(milliseconds: 300))
                  .asyncMap((_) => _eventStore.events),
              builder: (context, snapshot) {
                final events = snapshot.data ?? [];
                if (events.isEmpty) {
                  return const Center(child: Text('WhatsApp event bekleniyor...'));
                }
                return ListView.builder(
                  itemCount: events.length,
                  itemBuilder: (context, index) {
                    final event = events[index];
                    return Card(
                      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                      child: ListTile(
                        leading: _getEventIcon(event),
                        title: Text(event.type.toString()),
                        subtitle: Text(event.timestamp.toString().substring(0, 19)),
                        trailing: Text(event.actor),
                        onTap: () => _showEventDetails(event),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  void _simulateWhatsApp(String message) {
    _eventStore.simulateWhatsAppEvent(message);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('WhatsApp: $message → Event kaydedildi')),
    );
  }

  Widget _getEventIcon(Event event) {
    if (event.data?['channel'] == 'whatsapp') {
      return Image.network('https://upload.wikimedia.org/wikipedia/commons/6/6b/WhatsApp.svg', width: 24, height: 24);
    }
    return const Icon(Icons.event, color: Colors.teal);
  }

  void _showEventDetails(Event event) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(event.type.toString()),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Mesaj: ${event.data?['message'] ?? 'N/A'}'),
            Text('Intent: ${event.data?['intent'] ?? 'N/A'}'),
            Text('Kanal: ${event.data?['channel'] ?? 'N/A'}'),
          ],
        ),
      ),
    );
  }
}
