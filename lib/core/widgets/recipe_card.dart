import 'package:cookly/core/services/favorites_service.dart';
import 'package:cookly/core/theme/app_colors.dart';
import 'package:cookly/core/widgets/build_recipe_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class RecipeCard extends StatelessWidget {
  final String title;
  final String time;
  final String calories;
  final String imageUrl;
  final String recipeId;

  RecipeCard({
    super.key,
    required this.title,
    required this.time,
    required this.calories,
    required this.imageUrl,
    required this.recipeId,
  });

  final FavoritesService favoritesService = FavoritesService();

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isTight = constraints.maxWidth < 160;
        final titleSize = isTight ? 13.0 : 15.0;
        final statsSize = isTight ? 10.5 : 12.0;
        final iconSize = isTight ? 14.0 : 16.0;
        final padding = isTight ? 10.0 : 12.0;
        final imageRatio = isTight ? 1.15 : (4 / 3);

        return Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(18),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.05),
                blurRadius: 10,
                offset: const Offset(0, 5),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(18),
                ),
                child: AspectRatio(
                  aspectRatio: imageRatio,
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      BuildRecipeImage(imageUrl),
                      Positioned(
                        top: 8,
                        right: 8,
                        child: _buildFavoriteButton(context),
                      ),
                    ],
                  ),
                ),
              ),
              Expanded(
                child: Padding(
                  padding: EdgeInsets.all(padding),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        title,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: titleSize,
                          height: 1.2,
                        ),
                      ),
                      FittedBox(
                        fit: BoxFit.scaleDown,
                        alignment: Alignment.centerLeft,
                        child: Row(
                          children: [
                            Icon(
                              Icons.local_fire_department,
                              size: iconSize,
                              color: AppColors.brandCoral,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              calories,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontSize: statsSize,
                                color: Colors.grey,
                              ),
                            ),
                            const SizedBox(width: 8),
                            Icon(
                              Icons.timer,
                              size: iconSize,
                              color: Colors.grey,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              time,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontSize: statsSize,
                                color: Colors.grey,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildFavoriteButton(BuildContext context) {
    return StreamBuilder<bool>(
      stream: favoritesService.isFavoriteStream(recipeId),
      builder: (context, snapshot) {
        final isFav = snapshot.data ?? false;

        return GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: () {
            HapticFeedback.lightImpact();
            Feedback.forTap(context);
            favoritesService.toggleFavorite(recipeId);
          },
          child: _favoriteIconShell(
            child: Icon(
              isFav ? Icons.favorite : Icons.favorite_border,
              size: 16,
              color: AppColors.brandCoral,
            ),
          ),
        );
      },
    );
  }

  Widget _favoriteIconShell({required Widget child}) {
    return Container(
      height: 28,
      width: 28,
      decoration: BoxDecoration(
        color: Colors.white,
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.12),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      alignment: Alignment.center,
      child: child,
    );
  }
}
