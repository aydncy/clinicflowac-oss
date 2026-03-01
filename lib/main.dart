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
      title: 'ClinicFlowAC',
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
  final _controller = TextEditingController();
  String _currentId = 'patient_123';
  bool _ready = false;

  late final DemoPipeline _pipeline = DemoPipeline(store: _store);

  late final WhatsAppService _whatsapp = WhatsAppService(
    onEvent: (WorkflowEvent e) async {
      await _pipeline.handleEvent(e);
      setState(() => _currentId = e.entity.id);
    },
  );

  @override
  void initState() {
    super.initState();
    _store.init().then((_) => setState(() => _ready = true));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('ClinicFlowAC (Persistent)')),
      body: Center(
        child: _ready
            ? const Text('Persistent Event Store Ready')
            : const CircularProgressIndicator(),
      ),
    );
  }
}
