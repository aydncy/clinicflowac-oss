import 'package:flutter/material.dart';

import 'application/demo/demo_pipeline.dart';
import 'infrastructure/event_store/in_memory_event_store.dart';
import 'services/whatsapp_service.dart';
import 'domain/events/event_envelope.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ClinicFlowAC Demo',
      theme: ThemeData(useMaterial3: true),
      home: const DemoHomePage(),
    );
  }
}

class DemoHomePage extends StatefulWidget {
  const DemoHomePage({super.key});

  @override
  State<DemoHomePage> createState() => _DemoHomePageState();
}

class _DemoHomePageState extends State<DemoHomePage> {
  final store = InMemoryEventStore();
  late final DemoPipeline pipeline = DemoPipeline(store: store);

  String output = 'No events yet.';
  String lastAppointmentId = 'unknown_sender';

  late final WhatsAppService whatsapp = WhatsAppService(
    onEvent: (WorkflowEvent e) async {
      await pipeline.handleEvent(e);
      lastAppointmentId = e.entity.id;

      final timeline = await pipeline.loadTimelineForAppointment(lastAppointmentId);

      setState(() {
        output = _formatTimeline(timeline);
      });
    },
  );

  void runWebhookDemo() {
    final payload = {
      "entry": [
        {
          "changes": [
            {
              "value": {
                "contacts": [
                  {"wa_id": "905555000111"}
                ],
                "messages": [
                  {
                    "text": {"body": "Merhaba randevu almak istiyorum"}
                  }
                ]
              }
            }
          ]
        }
      ]
    };

    whatsapp.handleWebhook(payload);
  }

  String _formatTimeline(List<WorkflowEvent> events) {
    final b = StringBuffer();
    b.writeln('Appointment ID: $lastAppointmentId');
    b.writeln('Event count: ${events.length}');
    b.writeln('---');
    for (final e in events) {
      b.writeln('${e.ts.toIso8601String()}  ${e.type}');
      b.writeln('  actor: ${e.actor}');
      b.writeln('  entity: ${e.entity.kind}/${e.entity.id}');
      b.writeln('  data: ${e.data}');
      b.writeln('');
    }
    return b.toString();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('ClinicFlowAC - Event Pipeline Demo')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            FilledButton(
              onPressed: runWebhookDemo,
              child: const Text('Run WhatsApp Webhook Demo'),
            ),
            const SizedBox(height: 12),
            Expanded(
              child: SingleChildScrollView(
                child: Text(output),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
