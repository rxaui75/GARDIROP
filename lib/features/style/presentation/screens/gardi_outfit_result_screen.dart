import 'package:flutter/material.dart';
import 'package:gardirop/l10n/app_localizations.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_text_styles.dart';
import '../../domain/gardi_outfit_analysis.dart';
import 'dart:io';

import '../../../closet/domain/wardrobe_item.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../closet/application/wardrobe_provider.dart';
import '../../data/gardi_closet_matcher.dart';
import 'complete_the_look_screen.dart';

import '../../application/saved_looks_provider.dart';


class GardiOutfitResultScreen extends ConsumerStatefulWidget {
  const GardiOutfitResultScreen({
    super.key,
    required this.analysis,
    required this.items,
  });

  final GardiOutfitAnalysis analysis;
  final List<WardrobeItem> items;

  @override
  ConsumerState<GardiOutfitResultScreen> createState() =>
      _GardiOutfitResultScreenState();
}

class _GardiOutfitResultScreenState
    extends ConsumerState<GardiOutfitResultScreen> {
  bool _isSaving = false;
  bool _isSaved = false;

  Future<void> _showSavedLookDialog() async {
    if (!mounted) return;

    final l10n = AppLocalizations.of(context)!;

    await showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) {
        return AlertDialog(
          backgroundColor: AppColors.light,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
          ),
          title: Column(
            children: [
              Container(
                width: 58,
                height: 58,
                decoration: const BoxDecoration(
                  color: AppColors.beige,
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.favorite_rounded,
                  color: AppColors.primary,
                  size: 28,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                l10n.lookSavedTitle,
                textAlign: TextAlign.center,
                style: AppTextStyles.h3.copyWith(
                  color: AppColors.primary,
                ),
              ),
            ],
          ),
          content: Text(
            l10n.lookSavedMessage,
            textAlign: TextAlign.center,
            style: AppTextStyles.body.copyWith(
              color: AppColors.secondary,
              height: 1.5,
            ),
          ),
          actionsPadding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
          actions: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                SizedBox(
                  height: 48,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.of(dialogContext).pop();
                      context.go('/style');
                    },
                    style: ElevatedButton.styleFrom(
                      elevation: 0,
                      backgroundColor: AppColors.primary,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                    child: Text(
                      l10n.viewMyLooks,
                      style: AppTextStyles.caption.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                TextButton(
                  onPressed: () {
                    Navigator.of(dialogContext).pop();
                  },
                  child: Text(
                    l10n.notNow,
                    style: AppTextStyles.caption.copyWith(
                      color: AppColors.secondary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ],
        );
      },
    );
  }

  Future<void> _showSaveErrorDialog() async {
    if (!mounted) return;

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
                  Icons.favorite_border_rounded,
                  color: AppColors.primary,
                  size: 21,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  l10n.saveLookErrorTitle,
                  style: AppTextStyles.h3.copyWith(
                    color: AppColors.primary,
                  ),
                ),
              ),
            ],
          ),
          content: Text(
            l10n.saveLookErrorMessage,
            style: AppTextStyles.body.copyWith(
              color: AppColors.secondary,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(),
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
    final analysis = widget.analysis;
    final items = widget.items;
    final l10n = AppLocalizations.of(context)!;

    Future<void> saveLook() async {
      if (_isSaving || _isSaved) return;

      setState(() {
        _isSaving = true;
      });

      try {
        final repository = ref.read(
          savedLooksRepositoryProvider,
        );

        await repository.saveLook(
          itemIds: items
              .map((item) => item.id)
              .toList(growable: false),
          analysis: analysis,
        );

        if (!mounted) return;

        setState(() {
          _isSaving = false;
          _isSaved = true;
        });

        debugPrint('LOOK SAVED SUCCESSFULLY');

        await _showSavedLookDialog();
      } catch (error, stackTrace) {
        debugPrint(
          'Failed to save look: $error',
        );
        debugPrintStack(
          stackTrace: stackTrace,
        );

        if (!mounted) return;

        setState(() {
          _isSaving = false;
        });

        await _showSaveErrorDialog();
      }
    }
    final wardrobeAsync = ref.watch(wardrobeItemsProvider);

    final closetMatches = wardrobeAsync.maybeWhen(
      data: (wardrobeItems) {
        return GardiClosetMatcher.findMatches(
          wardrobeItems: wardrobeItems,
          selectedItems: items,
          recommendations: analysis.recommendedPieces,
        );
      },
      orElse: () => <GardiClosetMatch>[],
    );

    debugPrint('GARDI CLOSET MATCHES:');

    for (final match in closetMatches) {
      debugPrint(
        '${match.item.name} | '
            'score: ${match.score} | '
            'reasons: ${match.reasons}',
      );
    }

    return Scaffold(
      backgroundColor: AppColors.light,
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(20, 12, 20, 28),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _Header(
                      title: l10n.gardiTakeTitle,
                      subtitle: l10n.gardiTakeSubtitle,
                    ),

                    const SizedBox(height: 24),

                    _OutfitPreview(
                      items: items,
                    ),

                    const SizedBox(height: 20),

                    _AssessmentCard(
                      analysis: analysis,
                    ),



                    if (analysis.hasStrengths) ...[
                      const SizedBox(height: 30),
                      _BulletSection(
                        icon: Icons.favorite_border_rounded,
                        title: l10n.gardiWhyItWorks,
                        items: analysis.strengths,
                      ),
                    ],

                    if (analysis.hasConcerns) ...[
                      const SizedBox(height: 28),
                      _BulletSection(
                        icon: Icons.lightbulb_outline_rounded,
                        title: l10n.gardiThingsToConsider,
                        items: analysis.concerns,
                      ),
                    ],

                    if (analysis.hasSuggestions) ...[
                      const SizedBox(height: 28),
                      _BulletSection(
                        icon: Icons.auto_awesome_rounded,
                        title: l10n.gardiSuggestions,
                        items: analysis.suggestions,
                        emphasized: true,
                      ),
                    ],
                  ],
                ),
              ),
            ),

            _BottomActions(
              continueLabel: l10n.continueStyling,
              saveLabel: l10n.saveLook,
              savingLabel: l10n.savingLook,
              savedLabel: l10n.lookSaved,
              onContinue: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) => CompleteTheLookScreen(
                      selectedItems: items,
                      matches: closetMatches,
                      recommendations: analysis.recommendedPieces,
                    ),
                  ),
                );
              },
              onSave: saveLook,
              isSaving: _isSaving,
              isSaved: _isSaved,
            ),
          ],
        ),
      ),
    );
  }
}

class _Header extends StatelessWidget {
  const _Header({
    required this.title,
    required this.subtitle,
  });

  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        IconButton(
          onPressed: () => Navigator.of(context).pop(),
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
                title,
                style: AppTextStyles.h1.copyWith(
                  color: AppColors.primary,
                ),
              ),
            ),
            const Icon(
              Icons.auto_awesome_rounded,
              color: AppColors.secondary,
              size: 24,
            ),
          ],
        ),

        const SizedBox(height: 6),

        Text(
          subtitle,
          style: AppTextStyles.body.copyWith(
            color: AppColors.secondary,
          ),
        ),
      ],
    );
  }
}

class _OutfitPreview extends StatelessWidget {
  const _OutfitPreview({
    required this.items,
  });

  final List<WardrobeItem> items;

  @override
  Widget build(BuildContext context) {
    if (items.isEmpty) {
      return const SizedBox.shrink();
    }

    final visibleItems = items.take(4).toList();

    return Container(
      width: double.infinity,
      height: 290,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: AppColors.sand,
        borderRadius: BorderRadius.circular(28),
        border: Border.all(
          color: AppColors.taupe.withOpacity(0.45),
        ),
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          for (int index = 0;
          index < visibleItems.length;
          index++)
            _PositionedOutfitItem(
              item: visibleItems[index],
              index: index,
              total: visibleItems.length,
            ),

          if (items.length > 4)
            Positioned(
              right: 12,
              bottom: 10,
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: AppColors.primary,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  '+${items.length - 4}',
                  style: AppTextStyles.caption.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _PositionedOutfitItem extends StatelessWidget {
  const _PositionedOutfitItem({
    required this.item,
    required this.index,
    required this.total,
  });

  final WardrobeItem item;
  final int index;
  final int total;

  @override
  Widget build(BuildContext context) {
    final layout = _layoutFor(
      index: index,
      total: total,
    );

    return Positioned(
      left: layout.left,
      right: layout.right,
      top: layout.top,
      bottom: layout.bottom,
      child: Transform.rotate(
        angle: layout.rotation,
        child: Container(
          width: layout.width,
          height: layout.height,
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: AppColors.light,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 18,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(14),
            child: _WardrobeImage(
              imagePath: item.imagePath,
            ),
          ),
        ),
      ),
    );
  }

  _OutfitItemLayout _layoutFor({
    required int index,
    required int total,
  }) {
    if (total == 1) {
      return const _OutfitItemLayout(
        width: 165,
        height: 220,
        top: 18,
        rotation: 0,
      );
    }

    if (total == 2) {
      if (index == 0) {
        return const _OutfitItemLayout(
          width: 150,
          height: 205,
          left: 20,
          top: 20,
          rotation: -0.045,
        );
      }

      return const _OutfitItemLayout(
        width: 150,
        height: 205,
        right: 20,
        bottom: 18,
        rotation: 0.045,
      );
    }

    if (total == 3) {
      switch (index) {
        case 0:
          return const _OutfitItemLayout(
            width: 135,
            height: 180,
            left: 8,
            top: 12,
            rotation: -0.06,
          );
        case 1:
          return const _OutfitItemLayout(
            width: 135,
            height: 180,
            right: 8,
            top: 20,
            rotation: 0.06,
          );
        default:
          return const _OutfitItemLayout(
            width: 130,
            height: 165,
            bottom: 4,
            rotation: 0,
          );
      }
    }

    switch (index) {
      case 0:
        return const _OutfitItemLayout(
          width: 120,
          height: 155,
          left: 6,
          top: 5,
          rotation: -0.055,
        );
      case 1:
        return const _OutfitItemLayout(
          width: 120,
          height: 155,
          right: 6,
          top: 5,
          rotation: 0.055,
        );
      case 2:
        return const _OutfitItemLayout(
          width: 120,
          height: 150,
          left: 18,
          bottom: 3,
          rotation: 0.04,
        );
      default:
        return const _OutfitItemLayout(
          width: 120,
          height: 150,
          right: 18,
          bottom: 3,
          rotation: -0.04,
        );
    }
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
      return _placeholder();
    }

    final isAsset = imagePath.startsWith('assets/');

    if (isAsset) {
      return Image.asset(
        imagePath,
        fit: BoxFit.contain,
        errorBuilder: (_, __, ___) => _placeholder(),
      );
    }

    return Image.file(
      File(imagePath),
      fit: BoxFit.contain,
      errorBuilder: (_, __, ___) => _placeholder(),
    );
  }

  Widget _placeholder() {
    return Container(
      color: AppColors.beige,
      alignment: Alignment.center,
      child: const Icon(
        Icons.checkroom_rounded,
        color: AppColors.secondary,
        size: 42,
      ),
    );
  }
}

class _OutfitItemLayout {
  const _OutfitItemLayout({
    required this.width,
    required this.height,
    this.left,
    this.right,
    this.top,
    this.bottom,
    required this.rotation,
  });

  final double width;
  final double height;

  final double? left;
  final double? right;
  final double? top;
  final double? bottom;

  final double rotation;
}

class _AssessmentCard extends StatelessWidget {
  const _AssessmentCard({
    required this.analysis,
  });

  final GardiOutfitAnalysis analysis;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    late final String label;
    late final IconData icon;

    if (analysis.worksWell) {
      label = l10n.gardiWorksWell;
      icon = Icons.favorite_rounded;
    } else if (analysis.almostThere) {
      label = l10n.gardiAlmostThere;
      icon = Icons.auto_awesome_rounded;
    } else {
      label = l10n.gardiNeedsAdjustment;
      icon = Icons.tune_rounded;
    }

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        color: AppColors.primary,
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 12,
              vertical: 7,
            ),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.12),
              borderRadius: BorderRadius.circular(30),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  icon,
                  size: 16,
                  color: Colors.white,
                ),
                const SizedBox(width: 7),
                Text(
                  label,
                  style: AppTextStyles.caption.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 18),

          Text(
            analysis.summary,
            style: AppTextStyles.body.copyWith(
              color: Colors.white,
              height: 1.55,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}

class _AnalysisGrid extends StatelessWidget {
  const _AnalysisGrid({
    required this.analysis,
  });

  final GardiOutfitAnalysis analysis;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    final entries = [
      _AnalysisEntry(
        icon: Icons.palette_outlined,
        title: l10n.gardiColorHarmony,
        text: analysis.colorHarmony,
      ),
      _AnalysisEntry(
        icon: Icons.auto_awesome_outlined,
        title: l10n.gardiStyleHarmony,
        text: analysis.styleHarmony,
      ),
      _AnalysisEntry(
        icon: Icons.balance_outlined,
        title: l10n.gardiFitBalance,
        text: analysis.fitBalance,
      ),
      _AnalysisEntry(
        icon: Icons.event_available_outlined,
        title: l10n.gardiOccasionMatch,
        text: analysis.occasionMatch,
      ),
      _AnalysisEntry(
        icon: Icons.wb_sunny_outlined,
        title: l10n.gardiSeasonMatch,
        text: analysis.seasonMatch,
      ),
    ].where((entry) => entry.text.trim().isNotEmpty).toList();

    return Column(
      children: [
        for (int index = 0; index < entries.length; index++) ...[
          _AnalysisTile(
            entry: entries[index],
          ),
          if (index != entries.length - 1)
            const SizedBox(height: 12),
        ],
      ],
    );
  }
}

class _AnalysisEntry {
  const _AnalysisEntry({
    required this.icon,
    required this.title,
    required this.text,
  });

  final IconData icon;
  final String title;
  final String text;
}

class _AnalysisTile extends StatelessWidget {
  const _AnalysisTile({
    required this.entry,
  });

  final _AnalysisEntry entry;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: AppColors.beige,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: AppColors.taupe.withOpacity(0.45),
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              color: AppColors.light,
              borderRadius: BorderRadius.circular(13),
            ),
            child: Icon(
              entry.icon,
              color: AppColors.primary,
              size: 21,
            ),
          ),

          const SizedBox(width: 14),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  entry.title,
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.primary,
                    fontWeight: FontWeight.w700,
                  ),
                ),

                const SizedBox(height: 5),

                Text(
                  entry.text,
                  style: AppTextStyles.small.copyWith(
                    color: AppColors.secondary,
                    height: 1.5,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _BulletSection extends StatelessWidget {
  const _BulletSection({
    required this.icon,
    required this.title,
    required this.items,
    this.emphasized = false,
  });

  final IconData icon;
  final String title;
  final List<String> items;
  final bool emphasized;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: emphasized
            ? AppColors.sand
            : AppColors.light,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(
          color: emphasized
              ? AppColors.secondary.withOpacity(0.35)
              : AppColors.taupe.withOpacity(0.55),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                icon,
                color: AppColors.primary,
                size: 21,
              ),
              const SizedBox(width: 9),
              Expanded(
                child: Text(
                  title,
                  style: AppTextStyles.h3.copyWith(
                    color: AppColors.primary,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),

          for (int index = 0; index < items.length; index++) ...[
            _BulletItem(
              text: items[index],
            ),
            if (index != items.length - 1)
              const SizedBox(height: 12),
          ],
        ],
      ),
    );
  }
}

class _BulletItem extends StatelessWidget {
  const _BulletItem({
    required this.text,
  });

  final String text;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 6,
          height: 6,
          margin: const EdgeInsets.only(
            top: 7,
            right: 10,
          ),
          decoration: const BoxDecoration(
            color: AppColors.secondary,
            shape: BoxShape.circle,
          ),
        ),
        Expanded(
          child: Text(
            text,
            style: AppTextStyles.body.copyWith(
              color: AppColors.dark,
              height: 1.45,
            ),
          ),
        ),
      ],
    );
  }
}

class _BottomActions extends StatelessWidget {
  const _BottomActions({
    required this.continueLabel,
    required this.saveLabel,
    required this.savingLabel,
    required this.savedLabel,
    required this.onContinue,
    required this.onSave,
    required this.isSaving,
    required this.isSaved,
  });

  final String continueLabel;
  final String saveLabel;
  final String savingLabel;
  final String savedLabel;
  final VoidCallback onContinue;
  final VoidCallback onSave;
  final bool isSaving;
  final bool isSaved;

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
        child: Row(
          children: [
            Expanded(
              child: SizedBox(
                height: 52,
                child: OutlinedButton(
                  // Intentionally disabled until Continue Styling
                  // is connected to real closet recommendations.
                  onPressed: onContinue,
                  style: OutlinedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  child: Text(
                    continueLabel,
                    textAlign: TextAlign.center,
                    style: AppTextStyles.caption.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ),

            const SizedBox(width: 12),

            Expanded(
              child: SizedBox(
                height: 52,
                child: ElevatedButton.icon(
                  onPressed: isSaving || isSaved ? null : onSave,
                  icon: isSaving
                      ? const SizedBox(
                    width: 18,
                    height: 18,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: Colors.white,
                    ),
                  )
                      : Icon(
                    isSaved
                        ? Icons.favorite_rounded
                        : Icons.favorite_border_rounded,
                    size: 18,
                  ),
                  label: Text(
                    isSaving
                        ? savingLabel
                        : isSaved
                        ? savedLabel
                        : saveLabel,
                    style: AppTextStyles.caption.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    elevation: 0,
                    disabledBackgroundColor: isSaved
                        ? AppColors.primary
                        : AppColors.primary.withOpacity(0.65),
                    disabledForegroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
