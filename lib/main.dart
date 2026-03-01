import 'package:flutter/material.dart';
import 'package:hive_ce_flutter/hive_flutter.dart';

import 'application/demo/demo_pipeline.dart';
import 'domain/events/event_envelope.dart';
import 'domain/events/event_factories.dart';
import 'infrastructure/event_store/hive_event_store.dart';
import 'services/whatsapp_service.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
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
  final _store = HiveEventStore();
  late final DemoPipeline _pipeline = DemoPipeline(store: _store);

  final _controller = TextEditingController();
  String _currentAppointmentId = 'patient_123';
  bool _ready = false;

  late final WhatsAppService _whatsapp = WhatsAppService(
    onEvent: (WorkflowEvent e) async {
      await _pipeline.handleEvent(e);
      setState(() => _currentAppointmentId = e.entity.id);
    },
  );

  @override
  void initState() {
    super.initState();
    _store.init().then((_) {
      setState(() => _ready = true);
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<List<WorkflowEvent>> _loadEvents() async {
    if (!_ready) return const <WorkflowEvent>[];
    return _store.loadByEntity(kind: 'appointment', id: _currentAppointmentId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('ClinicFlowAC Demo (Persistent WES)')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    decoration: const InputDecoration(
                      hintText: 'WhatsApp mesajı yaz... (örn: "randevu al 15:00")',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                FilledButton(
                  onPressed: _ready ? () => _simulateWhatsApp(_controller.text.trim()) : null,
                  child: const Text('Gönder'),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Wrap(
              spacing: 10,
              runSpacing: 10,
              children: [
                FilledButton.tonal(
                  onPressed: _ready ? () => _addDemoEvent('appointment_created') : null,
                  child: const Text('🩺 Randevu Al'),
                ),
                FilledButton.tonal(
                  onPressed: _ready ? () => _addDemoEvent('appointment_cancelled') : null,
                  child: const Text('❌ İptal Et'),
                ),
                FilledButton.tonal(
                  onPressed: _ready ? () => _addDemoEvent('appointment_rescheduled') : null,
                  child: const Text('🔄 Ertele'),
                ),
              ],
            ),
          ),
          const Divider(height: 1),
          Expanded(
            child: !_ready
                ? const Center(child: CircularProgressIndicator())
                : FutureBuilder<List<WorkflowEvent>>(
                    future: _loadEvents(),
                    builder: (context, snapshot) {
                      final events = snapshot.data ?? const <WorkflowEvent>[];
                      if (events.isEmpty) {
                        return const Center(child: Text('Henüz event yok.'));
                      }
                      return ListView.builder(
                        itemCount: events.length,
                        itemBuilder: (context, i) {
                          final e = events[i];
                          return ListTile(
                            leading: Icon(_getIcon(e.type)),
                            title: Text(e.type),
                            subtitle: Text('${e.entity.kind}/${e.entity.id} • ${e.ts.toLocal()}'),
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
    final id = _currentAppointmentId;

    WorkflowEvent e;
    switch (type) {
      case 'appointment_created':
        e = EventFactories.appointmentCreated(
          appointmentId: id,
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
          entity: EntityRef(kind: 'appointment', id: id),
          data: {'reason': 'demo'},
        );
        break;

      case 'appointment_rescheduled':
        e = WorkflowEvent(
          id: 'demo_${DateTime.now().millisecondsSinceEpoch}',
          type: 'appointment_rescheduled',
          ts: DateTime.now().toUtc(),
          actor: 'clinic',
          entity: EntityRef(kind: 'appointment', id: id),
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
          entity: EntityRef(kind: 'appointment', id: id),
          data: {'note': type},
        );
        break;
    }

    await _pipeline.handleEvent(e);
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
      default:
        return Icons.bolt;
    }
  }
}
