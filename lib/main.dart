import 'package:flutter/material.dart';
import 'package:hive_ce_flutter/hive_flutter.dart';
import 'infrastructure/event_store/hive_event_store.dart';
import 'services/ovwi_client.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  runApp(const ClinicFlowAC());
}

class ClinicFlowAC extends StatelessWidget {
  const ClinicFlowAC({super.key});

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

  State<DemoScreen> createState() => _DemoScreenState();
}

class _DemoScreenState extends State<DemoScreen> {
  final _store = HiveEventStore();
  bool _ready = false;

  void initState() {
    super.initState();
    _store.init().then((_) => setState(() => _ready = true));
  }

  Future<void> _sendEventToOvwi() async {
    final client = OvwiClient();

    try {
      final result = await client.sendEvent(
        workflowId: "clinic-demo-1",
        eventId: DateTime.now().millisecondsSinceEpoch.toString(),
        payload: {
          "type": "appointment_created",
          "patient_id": "P-001",
        },
      );

      debugPrint("OVWI RESULT: $result");
    } catch (e) {
      debugPrint("OVWI ERROR: $e");
    }
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('ClinicFlowAC (Persistent Ready)'),
      ),
      body: Center(
        child: _ready
            ? Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    'Hive Event Store Initialized ✅',
                    style: TextStyle(fontSize: 16),
                  ),
                  const SizedBox(height: 32),
                  ElevatedButton(
                    onPressed: _sendEventToOvwi,
                    child: const Text("Send Event to OVWI"),
                  ),
                ],
              )
            : const CircularProgressIndicator(),
      ),
    );
  }
}