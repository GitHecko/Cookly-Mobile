import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cookly/core/theme/app_colors.dart';
import 'package:cookly/core/widgets/TextField.dart';
import 'package:cookly/core/widgets/show_loading_dialog.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class AddRecipeScreen extends StatefulWidget {
  const AddRecipeScreen({super.key});

  @override
  State<AddRecipeScreen> createState() => _AddRecipeScreenState();
}

class _AddRecipeScreenState extends State<AddRecipeScreen> {
  final nameController = TextEditingController();
  final descController = TextEditingController();
  final calorieController = TextEditingController();
  final ingredientController = TextEditingController();
  final timeController = TextEditingController();

  String selectedCategory = 'Dinner';
  final List<String> categories = [
    'Breakfast',
    'Lunch',
    'Dinner',
    'Vegan',
    'Dessert',
  ];

  // --- OPTION 1: MANUAL SAVE ---
  void _saveRecipeManual() async {
    if (nameController.text.isEmpty || descController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Please fill in the name and description"),
          behavior: SnackBarBehavior.floating,
          dismissDirection: DismissDirection.vertical,
          showCloseIcon: true,
        ),
      );
      return;
    }

    showLoadingDialog(context);

    try {
      await FirebaseFirestore.instance.collection('recipes').add({
        'name': nameController.text.trim(),
        'nameLower': nameController.text.trim().toLowerCase(),
        'description': descController.text.trim(),
        'calories': int.tryParse(calorieController.text.trim()) ?? 0,
        'time': int.tryParse(timeController.text.trim()) ?? 0,
        'ingredients': ingredientController.text.trim(),
        'category': selectedCategory,
        'imageURL': "",
        'createdAt': FieldValue.serverTimestamp(),
      });

      if (mounted) {
        Navigator.of(context, rootNavigator: true).pop();
        Navigator.pop(context);
        _showSuccessSnackBar("Manual recipe added!");
      }
    } catch (e) {
      _handleError(e);
    }
  }

  // --- OPTION 2: SCRIPT UPLOAD ---
  void _runAutoScript() async {
    showLoadingDialog(context);
    try {
      await uploadAllRecipes(); // Runs the 7-recipe script
      if (mounted) {
        Navigator.of(context, rootNavigator: true).pop();
        Navigator.pop(context);
        _showSuccessSnackBar("All recipes added via script!");
      }
    } catch (e) {
      _handleError(e);
    }
  }

  void _showSuccessSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.green,
        behavior: SnackBarBehavior.floating,
        dismissDirection: DismissDirection.vertical,
        showCloseIcon: true,
      ),
    );
  }

  void _handleError(dynamic e) {
    if (mounted) {
      Navigator.of(context, rootNavigator: true).pop();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Error: ${e.toString()}"),
          backgroundColor: Colors.red,
          behavior: SnackBarBehavior.floating,
          dismissDirection: DismissDirection.vertical,
          showCloseIcon: true,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundCreamAlt,
      appBar: AppBar(
        backgroundColor: AppColors.brandBlue,
        title: const Text(
          "Add New Recipe",
          style: TextStyle(color: Colors.white),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Textfield(
              controller: nameController,
              label: 'Recipe Name',
              hint: 'e.g. Cheese Pizza',
              icon: Icons.restaurant_menu,
            ),
            const SizedBox(height: 20),

            const Text(
              "Category",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: Colors.grey.shade300),
              ),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  value: selectedCategory,
                  isExpanded: true,
                  items: categories
                      .map((c) => DropdownMenuItem(value: c, child: Text(c)))
                      .toList(),
                  onChanged: (val) => setState(() => selectedCategory = val!),
                ),
              ),
            ),

            const SizedBox(height: 20),
            Textfield(
              controller: descController,
              label: 'Description',
              hint: 'Describe your dish',
              icon: Icons.description,
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: Textfield(
                    controller: calorieController,
                    label: 'Calories',
                    hint: '500',
                    icon: Icons.bolt,
                  ),
                ),
                const SizedBox(width: 15),
                Expanded(
                  child: Textfield(
                    controller: timeController,
                    label: 'Time (mins)',
                    hint: '30',
                    icon: Icons.timer,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Textfield(
              controller: ingredientController,
              label: 'Ingredients',
              hint: 'Cheese, Dough, Sauce...',
              icon: Icons.list,
            ),

            const SizedBox(height: 40),

            // --- BUTTON 1: MANUAL ---
            _buildActionButton(
              text: "Save Recipe Manually",
              color: AppColors.brandCoralAlt,
              onTap: _saveRecipeManual,
            ),

            const SizedBox(height: 15),

            // --- BUTTON 2: SCRIPT ---
            _buildActionButton(
              text: "Run Auto-Upload Script",
              color: AppColors.brandBlue, // Different color to distinguish
              onTap: _runAutoScript,
            ),
            const SizedBox(height: 15),

            // --- NEW BUTTON 3: ADD INSTRUCTIONS ---
            _buildActionButton(
              text: "Add Instructions to Recipes",
              color: Colors.teal, // Distinct color for instructions
              onTap: addInstructionsToRecipes,
            ),

            //BUTTON 4: REMOVE SCRIPT RECIPES
            // Inside your Column, below the other buttons:
            const SizedBox(height: 15),

            _buildActionButton(
              text: "Remove Script Recipes",
              color: Colors
                  .grey, // Grey color to show it's a utility/danger button
              onTap: () async {
                showLoadingDialog(context);
                try {
                  await removeScriptRecipes();
                  if (mounted) {
                    // ignore: use_build_context_synchronously
                    Navigator.of(context, rootNavigator: true).pop();
                    // ignore: use_build_context_synchronously
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text("Script recipes removed!"),
                        backgroundColor: Colors.orange,
                        behavior: SnackBarBehavior.floating,
                        dismissDirection: DismissDirection.vertical,
                        showCloseIcon: true,
                      ),
                    );
                  }
                } catch (e) {
                  _handleError(e);
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionButton({
    required String text,
    required Color color,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Container(
        height: 60,
        width: double.infinity,
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(30),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.1),
              blurRadius: 10,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Center(
          child: Text(
            text,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}

Future<void> removeScriptRecipes() async {
  final CollectionReference recipes = FirebaseFirestore.instance.collection(
    'recipes',
  );

  // List of IDs created by the 20-recipe script
  List<String> idsToRemove = [
    "breakfast_01",
    "breakfast_02",
    "breakfast_03",
    "breakfast_04",
    "lunch_01",
    "lunch_02",
    "lunch_03",
    "lunch_04",
    "dinner_01",
    "dinner_02",
    "dinner_03",
    "dinner_04",
    "dinner_05",
    "dinner_06",
    "vegan_01",
    "vegan_02",
    "vegan_03",
    "vegan_04",
    "dessert_01",
    "dessert_02",
    "dessert_03",
  ];

  for (String id in idsToRemove) {
    await recipes.doc(id).delete();
  }
  if (kDebugMode) {
    debugPrint("Cleanup complete: 20 recipes removed.");
  }
}

Future<void> uploadAllRecipes() async {
  final CollectionReference recipes = FirebaseFirestore.instance.collection(
    'recipes',
  );

  List<Map<String, dynamic>> data = [
    // BREAKFAST
    {
      "name": "Shakshuka with Feta",
      "category": "Breakfast",
      "time": 30,
      "calories": 320,
      "imageURL": "assets/images/shakshuka.jpg",
      "ingredients":
          "4 Large eggs, 1 can (400g) Diced tomatoes, 1 tbsp Tomato paste, 1 Red bell pepper (diced), 1 medium Onion, 2 cloves Garlic, 50g Feta cheese, 1 tsp Cumin, 1 tsp Smoked paprika, 2 tbsp Olive oil",
      "description":
          "A vibrant North African and Middle Eastern dish of eggs poached in a simmering, spiced tomato and bell pepper sauce. Finished with salty feta crumbles and fresh parsley, it is the ultimate savory breakfast.",
      "recipeId": "breakfast_05",
    },
    {
      "name": "Fluffy Blueberry Pancakes",
      "category": "Breakfast",
      "time": 20,
      "calories": 380,
      "imageURL": "assets/images/blueberry_pancakes.jpg",
      "ingredients":
          "200g All-purpose flour, 2 tbsp Sugar, 1 tbsp Baking powder, 1/2 tsp Salt, 1 Large egg, 250ml Milk, 50g Melted butter, 150g Fresh blueberries, 1 tsp Vanilla extract",
      "description":
          "Thick and airy American-style pancakes bursting with warm, juicy blueberries. These golden-brown stacks offer a perfect balance of sweetness and tang, traditionally served with a generous pour of maple syrup.",
      "recipeId": "breakfast_06",
    },
    {
      "name": "Overnight Oats with Chia",
      "category": "Breakfast",
      "time": 10,
      "calories": 290,
      "imageURL": "assets/images/overnight_oats.jpg",
      "ingredients":
          "50g Rolled oats, 120ml Almond milk, 1 tbsp Chia seeds, 1 tbsp Honey, 1/2 tsp Cinnamon, 30g Sliced almonds, 50g Fresh berries",
      "description":
          "A convenient and heart-healthy breakfast prepared the night before. The oats and chia seeds soak up the almond milk to create a creamy, pudding-like consistency, layered with crunchy almonds and seasonal fruit.",
      "recipeId": "breakfast_07",
    },

    // SNACKS
    {
      "name": "Classic Hummus",
      "category": "Snacks",
      "time": 15,
      "calories": 160,
      "imageURL": "assets/images/classic_hummus.jpg",
      "ingredients":
          "1 can (400g) Chickpeas, 60ml Tahini, 2 tbsp Lemon juice, 1 small clove Garlic, 1/2 tsp Salt, 2 tbsp Olive oil, 1/2 tsp Paprika (for garnish)",
      "description":
          "A smooth and velvety Levantine dip made from cooked, mashed chickpeas blended with rich tahini and zesty lemon. It provides a savory, nutty flavor profile that pairs perfectly with warm pita bread or fresh vegetable sticks.",
      "recipeId": "snack_01",
    },
    {
      "name": "Crispy Air-Fryer Chickpeas",
      "category": "Snacks",
      "time": 20,
      "calories": 140,
      "imageURL": "assets/images/crispy_air_fryer_chickpeas.jpg",
      "ingredients":
          "1 can (400g) Chickpeas, 1 tbsp Olive oil, 1/2 tsp Salt, 1/2 tsp Garlic powder, 1/4 tsp Cayenne pepper, 1/2 tsp Cumin",
      "description":
          "A highly addictive, protein-packed alternative to potato chips. These chickpeas are roasted until intensely crunchy and tossed in a bold blend of smoky and spicy seasonings for a satisfying midday pick-me-way.",
      "recipeId": "snack_02",
    },
    {
      "name": "Caprese Skewers",
      "category": "Snacks",
      "time": 10,
      "calories": 120,
      "imageURL": "assets/images/caprese_skewers.jpg",
      "ingredients":
          "200g Cherry tomatoes, 200g Mini mozzarella balls, 1 bunch Fresh basil leaves, 2 tbsp Balsamic glaze, 1 tbsp Extra virgin olive oil, Pinch of Sea salt",
      "description":
          "A bite-sized version of the classic Italian salad. These elegant skewers feature the refreshing trio of juicy tomatoes, creamy mozzarella, and aromatic basil, finished with a sweet and tangy balsamic drizzle.",
      "recipeId": "snack_03",
    },
    {
      "name": "Homemade Granola Bars",
      "category": "Snacks",
      "time": 40,
      "calories": 210,
      "imageURL": "assets/images/homemade_granola_bars.jpg",
      "ingredients":
          "200g Rolled oats, 100g Honey, 60g Peanut butter, 50g Mini chocolate chips, 30g Chopped walnuts, 1/2 tsp Vanilla, Pinch of Salt",
      "description":
          "Nutritious and chewy bars that provide a natural energy boost. Combining the heartiness of toasted oats with the creamy richness of peanut butter and a hint of dark chocolate, these are perfect for on-the-go snacking.",
      "recipeId": "snack_04",
    },

    // DRINKS
    {
      "name": "Iced Spanish Latte",
      "category": "Drinks",
      "time": 5,
      "calories": 180,
      "imageURL": "assets/images/iced_spanish_latte.jpg",
      "ingredients":
          "2 shots Espresso (60ml), 200ml Whole milk, 2 tbsp Condensed milk, 1 cup Ice cubes, 1/4 tsp Cinnamon (optional)",
      "description":
          "A sophisticated, creamy coffee treat that balances the bold intensity of double-shot espresso with the silky sweetness of condensed milk. Served over ice, it is a refreshing and indulgent pick-me-up.",
      "recipeId": "drink_01",
    },
    {
      "name": "Fresh Mint Lemonade",
      "category": "Drinks",
      "time": 10,
      "calories": 90,
      "imageURL": "assets/images/fresh_mint_lemonade.jpg",
      "ingredients":
          "3 large Lemons (juiced), 1L Cold water, 100g Sugar, 1/2 cup Fresh mint leaves, Ice cubes, Lemon slices for garnish",
      "description":
          "The ultimate summer thirst-quencher. This bright and zesty lemonade is blended with fresh, aromatic mint leaves to create a cooling, citrusy drink that is both crisp and revitalizing.",
      "recipeId": "drink_02",
    },
    {
      "name": "Strawberry Banana Smoothie",
      "category": "Drinks",
      "time": 5,
      "calories": 210,
      "imageURL": "assets/images/strawberry_banana_smoothie.jpg",
      "ingredients":
          "200g Frozen strawberries, 1 ripe Banana, 250ml Greek yogurt, 100ml Apple juice, 1 tbsp Honey",
      "description":
          "A thick and creamy fruit blend that is as nutritious as it is delicious. The sweetness of ripe bananas perfectly complements the tartness of the strawberries and Greek yogurt, creating a smooth, vibrant pink beverage.",
      "recipeId": "drink_03",
    },
  ];

  for (var recipe in data) {
    recipe['nameLower'] = recipe['name'].toString().toLowerCase();
    recipe['createdAt'] = FieldValue.serverTimestamp();

    await recipes.doc(recipe['recipeId']).set(recipe);
  }

  if (kDebugMode) {
    debugPrint("Database populated with 14 detailed recipes across 5 categories!");
  }
}

Future<void> addInstructionsToRecipes() async {
  final CollectionReference recipes = FirebaseFirestore.instance.collection(
    'recipes',
  );

  // Map containing ONLY the recipeId and the new instructions field
  List<Map<String, dynamic>> instructionData = [
    // Add these to your instructionData list inside addInstructionsToRecipes()
    {
      "recipeId": "burger_05",
      "instructions": [
        "Divide your ground beef into 100g balls; do not form them into patties yet.",
        "Heat a cast-iron skillet or griddle until smoking hot and lightly grease with oil.",
        "Place a beef ball on the skillet and use a heavy spatula to 'smash' it completely flat.",
        "Season immediately with salt and pepper, and cook for 2 minutes until a dark crust forms.",
        "Flip the patty, add a slice of American cheese, and cover with a lid for 30 seconds to melt.",
        "Place the patty on a toasted brioche bun with burger sauce, pickles, and onions.",
      ],
    },
  ];

  for (var data in instructionData) {
    // We use .update() so we only add the 'instructions' field
    // to the existing document without touching the other fields.
    await recipes.doc(data['recipeId']).update({
      'instructions': data['instructions'],
    });
  }

  if (kDebugMode) {
    debugPrint("Instructions successfully added to existing recipes!");
  }
}
