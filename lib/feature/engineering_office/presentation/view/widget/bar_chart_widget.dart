import 'package:flutter/material.dart';

class BarChartWidget extends StatelessWidget {
  final List<BarChartData> data;

  const BarChartWidget({super.key, required this.data});

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
            'الشكاوى حسب النوع',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF181C32)),
          ),
          const SizedBox(height: 24),
          Expanded(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: data.map((item) => Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text(
                        '${item.value}',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: item.color,
                          fontSize: 14,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Container(
                        height: (item.value / _maxValue) * 150,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [item.color, item.color.withValues(alpha: 0.6)],
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                          ),
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        item.label,
                        style: const TextStyle(fontSize: 11, color: Color(0xFFA1A5B7)),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              )).toList(),
            ),
          ),
        ],
      ),
    );
  }

  double get _maxValue {
    if (data.isEmpty) return 1;
    return data.map((e) => e.value).reduce((a, b) => a > b ? a : b).toDouble();
  }
}

class BarChartData {
  final String label;
  final int value;
  final Color color;

  BarChartData({required this.label, required this.value, required this.color});
}