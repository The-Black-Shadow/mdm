import 'package:flutter/material.dart';

import 'package:shimmer/shimmer.dart';

import 'package:mdm/core/theme/app_spacing.dart';

// >>> MetadataShimmer =======================
// Full-screen shimmer skeleton shown while video metadata is loading
class MetadataShimmer extends StatelessWidget {
  const MetadataShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Shimmer.fromColors(
      baseColor: isDark ? Colors.grey.shade800 : Colors.grey.shade300,
      highlightColor: isDark ? Colors.grey.shade600 : Colors.grey.shade100,
      child: const SingleChildScrollView(
        physics: NeverScrollableScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Thumbnail placeholder
            _ShimmerBlock(height: 220, borderRadius: 0),

            // Info section
            Padding(
              padding: EdgeInsets.all(AppSpacing.base),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title line 1
                  _ShimmerBlock(height: 20, width: double.infinity),
                  SizedBox(height: AppSpacing.sm),
                  // Title line 2
                  _ShimmerBlock(height: 20, width: 200),
                  SizedBox(height: AppSpacing.base),

                  // Channel row
                  Row(
                    children: [
                      _ShimmerCircle(radius: 14),
                      SizedBox(width: AppSpacing.sm),
                      _ShimmerBlock(height: 14, width: 120),
                    ],
                  ),
                  SizedBox(height: AppSpacing.md),

                  // Stats row
                  Row(
                    children: [
                      _ShimmerBlock(height: 12, width: 80),
                      SizedBox(width: AppSpacing.base),
                      _ShimmerBlock(height: 12, width: 100),
                    ],
                  ),
                  SizedBox(height: AppSpacing.xl),

                  // Description lines
                  _ShimmerBlock(height: 12, width: double.infinity),
                  SizedBox(height: AppSpacing.sm),
                  _ShimmerBlock(height: 12, width: double.infinity),
                  SizedBox(height: AppSpacing.sm),
                  _ShimmerBlock(height: 12, width: 160),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
// <<< MetadataShimmer =======================

// >>> ShimmerBlock =======================
class _ShimmerBlock extends StatelessWidget {
  final double height;
  final double? width;
  final double borderRadius;

  const _ShimmerBlock({
    required this.height,
    this.width,
    this.borderRadius = 8,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      width: width,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(borderRadius),
      ),
    );
  }
}
// <<< ShimmerBlock =======================

// >>> ShimmerCircle =======================
class _ShimmerCircle extends StatelessWidget {
  final double radius;

  const _ShimmerCircle({required this.radius});

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      radius: radius,
      backgroundColor: Colors.white,
    );
  }
}
// <<< ShimmerCircle =======================
