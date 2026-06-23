import 'package:flutter/material.dart';
import 'dart:math' as math;

class PieChartWidget extends StatelessWidget {
  final List<PieChartData> data;

  const PieChartWidget({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'الشكاوى حسب الحالة',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Color(0xFF181C32),
            ),
          ),
          const SizedBox(height: 24),
          Expanded(
            child: Row(
              children: [
                Expanded(
                  flex: 3,
                  child: CustomPaint(
                    painter: _PieChartPainter(data),
                    size: const Size(150, 150),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  flex: 2,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: data.map((item) => _legendItem(item)).toList(),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _legendItem(PieChartData item) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Container(
            width: 12,
            height: 12,
            decoration: BoxDecoration(
              color: item.color,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              item.label,
              style: const TextStyle(fontSize: 11, color: Color(0xFFA1A5B7)),
            ),
          ),
          Text(
            '${item.value}',
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
          ),
        ],
      ),
    );
  }
}

class PieChartData {
  final String label;
  final int value;
  final Color color;

  PieChartData({required this.label, required this.value, required this.color});
}

class _PieChartPainter extends CustomPainter {
  final List<PieChartData> data;

  _PieChartPainter(this.data);

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2;
    double startAngle = -math.pi / 2;

    final total = data.fold<int>(0, (sum, item) => sum + item.value);

    for (final item in data) {
      final sweepAngle = (item.value / total) * 2 * math.pi;
      final paint = Paint()
        ..color = item.color
        ..style = PaintingStyle.fill;

      canvas.drawArc(
        Rect.fromCircle(center: center, radius: radius),
        startAngle,
        sweepAngle,
        true,
        paint,
      );
      startAngle += sweepAngle;
    }

    // Center hole
    final holePaint = Paint()..color = Colors.white;
    canvas.drawCircle(center, radius * 0.6, holePaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
