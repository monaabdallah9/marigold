import 'package:flutter/material.dart';
import 'dart:ui';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:file_picker/file_picker.dart';
import '../screens/nail_diagnosis_result_screen.dart';
import '../widgets/healthcare_background.dart';

class NailDetectionScreen extends StatefulWidget {
  const NailDetectionScreen({super.key});

  @override
  State<NailDetectionScreen> createState() => _NailDetectionScreenState();
}

class _NailDetectionScreenState extends State<NailDetectionScreen> with SingleTickerProviderStateMixin {
  File? _image;
  final _picker = ImagePicker();
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  bool _isAnalyzing = false;

  // Add new parameters
  final Map<String, String> _healthParameters = {
    'Color': 'Normal',
    'Shape': 'Regular',
    'Texture': 'Smooth',
    'Spots': 'None',
    'Lines': 'None',
    'Growth': 'Normal',
  };

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.95).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _getImage(ImageSource source) async {
    try {
      final XFile? image = await _picker.pickImage(
        source: source,
        maxWidth: 1800,
        maxHeight: 1800,
        imageQuality: 95,
      );
      if (image != null) {
        setState(() {
          _image = File(image.path);
          _isAnalyzing = true;
        });
        // Simulate analysis process
        await Future.delayed(const Duration(seconds: 2));
        setState(() {
          _isAnalyzing = false;
        });
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: ${e.toString()}')),
      );
    }
  }

  void _showImageOptions() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: const Color(0xFF1976D2),
          borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
          border: Border.all(
            color: Colors.white.withOpacity(0.2),
            width: 1,
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Choose Image Source',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.white,
                shadows: [
                  Shadow(
                    color: Colors.black.withOpacity(0.1),
                    offset: const Offset(0, 2),
                    blurRadius: 4,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildImageOptionButton(
                  'Camera',
                  Icons.camera_alt,
                  () => _getImage(ImageSource.camera),
                ),
                _buildImageOptionButton(
                  'Gallery',
                  Icons.photo_library,
                  () => _getImage(ImageSource.gallery),
                ),
              ],
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  Widget _buildImageOptionButton(String title, IconData icon, VoidCallback onTap) {
    return GestureDetector(
      onTap: () {
        Navigator.pop(context);
        onTap();
      },
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.1),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: Colors.white.withOpacity(0.2),
                width: 1,
              ),
            ),
            child: Icon(icon, color: Colors.white, size: 32),
          ),
          const SizedBox(height: 8),
          Text(
            title,
            style: TextStyle(
              color: Colors.white.withOpacity(0.9),
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Main gradient background
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Color(0xFF1E88E5),  // Light blue
                  Color(0xFF1976D2),  // Blue
                  Color(0xFF1565C0),  // Dark blue
                ],
              ),
            ),
          ),
          // Medical symbols background
          const Positioned.fill(
            child: CustomPaint(
              painter: HealthcareBackgroundPainter(
                color: Color(0x0A2196F3),
              ),
            ),
          ),
          // Glass effect overlay
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.white.withOpacity(0.1),
                  Colors.white.withOpacity(0.15),
                ],
              ),
            ),
          ),
          // Main Content
          SafeArea(
            child: Stack(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildTopBar(context),
                    Expanded(
                      child: SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _buildMainCard(),
                            if (_image != null) _buildImagePreview(),
                            _buildAnalysisSection(),
                            _buildUploadSection(),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                if (_isAnalyzing) _buildAnalyzingOverlay(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildImagePreview() {
    return Container(
      margin: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.1),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: Colors.white.withOpacity(0.2),
          width: 1,
        ),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(24),
        child: Image.file(
          _image!,
          fit: BoxFit.cover,
          height: 200,
          width: double.infinity,
        ),
      ),
    );
  }

  Widget _buildAnalyzingOverlay() {
    return Container(
      color: Colors.black54,
      child: Center(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 24),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.1),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: Colors.white.withOpacity(0.2),
              width: 1,
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
              ),
              const SizedBox(height: 16),
              Text(
                'Analyzing Image...',
                style: TextStyle(
                  color: Colors.white.withOpacity(0.9),
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTopBar(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Row(
        children: [
          Container(
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: Colors.white.withOpacity(0.2),
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
            'Nail Analysis',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.white,
              shadows: [
                Shadow(
                  color: Colors.black.withOpacity(0.1),
                  offset: const Offset(0, 2),
                  blurRadius: 4,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMainCard() {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF1A237E), Color(0xFF3949AB)],
        ),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF1A237E).withOpacity(0.3),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Text(
                    'AI-Powered Analysis',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                const Text(
                  'Nail Health',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Take a photo of your nails',
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.9),
                    fontSize: 16,
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: Colors.white.withOpacity(0.2),
              ),
            ),
            child: const Icon(
              Icons.fingerprint,
              color: Colors.white,
              size: 32,
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _pickPDF() async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['pdf'],
      );
      
      if (result != null) {
        // Handle PDF file
        String path = result.files.single.path!;
        // TODO: Implement PDF processing
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('PDF uploaded successfully')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: ${e.toString()}')),
      );
    }
  }

  Widget _buildAnalysisSection() {
    // Define a consistent color palette
    const primaryColor = Color(0xFF1A237E);  // Deep blue
    final colors = [
      [primaryColor, primaryColor.withOpacity(0.8)],  // Color
      [const Color(0xFF303F9F), const Color(0xFF3949AB)],  // Shape
      [const Color(0xFF3949AB), const Color(0xFF5C6BC0)],  // Texture
      [const Color(0xFF5C6BC0), const Color(0xFF7986CB)],  // Spots
      [const Color(0xFF7986CB), const Color(0xFF9FA8DA)],  // Lines
      [const Color(0xFF9FA8DA), const Color(0xFFC5CAE9)],  // Growth
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: const Color(0xFF1A237E).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(
                  Icons.medical_services_outlined,
                  color: Color(0xFF1A237E),
                ),
              ),
              const SizedBox(width: 12),
              const Text(
                'Health Parameters',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1A237E),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        GridView.count(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisCount: 2,
          mainAxisSpacing: 12,
          crossAxisSpacing: 12,
          childAspectRatio: 1.6,
          children: [
            AnalysisItem(
              title: 'Color',
              icon: Icons.palette_outlined,
              gradient: LinearGradient(colors: colors[0]),
              description: 'Nail pigmentation\nand tone analysis',
            ),
            AnalysisItem(
              title: 'Shape',
              icon: Icons.medication_outlined,
              gradient: LinearGradient(colors: colors[1]),
              description: 'Curvature and\noverall form',
            ),
            AnalysisItem(
              title: 'Texture',
              icon: Icons.healing_outlined,
              gradient: LinearGradient(colors: colors[2]),
              description: 'Surface patterns\nand irregularities',
            ),
            AnalysisItem(
              title: 'Spots',
              icon: Icons.coronavirus_outlined,
              gradient: LinearGradient(colors: colors[3]),
              description: 'Discoloration and\nmarkings',
            ),
            AnalysisItem(
              title: 'Lines',
              icon: Icons.medical_information_outlined,
              gradient: LinearGradient(colors: colors[4]),
              description: 'Vertical and\nhorizontal ridges',
            ),
            AnalysisItem(
              title: 'Growth',
              icon: Icons.monitor_heart_outlined,
              gradient: LinearGradient(colors: colors[5]),
              description: 'Growth rate and\npattern analysis',
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildUploadSection() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          GestureDetector(
            onTapDown: (_) => _controller.forward(),
            onTapUp: (_) {
              _controller.reverse();
              _showImageOptions();
            },
            onTapCancel: () => _controller.reverse(),
            child: ScaleTransition(
              scale: _scaleAnimation,
              child: _buildUploadButton(
                'Upload Image',
                Icons.add_photo_alternate,
                () => _showImageOptions(),
              ),
            ),
          ),
          const SizedBox(height: 12),
          GestureDetector(
            onTapDown: (_) => _controller.forward(),
            onTapUp: (_) {
              _controller.reverse();
              _pickPDF();
            },
            onTapCancel: () => _controller.reverse(),
            child: ScaleTransition(
              scale: _scaleAnimation,
              child: _buildUploadButton(
                'Upload PDF',
                Icons.picture_as_pdf,
                _pickPDF,
                isPrimary: false,
              ),
            ),
          ),
          const SizedBox(height: 20),
          _buildDiagnoseButton(),
        ],
      ),
    );
  }

  Widget _buildUploadButton(
    String title,
    IconData icon,
    VoidCallback onTap, {
    bool isPrimary = true,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 16),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Colors.white.withOpacity(0.2),
          width: 1,
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: Colors.white.withOpacity(0.9)),
          const SizedBox(width: 8),
          Text(
            title,
            style: TextStyle(
              color: Colors.white.withOpacity(0.9),
              fontWeight: FontWeight.w600,
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDiagnoseButton() {
    return Container(
      width: double.infinity,
      height: 56,
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.2),
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
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: () {
                // Simulate diagnosis process
                setState(() => _isAnalyzing = true);
                Future.delayed(const Duration(seconds: 2), () {
                  setState(() => _isAnalyzing = false);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => NailDiagnosisResultScreen(
                        results: [
                          DiagnosisResult(
                            parameter: 'Condition',
                            value: 'Anemia - Possible signs detected',
                          ),
                          DiagnosisResult(
                            parameter: 'Condition',
                            value: 'Onychomycosis - Early signs of nail fungus',
                          ),
                          DiagnosisResult(
                            parameter: 'Condition',
                            value: 'Psoriasis - Potential indicators present',
                          ),
                        ],
                      ),
                    ),
                  );
                });
              },
              child: Center(
                child: Text(
                  'Diagnose Now',
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.95),
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class AnalysisItem extends StatelessWidget {
  final String title;
  final IconData icon;
  final Gradient gradient;
  final String description;

  const AnalysisItem({
    super.key,
    required this.title,
    required this.icon,
    required this.gradient,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: gradient,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  icon,
                  color: Colors.white,
                  size: 24,
                ),
                const SizedBox(width: 8),
                Text(
                  title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                    fontSize: 16,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              description,
              style: TextStyle(
                color: Colors.white.withOpacity(0.9),
                fontSize: 12,
                height: 1.2,
              ),
            ),
          ],
        ),
      ),
    );
  }
} 