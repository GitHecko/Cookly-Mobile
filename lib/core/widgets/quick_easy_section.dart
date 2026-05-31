import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cookly/core/theme/app_colors.dart';
import 'package:cookly/core/widgets/recipe_card.dart';
import 'package:cookly/feature/recipe_details/recipe_details_screen.dart';
import 'package:flutter/material.dart';

class QuickEasySection extends StatelessWidget {
  const QuickEasySection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Quick & Easy',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            Text(
              'View all',
              style: TextStyle(
                color: AppColors.brandCoral,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        SizedBox(
          height: 250,
          child: StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance
                .collection('recipes')
                .where('time', isLessThan: 25)
                .snapshots(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }
              if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                return const Center(child: Text("No fast recipes found."));
              }

              final docs = snapshot.data!.docs;

              return ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: docs.length,
                itemBuilder: (context, index) {
                  var data = docs[index].data() as Map<String, dynamic>;
                  String docId = docs[index].id;

                  return Padding(
                    padding: const EdgeInsets.only(right: 12.0),
                    child: GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => RecipeDetailsScreen(
                              recipeId: docId,
                              title: data['name'] ?? 'Recipe',
                              time: "${data['time']} Min",
                              calories: "${data['calories']} Cal",
                              imageUrl: data['imageURL'] ?? "",
                              ingredients: data['ingredients'] ?? "",
                              description: data['description'] ?? "",
                              recipe: data,
                            ),
                          ),
                        );
                      },
                      child: SizedBox(
                        width: 170,
                        child: RecipeCard(
                          title: data['name'] ?? 'Recipe',
                          time: "${data['time']} Min",
                          calories: "${data['calories']} Cal",
                          imageUrl: data['imageURL'] ?? "",
                          recipeId: docId,
                        ),
                      ),
                    ),
                  );
                },
              );
            },
          ),
        ),
      ],
    );
  }
}
