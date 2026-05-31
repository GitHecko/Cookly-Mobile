import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cookly/core/theme/app_colors.dart';
import 'package:flutter/material.dart';

class StatsRow extends StatelessWidget {
  const StatsRow({super.key, required this.userId});

  final String? userId;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance
                .collection('recipes')
                .snapshots(),
            builder: (context, snapshot) {
              final count = snapshot.data?.docs.length ?? 0;
              return _buildStatItem('$count', 'Recipes');
            },
          ),
          StreamBuilder<QuerySnapshot>(
            stream: userId == null
                ? null
                : FirebaseFirestore.instance
                      .collection('users')
                      .doc(userId)
                      .collection('favorites')
                      .snapshots(),
            builder: (context, snapshot) {
              final count = snapshot.data?.docs.length ?? 0;
              return _buildStatItem('$count', 'Saved');
            },
          ),
          _buildStatItem('Live', 'Status'),
        ],
      ),
    );
  }
}

Widget _buildStatItem(String value, String label) {
  return Column(
    children: [
      Text(
        value,
        style: const TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: AppColors.brandCoralDeep,
        ),
      ),
      Text(label, style: const TextStyle(color: AppColors.textSecondary)),
    ],
  );
}
