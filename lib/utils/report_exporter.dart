import 'dart:io';
import 'package:csv/csv.dart';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

import '../models/generator.dart';
import '../models/runtime_entry.dart';
import '../models/fuel_entry.dart';

class ReportExporter {
  // Generates CSV string
  static Future<String> _generateCSV(Generator generator) async {
    final fuelBox = Hive.box<FuelEntry>('fuelBox');
    final runtimeBox = Hive.box<RuntimeEntry>('runtimeBox');

    final fuelLogs =
        fuelBox.values.where((e) => e.generatorCode == generator.code).toList();

    final runtimeLogs =
        runtimeBox.values.where((e) => e.generator == generator.code).toList();

    double totalFuelUsed = fuelLogs.fold(0.0, (sum, e) => sum + e.litres);
    double totalRuntime = runtimeLogs.fold(0.0, (sum, e) => sum + e.hours);
    double actualRate = totalRuntime > 0 ? totalFuelUsed / totalRuntime : 0.0;

    final rows = <List<dynamic>>[];

    // Header summary
    rows.add(['Generator:', '${generator.name} (${generator.code})']);
    rows.add(['Fuel capacity:', '${generator.tankCapacity} L']);
    rows.add(['Estimated rate:', '${generator.fuelConsumptionRate} L/hr']);
    rows.add(['Total runtime:', '${totalRuntime.toStringAsFixed(1)} hr']);
    rows.add(['Total fuel used:', '${totalFuelUsed.toStringAsFixed(1)} L']);
    rows.add(['Actual usage rate:', '${actualRate.toStringAsFixed(2)} L/hr']);
    rows.add([]); // spacer

    // Table headers
    rows.add(['Date', 'Run time (hr)', 'Fuel usage (L)', 'Fuel balance (L)']);

    double fuelBalance = generator.tankCapacity;
    runtimeLogs.sort((a, b) => a.date.compareTo(b.date));

    for (final runtime in runtimeLogs) {
      final used = runtime.hours * generator.fuelConsumptionRate;
      fuelBalance = (fuelBalance - used).clamp(0, generator.tankCapacity);

      rows.add([
        runtime.date.toIso8601String().split('T').first,
        runtime.hours.toStringAsFixed(1),
        used.toStringAsFixed(1),
        fuelBalance.toStringAsFixed(1),
      ]);
    }

    return const ListToCsvConverter().convert(rows);
  }

  /// ✅ Download CSV to device (returns path)
  static Future<String> downloadGeneratorReport(Generator generator) async {
    final csvData = await _generateCSV(generator);
    final dir = await getApplicationDocumentsDirectory();
    final file = File('${dir.path}/${generator.code}_report.csv');
    await file.writeAsString(csvData);
    return file.path;
  }

  /// ✅ Share the generated CSV
  static Future<void> shareGeneratorReport(Generator generator) async {
    final path = await downloadGeneratorReport(generator);
    await Share.shareXFiles([
      XFile(path),
    ], text: 'Report for ${generator.name}');
  }
}
