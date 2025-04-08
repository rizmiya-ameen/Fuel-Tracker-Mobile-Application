import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive/hive.dart';
import 'package:intl/intl.dart';

import '../models/generator.dart';
import '../models/fuel_entry.dart';
import '../models/runtime_entry.dart';
import '../utils/report_exporter.dart';

class GeneratorSummaryCard extends StatefulWidget {
  final Generator generator;

  const GeneratorSummaryCard({super.key, required this.generator});

  @override
  State<GeneratorSummaryCard> createState() => _GeneratorSummaryCardState();
}

class _GeneratorSummaryCardState extends State<GeneratorSummaryCard> {
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    final fuelLogs =
        Hive.box<FuelEntry>('fuelBox').values
            .where((e) => e.generatorCode == widget.generator.code)
            .toList();

    final runtimeLogs =
        Hive.box<RuntimeEntry>(
          'runtimeBox',
        ).values.where((e) => e.generator == widget.generator.code).toList();

    final double totalFuel = fuelLogs.fold(0.0, (sum, e) => sum + e.litres);
    final double totalRuntime = runtimeLogs.fold(
      0.0,
      (sum, e) => sum + e.hours,
    );
    final double avgRate = totalRuntime > 0 ? totalFuel / totalRuntime : 0.0;

    double fuelBalance = widget.generator.tankCapacity;
    final List<_ReportRow> reportRows = [];

    final sortedRuntime = runtimeLogs..sort((a, b) => a.date.compareTo(b.date));
    for (final runtime in sortedRuntime) {
      final used = runtime.hours * widget.generator.fuelConsumptionRate;
      fuelBalance = (fuelBalance - used).clamp(
        0,
        widget.generator.tankCapacity,
      );
      reportRows.add(
        _ReportRow(
          date: runtime.date,
          runtime: runtime.hours,
          fuelUsed: used,
          balance: fuelBalance,
        ),
      );
    }

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    "${widget.generator.name} (${widget.generator.code})",
                    style: GoogleFonts.poppins(
                      fontWeight: FontWeight.w600,
                      fontSize: 16,
                      color: const Color(0xFF2BB6A3),
                    ),
                  ),
                ),
                IconButton(
                  icon: Icon(
                    _isExpanded ? Icons.expand_less : Icons.expand_more,
                  ),
                  onPressed: () => setState(() => _isExpanded = !_isExpanded),
                ),
              ],
            ),
            const SizedBox(height: 8),

            // Summary
            _infoRow(
              "Fuel usage (estimated):",
              "${widget.generator.fuelConsumptionRate} L/hr",
            ),
            _infoRow(
              "Fuel usage (actual):",
              "${avgRate.toStringAsFixed(2)} L/hr",
            ),
            _infoRow("Fuel capacity:", "${widget.generator.tankCapacity} L"),

            if (_isExpanded) ...[
              const Divider(height: 24),

              // ✅ Styled "Date-wise Usage" heading
              Container(
                alignment: Alignment.centerLeft,
                padding: const EdgeInsets.only(bottom: 4),
                decoration: const BoxDecoration(
                  border: Border(
                    bottom: BorderSide(color: Color(0xFFB2A4FF), width: 1.2),
                  ),
                ),
                child: Text(
                  "Date-wise Usage",
                  style: GoogleFonts.poppins(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFFB2A4FF),
                  ),
                ),
              ),

              const SizedBox(height: 8),
              _buildTable(reportRows),
              const SizedBox(height: 16),

              // Buttons
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton.icon(
                    onPressed: () async {
                      final path = await ReportExporter.downloadGeneratorReport(
                        widget.generator,
                      );
                      if (!context.mounted) return;
                      ScaffoldMessenger.of(
                        context,
                      ).showSnackBar(SnackBar(content: Text("Saved to $path")));
                    },
                    icon: const Icon(Icons.download),
                    label: const Text("Download"),
                    style: _buttonStyle(),
                  ),
                  ElevatedButton.icon(
                    onPressed: () {
                      ReportExporter.shareGeneratorReport(widget.generator);
                    },
                    icon: const Icon(Icons.share),
                    label: const Text("Share"),
                    style: _buttonStyle(),
                  ),
                ],
              ),
            ],
            if (!_isExpanded) const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }

  Widget _infoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        children: [
          Expanded(
            child: Text(label, style: GoogleFonts.poppins(fontSize: 13)),
          ),
          Text(
            value,
            style: GoogleFonts.poppins(
              fontWeight: FontWeight.w500,
              fontSize: 13,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTable(List<_ReportRow> rows) {
    if (rows.isEmpty) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 12),
        child: Center(
          child: Text(
            "No records to show",
            style: GoogleFonts.poppins(fontSize: 14, color: Colors.grey[600]),
          ),
        ),
      );
    }

    return Table(
      columnWidths: const {
        0: FlexColumnWidth(3),
        1: FlexColumnWidth(2),
        2: FlexColumnWidth(2),
        3: FlexColumnWidth(2),
      },
      border: TableBorder(
        verticalInside: BorderSide(color: Colors.grey.shade300, width: 1),
      ),
      children: [
        _buildTableRow(
          "Date",
          "Run time (hr)",
          "Fuel usage (L)",
          "Fuel balance (L)",
          isHeader: true,
        ),
        ...rows.map(
          (row) => _buildTableRow(
            DateFormat('yyyy-MM-dd').format(row.date),
            row.runtime.toStringAsFixed(1),
            row.fuelUsed.toStringAsFixed(1),
            row.balance.toStringAsFixed(1),
          ),
        ),
      ],
    );
  }

  TableRow _buildTableRow(
    String col1,
    String col2,
    String col3,
    String col4, {
    bool isHeader = false,
  }) {
    final style = GoogleFonts.poppins(
      fontWeight: isHeader ? FontWeight.bold : FontWeight.normal,
      fontSize: 13,
    );

    List<Widget> cells =
        [col1, col2, col3, col4]
            .map(
              (value) => Container(
                padding: const EdgeInsets.symmetric(vertical: 6),
                alignment: Alignment.center,
                child: Text(value, style: style, textAlign: TextAlign.center),
              ),
            )
            .toList();

    return TableRow(children: cells);
  }

  ButtonStyle _buttonStyle() => ElevatedButton.styleFrom(
    backgroundColor: const Color(0xFF2BB6A3),
    foregroundColor: Colors.white,
    textStyle: GoogleFonts.poppins(fontSize: 14),
    padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
  );
}

class _ReportRow {
  final DateTime date;
  final double runtime;
  final double fuelUsed;
  final double balance;

  _ReportRow({
    required this.date,
    required this.runtime,
    required this.fuelUsed,
    required this.balance,
  });
}
