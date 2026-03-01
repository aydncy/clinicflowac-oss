Map<String, dynamic> exportToOvwi(String workflowId) {
  return {
    "schema_version": "1.0.0",
    "workflow_id": workflowId,
    "workflow_type": "clinic_appointment",
    "source_system": "clinicflowac-oss",
    "source_version": "0.1.0",
    "actors": [],
    "events": [],
    "artifacts": []
  };
}
