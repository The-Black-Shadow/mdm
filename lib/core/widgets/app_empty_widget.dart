import 'package:flutter/material.dart';

import 'package:mdm/core/theme/app_colors.dart';

// >>> AppEmptyWidget =======================
class AppEmptyWidget extends StatelessWidget {
  final String message;
  final String? actionLabel;
  final VoidCallback? onAction;

  const AppEmptyWidget({
    super.key,
    required this.message,
    this.actionLabel,
    this.onAction,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Empty icon
          const Icon(
            Icons.inbox_outlined,
            size: 80,
            color: AppColors.textSecondaryDark,
          ),
          const SizedBox(height: 16),

          // Message
          Text(
            message,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: AppColors.textSecondaryDark,
                ),
          ),

          // Action button
          if (actionLabel != null && onAction != null) ...[
            const SizedBox(height: 16),
            TextButton(
              onPressed: onAction,
              child: Text(actionLabel!),
            ),
          ],
        ],
      ),
    );
  }
}
// <<< AppEmptyWidget =======================
