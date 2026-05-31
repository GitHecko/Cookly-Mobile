import 'package:cookly/core/theme/app_colors.dart';
import 'package:cookly/feature/auth/cubit/auth_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void showLogoutDialog(BuildContext context) {
  showDialog(
    context: context,
    builder: (innerContext) => AlertDialog(
      backgroundColor: AppColors.backgroundCreamAlt,
      title: const Text("Logout", style: TextStyle(color: AppColors.brandBlue)),
      content: const Text("Are you sure you want to sign out?"),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(innerContext),
          child: const Text("Cancel", style: TextStyle(color: Colors.grey)),
        ),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.brandCoralAlt,
          ),
          onPressed: () async {
            Navigator.pop(innerContext); // Close dialog

            // 1. Perform Cubit Logout
            await context.read<AuthCubit>().logout();

            // 2. HARD RESET Navigation to Login Screen
            if (context.mounted) {
              Navigator.pushNamedAndRemoveUntil(
                context,
                '/login',
                (route) =>
                    false, // This removes all previous screens from memory
              );
            }
          },
          child: const Text("Logout", style: TextStyle(color: Colors.white)),
        ),
      ],
    ),
  );
}
