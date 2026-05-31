import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';

class HistoryService {
  HistoryService({FirebaseAuth? auth, FirebaseFirestore? db})
    : _auth = auth ?? FirebaseAuth.instance,
      _db = db ?? FirebaseFirestore.instance;

  final FirebaseAuth _auth;
  final FirebaseFirestore _db;

  CollectionReference<Map<String, dynamic>> _userHistoryRef(String userId) {
    return _db.collection('users').doc(userId).collection('history');
  }

  Future<void> recordAccess(String recipeId) async {
    final user = _auth.currentUser;
    if (user == null) return;

    try {
      await _db.collection('users').doc(user.uid).set({
        'updatedAt': FieldValue.serverTimestamp(),
      }, SetOptions(merge: true));

      final ref = _userHistoryRef(user.uid).doc(recipeId);
      await ref.set({
        'recipeId': recipeId,
        'accessedAt': FieldValue.serverTimestamp(),
        'accessedAtLocal': DateTime.now().millisecondsSinceEpoch,
      });

      await _trimHistory(user.uid);
    } catch (e) {
      if (kDebugMode) {
        debugPrint('History record failed: $e');
      }
    }
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> historyStream({int limit = 10}) {
    final user = _auth.currentUser;
    if (user == null) {
      return const Stream.empty();
    }

    return _userHistoryRef(
      user.uid,
    ).orderBy('accessedAtLocal', descending: true).limit(limit).snapshots();
  }

  Future<void> _trimHistory(String userId) async {
    final snapshot = await _userHistoryRef(
      userId,
    ).orderBy('accessedAtLocal', descending: true).get();

    if (snapshot.docs.length <= 10) return;

    final extraDocs = snapshot.docs.skip(10);
    for (final doc in extraDocs) {
      await doc.reference.delete();
    }
  }
}
