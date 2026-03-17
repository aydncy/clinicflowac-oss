// lib/domain/events/event_envelope.dart
//
// ClinicFlowAC — Workflow Event Specification (WES) v0.1 ile uyumlu.
// Zorunlu alanlar: id, type, ts, actor, entity{kind,id}, data

/// SPEC: actor string enum
/// system | patient | clinic | integration
typedef ActorKind = String;

/// SPEC: entity.kind enum
/// appointment | document | consent
class EntityRef {
  final String kind;
  final String id;

  const EntityRef({required this.kind, required this.id});

  

  
        kind: json["kind"] as String,
        id: json["id"] as String,
      );
}

/// SPEC event envelope
class WorkflowEvent {
  final String id;
  final String type;
  final DateTime ts;
  final ActorKind actor;
  final EntityRef entity;
  final Map<String, dynamic> data;

  const WorkflowEvent({
    required this.id,
    required this.type,
    required this.ts,
    required this.actor,
    required this.entity,
    required this.data,
  });

  
        "id": id,
        "type": type,
        "ts": ts.toUtc().toIso8601String(),
        "actor": actor,
        "entity": entity.toJson(),
        "data": data,
      };

  
        id: json["id"] as String,
        type: json["type"] as String,
        ts: DateTime.parse(json["ts"] as String).toUtc(),
        actor: json["actor"] as String,
        entity: EntityRef.fromJson(json["entity"] as Map<String, dynamic>),
        data: (json["data"] as Map).cast<String, dynamic>(),
      );
}
