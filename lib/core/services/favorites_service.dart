import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FavoritesService {
  FavoritesService({FirebaseAuth? auth, FirebaseFirestore? db})
    : _auth = auth ?? FirebaseAuth.instance,
      _db = db ?? FirebaseFirestore.instance;

  final FirebaseAuth _auth;
  final FirebaseFirestore _db;

  CollectionReference _favoritesRef(String uid) =>
      _db.collection('users').doc(uid).collection('favorites');

  Stream<bool> isFavoriteStream(String recipeId) {
    final user = _auth.currentUser;
    if (user == null) return Stream<bool>.value(false);

    return _favoritesRef(user.uid)
        .where('recipeId', isEqualTo: recipeId)
        .snapshots()
        .map((snapshot) => snapshot.docs.isNotEmpty);
  }

  Future<bool?> toggleFavorite(String recipeId) async {
    final user = _auth.currentUser;
    if (user == null) return null;

    final favRef = _favoritesRef(user.uid);
    final query = await favRef.where('recipeId', isEqualTo: recipeId).get();

    if (query.docs.isEmpty) {
      await favRef.add({
        'recipeId': recipeId,
        'createdAt': FieldValue.serverTimestamp(),
      });
      return true;
    }

    await favRef.doc(query.docs.first.id).delete();
    return false;
  }
}
