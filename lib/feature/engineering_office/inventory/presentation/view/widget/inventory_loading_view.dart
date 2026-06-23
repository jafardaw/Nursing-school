import 'package:flutter/material.dart';
import 'package:skeletonizer/skeletonizer.dart';

class InventoryLoadingView extends StatelessWidget {
  const InventoryLoadingView({super.key});

  @override
  Widget build(BuildContext context) {
    return Skeletonizer(
      enabled: true,
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(32),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(width: 320, height: 28, color: Colors.white),
            const SizedBox(height: 10),
            Container(width: 520, height: 16, color: Colors.white),
            const SizedBox(height: 28),
            GridView.count(
              crossAxisCount: 5,
              shrinkWrap: true,
              mainAxisSpacing: 12,
              crossAxisSpacing: 12,
              childAspectRatio: 1.35,
              physics: const NeverScrollableScrollPhysics(),
              children: List.generate(
                5,
                (_) => Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 24),
            Container(
              height: 120,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
              ),
            ),
            const SizedBox(height: 24),
            Container(
              height: 520,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
