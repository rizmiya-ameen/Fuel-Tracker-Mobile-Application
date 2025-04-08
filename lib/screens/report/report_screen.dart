import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import '../../models/generator.dart';
import '../../components/generator_summary_card.dart';

class ReportScreen extends StatelessWidget {
  const ReportScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final generatorBox = Hive.box<Generator>('generatorBox');
    final generators = generatorBox.values.toList();

    return Scaffold(
      appBar: AppBar(title: const Text("Reports")),
      body: ListView(
        children:
            generators.map((g) => GeneratorSummaryCard(generator: g)).toList(),
      ),
    );
  }
}
