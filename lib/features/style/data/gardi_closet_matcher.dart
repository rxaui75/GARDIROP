import '../../closet/domain/wardrobe_item.dart';
import '../domain/gardi_outfit_analysis.dart';

class GardiClosetMatch {
  const GardiClosetMatch({
    required this.item,
    required this.score,
    required this.reasons,
  });

  final WardrobeItem item;
  final int score;
  final List<String> reasons;
}

class GardiClosetMatcher {
  const GardiClosetMatcher._();

  static List<GardiClosetMatch> findMatches({
    required List<WardrobeItem> wardrobeItems,
    required List<WardrobeItem> selectedItems,
    required List<GardiRecommendedPiece> recommendations,
  }) {
    if (wardrobeItems.isEmpty || recommendations.isEmpty) {
      return const [];
    }

    final selectedIds = selectedItems
        .map((item) => item.id)
        .toSet();

    final matches = <GardiClosetMatch>[];

    for (final item in wardrobeItems) {
      // Don't recommend something already selected
      // in the current outfit.
      if (selectedIds.contains(item.id)) {
        continue;
      }

      var bestScore = 0;
      var bestReasons = <String>[];

      for (final recommendation in recommendations) {
        var score = 0;
        final reasons = <String>[];

        // Category is the strongest signal.
        if (_categoryMatches(
          item.category,
          recommendation.category,
        )) {
          score += 5;
          reasons.add('category');
        } else {
          // If the category does not match at all,
          // this recommendation is not relevant.
          continue;
        }

        // Color match.
        if (_valueMatchesAny(
          item.colorName,
          recommendation.colors,
        )) {
          score += 3;
          reasons.add('color');
        }

        // Style match.
        if (_listsOverlap(
          item.styles,
          recommendation.styles,
        )) {
          score += 2;
          reasons.add('style');
        }

        // Fit match.
        if (_valueMatchesAny(
          item.fit,
          recommendation.fits,
        )) {
          score += 1;
          reasons.add('fit');
        }

        if (score > bestScore) {
          bestScore = score;
          bestReasons = reasons;
        }
      }

      if (bestScore > 0) {
        matches.add(
          GardiClosetMatch(
            item: item,
            score: bestScore,
            reasons: bestReasons,
          ),
        );
      }
    }

    // Best matches first.
    matches.sort(
          (a, b) => b.score.compareTo(a.score),
    );

    return matches;
  }

  static bool _categoryMatches(
      String itemCategory,
      String recommendedCategory,
      ) {
    final item = _normalize(itemCategory);
    final recommended = _normalize(recommendedCategory);

    if (item.isEmpty || recommended.isEmpty) {
      return false;
    }

    if (item == recommended) {
      return true;
    }

    const categoryGroups = {
      'bottoms': {
        'bottom',
        'bottoms',
        'pants',
        'trousers',
        'jeans',
        'denim',
        'shorts',
        'skirt',
        'skirts',
      },
      'top': {
        'top',
        'tops',
        'shirt',
        'shirts',
        'tshirt',
        'tshirts',
        'tee',
        'blouse',
        'blouses',
        'sweater',
        'sweaters',
      },
      'outerwear': {
        'outerwear',
        'jacket',
        'jackets',
        'blazer',
        'blazers',
        'coat',
        'coats',
        'cardigan',
        'cardigans',
      },
      'shoes': {
        'shoe',
        'shoes',
        'sneaker',
        'sneakers',
        'loafers',
        'heels',
        'boots',
        'sandals',
      },
      'dress': {
        'dress',
        'dresses',
      },
      'accessory': {
        'accessory',
        'accessories',
        'bag',
        'bags',
        'belt',
        'belts',
        'scarf',
        'scarves',
        'jewelry',
      },
    };

    for (final group in categoryGroups.values) {
      if (group.contains(item) &&
          group.contains(recommended)) {
        return true;
      }
    }

    return false;
  }

  static bool _valueMatchesAny(
      String? value,
      List<String> options,
      ) {
    if (value == null || value.trim().isEmpty) {
      return false;
    }

    final normalizedValue = _normalize(value);

    return options.any((option) {
      final normalizedOption = _normalize(option);

      return normalizedValue == normalizedOption ||
          normalizedValue.contains(normalizedOption) ||
          normalizedOption.contains(normalizedValue);
    });
  }

  static bool _listsOverlap(
      List<String> first,
      List<String> second,
      ) {
    if (first.isEmpty || second.isEmpty) {
      return false;
    }

    final normalizedFirst = first
        .map(_normalize)
        .where((value) => value.isNotEmpty)
        .toSet();

    return second.any(
          (value) => normalizedFirst.contains(
        _normalize(value),
      ),
    );
  }

  static String _normalize(String value) {
    return value
        .trim()
        .toLowerCase()
        .replaceAll(RegExp(r'[^a-z0-9]'), '');
  }
}