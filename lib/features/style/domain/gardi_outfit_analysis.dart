class GardiRecommendedPiece {
  const GardiRecommendedPiece({
    required this.category,
    required this.colors,
    required this.styles,
    required this.fits,
    required this.reason,
  });

  final String category;
  final List<String> colors;
  final List<String> styles;
  final List<String> fits;
  final String reason;

  factory GardiRecommendedPiece.fromJson(
      Map<String, dynamic> json,
      ) {
    return GardiRecommendedPiece(
      category: _readString(json['category']),
      colors: _readStringList(json['colors']),
      styles: _readStringList(json['styles']),
      fits: _readStringList(json['fits']),
      reason: _readString(json['reason']),
    );
  }

  static String _readString(dynamic value) {
    if (value is String) {
      return value.trim();
    }

    return '';
  }

  static List<String> _readStringList(dynamic value) {
    if (value is! List) {
      return const [];
    }

    return value
        .whereType<String>()
        .map((item) => item.trim())
        .where((item) => item.isNotEmpty)
        .toList(growable: false);
  }
}

class GardiOutfitAnalysis {
  const GardiOutfitAnalysis({
    required this.overallAssessment,
    required this.summary,
    required this.colorHarmony,
    required this.styleHarmony,
    required this.fitBalance,
    required this.occasionMatch,
    required this.seasonMatch,
    required this.strengths,
    required this.concerns,
    required this.suggestions,
    required this.recommendedPieces,
    required this.confidence,
  });

  final String overallAssessment;
  final String summary;
  final String colorHarmony;
  final String styleHarmony;
  final String fitBalance;
  final String occasionMatch;
  final String seasonMatch;

  final List<String> strengths;
  final List<String> concerns;
  final List<String> suggestions;
  final List<GardiRecommendedPiece> recommendedPieces;

  final double confidence;

  factory GardiOutfitAnalysis.fromJson(
      Map<String, dynamic> json,
      ) {
    return GardiOutfitAnalysis(
      overallAssessment: _readString(
        json['overallAssessment'],
      ),
      summary: _readString(
        json['summary'],
      ),
      colorHarmony: _readString(
        json['colorHarmony'],
      ),
      styleHarmony: _readString(
        json['styleHarmony'],
      ),
      fitBalance: _readString(
        json['fitBalance'],
      ),
      occasionMatch: _readString(
        json['occasionMatch'],
      ),
      seasonMatch: _readString(
        json['seasonMatch'],
      ),
      strengths: _readStringList(
        json['strengths'],
      ),
      concerns: _readStringList(
        json['concerns'],
      ),
      suggestions: _readStringList(
        json['suggestions'],
      ),
      recommendedPieces: _readRecommendedPieces(
        json['recommendedPieces'],
      ),
      confidence: _readDouble(
        json['confidence'],
      ),
    );
  }

  bool get worksWell =>
      overallAssessment == 'works_well';

  bool get almostThere =>
      overallAssessment == 'almost_there';

  bool get needsAdjustment =>
      overallAssessment == 'needs_adjustment';

  bool get hasStrengths => strengths.isNotEmpty;

  bool get hasConcerns => concerns.isNotEmpty;

  bool get hasSuggestions => suggestions.isNotEmpty;
  bool get hasRecommendedPieces =>
      recommendedPieces.isNotEmpty;

  static String _readString(dynamic value) {
    if (value is String) {
      return value.trim();
    }

    return '';
  }

  static List<String> _readStringList(dynamic value) {
    if (value is! List) {
      return const [];
    }

    return value
        .whereType<String>()
        .map((item) => item.trim())
        .where((item) => item.isNotEmpty)
        .toList(growable: false);
  }

  static double _readDouble(dynamic value) {
    if (value is num) {
      return value.toDouble();
    }

    return 0.0;
  }
  static List<GardiRecommendedPiece> _readRecommendedPieces(
      dynamic value,
      ) {
    if (value is! List) {
      return const [];
    }

    return value
        .whereType<Map>()
        .map(
          (item) => GardiRecommendedPiece.fromJson(
        Map<String, dynamic>.from(item),
      ),
    )
        .toList(growable: false);
  }
}