import 'package:flutter/material.dart';
import 'package:skeletonizer/skeletonizer.dart';

class WarehouseStockInLoadingView extends StatelessWidget {
  const WarehouseStockInLoadingView({super.key});

  @override
  Widget build(BuildContext context) {
    return Skeletonizer(
      enabled: true,
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(32),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Bone.text(words: 3),
            const SizedBox(height: 24),
            GridView.count(
              crossAxisCount: 4,
              shrinkWrap: true,
              mainAxisSpacing: 12,
              crossAxisSpacing: 12,
              physics: const NeverScrollableScrollPhysics(),
              childAspectRatio: 1.55,
              children: List.generate(
                4,
                (_) => Card(
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Bone.circle(size: 44),
                        const Spacer(),
                        Bone.text(words: 1),
                        const SizedBox(height: 8),
                        Bone.text(words: 2),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 24),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: List.generate(
                    7,
                    (_) => const Padding(
                      padding: EdgeInsets.symmetric(vertical: 12),
                      child: Bone.text(words: 8),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
