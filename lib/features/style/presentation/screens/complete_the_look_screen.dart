import 'dart:io';

import 'package:flutter/material.dart';
import 'package:gardirop/l10n/app_localizations.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_text_styles.dart';
import '../../../closet/domain/wardrobe_item.dart';
import '../../../closet/presentation/widgets/gardi_analyzing_dialog.dart';
import '../../data/gardi_closet_matcher.dart';
import '../../data/gardi_outfit_analysis_service.dart';
import '../../domain/gardi_outfit_analysis.dart';
import 'gardi_outfit_result_screen.dart';

class CompleteTheLookScreen extends StatelessWidget {
  const CompleteTheLookScreen({
    super.key,
    required this.selectedItems,
    required this.matches,
    required this.recommendations,
  });

  final List<WardrobeItem> selectedItems;
  final List<GardiClosetMatch> matches;
  final List<GardiRecommendedPiece> recommendations;

  Future<void> _analyzeUpdatedOutfit({
    required BuildContext context,
    required WardrobeItem addedItem,
  }) async {
    final updatedItems = [
      ...selectedItems,
      addedItem,
    ];

    debugPrint('UPDATED OUTFIT:');

    for (final item in updatedItems) {
      debugPrint(item.name);
    }

    showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (_) => const GardiAnalyzingDialog(
        mode: GardiAnalyzingMode.outfit,
      ),
    );

    try {
      final analysis =
      await GardiOutfitAnalysisService.analyze(
        items: updatedItems,
      );

      if (!context.mounted) return;

      // Close the Gardi analyzing popup.
      Navigator.of(
        context,
        rootNavigator: true,
      ).pop();

      if (!context.mounted) return;

      // Replace Complete the Look with the updated analysis.
      await Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (_) => GardiOutfitResultScreen(
            analysis: analysis,
            items: updatedItems,
          ),
        ),
      );
    } catch (error, stackTrace) {
      debugPrint(
        'Gardi updated outfit analysis failed: $error',
      );
      debugPrintStack(
        stackTrace: stackTrace,
      );

      if (!context.mounted) return;

      // Close the Gardi analyzing popup.
      Navigator.of(
        context,
        rootNavigator: true,
      ).pop();

      if (!context.mounted) return;

      await _showAnalysisErrorDialog(context);
    }
  }

  Future<void> _showAnalysisErrorDialog(
      BuildContext context,
      ) async {
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
                padding: const EdgeInsets.fromLTRB(
                  20,
                  12,
                  20,
                  32,
                ),
                child: Column(
                  crossAxisAlignment:
                  CrossAxisAlignment.start,
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

                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            l10n.completeTheLookTitle,
                            style: AppTextStyles.h1.copyWith(
                              color: AppColors.primary,
                            ),
                          ),
                        ),
                        const Icon(
                          Icons.auto_awesome_rounded,
                          color: AppColors.secondary,
                          size: 23,
                        ),
                      ],
                    ),

                    const SizedBox(height: 6),

                    Text(
                      l10n.completeTheLookSubtitle,
                      style: AppTextStyles.body.copyWith(
                        color: AppColors.secondary,
                      ),
                    ),

                    const SizedBox(height: 30),

                    if (matches.isNotEmpty) ...[
                      Text(
                        l10n.fromYourCloset,
                        style: AppTextStyles.h3.copyWith(
                          color: AppColors.primary,
                        ),
                      ),

                      const SizedBox(height: 14),

                      ...matches.take(5).map(
                            (match) => Padding(
                          padding: const EdgeInsets.only(
                            bottom: 12,
                          ),
                          child: _ClosetMatchCard(
                            match: match,
                            greatMatchLabel:
                            l10n.greatMatch,
                            onTap: () {
                              _analyzeUpdatedOutfit(
                                context: context,
                                addedItem: match.item,
                              );
                            },
                          ),
                        ),
                      ),
                    ] else ...[
                      _NoMatchesCard(
                        title:
                        l10n.noClosetMatchesTitle,
                        subtitle:
                        l10n.noClosetMatchesSubtitle,
                      ),
                    ],

                    if (recommendations.isNotEmpty) ...[
                      const SizedBox(height: 30),

                      Row(
                        children: [
                          const Icon(
                            Icons.auto_awesome_rounded,
                            size: 19,
                            color: AppColors.primary,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            l10n.gardiRecommends,
                            style: AppTextStyles.h3.copyWith(
                              color: AppColors.primary,
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 14),

                      ...recommendations.map(
                            (recommendation) => Padding(
                          padding: const EdgeInsets.only(
                            bottom: 12,
                          ),
                          child: _RecommendationCard(
                            recommendation:
                            recommendation,
                            colorsLabel:
                            l10n.recommendedColors,
                            stylesLabel:
                            l10n.recommendedStyles,
                            fitsLabel:
                            l10n.recommendedFits,
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ClosetMatchCard extends StatelessWidget {
  const _ClosetMatchCard({
    required this.match,
    required this.greatMatchLabel,
    required this.onTap,
  });

  final GardiClosetMatch match;
  final String greatMatchLabel;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final item = match.item;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(20),
        child: Ink(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: AppColors.beige,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: AppColors.taupe.withOpacity(0.45),
            ),
          ),
          child: Row(
            children: [
              Container(
                width: 82,
                height: 96,
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: AppColors.light,
                  borderRadius: BorderRadius.circular(15),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(11),
                  child: _ItemImage(
                    imagePath: item.imagePath,
                  ),
                ),
              ),

              const SizedBox(width: 14),

              Expanded(
                child: Column(
                  crossAxisAlignment:
                  CrossAxisAlignment.start,
                  children: [
                    Text(
                      item.name,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: AppTextStyles.body.copyWith(
                        color: AppColors.primary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),

                    const SizedBox(height: 7),

                    Row(
                      children: [
                        const Icon(
                          Icons.auto_awesome_rounded,
                          size: 14,
                          color: AppColors.secondary,
                        ),
                        const SizedBox(width: 5),
                        Text(
                          greatMatchLabel,
                          style:
                          AppTextStyles.caption.copyWith(
                            color: AppColors.secondary,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              const Icon(
                Icons.chevron_right_rounded,
                color: AppColors.secondary,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _NoMatchesCard extends StatelessWidget {
  const _NoMatchesCard({
    required this.title,
    required this.subtitle,
  });

  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.beige,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(
          color: AppColors.taupe.withOpacity(0.45),
        ),
      ),
      child: Column(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: const BoxDecoration(
              color: AppColors.sand,
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.checkroom_rounded,
              color: AppColors.primary,
            ),
          ),

          const SizedBox(height: 14),

          Text(
            title,
            textAlign: TextAlign.center,
            style: AppTextStyles.h3.copyWith(
              color: AppColors.primary,
            ),
          ),

          const SizedBox(height: 6),

          Text(
            subtitle,
            textAlign: TextAlign.center,
            style: AppTextStyles.small.copyWith(
              color: AppColors.secondary,
              height: 1.45,
            ),
          ),
        ],
      ),
    );
  }
}

class _RecommendationCard extends StatelessWidget {
  const _RecommendationCard({
    required this.recommendation,
    required this.colorsLabel,
    required this.stylesLabel,
    required this.fitsLabel,
  });

  final GardiRecommendedPiece recommendation;
  final String colorsLabel;
  final String stylesLabel;
  final String fitsLabel;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: AppColors.sand,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            _formatCategory(
              recommendation.category,
            ),
            style: AppTextStyles.h3.copyWith(
              color: AppColors.primary,
            ),
          ),

          if (recommendation.reason.isNotEmpty) ...[
            const SizedBox(height: 7),
            Text(
              recommendation.reason,
              style: AppTextStyles.small.copyWith(
                color: AppColors.secondary,
                height: 1.45,
              ),
            ),
          ],

          if (recommendation.colors.isNotEmpty) ...[
            const SizedBox(height: 16),
            _MetadataRow(
              label: colorsLabel,
              values: recommendation.colors,
            ),
          ],

          if (recommendation.styles.isNotEmpty) ...[
            const SizedBox(height: 10),
            _MetadataRow(
              label: stylesLabel,
              values: recommendation.styles,
            ),
          ],

          if (recommendation.fits.isNotEmpty) ...[
            const SizedBox(height: 10),
            _MetadataRow(
              label: fitsLabel,
              values: recommendation.fits,
            ),
          ],
        ],
      ),
    );
  }

  String _formatCategory(String value) {
    if (value.trim().isEmpty) {
      return '';
    }

    final clean = value.trim();

    return clean[0].toUpperCase() +
        clean.substring(1);
  }
}

class _MetadataRow extends StatelessWidget {
  const _MetadataRow({
    required this.label,
    required this.values,
  });

  final String label;
  final List<String> values;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 58,
          child: Text(
            label,
            style: AppTextStyles.caption.copyWith(
              color: AppColors.primary,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),

        Expanded(
          child: Text(
            values.join(' · '),
            style: AppTextStyles.caption.copyWith(
              color: AppColors.secondary,
              height: 1.4,
            ),
          ),
        ),
      ],
    );
  }
}

class _ItemImage extends StatelessWidget {
  const _ItemImage({
    required this.imagePath,
  });

  final String imagePath;

  @override
  Widget build(BuildContext context) {
    if (imagePath.isEmpty) {
      return _placeholder();
    }

    if (imagePath.startsWith('assets/')) {
      return Image.asset(
        imagePath,
        fit: BoxFit.contain,
        errorBuilder: (_, __, ___) =>
            _placeholder(),
      );
    }

    return Image.file(
      File(imagePath),
      fit: BoxFit.contain,
      errorBuilder: (_, __, ___) =>
          _placeholder(),
    );
  }

  Widget _placeholder() {
    return Container(
      color: AppColors.light,
      alignment: Alignment.center,
      child: const Icon(
        Icons.checkroom_rounded,
        color: AppColors.secondary,
        size: 34,
      ),
    );
  }
}