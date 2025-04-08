import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive/hive.dart';
import 'package:tracker_two/models/generator.dart';

class AddGeneratorScreen extends StatefulWidget {
  const AddGeneratorScreen({super.key});

  @override
  State<AddGeneratorScreen> createState() => _AddGeneratorScreenState();
}

class _AddGeneratorScreenState extends State<AddGeneratorScreen> {
  final _formKey = GlobalKey<FormState>();

  final _nameController = TextEditingController();
  final _codeController = TextEditingController();
  final _tankController = TextEditingController();
  final _rateController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _codeController.dispose();
    _tankController.dispose();
    _rateController.dispose();
    super.dispose();
  }

  void _saveGenerator() {
    if (_formKey.currentState!.validate()) {
      final newGenerator = Generator(
        name: _nameController.text,
        code: _codeController.text,
        tankCapacity: double.parse(_tankController.text),
        fuelConsumptionRate: double.parse(_rateController.text),
      );

      Hive.box<Generator>('generatorBox').add(newGenerator);

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Generator added!")));

      Navigator.pop(context); // return to list screen
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Add Generator',
          style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.w600),
        ),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            _buildLabel("Generator Name"),
            _buildInput(_nameController, "e.g., Main Lab", TextInputType.text),

            const SizedBox(height: 16),
            _buildLabel("Generator Code"),
            _buildInput(_codeController, "e.g., M340675", TextInputType.text),

            const SizedBox(height: 16),
            _buildLabel("Tank Capacity (litres)"),
            _buildInput(_tankController, "e.g., 200", TextInputType.number),

            const SizedBox(height: 16),
            _buildLabel("Fuel Usage Rate (litres/hour)"),
            _buildInput(_rateController, "e.g., 3.5", TextInputType.number),

            const SizedBox(height: 30),
            ElevatedButton.icon(
              onPressed: _saveGenerator,
              icon: const Icon(Icons.save),
              label: const Text("Save Generator"),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF2BB6A3),
                foregroundColor: Colors.white,
                textStyle: GoogleFonts.poppins(fontSize: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLabel(String text) {
    return Padding(
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
  }

  Widget _buildInput(
    TextEditingController controller,
    String hint,
    TextInputType type,
  ) {
    return TextFormField(
      controller: controller,
      keyboardType: type,
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: GoogleFonts.poppins(color: Colors.grey),
        filled: true,
        fillColor: Colors.white,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 12,
          vertical: 14,
        ),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
      ),
      validator: (value) {
        if (value == null || value.trim().isEmpty) {
          return 'This field is required';
        }
        return null;
      },
    );
  }
}
