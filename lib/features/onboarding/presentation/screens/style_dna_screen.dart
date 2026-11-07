import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gardirop/l10n/app_localizations.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_text_styles.dart';
import '../../application/onboarding_controller.dart';
import 'package:go_router/go_router.dart';
class StyleDnaScreen extends ConsumerWidget {
  const StyleDnaScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final onboarding = ref.watch(onboardingControllerProvider);
    final styleDna = onboarding.styleDna;

    final isArabic =
        Localizations.localeOf(context).languageCode == 'ar';

    if (styleDna == null) {
      return Scaffold(
        backgroundColor: AppColors.light,
        body: SafeArea(
          child: Center(
            child: Text(
              l10n.genericError,
              style: AppTextStyles.body.copyWith(
                color: AppColors.dark,
              ),
            ),
          ),
        ),
      );
    }

    final tags = styleDna.tags;

    String localizedTag(String tag) {
      switch (tag.toLowerCase()) {
        case 'minimal':
          return l10n.vibeMinimal;
        case 'chic':
          return l10n.vibeChic;
        case 'casual':
          return l10n.vibeCasual;
        case 'trendy':
          return l10n.vibeTrendy;
        case 'classic':
          return l10n.vibeClassic;
        case 'edgy':
          return l10n.vibeEdgy;
        case 'elegant':
          return 'Elegant';
        case 'streetwear':
          return 'Streetwear';
        case 'sporty':
          return 'Sporty';
        case 'romantic':
          return 'Romantic';
        case 'bold':
          return 'Bold';
        case 'rugged':
          return 'Rugged';
        case 'relaxed':
          return isArabic ? 'مريح' : 'Relaxed';
        case 'defined':
          return isArabic ? 'محدد' : 'Defined';
        case 'balanced':
          return isArabic ? 'متوازن' : 'Balanced';
        case 'versatile':
          return isArabic ? 'متعدد الاستخدامات' : 'Versatile';
        case 'polished':
          return isArabic ? 'مرتب وأنيق' : 'Polished';
        case 'effortless':
          return isArabic ? 'بسيط وطبيعي' : 'Effortless';
        case 'timeless':
          return isArabic ? 'كلاسيكي دائم' : 'Timeless';
        case 'personal':
          return isArabic ? 'شخصي' : 'Personal';
        default:
          return tag;
      }
    }

    String localizedHighlight(String highlight) {
      switch (highlight) {
        case 'Clean and effortless styling':
          return l10n.highlightMinimal;
        case 'Timeless and refined pieces':
          return l10n.highlightClassic;
        case 'Polished and elevated looks':
          return l10n.highlightPolished;
        case 'Comfortable everyday outfits':
          return l10n.highlightCasual;
        case 'Expressive looks with personality':
          return l10n.highlightExpressive;
        case 'Confident statement styling':
          return l10n.highlightBold;
        case 'Practical looks built for movement':
          return l10n.highlightSporty;
        case 'Soft and feminine details':
          return l10n.highlightRomantic;
        case 'Strong textures and practical pieces':
          return l10n.highlightRugged;
        case 'Versatile across different occasions':
          return l10n.highlightVersatile;
        case 'Prefers a more fitted silhouette':
          return l10n.highlightSlimFit;
        case 'Prefers a balanced regular fit':
          return l10n.highlightRegularFit;
        case 'Prefers comfortable relaxed fits':
          return l10n.highlightRelaxedFit;
        case 'Enjoys oversized silhouettes':
          return l10n.highlightOversizedFit;
        case 'Easy to mix and match':
          return l10n.highlightMixMatch;
        case 'A balance of comfort and style':
          return l10n.highlightComfortStyle;
        case 'Personalized around your preferences':
          return l10n.highlightPersonalized;
        default:
          return highlight;
      }
    }

    return Scaffold(
      backgroundColor: AppColors.light,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(
            28,
            18,
            28,
            20,
          ),
          child: Column(
            children: [
              Align(
                alignment: AlignmentDirectional.centerStart,
                child: IconButton(
                  onPressed: () =>
                      Navigator.of(context).maybePop(),
                  padding: EdgeInsets.zero,
                  icon: Icon(
                    isArabic
                        ? Icons.arrow_forward_ios_rounded
                        : Icons.arrow_back_ios_new_rounded,
                    size: 20,
                    color: AppColors.dark,
                  ),
                ),
              ),

              const SizedBox(height: 22),


              Text(
                l10n.styleDnaTitle,
                textAlign: TextAlign.center,
                style: AppTextStyles.h1.copyWith(
                  color: AppColors.dark,
                  fontSize: 30,
                ),
              ),

              const SizedBox(height: 8),

              Text(
                l10n.styleDnaSubtitle,
                textAlign: TextAlign.center,
                style: AppTextStyles.caption.copyWith(
                  color: AppColors.secondary,
                  fontSize: 14,
                  height: 1.35,
                ),
              ),

              const SizedBox(height: 18),

              Expanded(
                child: Column(
                  children: [
                    SizedBox(
                      height: 270,
                      child: _StyleBubbleCloud(
                        tags: tags
                            .map(localizedTag)
                            .toList(),
                      ),
                    ),

                    const SizedBox(height: 24),

                    Expanded(
                      child: ListView.separated(
                        physics:
                        const NeverScrollableScrollPhysics(),
                        itemCount:
                        styleDna.highlights.length,
                        separatorBuilder: (_, __) =>
                        const SizedBox(height: 12),
                        itemBuilder: (context, index) {
                          final text = localizedHighlight(
                            styleDna.highlights[index],
                          );

                          return _HighlightRow(
                            text: text,
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),

              SizedBox(
                width: double.infinity,
                height: 58,
                child: ElevatedButton(
                  onPressed: () async {
                    try {
                      await ref
                          .read(onboardingControllerProvider.notifier)
                          .saveOnboardingToFirestore();

                      if (!context.mounted) return;

                      context.push('/onboarding/add-first-items');
                    } catch (error) {
                      if (!context.mounted) return;

                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            l10n.genericError,
                          ),
                          backgroundColor: AppColors.error,
                        ),
                      );
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.dark,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius:
                      BorderRadius.circular(30),
                    ),
                  ),
                  child: Text(
                    l10n.styleDnaContinue,
                    style: AppTextStyles.body.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _StyleBubbleCloud extends StatelessWidget {
  const _StyleBubbleCloud({
    required this.tags,
  });

  final List<String> tags;

  @override
  Widget build(BuildContext context) {
    final safeTags = [
      ...tags,
      ...List.filled(5, ''),
    ].take(5).toList();

    return LayoutBuilder(
      builder: (context, constraints) {
        return Stack(
          alignment: Alignment.center,
          children: [
            // Main style
            _StyleBubble(
              label: safeTags[0],
              size: 112,
              offset: const Offset(0, -55),
              isPrimary: true,
            ),

            // Upper left
            _StyleBubble(
              label: safeTags[1],
              size: 86,
              offset: const Offset(-92, 20),
            ),

            // Upper right
            _StyleBubble(
              label: safeTags[2],
              size: 86,
              offset: const Offset(92, 20),
            ),

            // Lower left
            _StyleBubble(
              label: safeTags[3],
              size: 76,
              offset: const Offset(-50, 94),
            ),

            // Lower right
            _StyleBubble(
              label: safeTags[4],
              size: 76,
              offset: const Offset(50, 94),
            ),
          ],
        );
      },
    );
  }
}

class _StyleBubble extends StatelessWidget {
  const _StyleBubble({
    required this.label,
    required this.size,
    required this.offset,
    this.isPrimary = false,
  });

  final String label;
  final double size;
  final Offset offset;
  final bool isPrimary;

  @override
  Widget build(BuildContext context) {
    return Transform.translate(
      offset: offset,
      child: Container(
        width: size,
        height: size,
        alignment: Alignment.center,
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: isPrimary
              ? AppColors.primary
              : AppColors.beige,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(
                alpha: isPrimary ? 0.10 : 0.05,
              ),
              blurRadius: 14,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Text(
          label,
          textAlign: TextAlign.center,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: AppTextStyles.caption.copyWith(
            color: isPrimary
                ? Colors.white
                : AppColors.dark,
            fontWeight: FontWeight.w600,
            fontSize: isPrimary ? 14 : 12,
          ),
        ),
      ),
    );
  }
}

class _HighlightRow extends StatelessWidget {
  const _HighlightRow({
    required this.text,
  });

  final String text;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 26,
          height: 26,
          decoration: const BoxDecoration(
            shape: BoxShape.circle,
            color: AppColors.primary,
          ),
          child: const Icon(
            Icons.check_rounded,
            color: Colors.white,
            size: 16,
          ),
        ),

        const SizedBox(width: 12),

        Expanded(
          child: Text(
            text,
            style: AppTextStyles.body.copyWith(
              color: AppColors.dark,
              fontSize: 14,
              height: 1.35,
            ),
          ),
        ),
      ],
    );
  }
}

