import 'package:flutter/material.dart';
import 'dart:ui';
import '../theme/app_colors.dart';
import '../utils/page_transition.dart';
import '../l10n/app_localizations.dart';

class MedicalCondition {
  final String name;
  bool isSelected;

  MedicalCondition({
    required this.name,
    this.isSelected = false,
  });
}

class Allergy {
  final String type;
  bool isSelected;
  String? details;

  Allergy({
    required this.type,
    this.isSelected = false,
    this.details,
  });
}

class MedicalRecord {
  final String title;
  final String date;
  final String description;
  final String? doctorName;
  final String? facility;
  final List<String>? attachments;
  final List<MedicalCondition>? conditions;
  final List<Allergy>? allergies;

  const MedicalRecord({
    required this.title,
    required this.date,
    required this.description,
    this.doctorName,
    this.facility,
    this.attachments,
    this.conditions,
    this.allergies,
  });
}

class Medication {
  final String name;
  final String dosage;
  final String frequency;
  final String startDate;
  final String? endDate;
  final String? prescribedBy;
  final String? notes;

  const Medication({
    required this.name,
    required this.dosage,
    required this.frequency,
    required this.startDate,
    this.endDate,
    this.prescribedBy,
    this.notes,
  });
}

class MedicalHistoryScreen extends StatefulWidget {
  const MedicalHistoryScreen({super.key});

  @override
  State<MedicalHistoryScreen> createState() => _MedicalHistoryScreenState();
}

class _MedicalHistoryScreenState extends State<MedicalHistoryScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;
  int _selectedTab = 0;
  final _formKey = GlobalKey<FormState>();
  final Map<String, TextEditingController> _controllers = {
    'title': TextEditingController(),
    'date': TextEditingController(),
    'description': TextEditingController(),
    'doctorName': TextEditingController(),
    'facility': TextEditingController(),
    'name': TextEditingController(),
    'dosage': TextEditingController(),
    'frequency': TextEditingController(),
    'startDate': TextEditingController(),
    'endDate': TextEditingController(),
    'prescribedBy': TextEditingController(),
    'notes': TextEditingController(),
    'foodAllergy': TextEditingController(),
    'drugAllergy': TextEditingController(),
  };

  // List of medical conditions
  final List<MedicalCondition> _medicalConditions = [
    MedicalCondition(name: 'Asthma'),
    MedicalCondition(name: 'Diabetes type 1'),
    MedicalCondition(name: 'Diabetes type 2'),
    MedicalCondition(name: 'Arthritis'),
    MedicalCondition(name: 'Degenerative disc disease'),
    MedicalCondition(name: 'High blood pressure'),
    MedicalCondition(name: 'Low blood pressure'),
    MedicalCondition(name: 'Heart attack'),
    MedicalCondition(name: 'Parkinson\'s disease'),
    MedicalCondition(name: 'Hepatitis A'),
    MedicalCondition(name: 'Hepatitis B'),
    MedicalCondition(name: 'Hepatitis C'),
    MedicalCondition(name: 'Hernia'),
    MedicalCondition(name: 'Kidney failure'),
    MedicalCondition(name: 'Thyroid disease'),
    MedicalCondition(name: 'Autoimmune disease'),
    MedicalCondition(name: 'Other'),
  ];

  // List of allergies
  final List<Allergy> _allergies = [
    Allergy(type: 'Latex'),
    Allergy(type: 'Topical'),
    Allergy(type: 'Food'),
    Allergy(type: 'Drug'),
  ];

  // Initialize empty lists for records and medications
  List<MedicalRecord> _records = [];
  List<Medication> _medications = [];

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    )..forward();

    _fadeAnimation = CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.0, 0.6, curve: Curves.easeOut),
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.2, 0.7, curve: Curves.easeOutCubic),
    ));
  }

  @override
  void dispose() {
    _controller.dispose();
    _controllers.forEach((_, controller) => controller.dispose());
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final appLocalizations = AppLocalizations.of(context);
    return Scaffold(
      body: Stack(
        children: [
          // Background gradient
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  AppColors.primaryColor,
                  AppColors.secondaryColor.withOpacity(0.9),
                ],
                stops: const [0.3, 1.0],
              ),
            ),
          ),
          // Decorative elements
          Positioned(
            top: -100,
            right: -100,
            child: Container(
              width: 300,
              height: 300,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    AppColors.accentColor.withOpacity(0.2),
                    AppColors.accentColor.withOpacity(0.0),
                  ],
                ),
              ),
            ),
          ),
          Positioned(
            bottom: -80,
            left: -80,
            child: Container(
              width: 200,
              height: 200,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    AppColors.tertiaryColor.withOpacity(0.2),
                    AppColors.tertiaryColor.withOpacity(0.0),
                  ],
                ),
              ),
            ),
          ),
          // Main content
          SafeArea(
            child: Column(
              children: [
                // App Bar
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          color: AppColors.accentColor.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: AppColors.tertiaryColor.withOpacity(0.3),
                            width: 1,
                          ),
                        ),
                        child: IconButton(
                          icon: Icon(Icons.arrow_back,
                              color: Colors.white.withOpacity(0.9)),
                          onPressed: () => Navigator.pop(context),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Text(
                        appLocalizations.translate('medicalHistory'),
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
                // Tab Bar
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: AppColors.tertiaryColor.withOpacity(0.3),
                        width: 1.5,
                      ),
                    ),
                    child: Row(
                      children: [
                        _buildTabButton(
                          appLocalizations.translate('medicalRecords'),
                          Icons.folder_outlined,
                          0,
                        ),
                        _buildTabButton(
                          appLocalizations.translate('medications'),
                          Icons.medication_outlined,
                          1,
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                // Content
                Expanded(
                  child: _selectedTab == 0
                      ? _buildMedicalRecords()
                      : _buildMedications(),
                ),
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddDialog(),
        backgroundColor: AppColors.accentColor,
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  Widget _buildTabButton(String title, IconData icon, int index) {
    final isSelected = _selectedTab == index;
    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() => _selectedTab = index),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 16),
          decoration: BoxDecoration(
            color: isSelected
                ? AppColors.accentColor.withOpacity(0.2)
                : Colors.transparent,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: isSelected
                  ? AppColors.accentColor.withOpacity(0.3)
                  : Colors.transparent,
              width: 1.5,
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                color: Colors.white.withOpacity(isSelected ? 1 : 0.7),
                size: 20,
              ),
              const SizedBox(width: 8),
              Text(
                title,
                style: TextStyle(
                  color: Colors.white.withOpacity(isSelected ? 1 : 0.7),
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMedicalRecords() {
    final appLocalizations = AppLocalizations.of(context);
    if (_records.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.folder_outlined,
              size: 64,
              color: Colors.white.withOpacity(0.5),
            ),
            const SizedBox(height: 16),
            Text(
              appLocalizations.translate('noRecords'),
              style: TextStyle(
                fontSize: 18,
                color: Colors.white.withOpacity(0.7),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              appLocalizations.translate('addRecord'),
              style: TextStyle(
                fontSize: 14,
                color: Colors.white.withOpacity(0.5),
              ),
            ),
          ],
        ),
      );
    }
    return ListView.builder(
      padding: const EdgeInsets.fromLTRB(24, 0, 24, 100),
      itemCount: _records.length,
      itemBuilder: (context, index) {
        final record = _records[index];
        return Dismissible(
          key: Key(record.title + record.date),
          background: Container(
            decoration: BoxDecoration(
              color: Colors.red.withOpacity(0.7),
              borderRadius: BorderRadius.circular(20),
            ),
            alignment: Alignment.centerRight,
            padding: const EdgeInsets.only(right: 20),
            child: const Icon(
              Icons.delete_outline,
              color: Colors.white,
            ),
          ),
          direction: DismissDirection.endToStart,
          onDismissed: (direction) {
            setState(() {
              _records.removeAt(index);
            });
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: const Text('Record deleted'),
                backgroundColor: Colors.red.withOpacity(0.7),
                behavior: SnackBarBehavior.floating,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                margin: const EdgeInsets.all(16),
              ),
            );
          },
          confirmDismiss: (direction) async {
            final appLocalizations = AppLocalizations.of(context);
            return await showDialog(
              context: context,
              builder: (context) => AlertDialog(
                backgroundColor: AppColors.primaryColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                title: Text(
                  appLocalizations.translate('deleteRecord'),
                  style: const TextStyle(color: Colors.white),
                ),
                content: Text(
                  appLocalizations.translate('confirmDeleteRecord'),
                  style: const TextStyle(color: Colors.white70),
                ),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(false),
                    child: Text(
                      appLocalizations.translate('cancel'),
                      style: const TextStyle(color: Colors.white70),
                    ),
                  ),
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(true),
                    child: Text(
                      appLocalizations.translate('delete'),
                      style: const TextStyle(color: Colors.red),
                    ),
                  ),
                ],
              ),
            );
          },
          child: _buildRecordCard(record, index),
        );
      },
    );
  }

  Widget _buildRecordCard(MedicalRecord record, int index) {
    final appLocalizations = AppLocalizations.of(context);
    return SlideTransition(
      position: Tween<Offset>(
        begin: const Offset(0, 0.3),
        end: Offset.zero,
      ).animate(CurvedAnimation(
        parent: _controller,
        curve: Interval(
          0.2 + (index * 0.1),
          0.7 + (index * 0.1),
          curve: Curves.easeOutCubic,
        ),
      )),
      child: FadeTransition(
        opacity: CurvedAnimation(
          parent: _controller,
          curve: Interval(
            0.2 + (index * 0.1),
            0.7 + (index * 0.1),
            curve: Curves.easeOut,
          ),
        ),
        child: Container(
          margin: const EdgeInsets.only(bottom: 16),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.1),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: AppColors.tertiaryColor.withOpacity(0.3),
              width: 1.5,
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: AppColors.primaryColor.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(
                        Icons.folder_outlined,
                        color: Colors.white.withOpacity(0.9),
                        size: 20,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            record.title,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            record.date,
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.white.withOpacity(0.7),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Text(
                  record.description,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.white.withOpacity(0.9),
                  ),
                ),
                
                // Medical Conditions Section
                if (record.conditions != null && record.conditions!.isNotEmpty) ...[
                  const SizedBox(height: 16),
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: AppColors.primaryColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: AppColors.tertiaryColor.withOpacity(0.2),
                        width: 1,
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(
                              Icons.medical_services_outlined,
                              size: 16,
                              color: Colors.white.withOpacity(0.9),
                            ),
                            const SizedBox(width: 8),
                            Text(
                              appLocalizations.translate('medicalConditions'),
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: Colors.white.withOpacity(0.9),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Wrap(
                          spacing: 8,
                          children: record.conditions!.map((condition) {
                            return Chip(
                              backgroundColor: AppColors.primaryColor,
                              side: BorderSide(
                                color: AppColors.primaryColor,
                                width: 1,
                              ),
                              label: Text(
                                condition.name,
                                style: const TextStyle(
                                  fontSize: 12,
                                  color: Colors.white,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16),
                              ),
                              materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                            );
                          }).toList(),
                        ),
                      ],
                    ),
                  ),
                ],
                
                // Allergies Section
                if (record.allergies != null && record.allergies!.isNotEmpty) ...[
                  const SizedBox(height: 12),
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: AppColors.primaryColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: AppColors.tertiaryColor.withOpacity(0.2),
                        width: 1,
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(
                              Icons.warning_amber_outlined,
                              size: 16,
                              color: Colors.orange.withOpacity(0.9),
                            ),
                            const SizedBox(width: 8),
                            Text(
                              appLocalizations.translate('allergies'),
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: Colors.white.withOpacity(0.9),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: record.allergies!.map((allergy) {
                            return Padding(
                              padding: const EdgeInsets.only(bottom: 4),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    width: 6,
                                    height: 6,
                                    margin: const EdgeInsets.only(top: 6, right: 8),
                                    decoration: BoxDecoration(
                                      color: Colors.orange,
                                      shape: BoxShape.circle,
                                    ),
                                  ),
                                  Expanded(
                                    child: RichText(
                                      text: TextSpan(
                                        text: '${allergy.type}: ',
                                        style: TextStyle(
                                          fontSize: 12,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white.withOpacity(0.9),
                                        ),
                                        children: [
                                          TextSpan(
                                            text: allergy.details ?? 'Yes',
                                            style: TextStyle(
                                              fontWeight: FontWeight.normal,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            );
                          }).toList(),
                        ),
                      ],
                    ),
                  ),
                ],
                
                // Doctor and Facility Section
                if (record.doctorName != null || record.facility != null) ...[
                  const SizedBox(height: 12),
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: AppColors.primaryColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: AppColors.tertiaryColor.withOpacity(0.2),
                        width: 1,
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (record.doctorName != null)
                          Row(
                            children: [
                              Icon(
                                Icons.person_outline,
                                size: 16,
                                color: Colors.white.withOpacity(0.7),
                              ),
                              const SizedBox(width: 8),
                              Text(
                                record.doctorName!,
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.white.withOpacity(0.7),
                                ),
                              ),
                            ],
                          ),
                        if (record.doctorName != null && record.facility != null)
                          const SizedBox(height: 8),
                        if (record.facility != null)
                          Row(
                            children: [
                              Icon(
                                Icons.local_hospital_outlined,
                                size: 16,
                                color: Colors.white.withOpacity(0.7),
                              ),
                              const SizedBox(width: 8),
                              Text(
                                record.facility!,
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.white.withOpacity(0.7),
                                ),
                              ),
                            ],
                          ),
                      ],
                    ),
                  ),
                ],
                
                // Attachments Section
                if (record.attachments != null && record.attachments!.isNotEmpty) ...[
                  const SizedBox(height: 16),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: record.attachments!.map((attachment) {
                      return Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.accentColor.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: AppColors.accentColor.withOpacity(0.3),
                            width: 1,
                          ),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.attach_file,
                              size: 16,
                              color: Colors.white.withOpacity(0.9),
                            ),
                            const SizedBox(width: 4),
                            Text(
                              attachment,
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.white.withOpacity(0.9),
                              ),
                            ),
                          ],
                        ),
                      );
                    }).toList(),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildMedications() {
    final appLocalizations = AppLocalizations.of(context);
    if (_medications.isEmpty) {
      return Center(
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
              appLocalizations.translate('noMedicationsYet'),
              style: TextStyle(
                fontSize: 18,
                color: Colors.white.withOpacity(0.7),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              appLocalizations.translate('addMedicationPrompt'),
              style: TextStyle(
                fontSize: 14,
                color: Colors.white.withOpacity(0.5),
              ),
            ),
          ],
        ),
      );
    }
    return ListView.builder(
      padding: const EdgeInsets.fromLTRB(24, 0, 24, 100),
      itemCount: _medications.length,
      itemBuilder: (context, index) {
        final medication = _medications[index];
        return Dismissible(
          key: Key(medication.name + medication.startDate),
          background: Container(
            decoration: BoxDecoration(
              color: Colors.red.withOpacity(0.7),
              borderRadius: BorderRadius.circular(20),
            ),
            alignment: Alignment.centerRight,
            padding: const EdgeInsets.only(right: 20),
            child: const Icon(
              Icons.delete_outline,
              color: Colors.white,
            ),
          ),
          direction: DismissDirection.endToStart,
          onDismissed: (direction) {
            setState(() {
              _medications.removeAt(index);
            });
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: const Text('Medication deleted'),
                backgroundColor: Colors.red.withOpacity(0.7),
                behavior: SnackBarBehavior.floating,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                margin: const EdgeInsets.all(16),
              ),
            );
          },
          confirmDismiss: (direction) async {
            final appLocalizations = AppLocalizations.of(context);
            return await showDialog(
              context: context,
              builder: (context) => AlertDialog(
                backgroundColor: AppColors.primaryColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                title: Text(
                  appLocalizations.translate('deleteMedication'),
                  style: const TextStyle(color: Colors.white),
                ),
                content: Text(
                  appLocalizations.translate('confirmDeleteMedication'),
                  style: const TextStyle(color: Colors.white70),
                ),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(false),
                    child: Text(
                      appLocalizations.translate('cancel'),
                      style: const TextStyle(color: Colors.white70),
                    ),
                  ),
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(true),
                    child: Text(
                      appLocalizations.translate('delete'),
                      style: const TextStyle(color: Colors.red),
                    ),
                  ),
                ],
              ),
            );
          },
          child: _buildMedicationCard(medication, index),
        );
      },
    );
  }

  Widget _buildMedicationCard(Medication medication, int index) {
    final appLocalizations = AppLocalizations.of(context);
    return SlideTransition(
      position: Tween<Offset>(
        begin: const Offset(0, 0.3),
        end: Offset.zero,
      ).animate(CurvedAnimation(
        parent: _controller,
        curve: Interval(
          0.2 + (index * 0.1),
          0.7 + (index * 0.1),
          curve: Curves.easeOutCubic,
        ),
      )),
      child: FadeTransition(
        opacity: CurvedAnimation(
          parent: _controller,
          curve: Interval(
            0.2 + (index * 0.1),
            0.7 + (index * 0.1),
            curve: Curves.easeOut,
          ),
        ),
        child: Container(
          margin: const EdgeInsets.only(bottom: 16),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.1),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: AppColors.tertiaryColor.withOpacity(0.3),
              width: 1.5,
            ),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: AppColors.primaryColor.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Icon(
                            Icons.medication_outlined,
                            color: Colors.white,
                            size: 20,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                medication.name,
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                '${medication.dosage} - ${medication.frequency}',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.white.withOpacity(0.7),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: AppColors.primaryColor.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: AppColors.tertiaryColor.withOpacity(0.2),
                          width: 1,
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Icon(
                                Icons.calendar_today_outlined,
                                size: 16,
                                color: Colors.white.withOpacity(0.7),
                              ),
                              const SizedBox(width: 8),
                              Text(
                                appLocalizations.translate('startedOn') + medication.startDate,
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.white.withOpacity(0.7),
                                ),
                              ),
                            ],
                          ),
                          if (medication.endDate != null) ...[
                            const SizedBox(height: 8),
                            Row(
                              children: [
                                Icon(
                                  Icons.event_outlined,
                                  size: 16,
                                  color: Colors.white.withOpacity(0.7),
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  appLocalizations.translate('untilDate') + medication.endDate!,
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.white.withOpacity(0.7),
                                  ),
                                ),
                              ],
                            ),
                          ],
                          if (medication.prescribedBy != null) ...[
                            const SizedBox(height: 8),
                            Row(
                              children: [
                                Icon(
                                  Icons.person_outline,
                                  size: 16,
                                  color: Colors.white.withOpacity(0.7),
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  appLocalizations.translate('prescribedByLabel') + medication.prescribedBy!,
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.white.withOpacity(0.7),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ],
                      ),
                    ),
                    if (medication.notes != null) ...[
                      const SizedBox(height: 12),
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: AppColors.accentColor.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: AppColors.accentColor.withOpacity(0.2),
                            width: 1,
                          ),
                        ),
                        child: Row(
                          children: [
                            Icon(
                              Icons.notes_outlined,
                              size: 16,
                              color: Colors.white.withOpacity(0.7),
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                medication.notes!,
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.white.withOpacity(0.7),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _showAddDialog() {
    final appLocalizations = AppLocalizations.of(context);
    
    // Reset form fields
    _controllers.forEach((_, controller) => controller.clear());
    
    // Reset medical conditions and allergies
    for (var condition in _medicalConditions) {
      condition.isSelected = false;
    }
    
    for (var allergy in _allergies) {
      allergy.isSelected = false;
    }
    
    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) {
          return Dialog(
            backgroundColor: Colors.transparent,
            child: Container(
              constraints: BoxConstraints(
                maxHeight: MediaQuery.of(context).size.height * 0.8,
                maxWidth: 400,
              ),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    AppColors.primaryColor,
                    AppColors.secondaryColor.withOpacity(0.9),
                  ],
                ),
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.3),
                    blurRadius: 15,
                    offset: const Offset(0, 10),
                  ),
                ],
                border: Border.all(
                  color: AppColors.tertiaryColor.withOpacity(0.3),
                  width: 1.5,
                ),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
                  child: Container(
                    padding: const EdgeInsets.all(24),
                    child: Form(
                      key: _formKey,
                      child: SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              _selectedTab == 0 
                                ? appLocalizations.translate('addRecord')
                                : appLocalizations.translate('addMedication'),
                              style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                            const SizedBox(height: 24),
                            if (_selectedTab == 0) ...[
                              _buildFormField(
                                controller: _controllers['title']!,
                                label: appLocalizations.translate('title'),
                                validator: (value) =>
                                    value?.isEmpty ?? true ? appLocalizations.translate('enterTitle') : null,
                              ),
                              const SizedBox(height: 16),
                              _buildDateField(
                                controller: _controllers['date']!,
                                label: appLocalizations.translate('date'),
                              ),
                              const SizedBox(height: 16),
                              _buildFormField(
                                controller: _controllers['description']!,
                                label: appLocalizations.translate('description'),
                                maxLines: 3,
                                validator: (value) =>
                                    value?.isEmpty ?? true ? appLocalizations.translate('enterDescription') : null,
                              ),
                              const SizedBox(height: 16),
                              _buildMedicalConditionsSectionForDialog(setDialogState),
                              const SizedBox(height: 16),
                              _buildAllergiesSectionForDialog(setDialogState),
                              const SizedBox(height: 16),
                              _buildFormField(
                                controller: _controllers['doctorName']!,
                                label: appLocalizations.translate('doctorName'),
                              ),
                              const SizedBox(height: 16),
                              _buildFormField(
                                controller: _controllers['facility']!,
                                label: appLocalizations.translate('facility'),
                              ),
                            ] else ...[
                              _buildFormField(
                                controller: _controllers['name']!,
                                label: appLocalizations.translate('medicationName'),
                                validator: (value) =>
                                    value?.isEmpty ?? true ? appLocalizations.translate('enterMedicationName') : null,
                              ),
                              const SizedBox(height: 16),
                              _buildFormField(
                                controller: _controllers['dosage']!,
                                label: appLocalizations.translate('dosage'),
                                validator: (value) =>
                                    value?.isEmpty ?? true ? appLocalizations.translate('enterDosage') : null,
                              ),
                              const SizedBox(height: 16),
                              _buildFormField(
                                controller: _controllers['frequency']!,
                                label: appLocalizations.translate('frequency'),
                                validator: (value) =>
                                    value?.isEmpty ?? true ? appLocalizations.translate('enterFrequency') : null,
                              ),
                              const SizedBox(height: 16),
                              _buildDateField(
                                controller: _controllers['startDate']!,
                                label: appLocalizations.translate('startDate'),
                              ),
                              const SizedBox(height: 16),
                              _buildDateField(
                                controller: _controllers['endDate']!,
                                label: appLocalizations.translate('endDate'),
                                optional: true,
                              ),
                              const SizedBox(height: 16),
                              _buildFormField(
                                controller: _controllers['prescribedBy']!,
                                label: appLocalizations.translate('prescribedBy'),
                              ),
                              const SizedBox(height: 16),
                              _buildFormField(
                                controller: _controllers['notes']!,
                                label: appLocalizations.translate('notes'),
                                maxLines: 3,
                              ),
                            ],
                            const SizedBox(height: 24),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                TextButton(
                                  onPressed: () => Navigator.pop(context),
                                  child: Text(
                                    appLocalizations.translate('cancel'),
                                    style: TextStyle(
                                      color: Colors.white.withOpacity(0.7),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 16),
                                ElevatedButton(
                                  onPressed: _handleAdd,
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: AppColors.accentColor,
                                    foregroundColor: Colors.white,
                                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                  ),
                                  child: Text(
                                    appLocalizations.translate('save'),
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          );
        }
      ),
    );
  }

  Widget _buildFormField({
    required TextEditingController controller,
    required String label,
    int maxLines = 1,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      maxLines: maxLines,
      validator: validator,
      style: const TextStyle(color: Colors.white),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(color: Colors.white.withOpacity(0.7)),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(
            color: AppColors.tertiaryColor.withOpacity(0.3),
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(
            color: AppColors.tertiaryColor.withOpacity(0.3),
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(
            color: AppColors.accentColor.withOpacity(0.5),
            width: 2,
          ),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.red),
        ),
        filled: true,
        fillColor: Colors.white.withOpacity(0.1),
      ),
    );
  }

  Widget _buildDateField({
    required TextEditingController controller,
    required String label,
    bool optional = false,
  }) {
    final appLocalizations = AppLocalizations.of(context);
    return TextFormField(
      controller: controller,
      readOnly: true,
      onTap: () async {
        final date = await showDatePicker(
          context: context,
          initialDate: DateTime.now(),
          firstDate: DateTime(2000),
          lastDate: DateTime(2100),
          builder: (context, child) {
            return Theme(
              data: Theme.of(context).copyWith(
                colorScheme: ColorScheme.dark(
                  primary: AppColors.accentColor,
                  onPrimary: Colors.white,
                  surface: AppColors.primaryColor,
                  onSurface: Colors.white,
                ),
                dialogBackgroundColor: AppColors.primaryColor,
              ),
              child: child!,
            );
          },
        );
        if (date != null) {
          controller.text =
              "${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}";
        }
      },
      validator: optional
          ? null
          : (value) => value?.isEmpty ?? true ? appLocalizations.translate('selectDate') : null,
      style: const TextStyle(color: Colors.white),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(color: Colors.white.withOpacity(0.7)),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(
            color: AppColors.tertiaryColor.withOpacity(0.3),
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(
            color: AppColors.tertiaryColor.withOpacity(0.3),
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(
            color: AppColors.accentColor.withOpacity(0.5),
            width: 2,
          ),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.red),
        ),
        filled: true,
        fillColor: Colors.white.withOpacity(0.1),
        suffixIcon: Icon(
          Icons.calendar_today_outlined,
          color: Colors.white.withOpacity(0.7),
        ),
      ),
    );
  }

  void _handleAdd() {
    final appLocalizations = AppLocalizations.of(context);
    if (_formKey.currentState?.validate() ?? false) {
      setState(() {
        if (_selectedTab == 0) {
          // Prepare selected medical conditions
          List<MedicalCondition> selectedConditions = _medicalConditions
              .where((condition) => condition.isSelected)
              .map((condition) => MedicalCondition(
                    name: condition.name,
                    isSelected: true,
                  ))
              .toList();

          // Prepare selected allergies
          List<Allergy> selectedAllergies = _allergies
              .where((allergy) => allergy.isSelected)
              .map((allergy) {
                String? details;
                if (allergy.type == 'Food' && _controllers['foodAllergy']!.text.isNotEmpty) {
                  details = _controllers['foodAllergy']!.text;
                } else if (allergy.type == 'Drug' && _controllers['drugAllergy']!.text.isNotEmpty) {
                  details = _controllers['drugAllergy']!.text;
                }
                return Allergy(
                  type: allergy.type,
                  isSelected: true,
                  details: details,
                );
              })
              .toList();

          _records.add(MedicalRecord(
            title: _controllers['title']!.text,
            date: _controllers['date']!.text,
            description: _controllers['description']!.text,
            doctorName: _controllers['doctorName']!.text.isNotEmpty
                ? _controllers['doctorName']!.text
                : null,
            facility: _controllers['facility']!.text.isNotEmpty
                ? _controllers['facility']!.text
                : null,
            conditions: selectedConditions.isNotEmpty ? selectedConditions : null,
            allergies: selectedAllergies.isNotEmpty ? selectedAllergies : null,
          ));
        } else {
          _medications.add(Medication(
            name: _controllers['name']!.text,
            dosage: _controllers['dosage']!.text,
            frequency: _controllers['frequency']!.text,
            startDate: _controllers['startDate']!.text,
            endDate: _controllers['endDate']!.text.isNotEmpty
                ? _controllers['endDate']!.text
                : null,
            prescribedBy: _controllers['prescribedBy']!.text.isNotEmpty
                ? _controllers['prescribedBy']!.text
                : null,
            notes: _controllers['notes']!.text.isNotEmpty
                ? _controllers['notes']!.text
                : null,
          ));
        }
      });
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            _selectedTab == 0
                ? appLocalizations.translate('recordAdded')
                : appLocalizations.translate('medicationAdded'),
          ),
          backgroundColor: Colors.green.withOpacity(0.7),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          margin: const EdgeInsets.all(16),
        ),
      );
    }
  }

  // Methods to build medical conditions and allergies UI
  Widget _buildMedicalConditionsSectionForDialog(Function setState) {
    final appLocalizations = AppLocalizations.of(context);
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.primaryColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: AppColors.tertiaryColor.withOpacity(0.3),
          width: 1.5,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            appLocalizations.translate('medicalConditions'),
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.white.withOpacity(0.9),
            ),
          ),
          const SizedBox(height: 16),
          Column(
            mainAxisSize: MainAxisSize.min,
            children: _medicalConditions.map((condition) {
              return _buildConditionCheckboxForDialog(condition, setState);
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildConditionCheckboxForDialog(MedicalCondition condition, Function setState) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () {
          setState(() {
            condition.isSelected = !condition.isSelected;
          });
        },
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: Row(
            children: [
              Container(
                height: 24,
                width: 24,
                decoration: BoxDecoration(
                  color: condition.isSelected ? AppColors.accentColor : Colors.transparent,
                  border: Border.all(
                    color: condition.isSelected ? AppColors.accentColor : Colors.white.withOpacity(0.7),
                    width: 2,
                  ),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: condition.isSelected 
                  ? const Icon(
                      Icons.check,
                      size: 18,
                      color: Colors.white,
                    )
                  : null,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  condition.name,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.white.withOpacity(0.9),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAllergiesSectionForDialog(Function setState) {
    final appLocalizations = AppLocalizations.of(context);
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.primaryColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: AppColors.tertiaryColor.withOpacity(0.3),
          width: 1.5,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            appLocalizations.translate('allergies'),
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.white.withOpacity(0.9),
            ),
          ),
          const SizedBox(height: 16),
          Column(
            mainAxisSize: MainAxisSize.min,
            children: _allergies.map((allergy) {
              return _buildAllergyItemForDialog(allergy, setState);
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildAllergyItemForDialog(Allergy allergy, Function setState) {
    return Column(
      children: [
        Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: () {
              setState(() {
                allergy.isSelected = !allergy.isSelected;
              });
            },
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: Row(
                children: [
                  Container(
                    height: 24,
                    width: 24,
                    decoration: BoxDecoration(
                      color: allergy.isSelected ? AppColors.accentColor : Colors.transparent,
                      border: Border.all(
                        color: allergy.isSelected ? AppColors.accentColor : Colors.white.withOpacity(0.7),
                        width: 2,
                      ),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: allergy.isSelected 
                      ? const Icon(
                          Icons.check,
                          size: 18,
                          color: Colors.white,
                        )
                      : null,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      allergy.type,
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.white.withOpacity(0.9),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        if (allergy.isSelected && (allergy.type == 'Food' || allergy.type == 'Drug'))
          Padding(
            padding: const EdgeInsets.only(top: 8, bottom: 8, left: 32, right: 0),
            child: TextFormField(
              controller: allergy.type == 'Food' 
                ? _controllers['foodAllergy'] 
                : _controllers['drugAllergy'],
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                labelText: 'Specify ${allergy.type.toLowerCase()} allergies',
                labelStyle: TextStyle(color: Colors.white.withOpacity(0.7)),
                prefixIcon: Icon(
                  allergy.type == 'Food' ? Icons.restaurant : Icons.medication_outlined,
                  color: Colors.white.withOpacity(0.7),
                  size: 20,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(
                    color: AppColors.tertiaryColor.withOpacity(0.3),
                  ),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(
                    color: AppColors.tertiaryColor.withOpacity(0.3),
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(
                    color: AppColors.accentColor.withOpacity(0.5),
                    width: 2,
                  ),
                ),
                filled: true,
                fillColor: Colors.white.withOpacity(0.1),
                contentPadding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
              ),
            ),
          ),
      ],
    );
  }

  // Original methods for the main screen record cards
  Widget _buildMedicalConditionsSection() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.primaryColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: AppColors.tertiaryColor.withOpacity(0.3),
          width: 1.5,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Medical Conditions',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.white.withOpacity(0.9),
            ),
          ),
          const SizedBox(height: 16),
          Column(
            mainAxisSize: MainAxisSize.min,
            children: _medicalConditions.map((condition) {
              return _buildConditionCheckbox(condition);
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildConditionCheckbox(MedicalCondition condition) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () {
          setState(() {
            condition.isSelected = !condition.isSelected;
          });
        },
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: Row(
            children: [
              Container(
                height: 24,
                width: 24,
                decoration: BoxDecoration(
                  color: condition.isSelected ? AppColors.accentColor : Colors.transparent,
                  border: Border.all(
                    color: condition.isSelected ? AppColors.accentColor : Colors.white.withOpacity(0.7),
                    width: 2,
                  ),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: condition.isSelected 
                  ? const Icon(
                      Icons.check,
                      size: 18,
                      color: Colors.white,
                    )
                  : null,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  condition.name,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.white.withOpacity(0.9),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAllergiesSection() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.primaryColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: AppColors.tertiaryColor.withOpacity(0.3),
          width: 1.5,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Allergies',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.white.withOpacity(0.9),
            ),
          ),
          const SizedBox(height: 16),
          Column(
            mainAxisSize: MainAxisSize.min,
            children: _allergies.map((allergy) {
              return _buildAllergyItem(allergy);
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildAllergyItem(Allergy allergy) {
    return Column(
      children: [
        Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: () {
              setState(() {
                allergy.isSelected = !allergy.isSelected;
              });
            },
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: Row(
                children: [
                  Container(
                    height: 24,
                    width: 24,
                    decoration: BoxDecoration(
                      color: allergy.isSelected ? AppColors.accentColor : Colors.transparent,
                      border: Border.all(
                        color: allergy.isSelected ? AppColors.accentColor : Colors.white.withOpacity(0.7),
                        width: 2,
                      ),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: allergy.isSelected 
                      ? const Icon(
                          Icons.check,
                          size: 18,
                          color: Colors.white,
                        )
                      : null,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      allergy.type,
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.white.withOpacity(0.9),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        if (allergy.isSelected && (allergy.type == 'Food' || allergy.type == 'Drug'))
          Padding(
            padding: const EdgeInsets.only(top: 8, bottom: 8, left: 32, right: 0),
            child: TextFormField(
              controller: allergy.type == 'Food' 
                ? _controllers['foodAllergy'] 
                : _controllers['drugAllergy'],
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                labelText: 'Specify ${allergy.type.toLowerCase()} allergies',
                labelStyle: TextStyle(color: Colors.white.withOpacity(0.7)),
                prefixIcon: Icon(
                  allergy.type == 'Food' ? Icons.restaurant : Icons.medication_outlined,
                  color: Colors.white.withOpacity(0.7),
                  size: 20,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(
                    color: AppColors.tertiaryColor.withOpacity(0.3),
                  ),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(
                    color: AppColors.tertiaryColor.withOpacity(0.3),
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(
                    color: AppColors.accentColor.withOpacity(0.5),
                    width: 2,
                  ),
                ),
                filled: true,
                fillColor: Colors.white.withOpacity(0.1),
                contentPadding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
              ),
            ),
          ),
        
      ],
    );
  }
} 