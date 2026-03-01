import 'dart:convert';
import 'package:hive_ce_flutter/hive_ce_flutter.dart';
import 'core/models.dart';  // mevcut model varsa
// eğer core/models.dart yoksa söyle, düzeltiriz

class ProofPackExporter {
  final HiveEventStore _store;

  ProofPackExporter(this._store);

  Future<Map<String, dynamic>> generateProofPack({
    required String entityKind,
    required String entityId,
    String? actor,
  }) async {
    final events = await _store.loadByEntity(kind: entityKind, id: entityId);

    final pack = {
      'proof_pack_id': 'pp_${DateTime.now().millisecondsSinceEpoch}',
      'generated_at': DateTime.now().toUtc().toIso8601String(),
      'version': '0.1.0',
      'entity': {
        'kind': entityKind,
        'id': entityId,
      },
      'metadata': {
        'event_count': events.length,
        'first_event': events.isEmpty ? null : events.first.ts.toIso8601String(),
        'last_event': events.isEmpty ? null : events.last.ts.toIso8601String(),
        'actor': actor ?? 'system',
      },
      'events': events.map((e) => e.toJson()).toList(),
      'integrity': {
        'hash_chain_enabled': false, // 2. aşamada açacağız
        'total_hash': '', // sonra dolduracağız
      },
    };

    return pack;
  }

  Future<String> exportAsJson({
    required String entityKind,
    required String entityId,
  }) async {
    final pack = await generateProofPack(
      entityKind: entityKind,
      entityId: entityId,
    );
    return const JsonEncoder.withIndent('  ').convert(pack);
  }
}
