import 'exporters/ovwi_exporter.dart';
import 'services/ovwi_client.dart';

import 'package:flutter/material.dart';
import 'package:hive_ce_flutter/hive_flutter.dart';
import 'infrastructure/event_store/hive_event_store.dart';

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
  bool _ready = false;

  @override
  void initState() {
    super.initState();
    _initialize();
  }

  Future<void> _initialize() async {
    await _store.init();
    setState(() => _ready = true);
    await _testOvwiIntegration();
  }

  Future<void> _testOvwiIntegration() async {
    try {
      final workflow = exportToOvwi("test-workflow-001");
      await sendWorkflowToOvwi(workflow);
      debugPrint("OVWI INTEGRATION SUCCESS");
    } catch (e) {
      debugPrint("OVWI ERROR: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('ClinicFlowAC (Persistent Ready)')),
      body: Center(
        child: _ready
            ? const Text('Hive Event Store Initialized ✅')
            : const CircularProgressIndicator(),
      ),
    );
  }
}
