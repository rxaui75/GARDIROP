import 'package:cloud_firestore/cloud_firestore.dart';

import '../application/onboarding_controller.dart';

class OnboardingRepository {
  OnboardingRepository(this._firestore);

  final FirebaseFirestore _firestore;

  Future<void> saveOnboarding({
    required String uid,
    required OnboardingState state,
  }) async {
    final styleDna = state.styleDna;

    await _firestore.collection('users').doc(uid).set(
      {
        'stylingFor': state.stylingFor,
        'likedStyles': state.likedStyles,
        'dislikedStyles': state.dislikedStyles,
        'styleVibes': state.styleVibes,
        'occasions': state.occasions,
        'size': state.size,
        'fitPreference': state.fitPreference,
        'heightCm': state.heightCm,
        'weightKg': state.weightKg,

        'styleDna': styleDna == null
            ? null
            : {
          'tags': styleDna.tags,
          'highlights': styleDna.highlights,
        },

        'onboardingCompleted': state.onboardingCompleted,

        'updatedAt': FieldValue.serverTimestamp(),
      },
      SetOptions(
        merge: true,
      ),
    );
  }
}