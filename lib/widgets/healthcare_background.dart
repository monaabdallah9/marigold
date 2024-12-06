import 'package:flutter/material.dart';
import 'dart:math' as math;

class HealthcareBackgroundPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5
      ..color = const Color(0xFF2196F3).withOpacity(0.1);  // Medical blue

    // Draw medical symbols pattern
    final random = math.Random(42);  // Fixed seed for consistent pattern
    for (int i = 0; i < 30; i++) {
      final x = random.nextDouble() * size.width;
      final y = random.nextDouble() * size.height;
      final symbolSize = 15.0 + random.nextDouble() * 25.0;
      
      final symbolType = random.nextInt(5);
      switch (symbolType) {
        case 0:
          _drawCross(canvas, Offset(x, y), symbolSize, paint);
          break;
        case 1:
          _drawHeartbeat(canvas, Offset(x, y), symbolSize, paint);
          break;
        case 2:
          _drawStethoscope(canvas, Offset(x, y), symbolSize, paint);
          break;
        case 3:
          _drawPulse(canvas, Offset(x, y), symbolSize, paint);
          break;
        case 4:
          _drawHeart(canvas, Offset(x, y), symbolSize, paint);
          break;
      }
    }

    // Add top wave decoration
    final wavePath = Path();
    wavePath.moveTo(0, 0);
    wavePath.lineTo(0, size.height * 0.2);
    
    for (var i = 0; i <= 5; i++) {
      final x = size.width * (i / 5);
      final y = size.height * 0.2 + math.sin(i * math.pi) * 40;
      wavePath.lineTo(x, y);
    }
    
    wavePath.lineTo(size.width, 0);
    wavePath.close();

    final waveGradient = LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [
        const Color(0xFF2196F3).withOpacity(0.1),  // Medical blue
        const Color(0xFF64B5F6).withOpacity(0.05),  // Lighter blue
      ],
    ).createShader(Rect.fromLTWH(0, 0, size.width, size.height * 0.25));

    canvas.drawPath(wavePath, Paint()..shader = waveGradient);
  }

  void _drawCross(Canvas canvas, Offset center, double size, Paint paint) {
    canvas.drawLine(
      Offset(center.dx - size/2, center.dy),
      Offset(center.dx + size/2, center.dy),
      paint,
    );
    canvas.drawLine(
      Offset(center.dx, center.dy - size/2),
      Offset(center.dx, center.dy + size/2),
      paint,
    );
  }

  void _drawHeartbeat(Canvas canvas, Offset center, double size, Paint paint) {
    final path = Path();
    path.moveTo(center.dx - size/2, center.dy);
    path.lineTo(center.dx - size/4, center.dy);
    path.lineTo(center.dx - size/8, center.dy - size/2);
    path.lineTo(center.dx + size/8, center.dy + size/2);
    path.lineTo(center.dx + size/4, center.dy);
    path.lineTo(center.dx + size/2, center.dy);
    canvas.drawPath(path, paint);
  }

  void _drawStethoscope(Canvas canvas, Offset center, double size, Paint paint) {
    final path = Path();
    canvas.drawCircle(
      Offset(center.dx, center.dy + size/3),
      size/4,
      paint,
    );
    path.moveTo(center.dx, center.dy + size/3);
    path.lineTo(center.dx, center.dy - size/3);
    path.arcTo(
      Rect.fromCenter(
        center: Offset(center.dx + size/4, center.dy - size/3),
        width: size/2,
        height: size/2,
      ),
      math.pi,
      -math.pi,
      false,
    );
    canvas.drawPath(path, paint);
  }

  void _drawPulse(Canvas canvas, Offset center, double size, Paint paint) {
    final path = Path();
    path.moveTo(center.dx - size/2, center.dy);
    path.lineTo(center.dx - size/4, center.dy);
    path.lineTo(center.dx - size/6, center.dy - size/3);
    path.lineTo(center.dx, center.dy + size/3);
    path.lineTo(center.dx + size/6, center.dy - size/3);
    path.lineTo(center.dx + size/4, center.dy);
    path.lineTo(center.dx + size/2, center.dy);
    canvas.drawPath(path, paint);
  }

  void _drawHeart(Canvas canvas, Offset center, double size, Paint paint) {
    final path = Path();
    path.moveTo(center.dx, center.dy + size/3);
    path.cubicTo(
      center.dx - size/2, center.dy - size/3,
      center.dx - size/2, center.dy - size,
      center.dx, center.dy - size/3,
    );
    path.cubicTo(
      center.dx + size/2, center.dy - size,
      center.dx + size/2, center.dy - size/3,
      center.dx, center.dy + size/3,
    );
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
} 