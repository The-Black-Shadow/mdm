import 'package:flutter/material.dart';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:shimmer/shimmer.dart';

// >>> ThumbnailWidget =======================
class ThumbnailWidget extends StatelessWidget {
  final String url;
  final double? width;
  final double? height;
  final double borderRadius;

  const ThumbnailWidget({
    super.key,
    required this.url,
    this.width,
    this.height,
    this.borderRadius = 12,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return ClipRRect(
      borderRadius: BorderRadius.circular(borderRadius),
      child: CachedNetworkImage(
        imageUrl: url,
        width: width,
        height: height,
        memCacheWidth: 320,
        fit: BoxFit.cover,
        // Shimmer placeholder
        placeholder: (context, url) => Shimmer.fromColors(
          baseColor: isDark ? Colors.grey.shade800 : Colors.grey.shade300,
          highlightColor:
              isDark ? Colors.grey.shade600 : Colors.grey.shade100,
          child: Container(
            width: width,
            height: height,
            color: Colors.white,
          ),
        ),
        // Error fallback
        errorWidget: (context, url, error) => Container(
          width: width,
          height: height,
          color: isDark ? Colors.grey.shade800 : Colors.grey.shade200,
          child: const Icon(
            Icons.broken_image_outlined,
            color: Colors.grey,
          ),
        ),
      ),
    );
  }
}
// <<< ThumbnailWidget =======================
