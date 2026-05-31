import 'package:cookly/core/theme/app_colors.dart';
import 'package:cookly/core/widgets/textfield.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ProfileHeader extends StatefulWidget {
  const ProfileHeader({super.key, required this.user});

  final User? user;

  @override
  State<ProfileHeader> createState() => _ProfileHeaderState();
}

class _ProfileHeaderState extends State<ProfileHeader> {
  User? _user;

  @override
  void initState() {
    super.initState();
    _user = widget.user;
  }

  Future<void> _reloadUser() async {
    await FirebaseAuth.instance.currentUser?.reload();
    setState(() {
      _user = FirebaseAuth.instance.currentUser;
    });
  }

  Future<void> _showEditNameDialog(String currentName) async {
    final controller = TextEditingController(text: currentName);

    await showDialog<void>(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: AppColors.backgroundCreamAlt,
          title: const Text(
            'Edit Name',
            style: TextStyle(color: AppColors.brandBlue),
          ),
          content: Textfield(
            controller: controller,
            label: 'Name',
            hint: 'Enter your name',
            icon: Icons.person,
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel', style: TextStyle(color: Colors.grey)),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.brandCoralAlt,
              ),
              onPressed: () async {
                final name = controller.text.trim();
                if (name.isNotEmpty) {
                  await FirebaseAuth.instance.currentUser?.updateDisplayName(
                    name,
                  );
                  await _reloadUser();
                }
                if (context.mounted) {
                  Navigator.pop(context);
                }
              },
              child: const Text('Save', style: TextStyle(color: Colors.white)),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final rawDisplayName = _user?.displayName?.trim() ?? "";
    final email = _user?.email ?? "";
    final emailPrefix = email.contains('@') ? email.split('@').first : "";
    final displayName = rawDisplayName.isNotEmpty
        ? rawDisplayName
        : (emailPrefix.isNotEmpty ? emailPrefix : "Chef User");
    final avatarLetter = displayName.isNotEmpty
        ? displayName.characters.first.toUpperCase()
        : "C";

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 24),
      width: double.infinity,
      decoration: const BoxDecoration(
        color: AppColors.brandBlue,
        borderRadius: BorderRadius.vertical(bottom: Radius.circular(30)),
      ),
      child: Column(
        children: [
          CircleAvatar(
            radius: 44,
            backgroundColor: Colors.white,
            child: Text(
              avatarLetter,
              style: const TextStyle(
                color: AppColors.brandBlue,
                fontSize: 32,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(height: 15),
          Center(
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const SizedBox(width: 15),
                Text(
                  displayName,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(width: 6),
                GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap: _user == null
                      ? null
                      : () => _showEditNameDialog(rawDisplayName),
                  child: const SizedBox(
                    width: 18,
                    height: 18,
                    child: Icon(Icons.edit, size: 18, color: Colors.white),
                  ),
                ),
              ],
            ),
          ),
          Text(
            email,
            style: TextStyle(color: Colors.white.withAlpha(204), fontSize: 12),
          ),
        ],
      ),
    );
  }
}
