import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gardirop/l10n/app_localizations.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_text_styles.dart';
import '../../application/onboarding_controller.dart';
import '../../data/style_options.dart';
import '../../domain/style_option.dart';

import 'package:go_router/go_router.dart';

class StyleSwipeScreen extends ConsumerStatefulWidget {
  const StyleSwipeScreen({super.key});

  @override
  ConsumerState<StyleSwipeScreen> createState() =>
      _StyleSwipeScreenState();
}

class _StyleSwipeScreenState extends ConsumerState<StyleSwipeScreen> {
  int _currentIndex = 0;

  double _dragX = 0;
  bool _isAnimating = false;
  bool _completed = false;
  bool _didPrecache = false;

  static const double _swipeThreshold = 90;

  List<StyleOption> get _styles {
    final stylingFor =
        ref.read(onboardingControllerProvider).stylingFor;

    if (stylingFor == 'man') {
      return manStyleOptions;
    }

    return womanStyleOptions;
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    if (_didPrecache) return;
    _didPrecache = true;

    for (final style in _styles) {
      precacheImage(
        AssetImage(style.imagePath),
        context,
      );
    }
  }

  void _onPanUpdate(DragUpdateDetails details) {
    if (_isAnimating || _completed) return;

    setState(() {
      _dragX += details.delta.dx;
    });
  }

  void _onPanEnd(DragEndDetails details) {
    if (_isAnimating || _completed) return;

    if (_dragX > _swipeThreshold) {
      _chooseStyle(liked: true);
      return;
    }

    if (_dragX < -_swipeThreshold) {
      _chooseStyle(liked: false);
      return;
    }

    setState(() {
      _dragX = 0;
    });
  }

  Future<void> _chooseStyle({
    required bool liked,
  }) async {
    if (_isAnimating || _completed) return;
    if (_currentIndex >= _styles.length) return;

    final currentStyle = _styles[_currentIndex];

    setState(() {
      _isAnimating = true;

      _dragX = liked
          ? MediaQuery.sizeOf(context).width * 1.5
          : -MediaQuery.sizeOf(context).width * 1.5;
    });

    await Future.delayed(
      const Duration(milliseconds: 230),
    );

    if (!mounted) return;

    final controller =
    ref.read(onboardingControllerProvider.notifier);

    if (liked) {
      controller.likeStyle(currentStyle.id);
    } else {
      controller.dislikeStyle(currentStyle.id);
    }

    final isLastCard =
        _currentIndex == _styles.length - 1;

    if (isLastCard) {
      setState(() {
        _completed = true;
        _isAnimating = false;
        _dragX = 0;
      });

      return;
    }

    setState(() {
      _currentIndex++;
      _dragX = 0;
      _isAnimating = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final isArabic =
        Localizations.localeOf(context).languageCode == 'ar';

    if (_completed) {
      return _buildCompletedState(
        context,
        l10n,
      );
    }

    final currentStyle = _styles[_currentIndex];

    final screenWidth =
        MediaQuery.sizeOf(context).width;

    final rotation =
        (_dragX / screenWidth) * 0.12;

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
              // Back button
              Align(
                alignment: AlignmentDirectional.centerStart,
                child: IconButton(
                  onPressed: _isAnimating
                      ? null
                      : () {
                    Navigator.of(context).maybePop();
                  },
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

              const SizedBox(height: 10),

              // Progress
              Row(
                children: [
                  const Expanded(
                    child: _ProgressLine(
                      active: true,
                    ),
                  ),
                  const SizedBox(width: 6),
                  const Expanded(
                    child: _ProgressLine(
                      active: true,
                    ),
                  ),
                  const SizedBox(width: 6),
                  const Expanded(
                    child: _ProgressLine(),
                  ),
                  const SizedBox(width: 6),
                  const Expanded(
                    child: _ProgressLine(),
                  ),
                ],
              ),

              const SizedBox(height: 20),

              // Title
              Text(
                l10n.styleSwipeTitle,
                textAlign: TextAlign.center,
                style: AppTextStyles.h2.copyWith(
                  color: AppColors.dark,
                  fontSize: 25,
                  height: 1.15,
                  fontWeight: FontWeight.w600,
                ),
              ),

              const SizedBox(height: 8),

              // Subtitle
              Text(
                l10n.styleSwipeSubtitle,
                textAlign: TextAlign.center,
                style: AppTextStyles.caption.copyWith(
                  color: AppColors.secondary,
                  fontSize: 14,
                  height: 1.3,
                ),
              ),

              const SizedBox(height: 16),

              // Cards
              Expanded(
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    final cardHeight =
                    math.min(
                      constraints.maxHeight,
                      560.0,
                    );

                    return Center(
                      child: SizedBox(
                        height: cardHeight,
                        width: double.infinity,
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            // Third card behind
                            if (_currentIndex + 2 <
                                _styles.length)
                              Transform.translate(
                                offset:
                                const Offset(0, 20),
                                child: Transform.scale(
                                  scale: 0.92,
                                  child: _StyleCard(
                                    style:
                                    _styles[_currentIndex + 2],
                                    isBackground: true,
                                  ),
                                ),
                              ),

                            // Second card behind
                            if (_currentIndex + 1 <
                                _styles.length)
                              Transform.translate(
                                offset:
                                const Offset(0, 10),
                                child: Transform.scale(
                                  scale: 0.96,
                                  child: _StyleCard(
                                    style:
                                    _styles[_currentIndex + 1],
                                    isBackground: true,
                                  ),
                                ),
                              ),

                            // Current draggable card
                            AnimatedContainer(
                              duration: _isAnimating
                                  ? const Duration(
                                milliseconds: 220,
                              )
                                  : Duration.zero,
                              curve: Curves.easeOut,
                              transform:
                              Matrix4.identity()
                                ..translate(
                                  _dragX,
                                  0.0,
                                )
                                ..rotateZ(rotation),
                              transformAlignment:
                              Alignment.center,
                              child: GestureDetector(
                                onPanUpdate:
                                _onPanUpdate,
                                onPanEnd: _onPanEnd,
                                child: Stack(
                                  children: [
                                    _StyleCard(
                                      style:
                                      currentStyle,
                                    ),

                                    // LIKE indicator
                                    if (_dragX > 25)
                                      Positioned(
                                        top: 24,
                                        left: 24,
                                        child:
                                        _SwipeIndicator(
                                          label:
                                          l10n.styleSwipeYes,
                                          icon:
                                          Icons.favorite_rounded,
                                          positive:
                                          true,
                                          opacity:
                                          (_dragX.abs() /
                                              120)
                                              .clamp(
                                            0.0,
                                            1.0,
                                          ),
                                        ),
                                      ),

                                    // NO indicator
                                    if (_dragX < -25)
                                      Positioned(
                                        top: 24,
                                        right: 24,
                                        child:
                                        _SwipeIndicator(
                                          label:
                                          l10n.styleSwipeNo,
                                          icon:
                                          Icons.close_rounded,
                                          positive:
                                          false,
                                          opacity:
                                          (_dragX.abs() /
                                              120)
                                              .clamp(
                                            0.0,
                                            1.0,
                                          ),
                                        ),
                                      ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),

              const SizedBox(height: 18),

              // Counter
              Text(
                '${_currentIndex + 1} / ${_styles.length}',
                style: AppTextStyles.body.copyWith(
                  color: AppColors.dark,
                  fontWeight: FontWeight.w500,
                ),
              ),

              const SizedBox(height: 16),

              // Action buttons
              Row(
                mainAxisAlignment:
                MainAxisAlignment.center,
                children: [
                  _SwipeButton(
                    icon: Icons.close_rounded,
                    onPressed: _isAnimating
                        ? null
                        : () {
                      _chooseStyle(
                        liked: false,
                      );
                    },
                  ),

                  const SizedBox(width: 64),

                  _SwipeButton(
                    icon: Icons.favorite_rounded,
                    isPrimary: true,
                    onPressed: _isAnimating
                        ? null
                        : () {
                      _chooseStyle(
                        liked: true,
                      );
                    },
                  ),
                ],
              ),

              const SizedBox(height: 8),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCompletedState(
      BuildContext context,
      AppLocalizations l10n,
      ) {
    return Scaffold(
      backgroundColor: AppColors.light,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 32,
          ),
          child: Center(
            child: Column(
              mainAxisAlignment:
              MainAxisAlignment.center,
              children: [
                Container(
                  width: 86,
                  height: 86,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: AppColors.primary,
                  ),
                  child: const Icon(
                    Icons.favorite_rounded,
                    color: Colors.white,
                    size: 38,
                  ),
                ),

                const SizedBox(height: 28),

                Text(
                  l10n.styleSwipeComplete,
                  textAlign: TextAlign.center,
                  style: AppTextStyles.h1.copyWith(
                    color: AppColors.dark,
                    fontSize: 30,
                  ),
                ),

                const SizedBox(height: 14),

                Text(
                  '${ref.read(onboardingControllerProvider).likedStyles.length} styles liked',
                  textAlign: TextAlign.center,
                  style: AppTextStyles.body.copyWith(
                    color: AppColors.secondary,
                  ),
                ),

                const SizedBox(height: 36),

                SizedBox(
                  width: double.infinity,
                  height: 58,
                  child: ElevatedButton(
                    onPressed: () {
                      context.push('/onboarding/preferences');
                    },
                    style:
                    ElevatedButton.styleFrom(
                      backgroundColor:
                      AppColors.dark,
                      foregroundColor:
                      Colors.white,
                      shape:
                      RoundedRectangleBorder(
                        borderRadius:
                        BorderRadius.circular(
                          30,
                        ),
                      ),
                    ),
                    child: Text(
                      l10n.continueButton,
                      style:
                      AppTextStyles.body.copyWith(
                        color: Colors.white,
                        fontWeight:
                        FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _StyleCard extends StatelessWidget {
  const _StyleCard({
    required this.style,
    this.isBackground = false,
  });

  final StyleOption style;
  final bool isBackground;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: AppColors.light,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: AppColors.taupe.withValues(
            alpha: 0.75,
          ),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(
              alpha: isBackground ? 0.03 : 0.10,
            ),
            blurRadius:
            isBackground ? 10 : 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(23),
        child: Column(
          children: [
            Expanded(
              child: SizedBox(
                width: double.infinity,
                child: Image.asset(
                  style.imagePath,
                  fit: BoxFit.cover,
                  alignment: Alignment.center,
                ),
              ),
            ),

            Container(
              width: double.infinity,
              padding: const EdgeInsets.fromLTRB(
                18,
                10,
                18,
                12,
              ),
              color: AppColors.light,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    style.title,
                    maxLines: 1,
                    style: AppTextStyles.h3.copyWith(
                      color: AppColors.dark,
                      fontSize: 17,
                      fontWeight: FontWeight.w600,
                    ),
                  ),

                  const SizedBox(height: 2),

                  Text(
                    style.description,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: AppTextStyles.caption.copyWith(
                      color: AppColors.secondary,
                      fontSize: 12.5,
                      height: 1.25,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SwipeButton extends StatelessWidget {
  const _SwipeButton({
    required this.icon,
    required this.onPressed,
    this.isPrimary = false,
  });

  final IconData icon;
  final VoidCallback? onPressed;
  final bool isPrimary;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onPressed,
        customBorder: const CircleBorder(),
        child: Container(
          width: 62,
          height: 62,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: isPrimary
                ? AppColors.primary
                : Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(
                  alpha: 0.10,
                ),
                blurRadius: 16,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: Icon(
            icon,
            color: isPrimary
                ? Colors.white
                : AppColors.dark,
            size: isPrimary ? 28 : 30,
          ),
        ),
      ),
    );
  }
}

class _SwipeIndicator extends StatelessWidget {
  const _SwipeIndicator({
    required this.label,
    required this.icon,
    required this.positive,
    required this.opacity,
  });

  final String label;
  final IconData icon;
  final bool positive;
  final double opacity;

  @override
  Widget build(BuildContext context) {
    return Opacity(
      opacity: opacity,
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: 14,
          vertical: 9,
        ),
        decoration: BoxDecoration(
          color: positive
              ? AppColors.primary
              .withValues(alpha: 0.9)
              : AppColors.dark
              .withValues(alpha: 0.85),
          borderRadius: BorderRadius.circular(30),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              color: Colors.white,
              size: 17,
            ),
            const SizedBox(width: 6),
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
    );
  }
}

class _ProgressLine extends StatelessWidget {
  const _ProgressLine({
    this.active = false,
  });

  final bool active;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 4,
      decoration: BoxDecoration(
        color: active
            ? AppColors.primary
            : AppColors.taupe.withValues(
          alpha: 0.65,
        ),
        borderRadius: BorderRadius.circular(20),
      ),
    );
  }
}