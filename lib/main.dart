import 'package:flutter/material.dart';

import 'domain/events/event_envelope.dart';
import 'domain/events/event_factories.dart';
import 'infrastructure/event_store/in_memory_event_store.dart';
import 'services/whatsapp_service.dart';

void main() {
  runApp(const ClinicFlowAC());
}

class ClinicFlowAC extends StatelessWidget {
  const ClinicFlowAC({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ClinicFlowAC OSS Demo',
      theme: ThemeData(useMaterial3: true),
      home: const DemoScreen(),
    );
  }
}

class DemoScreen extends StatefulWidget {
  const DemoScreen({super.key});

  @override
  State<DemoScreen> createState() => _DemoScreenState();
}

class _DemoScreenState extends State<DemoScreen> {
  final _store = InMemoryEventStore();
  final _controller = TextEditingController();
  String _currentAppointmentId = 'patient_123';

  late final WhatsAppService _whatsapp = WhatsAppService(
    onEvent: (WorkflowEvent e) async {
      await _store.append(e);
      setState(() {
        _currentAppointmentId = e.entity.id;
      });
    },
  );

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<List<WorkflowEvent>> _loadEvents() {
    return _store.loadByEntity(kind: 'appointment', id: _currentAppointmentId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('ClinicFlowAC Demo (WES)'),
      ),
      body: Column(
        children: [
          // WhatsApp Simulation
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    decoration: const InputDecoration(
                      hintText: 'Type a WhatsApp message... (e.g. "book appointment 15:00")',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                FilledButton(
                  onPressed: () => _simulateWhatsApp(_controller.text.trim()),
                  child: const Text('Send'),
                ),
              ],
            ),
          ),

          // Demo Buttons
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Wrap(
              spacing: 10,
              runSpacing: 10,
              children: [
                FilledButton.tonal(
                  onPressed: () => _addDemoEvent('appointment_created'),
                  child: const Text('🩺 Book Appointment'),
                ),
                FilledButton.tonal(
                  onPressed: () => _addDemoEvent('appointment_cancelled'),
                  child: const Text('❌ Cancel'),
                ),
                FilledButton.tonal(
                  onPressed: () => _addDemoEvent('appointment_rescheduled'),
                  child: const Text('🔄 Reschedule'),
                ),
              ],
            ),
          ),

          // Summary Cards
          FutureBuilder<List<WorkflowEvent>>(
            future: _loadEvents(),
            builder: (context, snapshot) {
              final events = snapshot.data ?? const <WorkflowEvent>[];
              final status = events.isEmpty
                  ? 'no events'
                  : events.last.type.replaceAll('appointment_', '');
              final lastMsg = events
                  .where((e) => e.type == 'message_captured')
                  .lastOrNull
                  ?.data['message'] as String? ?? '—';

              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Row(
                  children: [
                    _summaryCard('Status', status, Icons.info_outline),
                    const SizedBox(width: 8),
                    _summaryCard('Events', events.length.toString(), Icons.list_alt),
                    const SizedBox(width: 8),
                    _summaryCard('Last Msg', lastMsg, Icons.message_outlined),
                  ],
                ),
              );
            },
          ),

          // Current Aggregate Info
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
            child: Row(
              children: [
                const Icon(Icons.info_outline, size: 18),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'Appointment ID (MVP): $_currentAppointmentId',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ),
              ],
            ),
          ),

          const Divider(height: 1),

          // Event Timeline
          Expanded(
            child: FutureBuilder<List<WorkflowEvent>>(
              future: _loadEvents(),
              builder: (context, snapshot) {
                final events = snapshot.data ?? const <WorkflowEvent>[];

                if (events.isEmpty) {
                  return const Center(
                    child: Text('No events yet. Use the demo buttons or type a WhatsApp message.'),
                  );
                }

                return ListView.builder(
                  itemCount: events.length,
                  itemBuilder: (context, i) {
                    final e = events[i];
                    return ListTile(
                      leading: Icon(_getIcon(e.type)),
                      title: Text(e.type),
                      subtitle: Text(
                        '${e.entity.kind}/${e.entity.id} • ${e.ts.toLocal()}',
                      ),
                      trailing: Text(e.actor),
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

  Future<void> _addDemoEvent(String type) async {
    final appointmentId = _currentAppointmentId;

    WorkflowEvent e;
    switch (type) {
      case 'appointment_created':
        e = EventFactories.appointmentCreated(
          appointmentId: appointmentId,
          startAt: DateTime.now().add(const Duration(hours: 2)),
          actor: 'clinic',
        );
        break;

      case 'appointment_cancelled':
        e = WorkflowEvent(
          id: 'demo_${DateTime.now().millisecondsSinceEpoch}',
          type: 'appointment_cancelled',
          ts: DateTime.now().toUtc(),
          actor: 'clinic',
          entity: EntityRef(kind: 'appointment', id: appointmentId),
          data: {'reason': 'demo'},
        );
        break;

      case 'appointment_rescheduled':
        e = WorkflowEvent(
          id: 'demo_${DateTime.now().millisecondsSinceEpoch}',
          type: 'appointment_rescheduled',
          ts: DateTime.now().toUtc(),
          actor: 'clinic',
          entity: EntityRef(kind: 'appointment', id: appointmentId),
          data: {
            'new_start_at': DateTime.now()
                .add(const Duration(days: 1))
                .toUtc()
                .toIso8601String(),
          },
        );
        break;

      default:
        e = WorkflowEvent(
          id: 'demo_${DateTime.now().millisecondsSinceEpoch}',
          type: 'note_added',
          ts: DateTime.now().toUtc(),
          actor: 'clinic',
          entity: EntityRef(kind: 'appointment', id: appointmentId),
          data: {'note': type},
        );
        break;
    }

    await _store.append(e);
    setState(() {});
  }

  void _simulateWhatsApp(String message) {
    if (message.isEmpty) return;

    final payload = {
      'entry': [
        {
          'changes': [
            {
              'value': {
                'contacts': [
                  {'wa_id': _currentAppointmentId}
                ],
                'messages': [
                  {
                    'text': {'body': message}
                  }
                ]
              }
            }
          ]
        }
      ]
    };

    _whatsapp.handleWebhook(payload);
    _controller.clear();
  }

  IconData _getIcon(String type) {
    switch (type) {
      case 'appointment_created':
        return Icons.schedule;
      case 'appointment_cancelled':
        return Icons.cancel;
      case 'appointment_rescheduled':
        return Icons.update;
      case 'message_received':
      case 'message_captured':
        return Icons.message;
      case 'document_requested':
        return Icons.description;
      case 'consent_given':
        return Icons.verified_user;
      default:
        return Icons.bolt;
    }
  }

  Widget _summaryCard(String title, String value, IconData icon) {
    return Expanded(
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, size: 20),
              const SizedBox(height: 4),
              Text(title,
                  style: const TextStyle(fontSize: 11, color: Colors.grey)),
              Text(value,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                  overflow: TextOverflow.ellipsis),
            ],
          ),
        ),
      ),
    );
  }
}
