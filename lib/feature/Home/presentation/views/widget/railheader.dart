import 'package:finalproject/core/theme/theme_extination.dart';
import 'package:flutter/material.dart';

class RailHeader extends StatelessWidget {
  final bool isExpanded;
  const RailHeader({super.key, required this.isExpanded});

  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 300),
      child: isExpanded
          ? Container(
              padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 20),
              child: Column(
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.1),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.local_hospital,
                      size: 35,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 15),
                  Text(
                    "كلية التمريض",
                    style: context.styles.headline4.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Divider(
                    color: Colors.white.withValues(alpha: 0.2),
                    thickness: 0.5,
                  ),
                ],
              ),
            )
          : const Padding(
              padding: EdgeInsets.symmetric(vertical: 30),
              child: Icon(Icons.local_hospital, color: Colors.white, size: 30),
            ),
    );
  }
}
