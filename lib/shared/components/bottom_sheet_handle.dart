import 'package:flutter/material.dart';

import 'package:mdm/core/theme/app_colors.dart';

// >>> BottomSheetHandle =======================
class BottomSheetHandle extends StatelessWidget {
  const BottomSheetHandle({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: 40,
        height: 4,
        margin: const EdgeInsets.only(top: 8),
        decoration: BoxDecoration(
          color: AppColors.textSecondaryDark.withValues(alpha: 0.3),
          borderRadius: BorderRadius.circular(2),
        ),
      ),
    );
  }
}
// <<< BottomSheetHandle =======================
