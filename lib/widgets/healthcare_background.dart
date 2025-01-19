import 'package:flutter/material.dart';
import 'dart:math' as math;

class HealthcareBackground extends StatelessWidget {
  final bool reversed;

  const HealthcareBackground({
    Key? key,
    this.reversed = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: reversed ? Alignment.topRight : Alignment.topLeft,
          end: reversed ? Alignment.bottomLeft : Alignment.bottomRight,
          colors: const [
            Color(0xFF90CAF9), // Very Light Blue
            Color(0xFFBBDEFB), // Extra Light Blue
          ],
          stops: const [0.0, 0.8],
        ),
      ),
      child: CustomPaint(
        painter: HealthcareBackgroundPainter(
          color: Color(0x0A2196F3),
        ),
        size: Size.infinite,
      ),
    );
  }
}

class HealthcareBackgroundPainter extends CustomPainter {
  final Color color;

  const HealthcareBackgroundPainter({
    this.color = const Color(0x0A2196F3),
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.0;

    final spacing = size.width * 0.1;
    final iconSize = size.width * 0.05;

    for (var x = 0.0; x < size.width; x += spacing) {
      for (var y = 0.0; y < size.height; y += spacing) {
        final random = math.Random((x + y).toInt());
        final icon = random.nextInt(4);

        switch (icon) {
          case 0:
            _drawCross(canvas, paint, Offset(x, y), iconSize);
            break;
          case 1:
            _drawHeart(canvas, paint, Offset(x, y), iconSize);
            break;
          case 2:
            _drawPlus(canvas, paint, Offset(x, y), iconSize);
            break;
          case 3:
            _drawPill(canvas, paint, Offset(x, y), iconSize);
            break;
        }
      }
    }
  }

  void _drawCross(Canvas canvas, Paint paint, Offset center, double size) {
    canvas.drawLine(
      Offset(center.dx - size / 2, center.dy),
      Offset(center.dx + size / 2, center.dy),
      paint,
    );
    canvas.drawLine(
      Offset(center.dx, center.dy - size / 2),
      Offset(center.dx, center.dy + size / 2),
      paint,
    );
  }

  void _drawHeart(Canvas canvas, Paint paint, Offset center, double size) {
    final path = Path();
    path.moveTo(center.dx, center.dy + size / 2);
    path.cubicTo(
      center.dx - size / 2,
      center.dy,
      center.dx - size / 2,
      center.dy - size / 2,
      center.dx,
      center.dy - size / 2,
    );
    path.cubicTo(
      center.dx + size / 2,
      center.dy - size / 2,
      center.dx + size / 2,
      center.dy,
      center.dx,
      center.dy + size / 2,
    );
    canvas.drawPath(path, paint);
  }

  void _drawPlus(Canvas canvas, Paint paint, Offset center, double size) {
    canvas.drawLine(
      Offset(center.dx - size / 3, center.dy),
      Offset(center.dx + size / 3, center.dy),
      paint,
    );
    canvas.drawLine(
      Offset(center.dx, center.dy - size / 3),
      Offset(center.dx, center.dy + size / 3),
      paint,
    );
  }

  void _drawPill(Canvas canvas, Paint paint, Offset center, double size) {
    final rect = Rect.fromCenter(
      center: center,
      width: size / 2,
      height: size,
    );
    canvas.drawRRect(
      RRect.fromRectAndRadius(rect, Radius.circular(size / 4)),
      paint,
    );
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
} 