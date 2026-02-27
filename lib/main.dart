import 'package:flutter/material.dart';
import 'services/event_store.dart';
import 'data/demo_clinic.dart';

void main() {
  runApp(const ClinicFlowApp());
}

class ClinicFlowApp extends StatelessWidget {
  const ClinicFlowApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title
