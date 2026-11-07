import 'dart:io';

import 'package:flutter/material.dart';
import 'package:gardirop/l10n/app_localizations.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_text_styles.dart';
import '/core/services/gardi_functions_service.dart';
import '../../../closet/domain/wardrobe_item.dart';
import '../../../closet/presentation/widgets/gardi_analyzing_dialog.dart';
import '../../domain/gardi_outfit_analysis.dart';
import 'gardi_outfit_result_screen.dart';

class OutfitBuilderScreen extends StatefulWidget {
  const OutfitBuilderScreen({
    super.key,
    required this.items,
  });

  final List<WardrobeItem> items;

  @override
  State<OutfitBuilderScreen> createState() =>
      _OutfitBuilderScreenState();
}

class _OutfitBuilderScreenState extends State<OutfitBuilderScreen> {
  bool _isAnalyzing = false;

  Future<void> _analyzeOutfit() async {
    if (_isAnalyzing) return;

    setState(() {
      _isAnalyzing = true;
    });

    showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (_) {
        return const GardiAnalyzingDialog(
          mode: GardiAnalyzingMode.outfit,
        );
      },
    );

    try {
      final outfitItems = widget.items.map((item) {
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

      debugPrint('GARDI OUTFIT ANALYSIS:');
      debugPrint(analysisJson.toString());

      final analysis = GardiOutfitAnalysis.fromJson(
        analysisJson,
      );

      if (!mounted) return;

// Close the Gardi analyzing popup.
      Navigator.of(
        context,
        rootNavigator: true,
      ).pop();

      if (!mounted) return;

// Open the real outfit analysis result.
      await Navigator.of(context).push(
        MaterialPageRoute(
          builder: (_) => GardiOutfitResultScreen(
            analysis: analysis,
            items: widget.items,
          ),
        ),
      );
    } catch (error, stackTrace) {
      debugPrint('Gardi outfit analysis failed: $error');
      debugPrintStack(stackTrace: stackTrace);

      if (!mounted) return;

      Navigator.of(context, rootNavigator: true).pop();

      await _showAnalysisErrorDialog();
    } finally {
      if (mounted) {
        setState(() {
          _isAnalyzing = false;
        });
      }
    }
  }

  Future<void> _showAnalysisErrorDialog() async {
    final l10n = AppLocalizations.of(context)!;

    await showDialog<void>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          backgroundColor: AppColors.light,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
          ),
          title: Row(
            children: [
              Container(
                width: 42,
                height: 42,
                decoration: const BoxDecoration(
                  color: AppColors.beige,
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.auto_awesome_rounded,
                  color: AppColors.primary,
                  size: 21,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  l10n.gardiOutfitErrorTitle,
                  style: AppTextStyles.h3.copyWith(
                    color: AppColors.primary,
                  ),
                ),
              ),
            ],
          ),
          content: Text(
            l10n.gardiOutfitErrorMessage,
            style: AppTextStyles.body.copyWith(
              color: AppColors.secondary,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(dialogContext).pop();
              },
              child: Text(
                l10n.tryAgain,
                style: AppTextStyles.body.copyWith(
                  color: AppColors.primary,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: AppColors.light,
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding:
                const EdgeInsets.fromLTRB(20, 12, 20, 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    IconButton(
                      onPressed: () =>
                          Navigator.of(context).pop(),
                      padding: EdgeInsets.zero,
                      alignment: Alignment.centerLeft,
                      icon: const Icon(
                        Icons.arrow_back_ios_new_rounded,
                        color: AppColors.primary,
                        size: 20,
                      ),
                    ),

                    const SizedBox(height: 12),

                    Text(
                      l10n.outfitBuilderTitle,
                      style: AppTextStyles.h1.copyWith(
                        color: AppColors.primary,
                      ),
                    ),

                    const SizedBox(height: 6),

                    Text(
                      l10n.outfitBuilderSubtitle,
                      style: AppTextStyles.body.copyWith(
                        color: AppColors.secondary,
                      ),
                    ),

                    const SizedBox(height: 30),

                    Text(
                      l10n.selectedPieces,
                      style: AppTextStyles.h3.copyWith(
                        color: AppColors.primary,
                      ),
                    ),

                    const SizedBox(height: 16),

                    GridView.builder(
                      shrinkWrap: true,
                      physics:
                      const NeverScrollableScrollPhysics(),
                      itemCount: widget.items.length,
                      gridDelegate:
                      const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: 12,
                        mainAxisSpacing: 16,
                        childAspectRatio: 0.78,
                      ),
                      itemBuilder: (context, index) {
                        return _SelectedItemCard(
                          item: widget.items[index],
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),

            _BottomActionBar(
              label: l10n.analyzeWithGardi,
              onPressed:
              _isAnalyzing ? null : _analyzeOutfit,
            ),
          ],
        ),
      ),
    );
  }
}

class _SelectedItemCard extends StatelessWidget {
  const _SelectedItemCard({
    required this.item,
  });

  final WardrobeItem item;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Container(
            width: double.infinity,
            decoration: BoxDecoration(
              color: AppColors.beige,
              borderRadius: BorderRadius.circular(18),
            ),
            clipBehavior: Clip.antiAlias,
            child: _WardrobeImage(
              imagePath: item.imagePath,
            ),
          ),
        ),

        const SizedBox(height: 8),

        Text(
          item.name.isNotEmpty
              ? item.name
              : item.category,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: AppTextStyles.caption.copyWith(
            fontWeight: FontWeight.w600,
            color: AppColors.primary,
          ),
        ),

        if (item.category.isNotEmpty) ...[
          const SizedBox(height: 2),
          Text(
            item.category,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: AppTextStyles.small.copyWith(
              color: AppColors.secondary,
            ),
          ),
        ],
      ],
    );
  }
}

class _WardrobeImage extends StatelessWidget {
  const _WardrobeImage({
    required this.imagePath,
  });

  final String imagePath;

  @override
  Widget build(BuildContext context) {
    if (imagePath.isEmpty) {
      return _fallback();
    }

    if (imagePath.startsWith('assets/')) {
      return Image.asset(
        imagePath,
        width: double.infinity,
        height: double.infinity,
        fit: BoxFit.cover,
        errorBuilder: (_, __, ___) => _fallback(),
      );
    }

    return Image.file(
      File(imagePath),
      width: double.infinity,
      height: double.infinity,
      fit: BoxFit.cover,
      errorBuilder: (_, __, ___) => _fallback(),
    );
  }

  Widget _fallback() {
    return Center(
      child: Icon(
        Icons.checkroom_rounded,
        size: 36,
        color: AppColors.secondary,
      ),
    );
  }
}

class _BottomActionBar extends StatelessWidget {
  const _BottomActionBar({
    required this.label,
    required this.onPressed,
  });

  final String label;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 16),
      decoration: BoxDecoration(
        color: AppColors.light,
        border: Border(
          top: BorderSide(
            color: AppColors.taupe.withOpacity(0.45),
          ),
        ),
      ),
      child: SafeArea(
        top: false,
        child: SizedBox(
          width: double.infinity,
          height: 52,
          child: ElevatedButton.icon(
            onPressed: onPressed,
            icon: const Icon(
              Icons.auto_awesome_rounded,
              size: 19,
            ),
            label: Text(
              label,
              style: AppTextStyles.body.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            style: ElevatedButton.styleFrom(
              elevation: 0,
              backgroundColor: AppColors.primary,
              foregroundColor: Colors.white,
              disabledBackgroundColor:
              AppColors.primary.withOpacity(0.55),
              disabledForegroundColor:
              Colors.white.withOpacity(0.75),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
            ),
          ),
        ),
      ),
    );
  }
}