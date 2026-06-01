import 'package:cookly/core/widgets/categories.dart';
import 'package:cookly/feature/home/presentation/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:cookly/core/widgets/home_header.dart';
import 'package:cookly/core/widgets/home_searchbar.dart';
import 'package:cookly/core/widgets/promocard.dart';
import 'package:cookly/core/widgets/quick_easy_section.dart';
import 'package:cookly/core/widgets/all_recipes_section.dart';
import 'package:cookly/core/widgets/filtered_recipe_list.dart';


class HomeContentState extends State<HomeContent> {
  String selectedCategory = 'All';
  String searchQuery = "";
  final TextEditingController searchController = TextEditingController();

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const HomeHeader(),
            const SizedBox(height: 16),
            
            // Pass the controller and logic to the search bar
            HomeSearchbar(
              controller: searchController,
              onChanged: (value) {
                setState(() {
                  searchQuery = value.toLowerCase();
                });
              },
            ),
            
            const SizedBox(height: 16),
            const Promocard(),
            const SizedBox(height: 24),

            Categories(
              onCategorySelected: (category) {
                setState(() {
                  selectedCategory = category;
                });
              },
            ),

            const SizedBox(height: 24),

            if (searchQuery.isNotEmpty || selectedCategory != 'All') ...[
              Text(
                searchQuery.isNotEmpty 
                    ? "Searching for '$searchQuery' in $selectedCategory" 
                    : '$selectedCategory Recipes',
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              
              FilteredRecipeList(
                category: selectedCategory, 
                searchQuery: searchQuery,
              ),
            ] 
            else ...[
              const QuickEasySection(),
              const SizedBox(height: 24),
              const AllRecipesSection(),
            ],
          ],
        ),
      ),
    );
  }
}
