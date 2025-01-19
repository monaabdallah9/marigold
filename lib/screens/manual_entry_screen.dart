import 'package:flutter/material.dart';

class ManualEntryScreen extends StatefulWidget {
  const ManualEntryScreen({super.key});

  @override
  State<ManualEntryScreen> createState() => _ManualEntryScreenState();
}

class _ManualEntryScreenState extends State<ManualEntryScreen> {
  final _formKey = GlobalKey<FormState>();
  final Map<String, TextEditingController> _controllers = {
    'testName': TextEditingController(),
    'testDate': TextEditingController(),
    'testValue': TextEditingController(),
    'unit': TextEditingController(),
    'referenceRange': TextEditingController(),
  };

  @override
  void dispose() {
    _controllers.forEach((_, controller) => controller.dispose());
    super.dispose();
  }

  Future<void> _selectDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
    );
    if (picked != null) {
      setState(() {
        _controllers['testDate']!.text = "${picked.year}-${picked.month.toString().padLeft(2, '0')}-${picked.day.toString().padLeft(2, '0')}";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF0F4FF),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Container(
            padding: const EdgeInsets.all(8),
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: Color(0xFFD6E1FF),
            ),
            child: const Icon(Icons.arrow_back, color: Color(0xFF2B417B)),
          ),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Manual Entry',
          style: TextStyle(
            color: Color(0xFF2B417B),
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _buildTextField(
                label: 'Test Name',
                controller: _controllers['testName']!,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter test name';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              _buildTextField(
                label: 'Test Date',
                controller: _controllers['testDate']!,
                readOnly: true,
                onTap: _selectDate,
                suffixIcon: const Icon(Icons.calendar_today),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please select test date';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              _buildTextField(
                label: 'Test Value',
                controller: _controllers['testValue']!,
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter test value';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              _buildTextField(
                label: 'Unit',
                controller: _controllers['unit']!,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter unit';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              _buildTextField(
                label: 'Reference Range',
                controller: _controllers['referenceRange']!,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter reference range';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 40),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    // TODO: Handle form submission
                    // You can process the form data here
                    Navigator.pop(context);
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF2B417B),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                child: const Text(
                  'Save',
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required String label,
    required TextEditingController controller,
    TextInputType? keyboardType,
    bool readOnly = false,
    VoidCallback? onTap,
    Widget? suffixIcon,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      readOnly: readOnly,
      onTap: onTap,
      validator: validator,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(color: Color(0xFF2B417B)),
        suffixIcon: suffixIcon,
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFF2B417B)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFF2B417B)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFF2B417B), width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.red),
        ),
      ),
    );
  }
} 