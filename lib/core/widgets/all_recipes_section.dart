import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cookly/core/theme/app_colors.dart';
import 'package:cookly/core/widgets/recipe_card.dart';
import 'package:cookly/feature/recipe_details/recipe_details_screen.dart';
import 'package:flutter/material.dart';

class AllRecipesSection extends StatelessWidget {
  const AllRecipesSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'All Recipes',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 16),
        StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance.collection('recipes').snapshots(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(color: AppColors.brandBlue),
              );
            }

            final docs = snapshot.data?.docs ?? [];
            if (docs.isEmpty) {
              return const Center(
                child: Padding(
                  padding: EdgeInsets.only(top: 24),
                  child: Text('No recipes found.'),
                ),
              );
            }

            final screenWidth = MediaQuery.of(context).size.width;
            final cardAspectRatio = screenWidth < 360 ? 0.68 : 0.75;

            return GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: cardAspectRatio,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
              ),
              itemCount: docs.length,
              itemBuilder: (context, index) {
                final data = docs[index].data() as Map<String, dynamic>;
                final docId = docs[index].id;

                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => RecipeDetailsScreen(
                          recipeId: docId,
                          title: data['name'] ?? 'Recipe',
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
                  child: RecipeCard(
                    title: data['name'] ?? '',
                    time: "${data['time']} Min",
                    calories: "${data['calories']} Cal",
                    imageUrl: data['imageURL'] ?? '',
                    recipeId: docId,
                  ),
                );
              },
            );
          },
        ),
      ],
    );
  }
}
