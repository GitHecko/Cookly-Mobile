import 'package:cookly/core/theme/app_colors.dart';
import 'package:flutter/material.dart';

class Categories extends StatefulWidget {
  // Add this line to accept a function from the parent
  final Function(String) onCategorySelected;

  const Categories({super.key, required this.onCategorySelected});

  @override
  State<Categories> createState() => _CategoriesState();
}

class _CategoriesState extends State<Categories> {
  final List<String> categories = [
    'All',
    'Dinner',
    'Lunch',
    'Breakfast',
    'Dessert',
    'Snacks',
    'Drinks',
  ];
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Categories',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 12),
        SizedBox(
          height: 45,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: categories.length,
            separatorBuilder: (_, __) => const SizedBox(width: 8),
            itemBuilder: (context, index) {
              final isSelected = _selectedIndex == index;
              return ChoiceChip(
                showCheckmark: false,
                label: Text(categories[index]),
                selected: isSelected,
                selectedColor: AppColors.brandCoral,
                backgroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                  side: BorderSide(
                    color: isSelected
                        ? Colors.transparent
                        : Colors.grey.shade300,
                  ),
                ),
                labelStyle: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: isSelected ? Colors.white : Colors.black,
                ),
                onSelected: (bool selected) {
                  setState(() {
                    _selectedIndex = index;
                  });
                  widget.onCategorySelected(categories[index]);
                },
              );
            },
          ),
        ),
      ],
    );
  }
}
