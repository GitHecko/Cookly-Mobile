//import 'package:cookly/feature/Add%20Recipe/add_recipe_screen.dart';
import 'package:flutter/material.dart';

class HomeHeader extends StatelessWidget {
  const HomeHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Expanded(
          child: Text(
            'What are you cooking today?',
            textAlign: TextAlign.left,
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
        ),
        // InkWell(
        //  onTap: () {
        //   Navigator.push(
        // context,
        //   MaterialPageRoute(builder: (context) => AddRecipeScreen()),
        //   );
        //  },
        //  child: const CircleAvatar(
        //   backgroundColor: Colors.white,
        //  child: Icon(Icons.add, color: Colors.black),
        //  ),
        // ),
      ],
    );
  }
}
