import 'package:flutter/material.dart';
import 'package:skeletonizer/skeletonizer.dart';

class LoadingWidget extends StatelessWidget {
  const LoadingWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Skeletonizer(
        enabled: true,
        child: CustomScrollView(
          slivers: [
            // AppBar وهمي
            SliverAppBar(
              title: Bone.text(words: 2),
              expandedHeight: 200,
              flexibleSpace: const FlexibleSpaceBar(),
            ),
            // محتوى وهمي
            SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, index) => Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Bone.text(words: 4),
                          const SizedBox(height: 8),
                          Bone.text(words: 10),
                          const SizedBox(height: 12),
                          Row(
                            children: [
                              const Bone.circle(size: 40),
                              const SizedBox(width: 12),
                              Expanded(child: Bone.text()),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                childCount: 5,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
