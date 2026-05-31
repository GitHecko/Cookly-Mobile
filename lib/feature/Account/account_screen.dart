import 'package:cookly/core/theme/app_colors.dart';
import 'package:cookly/feature/Account/widgets/profile_header.dart';
import 'package:cookly/feature/Account/widgets/settings_list.dart';
import 'package:cookly/feature/Account/widgets/stats_row.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AccountScreen extends StatelessWidget {
  const AccountScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    return Scaffold(
      backgroundColor: AppColors.backgroundCreamAlt,
      body: Column(
        children: [
          ProfileHeader(user: user),
          const SizedBox(height: 10),
          StatsRow(userId: user?.uid),
          const SizedBox(height: 6),
          Expanded(
            child: SafeArea(
              top: false,
              child: SingleChildScrollView(child: SettingsList(user: user)),
            ),
          ),
        ],
      ),
    );
  }
}
