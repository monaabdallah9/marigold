import 'package:flutter/material.dart';
import 'dart:ui';
import '../theme/app_colors.dart';
import '../l10n/app_localizations.dart';

class LabResult {
  final String title;
  final String status;
  final String? description;
  final String? recommendation;
  final double? value;
  final String? unit;
  final double? referenceMin;
  final double? referenceMax;

  LabResult({
    required this.title,
    required this.status,
    this.description,
    this.recommendation,
    this.value,
    this.unit,
    this.referenceMin,
    this.referenceMax,
  });
}

class LabResultAnalysisScreen extends StatefulWidget {
  const LabResultAnalysisScreen({super.key});

  @override
  State<LabResultAnalysisScreen> createState() => _LabResultAnalysisScreenState();
}

class _LabResultAnalysisScreenState extends State<LabResultAnalysisScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;
  late List<LabResult> _results;

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
  void didChangeDependencies() {
    super.didChangeDependencies();
    final appLocalizations = AppLocalizations.of(context);
    _results = [
      LabResult(
        title: appLocalizations.translate('completeBloodCount'),
        status: appLocalizations.translate('normal'),
        description: appLocalizations.translate('bloodCellDescription'),
        recommendation: appLocalizations.translate('bloodCellRecommendation'),
        value: 14.2,
        unit: 'g/dL',
        referenceMin: 12.0,
        referenceMax: 15.5,
      ),
      LabResult(
        title: appLocalizations.translate('bloodGlucose'),
        status: appLocalizations.translate('elevated'),
        description: appLocalizations.translate('glucoseDescription'),
        recommendation: appLocalizations.translate('glucoseRecommendation'),
        value: 110,
        unit: 'mg/dL',
        referenceMin: 70,
        referenceMax: 100,
      ),
      LabResult(
        title: appLocalizations.translate('cholesterol'),
        status: appLocalizations.translate('normal'),
        description: appLocalizations.translate('cholesterolDescription'),
        recommendation: appLocalizations.translate('cholesterolRecommendation'),
        value: 180,
        unit: 'mg/dL',
        referenceMin: 150,
        referenceMax: 200,
      ),
    ];
  }

  @override
  void dispose() {
    _controller.dispose();
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
                          icon: Icon(Icons.arrow_back, color: Colors.white.withOpacity(0.9)),
                          onPressed: () => Navigator.pop(context),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Text(
                        appLocalizations.translate('analysisResults'),
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
                  child: SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    child: Padding(
                      padding: const EdgeInsets.all(24.0),
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
                                            Icons.analytics_outlined,
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
                                                appLocalizations.translate('analysisComplete'),
                                                style: const TextStyle(
                                                  fontSize: 20,
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.white,
                                                ),
                                              ),
                                              const SizedBox(height: 4),
                                              Text(
                                                appLocalizations.translate('detailedResults'),
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
                          // Results List
                          ...List.generate(_results.length, (index) {
                            final result = _results[index];
                            return Padding(
                              padding: const EdgeInsets.only(bottom: 16),
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
                                                color: _getStatusColor(result.status).withOpacity(0.2),
                                                borderRadius: BorderRadius.circular(12),
                                              ),
                                              child: Icon(
                                                _getStatusIcon(result.status),
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
                                                    result.title,
                                                    style: const TextStyle(
                                                      fontSize: 16,
                                                      fontWeight: FontWeight.bold,
                                                      color: Colors.white,
                                                    ),
                                                  ),
                                                  const SizedBox(height: 4),
                                                  Text(
                                                    result.status,
                                                    style: TextStyle(
                                                      fontSize: 14,
                                                      color: _getStatusColor(result.status),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                        if (result.value != null)
                                          Padding(
                                            padding: const EdgeInsets.only(top: 16),
                                            child: Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Row(
                                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                  children: [
                                                    Expanded(
                                                      child: Text(
                                                        appLocalizations.translate('value'),
                                                        style: TextStyle(
                                                          color: Colors.grey[600],
                                                          fontSize: 14,
                                                        ),
                                                      ),
                                                    ),
                                                    Text(
                                                      '${result.value} ${result.unit}',
                                                      style: const TextStyle(
                                                        fontSize: 16,
                                                        fontWeight: FontWeight.w500,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                const SizedBox(height: 8),
                                                ClipRRect(
                                                  borderRadius: BorderRadius.circular(4),
                                                  child: LinearProgressIndicator(
                                                    value: _calculateProgressValue(
                                                      result.value!,
                                                      result.referenceMin!,
                                                      result.referenceMax!,
                                                    ),
                                                    backgroundColor: Colors.white.withOpacity(0.1),
                                                    valueColor: AlwaysStoppedAnimation<Color>(
                                                      _getStatusColor(result.status),
                                                    ),
                                                    minHeight: 8,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        if (result.description != null)
                                          Padding(
                                            padding: const EdgeInsets.only(top: 16),
                                            child: Text(
                                              result.description!,
                                              style: TextStyle(
                                                fontSize: 14,
                                                color: Colors.white.withOpacity(0.7),
                                              ),
                                            ),
                                          ),
                                        if (result.recommendation != null)
                                          Padding(
                                            padding: const EdgeInsets.only(top: 12),
                                            child: Row(
                                              children: [
                                                Icon(
                                                  Icons.tips_and_updates_outlined,
                                                  size: 16,
                                                  color: Colors.white.withOpacity(0.7),
                                                ),
                                                const SizedBox(width: 8),
                                                Expanded(
                                                  child: Text(
                                                    result.recommendation!,
                                                    style: TextStyle(
                                                      fontSize: 14,
                                                      color: Colors.white.withOpacity(0.7),
                                                      fontStyle: FontStyle.italic,
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
                            );
                          }),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'normal':
      case 'good':
        return Colors.green;
      case 'elevated':
        return Colors.orange;
      case 'low':
        return Colors.red;
      default:
        return AppColors.accentColor;
    }
  }

  IconData _getStatusIcon(String status) {
    switch (status.toLowerCase()) {
      case 'normal':
      case 'good':
        return Icons.check_circle_outline;
      case 'elevated':
        return Icons.warning_amber_outlined;
      case 'low':
        return Icons.error_outline;
      default:
        return Icons.info_outline;
    }
  }

  double _calculateProgressValue(double value, double min, double max) {
    if (value < min) return 0.0;
    if (value > max) return 1.0;
    return (value - min) / (max - min);
  }
} 