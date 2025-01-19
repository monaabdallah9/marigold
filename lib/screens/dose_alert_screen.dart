import 'package:flutter/material.dart';
import 'dart:ui';

class DoseAlertScreen extends StatefulWidget {
  const DoseAlertScreen({super.key});

  @override
  State<DoseAlertScreen> createState() => _DoseAlertScreenState();
}

class _DoseAlertScreenState extends State<DoseAlertScreen> {
  List<MedicationTime> _medications = [];
  TimeOfDay _selectedTime = TimeOfDay.now();
  List<bool> _selectedDays = List.generate(7, (index) => false);

  void _addMedication() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        String medicineName = '';
        String dosage = '';
        TimeOfDay selectedTime = _selectedTime;
        List<bool> selectedDays = List.generate(7, (index) => false);
        
        Widget _buildDialogDayButton(String label, int index, StateSetter setState) {
          return GestureDetector(
            onTap: () => setState(() => selectedDays[index] = !selectedDays[index]),
            child: Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: selectedDays[index] ? const Color(0xFF1976D2) : Colors.transparent,
                border: Border.all(color: const Color(0xFF1976D2)),
                shape: BoxShape.circle,
              ),
              child: Center(
                child: Text(
                  label,
                  style: TextStyle(
                    color: selectedDays[index] ? Colors.white : const Color(0xFF1976D2),
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          );
        }

        return StatefulBuilder(
          builder: (context, setState) {
            return Dialog(
              backgroundColor: Colors.transparent,
              insetPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
              child: SingleChildScrollView(
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        Colors.white.withOpacity(0.95),
                        Colors.white.withOpacity(0.90),
                      ],
                    ),
                    borderRadius: BorderRadius.circular(24),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.2),
                        blurRadius: 20,
                        offset: const Offset(0, 10),
                      ),
                    ],
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: const Color(0xFF1976D2).withOpacity(0.1),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: const Icon(
                              Icons.medication_outlined,
                              color: Color(0xFF1976D2),
                              size: 24,
                            ),
                          ),
                          const SizedBox(width: 12),
                          const Text(
                            'Add Medication',
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF1976D2),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 24),
                      TextField(
                        onChanged: (value) => medicineName = value,
                        decoration: InputDecoration(
                          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                          hintText: 'Medicine Name',
                          prefixIcon: const Icon(Icons.medication, color: Color(0xFF1976D2)),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: const BorderSide(color: Color(0xFF1976D2)),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: const BorderSide(color: Color(0xFF1976D2), width: 2),
                          ),
                          filled: true,
                          fillColor: const Color(0xFF1976D2).withOpacity(0.05),
                          isDense: true,
                        ),
                      ),
                      const SizedBox(height: 16),
                      TextField(
                        onChanged: (value) => dosage = value,
                        decoration: InputDecoration(
                          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                          hintText: 'Dosage (e.g., 1 pill)',
                          prefixIcon: const Icon(Icons.medical_information, color: Color(0xFF1976D2)),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: const BorderSide(color: Color(0xFF1976D2)),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: const BorderSide(color: Color(0xFF1976D2), width: 2),
                          ),
                          filled: true,
                          fillColor: const Color(0xFF1976D2).withOpacity(0.05),
                          isDense: true,
                        ),
                      ),
                      const SizedBox(height: 24),
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: const Color(0xFF1976D2).withOpacity(0.1),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: const Icon(
                              Icons.access_time,
                              color: Color(0xFF1976D2),
                              size: 20,
                            ),
                          ),
                          const SizedBox(width: 12),
                          const Text(
                            'Time',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF1976D2),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      InkWell(
                        onTap: () async {
                          final TimeOfDay? picked = await showTimePicker(
                            context: context,
                            initialTime: selectedTime,
                            builder: (context, child) {
                              return Theme(
                                data: Theme.of(context).copyWith(
                                  colorScheme: const ColorScheme.light(
                                    primary: Color(0xFF1976D2),
                                    onPrimary: Colors.white,
                                    surface: Colors.white,
                                    onSurface: Colors.black,
                                  ),
                                ),
                                child: child!,
                              );
                            },
                          );
                          if (picked != null) {
                            setState(() {
                              selectedTime = picked;
                            });
                          }
                        },
                        child: Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: const Color(0xFF1976D2).withOpacity(0.05),
                            border: Border.all(color: const Color(0xFF1976D2)),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                selectedTime.format(context),
                                style: const TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF1976D2),
                                ),
                              ),
                              const SizedBox(width: 12),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                                decoration: BoxDecoration(
                                  color: const Color(0xFF1976D2).withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Text(
                                  selectedTime.period == DayPeriod.am ? 'AM' : 'PM',
                                  style: const TextStyle(
                                    color: Color(0xFF1976D2),
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 24),
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: const Color(0xFF1976D2).withOpacity(0.1),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: const Icon(
                              Icons.calendar_today,
                              color: Color(0xFF1976D2),
                              size: 20,
                            ),
                          ),
                          const SizedBox(width: 12),
                          const Text(
                            'Repeat',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF1976D2),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          _buildDialogDayButton('M', 0, setState),
                          _buildDialogDayButton('T', 1, setState),
                          _buildDialogDayButton('W', 2, setState),
                          _buildDialogDayButton('T', 3, setState),
                          _buildDialogDayButton('F', 4, setState),
                          _buildDialogDayButton('S', 5, setState),
                          _buildDialogDayButton('S', 6, setState),
                        ],
                      ),
                      const SizedBox(height: 24),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          TextButton(
                            onPressed: () => Navigator.pop(context),
                            style: TextButton.styleFrom(
                              foregroundColor: Colors.grey,
                            ),
                            child: const Text('Cancel'),
                          ),
                          const SizedBox(width: 16),
                          ElevatedButton(
                            onPressed: () {
                              if (medicineName.isNotEmpty && dosage.isNotEmpty) {
                                setState(() {
                                  _medications.add(MedicationTime(
                                    name: medicineName,
                                    time: selectedTime,
                                    dosage: dosage,
                                    weeklySchedule: List.from(selectedDays),
                                  ));
                                  _medications.sort((a, b) => 
                                    (a.time.hour * 60 + a.time.minute)
                                    .compareTo(b.time.hour * 60 + b.time.minute));
                                });
                                Navigator.pop(context);
                                this.setState(() {});
                              }
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF1976D2),
                              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            child: const Text(
                              'Add Medication',
                              style: TextStyle(fontSize: 16),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFF1E88E5),
            Color(0xFF1976D2),
            Color(0xFF1565C0),
          ],
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          title: const Text(
            'Medication Times',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          centerTitle: true,
        ),
        body: _medications.isEmpty
            ? Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.medication_outlined,
                      size: 64,
                      color: Colors.white.withOpacity(0.5),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'No medications added yet',
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.7),
                        fontSize: 18,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Tap + to add your first medication',
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.5),
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              )
            : ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: _medications.length,
                itemBuilder: (context, index) {
                  final med = _medications[index];
                  return Dismissible(
                    key: Key(med.name + med.time.toString()),
                    background: Container(
                      margin: const EdgeInsets.symmetric(vertical: 8),
                      decoration: BoxDecoration(
                        color: Colors.red.withOpacity(0.8),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      alignment: Alignment.centerRight,
                      padding: const EdgeInsets.only(right: 20),
                      child: const Icon(Icons.delete, color: Colors.white),
                    ),
                    direction: DismissDirection.endToStart,
                    onDismissed: (direction) {
                      setState(() {
                        _medications.removeAt(index);
                      });
                    },
                    child: Container(
                      margin: const EdgeInsets.symmetric(vertical: 8),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: Colors.white.withOpacity(0.2),
                          width: 1,
                        ),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(16),
                        child: BackdropFilter(
                          filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
                          child: ListTile(
                            contentPadding: const EdgeInsets.all(16),
                            leading: Container(
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.2),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: const Icon(
                                Icons.medication,
                                color: Colors.white,
                              ),
                            ),
                            title: Text(
                              med.name,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const SizedBox(height: 8),
                                Row(
                                  children: [
                                    Icon(
                                      Icons.medical_information,
                                      size: 16,
                                      color: Colors.white.withOpacity(0.7),
                                    ),
                                    const SizedBox(width: 8),
                                    Text(
                                      'Dosage: ${med.dosage}',
                                      style: TextStyle(
                                        color: Colors.white.withOpacity(0.7),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 4),
                                Row(
                                  children: [
                                    Icon(
                                      Icons.access_time,
                                      size: 16,
                                      color: Colors.white.withOpacity(0.7),
                                    ),
                                    const SizedBox(width: 8),
                                    Text(
                                      'Time: ${med.time.format(context)}',
                                      style: TextStyle(
                                        color: Colors.white.withOpacity(0.7),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 8),
                                Row(
                                  children: [
                                    Icon(
                                      Icons.calendar_today,
                                      size: 16,
                                      color: Colors.white.withOpacity(0.7),
                                    ),
                                    const SizedBox(width: 8),
                                    ...List.generate(7, (index) {
                                      final days = ['M', 'T', 'W', 'T', 'F', 'S', 'S'];
                                      return Container(
                                        margin: const EdgeInsets.only(right: 4),
                                        padding: const EdgeInsets.all(4),
                                        decoration: BoxDecoration(
                                          color: med.weeklySchedule[index]
                                              ? Colors.white.withOpacity(0.2)
                                              : Colors.transparent,
                                          borderRadius: BorderRadius.circular(4),
                                        ),
                                        child: Text(
                                          days[index],
                                          style: TextStyle(
                                            color: med.weeklySchedule[index]
                                                ? Colors.white
                                                : Colors.white.withOpacity(0.4),
                                            fontSize: 12,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      );
                                    }),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
        floatingActionButton: Container(
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Colors.white, Colors.white70],
            ),
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.2),
                blurRadius: 8,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: FloatingActionButton(
            onPressed: _addMedication,
            backgroundColor: Colors.transparent,
            elevation: 0,
            child: const Icon(
              Icons.add,
              color: Color(0xFF1976D2),
            ),
          ),
        ),
      ),
    );
  }
}

class MedicationTime {
  final String name;
  final TimeOfDay time;
  final String dosage;
  final List<bool> weeklySchedule;

  const MedicationTime({
    required this.name,
    required this.time,
    required this.dosage,
    required this.weeklySchedule,
  });
} 