import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:tracker_two/models/fuel_entry.dart';
import 'package:tracker_two/models/runtime_entry.dart';
import 'package:tracker_two/models/generator.dart';
import 'package:tracker_two/screens/dashboard/dashboard_screen.dart';
import 'package:tracker_two/theme/app_theme.dart'; // Optional: your custom theme

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // ✅ Initialize Hive
  await Hive.initFlutter();

  // ✅ Register Hive adapters
  Hive.registerAdapter(FuelEntryAdapter());
  Hive.registerAdapter(RuntimeEntryAdapter());
  Hive.registerAdapter(GeneratorAdapter());

  // 🧼 TEMP: Delete Hive boxes during dev (remove later in production)
  //await Hive.deleteBoxFromDisk('fuelBox');
  //await Hive.deleteBoxFromDisk('runtimeBox');
  //await Hive.deleteBoxFromDisk('generatorBox');

  // ✅ Open Hive boxes
  await Hive.openBox<FuelEntry>('fuelBox');
  await Hive.openBox<RuntimeEntry>('runtimeBox');
  await Hive.openBox<Generator>('generatorBox');

  runApp(const TrackerApp());
}

class TrackerApp extends StatelessWidget {
  const TrackerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Fuel Tracker',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      home: const DashboardScreen(),
    );
  }
}
