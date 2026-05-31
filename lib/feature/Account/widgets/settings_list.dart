import 'package:cookly/core/theme/app_colors.dart';
import 'package:cookly/core/widgets/show_logout_dialog.dart';
import 'package:cookly/feature/history/cooking_history_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class SettingsList extends StatelessWidget {
  const SettingsList({super.key, required this.user});

  final User? user;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        children: [
          _settingsTile(
            icon: Icons.menu_book_outlined,
            title: "My Recipes",
            textColor: Colors.black,
            onTap: () => _showComingSoon(context, "My Recipes"),
          ),
          _settingsTile(
            icon: Icons.history,
            title: "Cooking History",
            textColor: Colors.black,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => CookingHistoryScreen()),
              );
            },
          ),
          _settingsTile(
            icon: Icons.notifications_none,
            title: "Notifications",
            textColor: Colors.black,
            onTap: () => _showComingSoon(context, "Notifications"),
          ),
          _settingsTile(
            icon: Icons.lock_outline,
            title: "Privacy Policy",
            textColor: Colors.black,
            onTap: () => _showPrivacyDialog(context, user?.email),
          ),
          const SizedBox(height: 12),
          const Divider(height: 24, color: AppColors.divider),
          _settingsTile(
            icon: Icons.logout,
            title: "Log Out",
            textColor: AppColors.brandCoralDeep,
            onTap: () => showLogoutDialog(context),
          ),
          const SizedBox(height: 12),
        ],
      ),
    );
  }
}

Widget _settingsTile({
  required IconData icon,
  required String title,
  required Color textColor,
  required VoidCallback onTap,
}) {
  const borderColor = AppColors.brandCoralDeep;
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 12),
    child: InkWell(
      borderRadius: BorderRadius.circular(14),
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: AppColors.backgroundCreamAlt,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: borderColor, width: 1.2),
        ),
        child: Row(
          children: [
            Icon(icon, color: borderColor, size: 20),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                title,
                style: TextStyle(
                  color: textColor,
                  fontWeight: FontWeight.w600,
                  fontSize: 14,
                ),
              ),
            ),
            const Icon(
              Icons.arrow_forward_ios,
              size: 16,
              color: AppColors.textMuted,
            ),
          ],
        ),
      ),
    ),
  );
}

void _showComingSoon(BuildContext context, String featureName) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text("$featureName is coming soon."),
      behavior: SnackBarBehavior.floating,
      dismissDirection: DismissDirection.vertical,
      showCloseIcon: true,
    ),
  );
}

void _showPrivacyDialog(BuildContext context, String? email) {
  showDialog(
    context: context,
    builder: (_) => AlertDialog(
      backgroundColor: AppColors.backgroundCreamAlt,
      title: const Text(
        "Privacy Policy",
        style: TextStyle(color: AppColors.brandBlue),
      ),
      content: Text(
        "Cookly stores account identity through Firebase Authentication and "
        "saves recipes/favorites in Cloud Firestore.\n\n"
        "Signed in as: ${email ?? 'Unknown user'}",
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text("Close", style: TextStyle(color: Colors.grey)),
        ),
      ],
    ),
  );
}
