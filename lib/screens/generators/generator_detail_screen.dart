import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'package:tracker_two/models/generator.dart';
import 'package:tracker_two/models/fuel_entry.dart';

class GeneratorDetailScreen extends StatelessWidget {
  final Generator generator;

  const GeneratorDetailScreen({super.key, required this.generator});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          generator.name,
          style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.w600),
        ),
      ),
      body: ValueListenableBuilder(
        valueListenable: Hive.box<FuelEntry>('fuelBox').listenable(),
        builder: (context, Box<FuelEntry> fuelBox, _) {
          final fuelLogs = fuelBox.values.where(
            (log) => log.generatorCode == generator.code,
          );

          double totalFuelFilled = fuelLogs.fold(
            0.0,
            (sum, log) => sum + log.litres,
          );
          double tankCapacity = generator.tankCapacity;
          double remaining = tankCapacity - totalFuelFilled;

          if (remaining < 0) remaining = 0;

          double percent = (remaining / tankCapacity) * 100;
          final estimatedRuntime =
              generator.fuelConsumptionRate > 0
                  ? (remaining / generator.fuelConsumptionRate).toStringAsFixed(
                    1,
                  )
                  : "N/A";

          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              _buildDetailTile(
                icon: Icons.qr_code_2,
                label: "Generator Code",
                value: generator.code,
              ),
              _buildDetailTile(
                icon: Icons.local_gas_station,
                label: "Tank Capacity",
                value: "${generator.tankCapacity} Litres",
              ),
              _buildDetailTile(
                icon: Icons.speed,
                label: "Fuel Usage Rate",
                value: "${generator.fuelConsumptionRate} L/hr",
              ),
              _buildLiveFuelStats(percent, estimatedRuntime, remaining),
            ],
          );
        },
      ),
    );
  }

  Widget _buildDetailTile({
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        leading: Icon(icon, color: const Color(0xFFB2A4FF)),
        title: Text(
          label,
          style: GoogleFonts.poppins(fontWeight: FontWeight.w500),
        ),
        subtitle: Text(value, style: GoogleFonts.poppins()),
      ),
    );
  }

  Widget _buildLiveFuelStats(
    double percent,
    String estRuntime,
    double remaining,
  ) {
    Color fuelColor;
    if (percent > 50) {
      fuelColor = Colors.green;
    } else if (percent > 20) {
      fuelColor = Colors.orange;
    } else {
      fuelColor = Colors.red;
    }

    return Card(
      color: const Color(0xFFF1F0FF),
      margin: const EdgeInsets.only(top: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Live Fuel Estimate",
              style: GoogleFonts.poppins(
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Icon(Icons.battery_charging_full, color: fuelColor),
                const SizedBox(width: 8),
                Text(
                  "Fuel Remaining: ${percent.toStringAsFixed(1)}%",
                  style: GoogleFonts.poppins(fontSize: 14),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                const Icon(Icons.timer_outlined, color: Colors.deepPurple),
                const SizedBox(width: 8),
                Text(
                  "Estimated Runtime: $estRuntime hrs",
                  style: GoogleFonts.poppins(fontSize: 14),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                const Icon(
                  Icons.local_gas_station_outlined,
                  color: Colors.blueGrey,
                ),
                const SizedBox(width: 8),
                Text(
                  "Litres Remaining: ${remaining.toStringAsFixed(1)} L",
                  style: GoogleFonts.poppins(fontSize: 14),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
