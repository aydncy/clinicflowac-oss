import 'package:flutter/material.dart';
import 'package:hive_ce_flutter/hive_ce_flutter.dart';
import 'dart:convert';

void main() async {
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
      debugShowCheckedModeBanner: false,
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

  late final WhatsAppService _whatsapp;

  @override
  void initState() {
    super.initState();
    _whatsapp = WhatsAppService(
      onEvent: (WorkflowEvent e) async {
        await _pipeline.handleEvent(e);
        if (mounted) setState(() => _currentAppointmentId = e.entity.id);
      },
    );

    _store.init().then((_) {
      if (mounted) setState(() => _ready = true);
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  // === RESET ALL RECORDS ===
  Future<void> _resetAllRecords() async {
    try {
      await Hive.deleteFromDisk();
      await Hive.initFlutter();
      await _store.init();
      setState(() {
        _currentAppointmentId = 'patient_123';
        _ready = true;
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('✅ All records cleared. Fresh start!'), backgroundColor: Colors.green),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e'), backgroundColor: Colors.red),
        );
      }
    }
  }

  // === PROOF PACK EXPORT ===
  Future<void> _exportProofPack() async {
    final exporter = ProofPackExporter(_store);
    final pack = await exporter.generateProofPack(
      entityKind: 'appointment',
      entityId: _currentAppointmentId,
    );
    final jsonStr = const JsonEncoder.withIndent('  ').convert(pack);

    if (mounted) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Proof Pack Generated'),
          content: SingleChildScrollView(
            child: SelectableText(jsonStr),
          ),
          actions: [
            TextButton(onPressed: () => Navigator.pop(context), child: const Text('Close')),
          ],
        ),
      );
    }
  }

  Future<List<WorkflowEvent>> _loadEvents() async {
    if (!_ready) return const [];
    return _store.loadByEntity(kind: 'appointment', id: _currentAppointmentId);
  }

  Future<void> _addDemoEvent(String type) async {
    final id = _currentAppointmentId;
    WorkflowEvent e;

    switch (type) {
      case 'appointment_created':
        e = EventFactories.appointmentCreated(appointmentId: id, startAt: DateTime.now().add(const Duration(hours: 2)), actor: 'clinic');
        break;
      case 'appointment_cancelled':
        e = WorkflowEvent(id: 'demo_${DateTime.now().millisecondsSinceEpoch}', type: 'appointment_cancelled', ts: DateTime.now().toUtc(), actor: 'clinic', entity: EntityRef(kind: 'appointment', id: id), data: {'reason': 'demo'});
        break;
      case 'appointment_rescheduled':
        e = WorkflowEvent(id: 'demo_${DateTime.now().millisecondsSinceEpoch}', type: 'appointment_rescheduled', ts: DateTime.now().toUtc(), actor: 'clinic', entity: EntityRef(kind: 'appointment', id: id), data: {'new_start_at': DateTime.now().add(const Duration(days: 1)).toUtc().toIso8601String()});
        break;
      default:
        e = WorkflowEvent(id: 'demo_${DateTime.now().millisecondsSinceEpoch}', type: 'note_added', ts: DateTime.now().toUtc(), actor: 'clinic', entity: EntityRef(kind: 'appointment', id: id), data: {'note': type});
    }

    await _pipeline.handleEvent(e);
    setState(() {});
  }

  void _simulateWhatsApp(String message) {
    if (message.isEmpty) return;
    final payload = {'entry': [{'changes': [{'value': {'contacts': [{'wa_id': _currentAppointmentId}], 'messages': [{'text': {'body': message}}]}}]}]};
    _whatsapp.handleWebhook(payload);
    _controller.clear();
  }

  IconData _getIcon(String type) {
    switch (type) {
      case 'appointment_created': return Icons.schedule;
      case 'appointment_cancelled': return Icons.cancel;
      case 'appointment_rescheduled': return Icons.update;
      default: return Icons.bolt;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('ClinicFlowAC Demo')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    decoration: const InputDecoration(hintText: 'Type WhatsApp message...', border: OutlineInputBorder()),
                  ),
                ),
                const SizedBox(width: 10),
                FilledButton(onPressed: _ready ? () => _simulateWhatsApp(_controller.text.trim()) : null, child: const Text('Send')),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Wrap(
              spacing: 10,
              runSpacing: 10,
              children: [
                FilledButton.tonal(onPressed: _ready ? () => _addDemoEvent('appointment_created') : null, child: const Text('Book Appointment')),
                FilledButton.tonal(onPressed: _ready ? () => _addDemoEvent('appointment_cancelled') : null, child: const Text('Cancel')),
                FilledButton.tonal(onPressed: _ready ? () => _addDemoEvent('appointment_rescheduled') : null, child: const Text('Reschedule')),
                FilledButton.tonal(onPressed: _ready ? _resetAllRecords : null, style: FilledButton.styleFrom(backgroundColor: Colors.red.shade100), child: const Text('🔄 Reset All Records')),
                FilledButton.tonal(onPressed: _ready ? _exportProofPack : null, child: const Text('📦 Export Proof Pack')),
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
                      final events = snapshot.data ?? const [];
                      if (events.isEmpty) return const Center(child: Text('No events yet.'));
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
}

// ====================== MINIMAL STUB CLASSES (CI geçsin diye) ======================
class WorkflowEvent {
  final String id;
  final String type;
  final DateTime ts;
  final String actor;
  final EntityRef entity;
  final Map<String, dynamic> data;
  WorkflowEvent({required this.id, required this.type, required this.ts, required this.actor, required this.entity, required this.data});
  Map<String, dynamic> toJson() => {'id': id, 'type': type, 'ts': ts.toIso8601String(), 'actor': actor, 'entity': entity.toJson(), 'data': data};
}

class EntityRef {
  final String kind;
  final String id;
  EntityRef({required this.kind, required this.id});
  Map<String, dynamic> toJson() => {'kind': kind, 'id': id};
}

class HiveEventStore {
  Future<void> init() async {}
  Future<List<WorkflowEvent>> loadByEntity({required String kind, required String id}) async => [];
  Future<void> append(WorkflowEvent e) async {}
}

class DemoPipeline {
  final HiveEventStore store;
  DemoPipeline({required this.store});
  Future<void> handleEvent(WorkflowEvent e) async {}
}

class WhatsAppService {
  final Function(WorkflowEvent) onEvent;
  WhatsAppService({required this.onEvent});
  void handleWebhook(Map payload) {}
}

class EventFactories {
  static WorkflowEvent appointmentCreated({required String appointmentId, required DateTime startAt, required String actor}) {
    return WorkflowEvent(id: 'demo_${DateTime.now().millisecondsSinceEpoch}', type: 'appointment_created', ts: DateTime.now().toUtc(), actor: actor, entity: EntityRef(kind: 'appointment', id: appointmentId), data: {'start_at': startAt.toUtc().toIso8601String()});
  }
}

class ProofPackExporter {
  final HiveEventStore _store;
  ProofPackExporter(this._store);

  Future<Map<String, dynamic>> generateProofPack({required String entityKind, required String entityId}) async {
    final events = await _store.loadByEntity(kind: entityKind, id: entityId);
    return {
      'proof_pack_id': 'pp_${DateTime.now().millisecondsSinceEpoch}',
      'generated_at': DateTime.now().toUtc().toIso8601String(),
      'version': '0.1.0',
      'entity': {'kind': entityKind, 'id': entityId},
      'metadata': {'event_count': events.length, 'first_event': events.isEmpty ? null : events.first.ts.toIso8601String(), 'last_event': events.isEmpty ? null : events.last.ts.toIso8601String()},
      'events': events.map((e) => e.toJson()).toList(),
      'integrity': {'hash_chain_enabled': false, 'total_hash': ''},
    };
  }
}
