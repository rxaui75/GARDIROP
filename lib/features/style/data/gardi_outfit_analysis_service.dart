import '/core/services/gardi_functions_service.dart';
import '../../closet/domain/wardrobe_item.dart';
import '../domain/gardi_outfit_analysis.dart';

class GardiOutfitAnalysisService {
  const GardiOutfitAnalysisService._();

  static Future<GardiOutfitAnalysis> analyze({
    required List<WardrobeItem> items,
  }) async {
    if (items.length < 2) {
      throw Exception(
        'At least two wardrobe items are required.',
      );
    }

    final outfitItems = items.map((item) {
      return <String, dynamic>{
        'name': item.name,
        'category': item.category,
        'colorName': item.colorName,
        'material': item.material,
        'fit': item.fit,
        'seasons': item.seasons,
        'occasions': item.occasions,
        'styles': item.styles,
        'tags': item.tags,
      };
    }).toList();

    final analysisJson =
    await GardiFunctionsService.analyzeOutfit(
      items: outfitItems,
    );

    debugPrintAnalysis(analysisJson);

    return GardiOutfitAnalysis.fromJson(
      analysisJson,
    );
  }

  static void debugPrintAnalysis(
      Map<String, dynamic> analysis,
      ) {
    // Kept here so every outfit-analysis entry point
    // uses the same debug output during development.
    // ignore: avoid_print
    print('GARDI OUTFIT ANALYSIS:');

    // ignore: avoid_print
    print(analysis);
  }
}
