import 'package:flutter/material.dart';

import 'package:mdm/core/theme/app_colors.dart';

// >>> ProgressBarWidget =======================
class ProgressBarWidget extends StatelessWidget {
  final double progress;
  final Color? color;
  final double height;
  final bool showPercentage;

  const ProgressBarWidget({
    super.key,
    required this.progress,
    this.color,
    this.height = 4,
    this.showPercentage = false,
  });

  @override
  Widget build(BuildContext context) {
    final barColor = color ?? AppColors.downloading;
    final clampedProgress = progress.clamp(0.0, 1.0);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      mainAxisSize: MainAxisSize.min,
      children: [
        // Progress bar
        LayoutBuilder(
          builder: (context, constraints) {
            final totalWidth = constraints.maxWidth;

            return Stack(
              children: [
                // Background
                Container(
                  height: height,
                  width: totalWidth,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(height / 2),
                  ),
                ),
                // Foreground
                AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeInOut,
                  height: height,
                  width: clampedProgress * totalWidth,
                  decoration: BoxDecoration(
                    color: barColor,
                    borderRadius: BorderRadius.circular(height / 2),
                  ),
                ),
              ],
            );
          },
        ),

        // Percentage label
        if (showPercentage) ...[
          const SizedBox(height: 4),
          Text(
            '${(clampedProgress * 100).toInt()}%',
            style: Theme.of(context).textTheme.labelSmall,
          ),
        ],
      ],
    );
  }
}
// <<< ProgressBarWidget =======================
