import 'package:cookly/core/services/favorites_service.dart';
import 'package:cookly/core/services/history_service.dart';
import 'package:cookly/core/theme/app_colors.dart';
import 'package:cookly/feature/recipe_details/cooking_steps.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class RecipeDetailsScreen extends StatefulWidget {
  final String recipeId;
  final String title;
  final String time;
  final String calories;
  final String imageUrl;
  final String ingredients;
  final String description;
  final Map<String, dynamic> recipe;
  final bool recordHistory;

  const RecipeDetailsScreen({
    super.key,
    required this.recipeId,
    required this.title,
    required this.time,
    required this.calories,
    required this.imageUrl,
    required this.ingredients,
    required this.description,
    required this.recipe,
    this.recordHistory = true,
  });

  @override
  State<RecipeDetailsScreen> createState() => _RecipeDetailsScreenState();
}

class _RecipeDetailsScreenState extends State<RecipeDetailsScreen> {
  final FavoritesService _favoritesService = FavoritesService();
  final HistoryService _historyService = HistoryService();
  
  // CUSTOM TOP OVERLAY NOTIFICATION
  void _showCustomToast(BuildContext context, String message) {
    OverlayState? overlayState = Overlay.of(context);
    late OverlayEntry overlayEntry;

    overlayEntry = OverlayEntry(
      builder: (context) => Positioned(
        top: MediaQuery.of(context).padding.top + 10, // Just below the notch
        left: 20,
        right: 20,
        child: Material(
          color: Colors.transparent,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: AppColors.textPrimary,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.3),
                  blurRadius: 10,
                  offset: const Offset(0, 5),
                ),
              ],
            ),
            child: Row(
              children: [
                const Icon(Icons.favorite_rounded, color: AppColors.brandCoral),
                const SizedBox(width: 15),
                Expanded(
                  child: Text(
                    message,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );

    overlayState.insert(overlayEntry);
    Future.delayed(const Duration(seconds: 2), () => overlayEntry.remove());
  }

  @override
  void initState() {
    super.initState();
    if (widget.recordHistory) {
      _historyService.recordAccess(widget.recipeId);
    }
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;

    List<String> ingredientsList = widget.ingredients.isNotEmpty
        ? widget.ingredients.split(',').map((e) => e.trim()).toList()
        : [];

    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          // Background Image
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            height: size.height * 0.5,
            child: widget.imageUrl.startsWith('http')
                ? Image.network(
                    widget.imageUrl,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stack) =>
                        Container(color: Colors.grey),
                  )
                : (widget.imageUrl.isNotEmpty
                    ? Image.asset(widget.imageUrl, fit: BoxFit.cover)
                    : Container(color: Colors.grey)),
          ),

          // Scrollable Content
          SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(height: size.height * 0.43),
                Container(
                  padding: const EdgeInsets.all(16),
                  width: size.width,
                  decoration: const BoxDecoration(
                    color: AppColors.backgroundCream,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(50),
                      topRight: Radius.circular(50),
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Center(
                        child: Container(
                          width: 50,
                          height: 5,
                          decoration: BoxDecoration(
                            color: Colors.grey[300],
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ),
                      const SizedBox(height: 25),
                      Text(
                        widget.title,
                        style: const TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 15),
                      Row(
                        children: [
                          _buildInfoItem(Icons.timer, widget.time),
                          const SizedBox(width: 20),
                          _buildInfoItem(
                            Icons.local_fire_department,
                            widget.calories,
                          ),
                        ],
                      ),
                      const SizedBox(height: 30),
                      const Text(
                        "Description",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        widget.description,
                        style: const TextStyle(
                          fontSize: 16,
                          color: Colors.black87,
                          height: 1.5,
                        ),
                      ),
                      const SizedBox(height: 30),
                      const Text(
                        "Ingredients",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 12),
                      ...ingredientsList.map(
                        (item) => Padding(
                          padding: const EdgeInsets.only(bottom: 12.0),
                          child: Row(
                            children: [
                              const Icon(
                                Icons.check_circle,
                                size: 18,
                                color: AppColors.brandCoral,
                              ),
                              const SizedBox(width: 10),
                              Text(item, style: const TextStyle(fontSize: 16)),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 30),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () {
                            List<dynamic> instructionsData =
                                widget.recipe['instructions'] ?? [];

                            List<String> cookingSteps = instructionsData
                                .map((e) => e.toString())
                                .toList();

                            if (cookingSteps.isEmpty) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text(
                                    "No detailed steps available for this recipe yet!",
                                  ),
                                  behavior: SnackBarBehavior.floating,
                                  dismissDirection: DismissDirection.vertical,
                                  showCloseIcon: true,
                                ),
                              );
                              return;
                            }

                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => CookingStepsScreen(
                                  title: widget.title,
                                  steps: cookingSteps,
                                  // FIXED: Changed character range [^0-8] to [^0-9] to handle numbers like 90 correctly.
                                  recipeTime: int.tryParse(widget.time.replaceAll(RegExp(r'[^0-9]'), '')) ?? 5, 
                                ),
                              ),
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.brandBlue,
                            padding: const EdgeInsets.symmetric(vertical: 15),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15),
                            ),
                          ),
                          child: const Text(
                            "Start Cooking",
                            style: TextStyle(color: Colors.white, fontSize: 18),
                          ),
                        ),
                      ),
                      const SizedBox(height: 50),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Top Action Buttons
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: const CircleAvatar(
                      backgroundColor: Colors.white,
                      child: Icon(Icons.arrow_back, color: Colors.black),
                    ),
                  ),
                  StreamBuilder<bool>(
                    stream: _favoritesService.isFavoriteStream(widget.recipeId),
                    builder: (context, snapshot) {
                      final isFav = snapshot.data ?? false;

                      return GestureDetector(
                        onTap: () async {
                          HapticFeedback.lightImpact();
                          Feedback.forTap(context);
                          final result = await _favoritesService.toggleFavorite(
                            widget.recipeId,
                          );
                          if (!mounted || result == null) return;
                          _showCustomToast(
                            this.context,
                            result
                                ? "Added to Favorites ❤️"
                                : "Removed from Favorites",
                          );
                        },
                        child: CircleAvatar(
                          backgroundColor: Colors.white,
                          child: Icon(
                            isFav ? Icons.favorite : Icons.favorite_border,
                            color: AppColors.brandCoral,
                          ),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoItem(IconData icon, String text) {
    return Row(
      children: [
        Icon(icon, color: AppColors.brandCoral, size: 20),
        const SizedBox(width: 5),
        Text(text, style: const TextStyle(fontWeight: FontWeight.w500)),
      ],
    );
  }
}