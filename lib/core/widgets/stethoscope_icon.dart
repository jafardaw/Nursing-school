import 'package:flutter/material.dart';

class StethoscopeIconWidget extends StatelessWidget {
  final double size;
  final Color color;

  const StethoscopeIconWidget({
    super.key,
    this.size = 42.0,
    this.color = Colors.white,
  });

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: Size(size, size),
      painter: _StethoscopePainter(color: color),
    );
  }
}

class _StethoscopePainter extends CustomPainter {
  final Color color;

  _StethoscopePainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final strokeWidth = size.width * 0.085;

    final paintTubes = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    final paintSolid = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    final w = size.width;
    final h = size.height;

    // 1. Earpieces (Left & Right top curves)
    final leftEarPath = Path()
      ..moveTo(w * 0.28, h * 0.15)
      ..cubicTo(w * 0.28, h * 0.05, w * 0.42, h * 0.05, w * 0.42, h * 0.25)
      ..lineTo(w * 0.42, h * 0.38);

    final rightEarPath = Path()
      ..moveTo(w * 0.72, h * 0.15)
      ..cubicTo(w * 0.72, h * 0.05, w * 0.58, h * 0.05, w * 0.58, h * 0.25)
      ..lineTo(w * 0.58, h * 0.38);

    canvas.drawPath(leftEarPath, paintTubes);
    canvas.drawPath(rightEarPath, paintTubes);

    // Ear tips
    canvas.drawCircle(Offset(w * 0.28, h * 0.15), strokeWidth * 0.9, paintSolid);
    canvas.drawCircle(Offset(w * 0.72, h * 0.15), strokeWidth * 0.9, paintSolid);

    // 2. Y-Joint stem
    final yStemPath = Path()
      ..moveTo(w * 0.42, h * 0.38)
      ..cubicTo(w * 0.42, h * 0.52, w * 0.5, h * 0.52, w * 0.5, h * 0.58)
      ..lineTo(w * 0.5, h * 0.7);

    final yRightPath = Path()
      ..moveTo(w * 0.58, h * 0.38)
      ..cubicTo(w * 0.58, h * 0.52, w * 0.5, h * 0.52, w * 0.5, h * 0.58);

    canvas.drawPath(yStemPath, paintTubes);
    canvas.drawPath(yRightPath, paintTubes);

    // 3. Chestpiece (Diaphragm bell) at bottom right loop
    final loopPath = Path()
      ..moveTo(w * 0.5, h * 0.7)
      ..cubicTo(w * 0.5, h * 0.88, w * 0.78, h * 0.88, w * 0.78, h * 0.7)
      ..lineTo(w * 0.78, h * 0.65);

    canvas.drawPath(loopPath, paintTubes);

    // Diaphragm head (Chestpiece)
    canvas.drawCircle(Offset(w * 0.78, h * 0.62), strokeWidth * 1.8, paintSolid);

    final innerPaint = Paint()
      ..color = Colors.white.withValues(alpha: 0.35)
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth * 0.4;

    canvas.drawCircle(Offset(w * 0.78, h * 0.62), strokeWidth * 1.0, innerPaint);
  }

  @override
  bool shouldRepaint(covariant _StethoscopePainter oldDelegate) =>
      oldDelegate.color != color;
}
