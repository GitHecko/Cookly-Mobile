import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cookly/core/theme/app_colors.dart';
import 'package:cookly/core/widgets/recipe_card.dart';
import 'package:cookly/feature/recipe_details/recipe_details_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class FavoritesScreen extends StatelessWidget {
  const FavoritesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    return Scaffold(
      backgroundColor: AppColors.backgroundCream,
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
              child: Row(
                children: [
                  Container(
                    height: 28,
                    width: 6,
                    decoration: BoxDecoration(
                      color: AppColors.brandCoralAlt,
                      borderRadius: BorderRadius.circular(6),
                    ),
                  ),
                  const SizedBox(width: 10),
                  const Text(
                    "Saved Recipes",
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
              child: StreamBuilder<QuerySnapshot>(
                stream: user == null
                    ? const Stream.empty()
                    : FirebaseFirestore.instance
                          .collection('users')
                          .doc(user.uid)
                          .collection('favorites')
                          .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                      child: CircularProgressIndicator(
                        color: AppColors.brandCoral,
                      ),
                    );
                  }

                  final favDocs = snapshot.data?.docs ?? [];

                  if (favDocs.isEmpty) {
                    return _buildEmptyState();
                  }

                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: GridView.builder(
                      physics: const BouncingScrollPhysics(),
                      padding: const EdgeInsets.only(top: 8, bottom: 24),
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: 16,
                        mainAxisSpacing: 16,
                        // Using aspect ratio ensures the card stays proportionate
                        // on both narrow and wide screens (Width / Height)
                        childAspectRatio: 0.66,
                      ),
                      itemCount: favDocs.length,
                      itemBuilder: (context, index) {
                        String rId = favDocs[index]['recipeId'];

                        return FutureBuilder<DocumentSnapshot>(
                          future: FirebaseFirestore.instance
                              .collection('recipes')
                              .doc(rId)
                              .get(),
                          builder: (context, recipeSnap) {
                            if (!recipeSnap.hasData) {
                              return const SizedBox();
                            }

                            var data =
                                recipeSnap.data!.data() as Map<String, dynamic>;

                            return GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => RecipeDetailsScreen(
                                      recipe: data,
                                      recipeId: rId,
                                      title: data['name'] ?? '',
                                      time: "${data['time']} Min",
                                      calories: "${data['calories']} Cal",
                                      imageUrl: data['imageURL'] ?? '',
                                      ingredients:
                                          data['ingredients']?.toString() ?? '',
                                      description: data['description'] ?? '',
                                    ),
                                  ),
                                );
                              },
                              child: RecipeCard(
                                title: data['name'] ?? '',
                                time: "${data['time']} Min",
                                calories: "${data['calories']} Cal",
                                imageUrl: data['imageURL'] ?? '',
                                recipeId: rId,
                              ),
                            );
                          },
                        );
                      },
                    ),
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
            Icons.favorite_rounded,
            size: 80,
            color: AppColors.brandCoral.withValues(alpha: 0.3),
          ),
          const SizedBox(height: 16),
          const Text(
            "No favorites yet!",
            style: TextStyle(
              fontSize: 20,
              color: AppColors.textPrimary,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            "Heart your top picks to see them here.",
            style: TextStyle(color: Colors.grey),
          ),
        ],
      ),
    );
  }
}
