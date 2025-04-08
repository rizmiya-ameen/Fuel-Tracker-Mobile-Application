import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive/hive.dart';
import 'package:tracker_two/models/fuel_entry.dart';
import 'package:tracker_two/models/generator.dart';

class FuelTab extends StatefulWidget {
  const FuelTab({super.key});

  @override
  State<FuelTab> createState() => _FuelTabState();
}

class _FuelTabState extends State<FuelTab> {
  final _formKey = GlobalKey<FormState>();
  final _fuelController = TextEditingController();
  final _rateController = TextEditingController();
  final _filledByController = TextEditingController();

  DateTime? selectedDate;
  String? selectedGenerator;

  final TextStyle placeholderStyle = GoogleFonts.poppins(
    fontSize: 16,
    color: Colors.grey,
  );

  List<Generator> generators = [];

  @override
  void initState() {
    super.initState();
    generators = Hive.box<Generator>('generatorBox').values.toList();
  }

  @override
  void dispose() {
    _fuelController.dispose();
    _rateController.dispose();
    _filledByController.dispose();
    super.dispose();
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2101),
    );
    if (picked != null) {
      setState(() {
        selectedDate = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildLabel("Date"),
            _buildCardInput(
              icon: Icons.calendar_today,
              child: InkWell(
                onTap: () => _selectDate(context),
                child: InputDecorator(
                  decoration: const InputDecoration(border: InputBorder.none),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        selectedDate != null
                            ? "${selectedDate!.toLocal()}".split(' ')[0]
                            : "Select a date",
                        style: placeholderStyle,
                      ),
                      const Icon(Icons.arrow_drop_down),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),

            _buildLabel("Generator"),
            _buildCardInput(
              icon: Icons.electric_bolt,
              child: DropdownButtonFormField<String>(
                value: selectedGenerator,
                hint: Text("Select Generator", style: placeholderStyle),
                icon: const Icon(Icons.arrow_drop_down),
                decoration: const InputDecoration(border: InputBorder.none),
                items:
                    generators.map((gen) {
                      return DropdownMenuItem<String>(
                        value: gen.code,
                        child: Text(gen.name),
                      );
                    }).toList(),
                validator:
                    (value) =>
                        value == null ? 'Please select a generator' : null,
                onChanged: (value) {
                  setState(() {
                    selectedGenerator = value;
                  });
                },
              ),
            ),
            const SizedBox(height: 20),

            _buildLabel("Fuel Quantity (Litres)"),
            _buildCardInput(
              icon: Icons.local_gas_station,
              child: TextFormField(
                controller: _fuelController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  hintText: "e.g., 50",
                  hintStyle: placeholderStyle,
                  border: InputBorder.none,
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter quantity';
                  }
                  return null;
                },
              ),
            ),
            const SizedBox(height: 20),

            _buildLabel("Rate (₹ per litre)"),
            _buildCardInput(
              icon: Icons.currency_rupee,
              child: TextFormField(
                controller: _rateController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  hintText: "e.g., 89.50",
                  hintStyle: placeholderStyle,
                  border: InputBorder.none,
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter rate per litre';
                  }
                  return null;
                },
              ),
            ),
            const SizedBox(height: 20),

            _buildLabel("Filled By"),
            _buildCardInput(
              icon: Icons.person,
              child: TextFormField(
                controller: _filledByController,
                decoration: InputDecoration(
                  hintText: "Enter name",
                  hintStyle: placeholderStyle,
                  border: InputBorder.none,
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter name';
                  }
                  return null;
                },
              ),
            ),
            const SizedBox(height: 30),

            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton.icon(
                onPressed: () {
                  if (selectedDate == null) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Please select a date')),
                    );
                    return;
                  }

                  if (_formKey.currentState!.validate()) {
                    final fuelEntry = FuelEntry(
                      generatorCode: selectedGenerator!,
                      litres: double.parse(_fuelController.text),
                      date: selectedDate!,
                      filledBy: _filledByController.text,
                      rate: double.parse(_rateController.text),
                    );

                    Hive.box<FuelEntry>('fuelBox').add(fuelEntry);

                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Fuel entry saved!')),
                    );

                    setState(() {
                      selectedDate = null;
                      selectedGenerator = null;
                      _fuelController.clear();
                      _rateController.clear();
                      _filledByController.clear();
                    });

                    _formKey.currentState!.reset();
                  }
                },
                icon: const Icon(Icons.check),
                label: const Text("Save"),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF2BB6A3),
                  foregroundColor: Colors.white,
                  textStyle: GoogleFonts.poppins(fontSize: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLabel(String text) => Padding(
    padding: const EdgeInsets.only(left: 4, bottom: 6),
    child: Text(
      text,
      style: GoogleFonts.poppins(
        fontWeight: FontWeight.bold,
        fontSize: 14,
        color: Colors.black87,
      ),
    ),
  );

  Widget _buildCardInput({required IconData icon, required Widget child}) =>
      Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: const Color(0xFFDEDFF5)),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.shade100,
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 12),
              child: Icon(icon, color: const Color(0xFFB2A4FF), size: 20),
            ),
            const SizedBox(width: 8),
            Expanded(child: child),
          ],
        ),
      );
}
