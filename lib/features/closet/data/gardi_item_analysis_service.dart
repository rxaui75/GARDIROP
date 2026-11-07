import 'package:gardirop/core/services/gardi_functions_service.dart';

import '../domain/item_draft.dart';

class GardiItemAnalysisResult {
  const GardiItemAnalysisResult({
    required this.draft,
    required this.analysis,
  });

  final ItemDraft draft;
  final Map<String, dynamic> analysis;
}

class GardiItemAnalysisService {
  GardiItemAnalysisService._();

  static Future<GardiItemAnalysisResult> analyze({
    required String imagePath,
  }) async {
    final analysis =
    await GardiFunctionsService.analyzeWardrobeItem(
      imagePath: imagePath,
    );

    final seasons = _stringList(
      analysis['seasons'],
    );

    final occasions = _stringList(
      analysis['occasions'],
    );

    final styles = _stringList(
      analysis['styles'],
    );

    final tags = _stringList(
      analysis['tags'],
    );

    final draft = ItemDraft(
      name: _stringValue(
        analysis['name'],
        fallback: 'New Item',
      ),
      category: _stringValue(
        analysis['category'],
        fallback: 'Other',
      ),
      imagePath: imagePath,
      colorHex: _nullableString(
        analysis['colorHex'],
      ),
      material: _nullableString(
        analysis['material'],
      ),
      fit: _nullableString(
        analysis['fit'],
      ),
      season: seasons.isEmpty
          ? null
          : seasons.join(', '),
      occasion: occasions,
      style: styles,
      tags: tags,
      source: ItemDraftSource.aiScan,
    );

    return GardiItemAnalysisResult(
      draft: draft,
      analysis: analysis,
    );
  }

  static List<String> _stringList(dynamic value) {
    if (value is! List) {
      return const [];
    }

    return value
        .map((item) => item.toString().trim())
        .where((item) => item.isNotEmpty)
        .toList();
  }

  static String _stringValue(
      dynamic value, {
        required String fallback,
      }) {
    if (value == null) {
      return fallback;
    }

    final text = value.toString().trim();

    return text.isEmpty ? fallback : text;
  }

  static String? _nullableString(dynamic value) {
    if (value == null) {
      return null;
    }

    final text = value.toString().trim();

    return text.isEmpty ? null : text;
  }
}