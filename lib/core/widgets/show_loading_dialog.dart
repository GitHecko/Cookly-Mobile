import 'package:cookly/core/theme/app_colors.dart';
import 'package:flutter/material.dart';

void showLoadingDialog(BuildContext context) {
  showDialog(
    context: context,
    barrierDismissible: false, // Prevents closing by tapping outside
    builder: (BuildContext context) {
      return Dialog(
        backgroundColor: AppColors.backgroundCreamAlt,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: const [
              CircularProgressIndicator(),
              SizedBox(height: 15),
              Text(
                "Authenticating...",
                style: TextStyle(fontSize: 16, color: AppColors.brandBlue),
              ),
            ],
          ),
        ),
      );
    },
  );
}
