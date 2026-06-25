import 'package:flutter/material.dart';

import 'package:mdm/core/theme/app_colors.dart';

// >>> QualityBadge =======================
class QualityBadge extends StatelessWidget {
  final String label;
  final Color? color;

  const QualityBadge({
    super.key,
    required this.label,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color ?? AppColors.info,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        label,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 12,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
// <<< QualityBadge =======================
