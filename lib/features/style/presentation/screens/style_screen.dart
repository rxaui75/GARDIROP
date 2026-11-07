import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:gardirop/l10n/app_localizations.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_text_styles.dart';
import '../../../closet/application/wardrobe_provider.dart';
import '../../../closet/domain/wardrobe_item.dart';
import '../../application/saved_looks_provider.dart';
import '../../domain/saved_look.dart';
import 'saved_look_detail_screen.dart';

class StyleScreen extends ConsumerStatefulWidget {
  const StyleScreen({super.key});

  @override
  ConsumerState<StyleScreen> createState() => _StyleScreenState();
}

class _StyleScreenState extends ConsumerState<StyleScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _moveTo(int index) {
    if (!_pageController.hasClients) return;
    _pageController.animateToPage(
      index,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOutCubic,
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final savedLooksAsync = ref.watch(savedLooksProvider);
    final wardrobeAsync = ref.watch(wardrobeItemsProvider);

    return Scaffold(
      backgroundColor: AppColors.light,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    child: Text(
                      l10n.styleMeTitle,
                      style: AppTextStyles.h1.copyWith(color: AppColors.primary),
                    ),
                  ),
                  const SizedBox(width: 8),
                  OutlinedButton.icon(
                    onPressed: () => context.push('/style/select-items'),
                    icon: const Icon(Icons.add_rounded, size: 19),
                    label: Text(l10n.styleAnOutfit),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: AppColors.primary,
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                      side: BorderSide(color: AppColors.taupe),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(24),
                      ),
                      textStyle: AppTextStyles.small.copyWith(fontWeight: FontWeight.w600),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                l10n.styleMeSubtitle,
                style: AppTextStyles.body.copyWith(color: AppColors.secondary),
              ),
              const SizedBox(height: 22),
              Text(
                l10n.myLooks,
                style: AppTextStyles.h2.copyWith(color: AppColors.primary),
              ),
              const SizedBox(height: 4),
              Text(
                l10n.myLooksSubtitle,
                style: AppTextStyles.caption.copyWith(color: AppColors.secondary),
              ),
              const SizedBox(height: 14),
              savedLooksAsync.when(
                loading: () => const _LooksLoadingState(),
                error: (_, __) => _LooksErrorState(
                  message: l10n.savedLooksLoadError,
                  retryLabel: l10n.tryAgain,
                  onRetry: () => ref.invalidate(savedLooksProvider),
                ),
                data: (looks) {
                  if (looks.isEmpty) {
                    return _EmptyLooksState(
                      title: l10n.noSavedLooksTitle,
                      subtitle: l10n.noSavedLooksSubtitle,
                    );
                  }
                  return wardrobeAsync.when(
                    loading: () => const _LooksLoadingState(),
                    error: (_, __) => _LooksErrorState(
                      message: l10n.savedLooksLoadError,
                      retryLabel: l10n.tryAgain,
                      onRetry: () => ref.invalidate(wardrobeItemsProvider),
                    ),
                    data: (wardrobeItems) {
                      final wardrobeById = {
                        for (final item in wardrobeItems) item.id: item,
                      };
                      final page = _currentPage.clamp(0, looks.length - 1);
                      return Column(
                        children: [
                          SizedBox(
                            height: (MediaQuery.sizeOf(context).height * 0.43)
                                .clamp(265.0, 345.0),
                            child: PageView.builder(
                              controller: _pageController,
                              itemCount: looks.length,
                              onPageChanged: (index) {
                                setState(() => _currentPage = index);
                              },
                              itemBuilder: (context, index) => Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 2, vertical: 4),
                                child: _SavedLookCard(
                                  look: looks[index],
                                  wardrobeById: wardrobeById,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 8),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              _CarouselArrow(
                                icon: Icons.chevron_left_rounded,
                                enabled: page > 0,
                                onTap: () => _moveTo(page - 1),
                              ),
                              Text(
                                '${page + 1} / ${looks.length}',
                                style: AppTextStyles.caption.copyWith(
                                  color: AppColors.primary,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              _CarouselArrow(
                                icon: Icons.chevron_right_rounded,
                                enabled: page < looks.length - 1,
                                onTap: () => _moveTo(page + 1),
                              ),
                            ],
                          ),
                        ],
                      );
                    },
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _CarouselArrow extends StatelessWidget {
  const _CarouselArrow({
    required this.icon,
    required this.enabled,
    required this.onTap,
  });
  final IconData icon;
  final bool enabled;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.beige,
      shape: const CircleBorder(),
      child: IconButton(
        onPressed: enabled ? onTap : null,
        icon: Icon(icon),
        color: AppColors.primary,
        disabledColor: AppColors.secondary.withOpacity(0.35),
        tooltip: enabled ? null : '',
      ),
    );
  }
}

class _SavedLookCard extends StatelessWidget {
  const _SavedLookCard({
    required this.look,
    required this.wardrobeById,
  });
  final SavedLook look;
  final Map<String, WardrobeItem> wardrobeById;

  @override
  Widget build(BuildContext context) {
    final items = look.itemIds
        .map((id) => wardrobeById[id])
        .whereType<WardrobeItem>()
        .take(6)
        .toList(growable: false);
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(24),
        onTap: () {
          Navigator.of(context).push(
            MaterialPageRoute<void>(
              builder: (_) => SavedLookDetailScreen(
                look: look,
                items: items,
              ),
            ),
          );
        },
        child: Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: AppColors.beige,
            borderRadius: BorderRadius.circular(24),
            border: Border.all(color: AppColors.taupe.withOpacity(0.5)),
          ),
          child: _OutfitBoard(items: items),
        ),
      ),
    );
  }
}

class _OutfitBoard extends StatelessWidget {
  const _OutfitBoard({required this.items});
  final List<WardrobeItem> items;

  @override
  Widget build(BuildContext context) {
    if (items.isEmpty) {
      return const Center(
        child: Icon(Icons.checkroom_rounded, color: AppColors.secondary, size: 50),
      );
    }
    return LayoutBuilder(
      builder: (context, constraints) {
        final w = constraints.maxWidth;
        final h = constraints.maxHeight;
        // Balanced layouts based on the number of actual closet pieces.
        // Relative positions keep the composition responsive on small phones.
        final layouts = switch (items.length) {
          1 => <Rect>[
            Rect.fromLTWH(w * .19, h * .10, w * .62, h * .80),
          ],
          2 => <Rect>[
            Rect.fromLTWH(w * .07, h * .20, w * .43, h * .60),
            Rect.fromLTWH(w * .50, h * .20, w * .43, h * .60),
          ],
          3 => <Rect>[
            Rect.fromLTWH(w * .06, h * .08, w * .43, h * .53),
            Rect.fromLTWH(w * .51, h * .08, w * .43, h * .53),
            Rect.fromLTWH(w * .31, h * .60, w * .38, h * .35),
          ],
          4 => <Rect>[
            Rect.fromLTWH(w * .06, h * .05, w * .43, h * .43),
            Rect.fromLTWH(w * .51, h * .05, w * .43, h * .43),
            Rect.fromLTWH(w * .06, h * .52, w * .43, h * .43),
            Rect.fromLTWH(w * .51, h * .52, w * .43, h * .43),
          ],
          _ => <Rect>[
            Rect.fromLTWH(w * .04, h * .04, w * .44, h * .44),
            Rect.fromLTWH(w * .52, h * .04, w * .44, h * .44),
            Rect.fromLTWH(w * .30, h * .31, w * .40, h * .39),
            Rect.fromLTWH(w * .03, h * .63, w * .30, h * .32),
            Rect.fromLTWH(w * .35, h * .67, w * .30, h * .28),
            Rect.fromLTWH(w * .67, h * .63, w * .30, h * .32),
          ],
        };
        return ClipRRect(
          borderRadius: BorderRadius.circular(18),
          child: ColoredBox(
            color: AppColors.sand,
            child: Stack(
              children: [
                for (var i = 0; i < items.length; i++)
                  Positioned.fromRect(
                    rect: layouts[i],
                    child: _WardrobeImage(imagePath: items[i].imagePath),
                  ),
              ],
            ),
          ),
        );
      },
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
      return _placeholder();
    }

    if (imagePath.startsWith('assets/')) {
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
      color: AppColors.light,
      alignment: Alignment.center,
      child: const Icon(
        Icons.checkroom_rounded,
        color: AppColors.secondary,
        size: 30,
      ),
    );
  }
}

class _LooksLoadingState extends StatelessWidget {
  const _LooksLoadingState();

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.symmetric(vertical: 48),
      child: Center(
        child: CircularProgressIndicator(
          color: AppColors.primary,
        ),
      ),
    );
  }
}

class _LooksErrorState extends StatelessWidget {
  const _LooksErrorState({
    required this.message,
    required this.retryLabel,
    required this.onRetry,
  });

  final String message;
  final String retryLabel;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppColors.beige,
        borderRadius: BorderRadius.circular(22),
      ),
      child: Column(
        children: [
          const Icon(
            Icons.error_outline_rounded,
            color: AppColors.primary,
            size: 34,
          ),
          const SizedBox(height: 12),
          Text(
            message,
            textAlign: TextAlign.center,
            style: AppTextStyles.body.copyWith(
              color: AppColors.secondary,
            ),
          ),
          const SizedBox(height: 16),
          OutlinedButton(
            onPressed: onRetry,
            child: Text(retryLabel),
          ),
        ],
      ),
    );
  }
}

class _EmptyLooksState extends StatelessWidget {
  const _EmptyLooksState({
    required this.title,
    required this.subtitle,
  });

  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(
        horizontal: 24,
        vertical: 34,
      ),
      decoration: BoxDecoration(
        color: AppColors.beige,
        borderRadius: BorderRadius.circular(22),
      ),
      child: Column(
        children: [
          Container(
            width: 62,
            height: 62,
            decoration: const BoxDecoration(
              color: AppColors.light,
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.favorite_border_rounded,
              color: AppColors.primary,
              size: 27,
            ),
          ),
          const SizedBox(height: 18),
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
            style: AppTextStyles.caption.copyWith(
              color: AppColors.secondary,
            ),
          ),
        ],
      ),
    );
  }
}
