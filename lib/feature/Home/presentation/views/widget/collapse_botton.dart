import 'package:flutter/material.dart';

class CollapseButton extends StatelessWidget {
  final bool isExpanded;
  final VoidCallback onTap;
  const CollapseButton({
    super.key,
    required this.isExpanded,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(bottom: 20),
      child: IconButton(
        icon: Icon(
          isExpanded ? Icons.arrow_back_ios : Icons.arrow_forward_ios,
          color: Colors.white.withValues(alpha: 0.7),
        ),
        onPressed: onTap,
      ),
    );
  }
}
