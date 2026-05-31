import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cookly/core/theme/app_colors.dart';
import 'package:cookly/feature/recipe_details/recipe_details_screen.dart';
import 'package:flutter/material.dart';

class Promocard extends StatelessWidget {
  const Promocard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 160,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.brandCoral,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Cook the best\nrecipes at home',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 12),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: Colors.black,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),

                  onPressed: () async {
                    var snapshot = await FirebaseFirestore.instance
                        .collection('recipes')
                        .get();

                    if (snapshot.docs.isNotEmpty) {
                      var randomDoc = (snapshot.docs..shuffle()).first;
                      var data = randomDoc.data();

                      if (!context.mounted) return;
                      Navigator.push(
                        context,
                        PageRouteBuilder(
                          pageBuilder:
                              (context, animation, secondaryAnimation) =>
                                  RecipeDetailsScreen(
                                    recipeId: randomDoc.id,
                                    title: data['name'] ?? '',
                                    time: "${data['time']} Min",
                                    calories: "${data['calories']} Cal",
                                    imageUrl: data['imageURL'] ?? '',
                                    ingredients: data['ingredients'] ?? '',
                                    description: data['description'] ?? '',
                                    recipe: data,
                                  ),
                          transitionsBuilder:
                              (context, animation, secondaryAnimation, child) {
                                return FadeTransition(
                                  opacity: animation,
                                  child: child,
                                );
                              },
                        ),
                      );
                    }
                  },
                  child: const Text('Explore'),
                ),
              ],
            ),
          ),
          const Icon(Icons.restaurant, size: 80, color: Colors.white70),
        ],
      ),
    );
  }
}
