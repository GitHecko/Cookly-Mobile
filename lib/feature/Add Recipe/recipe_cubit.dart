import 'package:cloud_firestore/cloud_firestore.dart';

Future<void> addRecipe({
  required String name,
  required String description,
  required int calories,
  required String ingredients,
  required int time,
}) async {
  try {
    await FirebaseFirestore.instance.collection('recipes').add({
      'name': name,
      'nameLower': name.toLowerCase(),
      'description': description,
      'calories': calories,
      'ingredients': ingredients,
      'time': time,
      'imageURL': "", // Placeholder for now
    });
  } catch (e) {
    rethrow;
  }
}
