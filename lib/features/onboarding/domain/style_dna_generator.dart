import '../application/onboarding_controller.dart';
import 'style_dna.dart';

class StyleDnaGenerator {
  const StyleDnaGenerator._();

  static StyleDna generate(OnboardingState state) {
    final scores = <String, int>{};

    void addScore(String style, [int amount = 1]) {
      scores.update(
        style,
            (value) => value + amount,
        ifAbsent: () => amount,
      );
    }

    // Visual swipe preferences carry the most weight.
    for (final style in state.likedStyles) {
      addScore(style, 3);
    }

    // Explicit Style Vibe preferences.
    for (final vibe in state.styleVibes) {
      addScore(vibe, 2);
    }

    // Sort strongest style signals first.
    final sortedStyles = scores.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));

    final tags = <String>[];

    for (final entry in sortedStyles) {
      final label = _styleLabel(entry.key);

      if (!tags.contains(label)) {
        tags.add(label);
      }

      if (tags.length == 3) {
        break;
      }
    }

    // Add personality / lifestyle tags.
    final lifestyleTags = _buildLifestyleTags(state);

    for (final tag in lifestyleTags) {
      if (!tags.contains(tag)) {
        tags.add(tag);
      }

      if (tags.length == 5) {
        break;
      }
    }

    // Fallback so the UI always has enough content.
    const fallbackTags = [
      'Versatile',
      'Timeless',
      'Effortless',
      'Balanced',
      'Personal',
    ];

    for (final tag in fallbackTags) {
      if (tags.length == 5) break;

      if (!tags.contains(tag)) {
        tags.add(tag);
      }
    }

    final highlights = _buildHighlights(state);

    return StyleDna(
      tags: tags.take(5).toList(),
      highlights: highlights.take(4).toList(),
    );
  }

  static List<String> _buildLifestyleTags(
      OnboardingState state,
      ) {
    final tags = <String>[];

    if (state.fitPreference == 'relaxed' ||
        state.fitPreference == 'oversized') {
      tags.add('Relaxed');
    }

    if (state.fitPreference == 'slim') {
      tags.add('Defined');
    }

    if (state.fitPreference == 'regular') {
      tags.add('Balanced');
    }

    if (state.occasions.contains('everyday') ||
        state.occasions.contains('work')) {
      tags.add('Versatile');
    }

    if (state.occasions.contains('special_event') ||
        state.occasions.contains('going_out')) {
      tags.add('Polished');
    }

    if (state.occasions.contains('travel') ||
        state.occasions.contains('at_home')) {
      tags.add('Effortless');
    }

    return tags;
  }

  static List<String> _buildHighlights(
      OnboardingState state,
      ) {
    final highlights = <String>[];

    final topStyles = <String>{
      ...state.likedStyles,
      ...state.styleVibes,
    };

    if (topStyles.contains('minimal')) {
      highlights.add('Clean and effortless styling');
    }

    if (topStyles.contains('classic')) {
      highlights.add('Timeless and refined pieces');
    }

    if (topStyles.contains('chic') ||
        topStyles.contains('elegant')) {
      highlights.add('Polished and elevated looks');
    }

    if (topStyles.contains('casual')) {
      highlights.add('Comfortable everyday outfits');
    }

    if (topStyles.contains('streetwear') ||
        topStyles.contains('edgy')) {
      highlights.add('Expressive looks with personality');
    }

    if (topStyles.contains('bold') ||
        topStyles.contains('trendy')) {
      highlights.add('Confident statement styling');
    }

    if (topStyles.contains('sporty')) {
      highlights.add('Practical looks built for movement');
    }

    if (topStyles.contains('romantic')) {
      highlights.add('Soft and feminine details');
    }

    if (topStyles.contains('rugged')) {
      highlights.add('Strong textures and practical pieces');
    }

    if (state.occasions.length >= 3) {
      highlights.add('Versatile across different occasions');
    }

    switch (state.fitPreference) {
      case 'slim':
        highlights.add('Prefers a more fitted silhouette');
        break;

      case 'regular':
        highlights.add('Prefers a balanced regular fit');
        break;

      case 'relaxed':
        highlights.add('Prefers comfortable relaxed fits');
        break;

      case 'oversized':
        highlights.add('Enjoys oversized silhouettes');
        break;
    }

    const fallbacks = [
      'Versatile for everyday life',
      'Easy to mix and match',
      'A balance of comfort and style',
      'Personalized around your preferences',
    ];

    for (final fallback in fallbacks) {
      if (highlights.length >= 4) break;

      if (!highlights.contains(fallback)) {
        highlights.add(fallback);
      }
    }

    return highlights;
  }

  static String _styleLabel(String id) {
    switch (id) {
      case 'minimal':
        return 'Minimal';
      case 'casual':
        return 'Casual';
      case 'classic':
        return 'Classic';
      case 'streetwear':
        return 'Streetwear';
      case 'elegant':
        return 'Elegant';
      case 'sporty':
        return 'Sporty';
      case 'romantic':
        return 'Romantic';
      case 'bold':
        return 'Bold';
      case 'rugged':
        return 'Rugged';
      case 'trendy':
        return 'Trendy';
      case 'chic':
        return 'Chic';
      case 'edgy':
        return 'Edgy';
      default:
        return id;
    }
  }
}