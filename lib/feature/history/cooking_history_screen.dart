import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cookly/core/services/history_service.dart';
import 'package:cookly/core/theme/app_colors.dart';
import 'package:cookly/feature/recipe_details/recipe_details_screen.dart';
import 'package:flutter/material.dart';

class CookingHistoryScreen extends StatelessWidget {
  CookingHistoryScreen({super.key});

  final HistoryService _historyService = HistoryService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundCream,
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
              child: Row(
                children: [
                  InkWell(
                    borderRadius: BorderRadius.circular(12),
                    onTap: () => Navigator.pop(context),
                    child: const Padding(
                      padding: EdgeInsets.all(6),
                      child: Icon(
                        Icons.arrow_back_ios_new,
                        size: 18,
                        color: AppColors.textPrimary,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Container(
                    height: 28,
                    width: 6,
                    decoration: BoxDecoration(
                      color: AppColors.brandBlue,
                      borderRadius: BorderRadius.circular(6),
                    ),
                  ),
                  const SizedBox(width: 10),
                  const Text(
                    'Cooking History',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary,
                      fontSize: 24,
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                stream: _historyService.historyStream(limit: 10),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                      child: CircularProgressIndicator(
                        color: AppColors.brandCoral,
                      ),
                    );
                  }

                  final docs = snapshot.data?.docs ?? [];
                  if (docs.isEmpty) {
                    return _buildEmptyState();
                  }

                  return ListView.separated(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                    itemCount: docs.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 12),
                    itemBuilder: (context, index) {
                      final entry = docs[index].data();
                      final recipeId = entry['recipeId'] as String?;

                      if (recipeId == null || recipeId.isEmpty) {
                        return const SizedBox();
                      }

                      return FutureBuilder<
                        DocumentSnapshot<Map<String, dynamic>>
                      >(
                        future: FirebaseFirestore.instance
                            .collection('recipes')
                            .doc(recipeId)
                            .get(),
                        builder: (context, recipeSnap) {
                          if (!recipeSnap.hasData) {
                            return const SizedBox();
                          }

                          final data = recipeSnap.data?.data();
                          if (data == null) return const SizedBox();

                          return Container(
                            decoration: BoxDecoration(
                              color: AppColors.white,
                              borderRadius: BorderRadius.circular(16),
                              boxShadow: [
                                BoxShadow(
                                  color: AppColors.shadowBlack10,
                                  blurRadius: 10,
                                  offset: const Offset(0, 4),
                                ),
                              ],
                            ),
                            child: ListTile(
                              contentPadding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 8,
                              ),
                              title: Text(
                                data['name'] ?? 'Recipe',
                                style: const TextStyle(
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.textPrimary,
                                ),
                              ),
                              subtitle: Text(
                                "${data['time'] ?? '-'} Min • ${data['calories'] ?? '-'} Cal",
                                style: const TextStyle(
                                  color: AppColors.textSecondary,
                                ),
                              ),
                              trailing: Container(
                                height: 28,
                                width: 28,
                                decoration: BoxDecoration(
                                  color: AppColors.backgroundCreamAlt,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: const Icon(
                                  Icons.arrow_forward_ios,
                                  size: 14,
                                  color: AppColors.textMuted,
                                ),
                              ),
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => RecipeDetailsScreen(
                                      recipeId: recipeId,
                                      title: data['name'] ?? '',
                                      time: "${data['time']} Min",
                                      calories: "${data['calories']} Cal",
                                      imageUrl: data['imageURL'] ?? '',
                                      ingredients: data['ingredients'] ?? '',
                                      description: data['description'] ?? '',
                                      recipe: data,
                                    ),
                                  ),
                                );
                              },
                            ),
                          );
                        },
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.history_toggle_off_rounded,
            size: 80,
            color: AppColors.brandCoral.withValues(alpha: 0.3),
          ),
          const SizedBox(height: 16),
          const Text(
            "No cooking history yet",
            style: TextStyle(
              fontSize: 20,
              color: AppColors.textPrimary,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            "Your recent recipes will show up here.",
            style: TextStyle(color: Colors.grey),
          ),
        ],
      ),
    );
  }
}
