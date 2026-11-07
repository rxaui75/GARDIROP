import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../domain/gardi_outfit_analysis.dart';
import '../domain/saved_look.dart';

class SavedLooksRepository {
  SavedLooksRepository({
    FirebaseFirestore? firestore,
    FirebaseAuth? auth,
  })  : _firestore = firestore ?? FirebaseFirestore.instance,
        _auth = auth ?? FirebaseAuth.instance;

  final FirebaseFirestore _firestore;
  final FirebaseAuth _auth;

  String get _userId {
    final user = _auth.currentUser;

    if (user == null) {
      throw StateError(
        'A signed-in user is required to access saved looks.',
      );
    }

    return user.uid;
  }

  CollectionReference<Map<String, dynamic>>
  get _savedLooksCollection {
    return _firestore
        .collection('users')
        .doc(_userId)
        .collection('saved_looks');
  }

  Stream<List<SavedLook>> watchSavedLooks() {
    return _savedLooksCollection
        .orderBy(
      'createdAt',
      descending: true,
    )
        .snapshots()
        .map(
          (snapshot) => snapshot.docs
          .map(
        SavedLook.fromFirestore,
      )
          .toList(growable: false),
    );
  }

  Future<String> saveLook({
    required List<String> itemIds,
    required GardiOutfitAnalysis analysis,
  }) async {
    final uniqueItemIds = itemIds
        .where((id) => id.trim().isNotEmpty)
        .toSet()
        .toList(growable: false);

    if (uniqueItemIds.length < 2) {
      throw ArgumentError(
        'A saved look must contain at least two wardrobe items.',
      );
    }

    final document = _savedLooksCollection.doc();

    await document.set({
      'itemIds': uniqueItemIds,
      'overallAssessment':
      analysis.overallAssessment,
      'summary': analysis.summary,
      'strengths': analysis.strengths,
      'suggestions': analysis.suggestions,
      'createdAt': FieldValue.serverTimestamp(),
      'updatedAt': FieldValue.serverTimestamp(),
    });

    return document.id;
  }

  Future<void> deleteLook(
      String lookId,
      ) async {
    if (lookId.trim().isEmpty) {
      return;
    }

    await _savedLooksCollection
        .doc(lookId)
        .delete();
  }
}