import 'package:flutter/material.dart';
import 'dart:async';
import '../theme/app_colors.dart';
import '../widgets/healthcare_background.dart';
import '../widgets/login_logo.dart';
import 'login_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.0, 0.5, curve: Curves.easeIn),
    ));

    _scaleAnimation = Tween<double>(
      begin: 0.5,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.3, 0.8, curve: Curves.easeOut),
    ));

    _controller.forward();

    Timer(const Duration(seconds: 3), () {
      if (mounted) {
        Navigator.pushReplacement(
          context,
          PageRouteBuilder(
            pageBuilder: (context, animation, secondaryAnimation) => const LoginScreen(),
            transitionsBuilder: (context, animation, secondaryAnimation, child) {
              return FadeTransition(
                opacity: animation,
                child: child,
              );
            },
            transitionDuration: const Duration(milliseconds: 800),
          ),
        );
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final params = {
      'padding': size.width * 0.05,
      'logoSize': size.width * 0.45,  // Larger logo for splash screen
      'spacing': size.height * 0.022,
      'titleSize': size.width * 0.09,  // Larger title for splash
      'subtitleSize': size.width * 0.042,
    };

    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          // Background gradient
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Colors.white,
                  Color(0xFFF5F9FF),  // Very light blue
                  Color(0xFFEDF4FF),  // Light blue tint
                ],
              ),
            ),
          ),
          // Medical symbols background
          Positioned.fill(
            child: CustomPaint(
              painter: HealthcareBackgroundPainter(),
            ),
          ),
          // Main content
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Logo animation
                FadeTransition(
                  opacity: _fadeAnimation,
                  child: ScaleTransition(
                    scale: _scaleAnimation,
                    child: Hero(
                      tag: 'app_logo',
                      child: SizedBox(
                        width: params['logoSize'],
                        height: params['logoSize'],
                        child: const LoginLogo(),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: params['spacing']! * 2),
                // Text animations
                FadeTransition(
                  opacity: _fadeAnimation,
                  child: Column(
                    children: [
                      Text(
                        'MARIGOLD',
                        style: TextStyle(
                          fontSize: params['titleSize'],
                          fontWeight: FontWeight.w800,
                          color: const Color(0xFF2196F3),  // Medical blue
                          letterSpacing: 4,
                          height: 1.2,
                        ),
                      ),
                      SizedBox(height: params['spacing']),
                      Text(
                        'PRIME HEALTHCARE',
                        style: TextStyle(
                          fontSize: params['subtitleSize'],
                          color: const Color(0xFF1976D2).withOpacity(0.8),  // Darker medical blue
                          letterSpacing: 3,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          // Loading indicator
          Positioned(
            bottom: 50,
            left: 0,
            right: 0,
            child: FadeTransition(
              opacity: _fadeAnimation,
              child: Center(
                child: SizedBox(
                  width: 45,
                  height: 45,
                  child: CircularProgressIndicator(
                    color: const Color(0xFF2196F3).withOpacity(0.8),  // Medical blue
                    strokeWidth: 3,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
} 