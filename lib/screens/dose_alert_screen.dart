import 'package:flutter/material.dart';
import 'dart:ui';
import '../theme/app_colors.dart';
import '../l10n/app_localizations.dart';

class DoseAlert {
  final String medication;
  final String dosage;
  final TimeOfDay time;
  final String frequency;
  final String instructions;
  final bool isActive;

  DoseAlert({
    required this.medication,
    required this.dosage,
    required this.time,
    required this.frequency,
    required this.instructions,
    this.isActive = true,
  });
}

class DoseAlertScreen extends StatefulWidget {
  const DoseAlertScreen({super.key});

  @override
  State<DoseAlertScreen> createState() => _DoseAlertScreenState();
}

class _DoseAlertScreenState extends State<DoseAlertScreen> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;
  final List<DoseAlert> _alerts = [];

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
    super.dispose();
  }

  Future<void> _showAddAlertDialog() async {
    final formKey = GlobalKey<FormState>();
    String medication = '';
    String dosage = '';
    TimeOfDay selectedTime = TimeOfDay.now();
    String frequency = '';
    String instructions = '';
    final appLocalizations = AppLocalizations.of(context);

    showDialog(
      context: context,
      builder: (context) => Dialog(
              backgroundColor: Colors.transparent,
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                AppColors.primaryColor,
                AppColors.secondaryColor.withOpacity(0.9),
                      ],
                    ),
                    borderRadius: BorderRadius.circular(24),
            border: Border.all(
              color: AppColors.tertiaryColor.withOpacity(0.3),
              width: 1.5,
            ),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(24),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
              child: Container(
                padding: const EdgeInsets.all(24),
                child: Form(
                  key: formKey,
                  child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            appLocalizations.translate('addMedicationAlert'),
                            style: const TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                      ),
                      const SizedBox(height: 24),
                        _buildDialogTextField(
                          label: appLocalizations.translate('medicationName'),
                          icon: Icons.medication_outlined,
                          onChanged: (value) => medication = value,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return appLocalizations.translate('enterMedicationName');
                            }
                            return null;
                          },
                      ),
                      const SizedBox(height: 16),
                        _buildDialogTextField(
                          label: appLocalizations.translate('dosage'),
                          icon: Icons.medical_information_outlined,
                        onChanged: (value) => dosage = value,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return appLocalizations.translate('enterDosage');
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 16),
                        StatefulBuilder(
                          builder: (context, setState) => InkWell(
                        onTap: () async {
                          final TimeOfDay? picked = await showTimePicker(
                            context: context,
                            initialTime: selectedTime,
                            builder: (context, child) {
                              return Theme(
                                data: Theme.of(context).copyWith(
                                      timePickerTheme: TimePickerThemeData(
                                        backgroundColor: AppColors.primaryColor,
                                        hourMinuteTextColor: Colors.white,
                                        dialHandColor: AppColors.accentColor,
                                        dialBackgroundColor: Colors.white.withOpacity(0.1),
                                        dialTextColor: Colors.white,
                                        entryModeIconColor: Colors.white,
                                      ),
                                      textButtonTheme: TextButtonThemeData(
                                        style: TextButton.styleFrom(
                                          foregroundColor: Colors.white,
                                        ),
                                  ),
                                ),
                                child: child!,
                              );
                            },
                          );
                          if (picked != null) {
                                setState(() => selectedTime = picked);
                          }
                        },
                        child: Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                  color: AppColors.tertiaryColor.withOpacity(0.3),
                                ),
                              ),
                              child: Row(
                                children: [
                                  Icon(
                                    Icons.access_time_outlined,
                                    color: Colors.white.withOpacity(0.7),
                                  ),
                                  const SizedBox(width: 12),
                                  Text(
                                    '${appLocalizations.translate('time')}: ${selectedTime.format(context)}',
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 16,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                        ),
                        const SizedBox(height: 16),
                        _buildDialogTextField(
                          label: appLocalizations.translate('frequency'),
                          icon: Icons.repeat_outlined,
                          onChanged: (value) => frequency = value,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return appLocalizations.translate('enterFrequency');
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 16),
                        _buildDialogTextField(
                          label: appLocalizations.translate('instructions'),
                          icon: Icons.info_outline,
                          onChanged: (value) => instructions = value,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return appLocalizations.translate('enterDescription');
                            }
                            return null;
                          },
                          maxLines: 2,
                      ),
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
                            onPressed: () {
                                if (formKey.currentState!.validate()) {
                                setState(() {
                                    _alerts.add(DoseAlert(
                                      medication: medication,
                                      dosage: dosage,
                                    time: selectedTime,
                                      frequency: frequency,
                                      instructions: instructions,
                                  ));
                                });
                                Navigator.pop(context);
                              }
                            },
                            style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.accentColor,
                                foregroundColor: AppColors.primaryColor,
                              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            child: Text(
                                appLocalizations.translate('addMedication'),
                                style: const TextStyle(fontWeight: FontWeight.bold),
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
              ),
            );
  }

  Widget _buildDialogTextField({
    required String label,
    required IconData icon,
    required void Function(String) onChanged,
    required String? Function(String?) validator,
    int maxLines = 1,
  }) {
    return TextFormField(
      onChanged: onChanged,
      validator: validator,
      maxLines: maxLines,
      style: const TextStyle(color: Colors.white),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(color: Colors.white.withOpacity(0.7)),
        prefixIcon: Icon(icon, color: Colors.white.withOpacity(0.7)),
        filled: true,
        fillColor: Colors.white.withOpacity(0.1),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: AppColors.tertiaryColor.withOpacity(0.3)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: AppColors.tertiaryColor.withOpacity(0.3)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: AppColors.accentColor.withOpacity(0.5)),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.red),
        ),
        errorStyle: const TextStyle(color: Colors.red),
      ),
    );
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
                          icon: Icon(Icons.arrow_back, color: Colors.white.withOpacity(0.9)),
                          onPressed: () => Navigator.pop(context),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Text(
                        appLocalizations.translate('doseAlert'),
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
        ),
                // Main Content
                Expanded(
                  child: _alerts.isEmpty
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
                      appLocalizations.translate('noMedicationAlertsYet'),
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.white.withOpacity(0.7),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      appLocalizations.translate('addFirstAlertPrompt'),
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.white.withOpacity(0.5),
                      ),
                    ),
                  ],
                ),
              )
                      : SingleChildScrollView(
                          physics: const BouncingScrollPhysics(),
                          padding: const EdgeInsets.all(24),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Header Section
                              SlideTransition(
                                position: _slideAnimation,
                                child: FadeTransition(
                                  opacity: _fadeAnimation,
                                  child: Container(
                                    padding: const EdgeInsets.all(24),
                      decoration: BoxDecoration(
                                      gradient: LinearGradient(
                                        begin: Alignment.topLeft,
                                        end: Alignment.bottomRight,
                                        colors: [
                                          Colors.white.withOpacity(0.15),
                                          Colors.white.withOpacity(0.05),
                                        ],
                                      ),
                                      borderRadius: BorderRadius.circular(24),
                        border: Border.all(
                                        color: AppColors.tertiaryColor.withOpacity(0.3),
                                        width: 1.5,
                                      ),
                                    ),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          children: [
                                            Container(
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                                color: AppColors.accentColor.withOpacity(0.2),
                                                shape: BoxShape.circle,
                              ),
                              child: const Icon(
                                                Icons.medication_outlined,
                                                color: Colors.white,
                                                size: 24,
                                              ),
                                            ),
                                            const SizedBox(width: 16),
                                            Expanded(
                                              child: Column(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    appLocalizations.translate('medicationRemindersTitle'),
                                                    style: const TextStyle(
                                                      fontSize: 20,
                                                      fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                                                  const SizedBox(height: 4),
                                                  Text(
                                                    appLocalizations.translate('neverMissMedications'),
                                                    style: const TextStyle(
                                                      fontSize: 14,
                                                      color: Colors.white70,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 24),
                              // Alerts List
                              ...List.generate(_alerts.length, (index) {
                                final alert = _alerts[index];
                                return Padding(
                                  padding: const EdgeInsets.only(bottom: 16),
                                  child: Dismissible(
                                    key: Key(alert.medication + alert.time.toString()),
                                    direction: DismissDirection.endToStart,
                                    background: Container(
                                      alignment: Alignment.centerRight,
                                      padding: const EdgeInsets.only(right: 20),
                                      decoration: BoxDecoration(
                                        color: Colors.red.withOpacity(0.2),
                                        borderRadius: BorderRadius.circular(24),
                                      ),
                                      child: const Icon(
                                        Icons.delete_outline,
                                        color: Colors.red,
                                      ),
                                    ),
                                    onDismissed: (direction) {
                                      setState(() {
                                        _alerts.removeAt(index);
                                      });
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        SnackBar(
                                          content: Text(appLocalizations.translate('alertRemoved')),
                                          backgroundColor: AppColors.primaryColor,
                                        ),
                                      );
                                    },
                                    child: SlideTransition(
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
                                          padding: const EdgeInsets.all(20),
                                          decoration: BoxDecoration(
                                            color: Colors.white.withOpacity(0.1),
                                            borderRadius: BorderRadius.circular(24),
                                            border: Border.all(
                                              color: AppColors.tertiaryColor.withOpacity(0.3),
                                              width: 1.5,
                                            ),
                                          ),
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Row(
                                                children: [
                                                  Container(
                                                    padding: const EdgeInsets.all(10),
                                                    decoration: BoxDecoration(
                                                      color: AppColors.accentColor.withOpacity(0.2),
                                                      borderRadius: BorderRadius.circular(12),
                                                    ),
                                                    child: Icon(
                                                      Icons.medication_outlined,
                                                      color: alert.isActive ? Colors.white : Colors.white.withOpacity(0.5),
                                                      size: 20,
                                                    ),
                                                  ),
                                                  const SizedBox(width: 12),
                                                  Expanded(
                                                    child: Column(
                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                      children: [
                                                        Text(
                                                          alert.medication,
                                                          style: TextStyle(
                                                            fontSize: 16,
                                                            fontWeight: FontWeight.bold,
                                                            color: alert.isActive ? Colors.white : Colors.white.withOpacity(0.5),
                                                          ),
                                                        ),
                                                        const SizedBox(height: 4),
                                                        Text(
                                                          '${alert.dosage} • ${alert.frequency}',
                                                          style: TextStyle(
                                                            fontSize: 14,
                                                            color: alert.isActive ? Colors.white70 : Colors.white30,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                  Switch(
                                                    value: alert.isActive,
                                                    onChanged: (value) {
                                                      setState(() {
                                                        _alerts[index] = DoseAlert(
                                                          medication: alert.medication,
                                                          dosage: alert.dosage,
                                                          time: alert.time,
                                                          frequency: alert.frequency,
                                                          instructions: alert.instructions,
                                                          isActive: value,
                                                        );
                                                      });
                                                    },
                                                    activeColor: AppColors.accentColor,
                                                    inactiveThumbColor: Colors.white.withOpacity(0.3),
                                                    inactiveTrackColor: Colors.white.withOpacity(0.1),
                                    ),
                                  ],
                                ),
                                              const SizedBox(height: 16),
                                              Container(
                                                padding: const EdgeInsets.all(12),
                                                decoration: BoxDecoration(
                                                  color: Colors.white.withOpacity(0.05),
                                                  borderRadius: BorderRadius.circular(12),
                                                ),
                                                child: Row(
                                  children: [
                                    Icon(
                                      Icons.access_time_outlined,
                                      size: 16,
                                      color: alert.isActive ? Colors.white70 : Colors.white30,
                                    ),
                                    const SizedBox(width: 8),
                                    Text(
                                      '${alert.time.hour.toString().padLeft(2, '0')}:${alert.time.minute.toString().padLeft(2, '0')}',
                                      style: TextStyle(
                                        fontSize: 14,
                                        color: alert.isActive ? Colors.white70 : Colors.white30,
                                      ),
                                    ),
                                    const SizedBox(width: 16),
                                    Icon(
                                      Icons.info_outline,
                                      size: 16,
                                      color: alert.isActive ? Colors.white70 : Colors.white30,
                                    ),
                                    const SizedBox(width: 8),
                                    Expanded(
                                      child: Text(
                                        alert.instructions,
                                        style: TextStyle(
                                          fontSize: 14,
                                          color: alert.isActive ? Colors.white70 : Colors.white30,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                          ),
                                        ),
                                      );
                                    }),
                                  ],
                          ),
                        ),
                ),
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: SlideTransition(
        position: _slideAnimation,
        child: FadeTransition(
          opacity: _fadeAnimation,
          child: Container(
          decoration: BoxDecoration(
              gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
                colors: [
                  AppColors.accentColor.withOpacity(0.8),
                  AppColors.primaryColor.withOpacity(0.9),
                ],
            ),
              borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                  color: AppColors.primaryColor.withOpacity(0.3),
                  blurRadius: 15,
                  offset: const Offset(0, 5),
              ),
            ],
          ),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: _showAddAlertDialog,
                borderRadius: BorderRadius.circular(20),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: Colors.white.withOpacity(0.2),
                      width: 1,
                    ),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
              Icons.add,
                        color: Colors.white.withOpacity(0.95),
                        size: 24,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        appLocalizations.translate('addMedication'),
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.95),
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 0.5,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }
} 