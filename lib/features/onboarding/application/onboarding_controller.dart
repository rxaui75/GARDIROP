import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../domain/style_dna.dart';
import '../domain/style_dna_generator.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../data/onboarding_repository.dart';

class OnboardingState {
  const OnboardingState({
    this.stylingFor,
    this.likedStyles = const [],
    this.dislikedStyles = const [],
    this.preferredColors = const [],
    this.fitPreference,
    this.onboardingCompleted = false,
    this.styleVibes = const [],
    this.occasions = const [],
    this.size,
    this.heightCm,
    this.weightKg,
    this.styleDna,
  });

  final String? stylingFor;
  final List<String> likedStyles;
  final List<String> dislikedStyles;
  final List<String> preferredColors;
  final String? fitPreference;
  final bool onboardingCompleted;
  final List<String> styleVibes;
  final List<String> occasions;
  final String? size;
  final double? heightCm;
  final double? weightKg;
  final StyleDna? styleDna;

  OnboardingState copyWith({
    String? stylingFor,
    List<String>? likedStyles,
    List<String>? dislikedStyles,
    List<String>? preferredColors,
    String? fitPreference,
    bool? onboardingCompleted,
    List<String>? styleVibes,
    List<String>? occasions,
    String? size,
    double? heightCm,
    double? weightKg,
    StyleDna? styleDna,
  }) {
    return OnboardingState(
      stylingFor: stylingFor ?? this.stylingFor,
      likedStyles: likedStyles ?? this.likedStyles,
      dislikedStyles: dislikedStyles ?? this.dislikedStyles,
      preferredColors: preferredColors ?? this.preferredColors,
      fitPreference: fitPreference ?? this.fitPreference,
      onboardingCompleted:
      onboardingCompleted ?? this.onboardingCompleted,
      styleVibes: styleVibes ?? this.styleVibes,
      occasions: occasions ?? this.occasions,
      size: size ?? this.size,
      heightCm: heightCm ?? this.heightCm,
      weightKg: weightKg ?? this.weightKg,
      styleDna: styleDna ?? this.styleDna,
    );
  }
}

class OnboardingController extends Notifier<OnboardingState> {
  @override
  OnboardingState build() {
    return const OnboardingState();
  }

  void setStylingFor(String value) {
    state = state.copyWith(
      stylingFor: value,
    );
  }

  void likeStyle(String styleId) {
    final liked = {...state.likedStyles, styleId}.toList();
    final disliked =
    state.dislikedStyles.where((id) => id != styleId).toList();

    state = state.copyWith(
      likedStyles: liked,
      dislikedStyles: disliked,
    );
  }

  void dislikeStyle(String styleId) {
    final disliked = {...state.dislikedStyles, styleId}.toList();
    final liked =
    state.likedStyles.where((id) => id != styleId).toList();

    state = state.copyWith(
      likedStyles: liked,
      dislikedStyles: disliked,
    );
  }

  void setPreferredColors(List<String> values) {
    state = state.copyWith(
      preferredColors: values,
    );
  }

  void setFitPreference(String value) {
    state = state.copyWith(
      fitPreference: value,
    );
  }

  void completeOnboarding() {
    state = state.copyWith(
      onboardingCompleted: true,
    );
  }

  void toggleStyleVibe(String vibe) {
    final vibes = [...state.styleVibes];

    if (vibes.contains(vibe)) {
      vibes.remove(vibe);
    } else {
      vibes.add(vibe);
    }

    state = state.copyWith(
      styleVibes: vibes,
    );
  }

  void toggleOccasion(String occasion) {
    final occasions = [...state.occasions];

    if (occasions.contains(occasion)) {
      occasions.remove(occasion);
    } else {
      occasions.add(occasion);
    }

    state = state.copyWith(
      occasions: occasions,
    );
  }

  void setSize(String value) {
    state = state.copyWith(
      size: value,
    );
  }


  void setHeight(double value) {
    state = state.copyWith(
      heightCm: value,
    );
  }

  void setWeight(double? value) {
    state = OnboardingState(
      stylingFor: state.stylingFor,
      likedStyles: state.likedStyles,
      dislikedStyles: state.dislikedStyles,
      preferredColors: state.preferredColors,
      fitPreference: state.fitPreference,
      onboardingCompleted: state.onboardingCompleted,
      styleVibes: state.styleVibes,
      occasions: state.occasions,
      size: state.size,
      heightCm: state.heightCm,
      weightKg: value,
    );
  }

  void generateStyleDna() {
    final result = StyleDnaGenerator.generate(state);

    state = state.copyWith(
      styleDna: result,
    );
  }

  Future<void> saveOnboardingToFirestore() async {
    final user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      throw Exception('No authenticated user found.');
    }

    final repository =
    ref.read(onboardingRepositoryProvider);

    await repository.saveOnboarding(
      uid: user.uid,
      state: state,
    );
  }
}

final onboardingControllerProvider =
NotifierProvider<OnboardingController, OnboardingState>(
  OnboardingController.new,
);

final firestoreProvider = Provider<FirebaseFirestore>((ref) {
  return FirebaseFirestore.instance;
});

final onboardingRepositoryProvider =
Provider<OnboardingRepository>((ref) {
  final firestore = ref.watch(firestoreProvider);
  return OnboardingRepository(firestore);
});