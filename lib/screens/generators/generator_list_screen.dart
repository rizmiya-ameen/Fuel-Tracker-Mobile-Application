import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:tracker_two/models/generator.dart';

import 'add_generator_screen.dart';
import 'generator_detail_screen.dart';

class GeneratorListScreen extends StatelessWidget {
  const GeneratorListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final generatorBox = Hive.box<Generator>('generatorBox');

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Generators',
          style: GoogleFonts.poppins(fontSize: 20, fontWeight: FontWeight.w600),
        ),
      ),
      body: ValueListenableBuilder(
        valueListenable: generatorBox.listenable(),
        builder: (context, Box<Generator> box, _) {
          if (box.isEmpty) {
            return const Center(child: Text("No generators added yet."));
          }

          return ListView.builder(
            itemCount: box.length,
            itemBuilder: (context, index) {
              final generator = box.getAt(index);

              // 🔁 Simulate fuel left (in real app, calculate from logs)
              final double simulatedFuelLeft =
                  (generator?.tankCapacity ?? 0) * 0.65; // say 65% remaining
              final fuelPercentage =
                  ((simulatedFuelLeft / (generator?.tankCapacity ?? 1)) * 100)
                      .toInt();

              Color fuelColor;
              if (fuelPercentage > 50) {
                fuelColor = Colors.green;
              } else if (fuelPercentage > 20) {
                fuelColor = Colors.orange;
              } else {
                fuelColor = Colors.red;
              }

              return Dismissible(
                key: UniqueKey(),
                background: Container(
                  color: Colors.red,
                  alignment: Alignment.centerLeft,
                  padding: const EdgeInsets.only(left: 20),
                  child: const Icon(Icons.delete, color: Colors.white),
                ),
                direction: DismissDirection.startToEnd,
                confirmDismiss: (direction) async {
                  return await showDialog(
                    context: context,
                    builder:
                        (context) => AlertDialog(
                          title: const Text("Delete Generator"),
                          content: const Text(
                            "Are you sure you want to delete this generator?",
                          ),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.of(context).pop(false),
                              child: const Text("Cancel"),
                            ),
                            TextButton(
                              onPressed: () => Navigator.of(context).pop(true),
                              child: const Text("Delete"),
                            ),
                          ],
                        ),
                  );
                },
                onDismissed: (_) => generator?.delete(),
                child: Card(
                  margin: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  elevation: 2,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: ListTile(
                    leading: const Icon(
                      Icons.ev_station,
                      size: 32,
                      color: Color(0xFFB2A4FF),
                    ),
                    title: Text(
                      generator?.name ?? '',
                      style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Code: ${generator?.code ?? ''}"),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            Text(
                              "Fuel Left: ${simulatedFuelLeft.toStringAsFixed(1)} L ",
                              style: GoogleFonts.poppins(fontSize: 13),
                            ),
                            Container(
                              width: 10,
                              height: 10,
                              decoration: BoxDecoration(
                                color: fuelColor,
                                shape: BoxShape.circle,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    trailing: const Icon(Icons.chevron_right),
                    onTap: () {
                      if (generator != null) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder:
                                (_) =>
                                    GeneratorDetailScreen(generator: generator),
                          ),
                        );
                      }
                    },
                  ),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0xFFB2A4FF),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const AddGeneratorScreen()),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
