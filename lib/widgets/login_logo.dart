import 'package:flutter/material.dart';
import 'dart:math' as math;

class LoginLogo extends StatelessWidget {
  const LoginLogo({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: LogoPainter(),
      size: const Size(100, 100),
    );
  }
}

class LogoPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    
    // Draw outer circle
    final outerCirclePaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = size.width * 0.06
      ..shader = const LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [
          Color(0xFF2196F3),  // Medical blue
          Color(0xFF1976D2),  // Darker medical blue
        ],
      ).createShader(Rect.fromCircle(
        center: center,
        radius: size.width * 0.4,
      ));

    canvas.drawCircle(
      center,
      size.width * 0.4,
      outerCirclePaint,
    );

    // Draw heart shape
    final heartPaint = Paint()
      ..style = PaintingStyle.fill
      ..shader = const LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          Color(0xFFE91E63),  // Medical red
          Color(0xFFD81B60),  // Darker medical red
        ],
      ).createShader(Rect.fromCenter(
        center: center,
        width: size.width * 0.4,
        height: size.height * 0.4,
      ));

    final heartPath = Path();
    final heartSize = size.width * 0.25;
    final heartCenter = Offset(center.dx, center.dy - size.height * 0.05);
    
    // Left curve
    heartPath.moveTo(heartCenter.dx, heartCenter.dy + heartSize * 0.3);
    heartPath.cubicTo(
      heartCenter.dx - heartSize * 0.8, heartCenter.dy - heartSize * 0.2,
      heartCenter.dx - heartSize * 0.8, heartCenter.dy - heartSize * 0.8,
      heartCenter.dx, heartCenter.dy - heartSize * 0.2,
    );
    
    // Right curve
    heartPath.cubicTo(
      heartCenter.dx + heartSize * 0.8, heartCenter.dy - heartSize * 0.8,
      heartCenter.dx + heartSize * 0.8, heartCenter.dy - heartSize * 0.2,
      heartCenter.dx, heartCenter.dy + heartSize * 0.3,
    );

    canvas.drawPath(heartPath, heartPaint);

    // Draw medical cross
    final crossPaint = Paint()
      ..style = PaintingStyle.fill
      ..shader = LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          Colors.white,
          Colors.white.withOpacity(0.9),
        ],
      ).createShader(Rect.fromCenter(
        center: Offset(center.dx, center.dy + size.height * 0.15),
        width: size.width * 0.25,
        height: size.height * 0.25,
      ));

    // Horizontal bar
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromCenter(
          center: Offset(center.dx, center.dy + size.height * 0.15),
          width: size.width * 0.25,
          height: size.width * 0.08,
        ),
        Radius.circular(size.width * 0.02),
      ),
      crossPaint,
    );

    // Vertical bar
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromCenter(
          center: Offset(center.dx, center.dy + size.height * 0.15),
          width: size.width * 0.08,
          height: size.width * 0.25,
        ),
        Radius.circular(size.width * 0.02),
      ),
      crossPaint,
    );

    // Add pulse line effect
    final pulsePaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = size.width * 0.015
      ..color = const Color.fromARGB(255, 167, 208, 247)
      ..strokeCap = StrokeCap.round;

    final pulsePath = Path();
    final pulseWidth = size.width * 0.5;
    final pulseHeight = size.height * 0.08;
    final pulseY = center.dy + size.height * 0.15;
    
    pulsePath.moveTo(center.dx - pulseWidth * 0.5, pulseY);
    pulsePath.lineTo(center.dx - pulseWidth * 0.3, pulseY);
    pulsePath.lineTo(center.dx - pulseWidth * 0.2, pulseY - pulseHeight);
    pulsePath.lineTo(center.dx - pulseWidth * 0.1, pulseY + pulseHeight);
    pulsePath.lineTo(center.dx + pulseWidth * 0.1, pulseY - pulseHeight * 0.5);
    pulsePath.lineTo(center.dx + pulseWidth * 0.2, pulseY);
    pulsePath.lineTo(center.dx + pulseWidth * 0.5, pulseY);

    canvas.drawPath(pulsePath, pulsePaint);

    // Add shine effect
    final shinePaint = Paint()
      ..style = PaintingStyle.fill
      ..shader = RadialGradient(
        colors: [
          Colors.white.withOpacity(0.4),
          Colors.white.withOpacity(0),
        ],
      ).createShader(Rect.fromCircle(
        center: Offset(
          center.dx - size.width * 0.2,
          center.dy - size.height * 0.2,
        ),
        radius: size.width * 0.15,
      ));

    canvas.drawCircle(
      Offset(
        center.dx - size.width * 0.2,
        center.dy - size.height * 0.2,
      ),
      size.width * 0.15,
      shinePaint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
} 