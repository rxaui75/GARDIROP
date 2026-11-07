import 'dart:async';

import 'package:flutter/material.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_text_styles.dart';
import '../../../../l10n/app_localizations.dart';

enum GardiAnalyzingMode {
  item,
  outfit,
}

class GardiAnalyzingDialog extends StatefulWidget {
  const GardiAnalyzingDialog({
    super.key,
    this.mode = GardiAnalyzingMode.item,
  });

  final GardiAnalyzingMode mode;

  @override
  State<GardiAnalyzingDialog> createState() =>
      _GardiAnalyzingDialogState();
}

class _GardiAnalyzingDialogState extends State<GardiAnalyzingDialog>
    with TickerProviderStateMixin {
  int _activeStep = 0;
  Timer? _stepTimer;

  late final AnimationController _rotationController;
  late final AnimationController _pulseController;

  List<_AnalysisStep> _getSteps(AppLocalizations l10n) {
    switch (widget.mode) {
      case GardiAnalyzingMode.item:
        return [
          _AnalysisStep(
            icon: Icons.checkroom_outlined,
            text: l10n.gardiItemStepIdentify,
          ),
          _AnalysisStep(
            icon: Icons.palette_outlined,
            text: l10n.gardiItemStepColor,
          ),
          _AnalysisStep(
            icon: Icons.texture_outlined,
            text: l10n.gardiItemStepMaterial,
          ),
          _AnalysisStep(
            icon: Icons.auto_awesome_outlined,
            text: l10n.gardiItemStepStyle,
          ),
          _AnalysisStep(
            icon: Icons.wb_sunny_outlined,
            text: l10n.gardiItemStepSeason,
          ),
        ];

      case GardiAnalyzingMode.outfit:
        return [
          _AnalysisStep(
            icon: Icons.palette_outlined,
            text: l10n.gardiOutfitStepColor,
          ),
          _AnalysisStep(
            icon: Icons.auto_awesome_outlined,
            text: l10n.gardiOutfitStepStyle,
          ),
          _AnalysisStep(
            icon: Icons.balance_outlined,
            text: l10n.gardiOutfitStepFit,
          ),
          _AnalysisStep(
            icon: Icons.event_available_outlined,
            text: l10n.gardiOutfitStepOccasion,
          ),
          _AnalysisStep(
            icon: Icons.checkroom_outlined,
            text: l10n.gardiOutfitStepFinish,
          ),
        ];
    }
  }

  @override
  void initState() {
    super.initState();

    _rotationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 9),
    )..repeat();

    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1100),
      lowerBound: 0.94,
      upperBound: 1.06,
    )..repeat(reverse: true);

    _stepTimer = Timer.periodic(
      const Duration(milliseconds: 1700),
          (_) {
        if (!mounted) return;

        setState(() {
          if (_activeStep < 4) {
            _activeStep++;
          }
        });
      },
    );
  }

  @override
  void dispose() {
    _stepTimer?.cancel();
    _rotationController.dispose();
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final steps = _getSteps(l10n);

    final isOutfit = widget.mode == GardiAnalyzingMode.outfit;

    final title = isOutfit
        ? l10n.gardiAnalyzingOutfitTitle
        : l10n.gardiAnalyzingItemTitle;

    final progressText = isOutfit
        ? l10n.gardiAnalyzingOutfitProgress
        : l10n.gardiAnalyzingItemProgress;

    return PopScope(
      canPop: false,
      child: Dialog(
        backgroundColor: Colors.transparent,
        insetPadding: const EdgeInsets.symmetric(horizontal: 24),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.fromLTRB(24, 30, 24, 26),
          decoration: BoxDecoration(
            color: AppColors.light,
            borderRadius: BorderRadius.circular(28),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.12),
                blurRadius: 30,
                offset: const Offset(0, 14),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                title,
                textAlign: TextAlign.center,
                style: AppTextStyles.h2.copyWith(
                  color: AppColors.dark,
                  height: 1.15,
                ),
              ),

              const SizedBox(height: 8),

              Text(
                l10n.gardiAnalyzingWait,
                style: AppTextStyles.body.copyWith(
                  color: AppColors.secondary,
                ),
              ),

              const SizedBox(height: 30),

              SizedBox(
                width: 235,
                height: 235,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    RotationTransition(
                      turns: _rotationController,
                      child: Container(
                        width: 210,
                        height: 210,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: AppColors.secondary.withOpacity(0.28),
                            width: 1.2,
                          ),
                        ),
                      ),
                    ),

                    _OrbitIcon(
                      alignment: const Alignment(0, -1),
                      icon: steps[0].icon,
                      active: _activeStep == 0,
                    ),

                    _OrbitIcon(
                      alignment: const Alignment(0.95, -0.25),
                      icon: steps[1].icon,
                      active: _activeStep == 1,
                    ),

                    _OrbitIcon(
                      alignment: const Alignment(0.62, 0.82),
                      icon: steps[2].icon,
                      active: _activeStep == 2,
                    ),

                    _OrbitIcon(
                      alignment: const Alignment(-0.62, 0.82),
                      icon: steps[3].icon,
                      active: _activeStep == 3,
                    ),

                    _OrbitIcon(
                      alignment: const Alignment(-0.95, -0.25),
                      icon: steps[4].icon,
                      active: _activeStep == 4,
                    ),

                    ScaleTransition(
                      scale: _pulseController,
                      child: Container(
                        width: 104,
                        height: 104,
                        decoration: BoxDecoration(
                          color: AppColors.beige,
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: AppColors.primary.withOpacity(0.08),
                              blurRadius: 24,
                            ),
                          ],
                        ),
                        child: Icon(
                          isOutfit
                              ? Icons.auto_awesome_rounded
                              : Icons.checkroom_rounded,
                          size: 48,
                          color: AppColors.primary,
                        ),
                      ),
                    ),

                    Positioned(
                      right: 48,
                      top: 44,
                      child: _Sparkle(
                        controller: _pulseController,
                        size: 17,
                      ),
                    ),

                    Positioned(
                      left: 48,
                      bottom: 48,
                      child: _Sparkle(
                        controller: _pulseController,
                        size: 13,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              AnimatedSwitcher(
                duration: const Duration(milliseconds: 350),
                transitionBuilder: (child, animation) {
                  return FadeTransition(
                    opacity: animation,
                    child: SlideTransition(
                      position: Tween<Offset>(
                        begin: const Offset(0, 0.2),
                        end: Offset.zero,
                      ).animate(animation),
                      child: child,
                    ),
                  );
                },
                child: Row(
                  key: ValueKey(_activeStep),
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      steps[_activeStep].icon,
                      size: 19,
                      color: AppColors.primary,
                    ),
                    const SizedBox(width: 9),
                    Flexible(
                      child: Text(
                        steps[_activeStep].text,
                        textAlign: TextAlign.center,
                        style: AppTextStyles.body.copyWith(
                          color: AppColors.dark,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 22),

              ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: LinearProgressIndicator(
                  minHeight: 5,
                  value: (_activeStep + 1) / steps.length,
                  backgroundColor: AppColors.taupe.withOpacity(0.35),
                  valueColor: const AlwaysStoppedAnimation<Color>(
                    AppColors.primary,
                  ),
                ),
              ),

              const SizedBox(height: 14),

              Text(
                _activeStep < steps.length - 1
                    ? progressText
                    : l10n.gardiAnalyzingAlmostDone,
                textAlign: TextAlign.center,
                style: AppTextStyles.small.copyWith(
                  color: AppColors.secondary,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _AnalysisStep {
  const _AnalysisStep({
    required this.icon,
    required this.text,
  });

  final IconData icon;
  final String text;
}

class _OrbitIcon extends StatelessWidget {
  const _OrbitIcon({
    required this.alignment,
    required this.icon,
    required this.active,
  });

  final Alignment alignment;
  final IconData icon;
  final bool active;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: alignment,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 350),
        width: active ? 48 : 42,
        height: active ? 48 : 42,
        decoration: BoxDecoration(
          color: active ? AppColors.taupe : AppColors.beige,
          shape: BoxShape.circle,
          border: Border.all(
            color: active
                ? AppColors.primary.withOpacity(0.25)
                : Colors.transparent,
          ),
        ),
        child: Icon(
          icon,
          size: active ? 22 : 19,
          color: active
              ? AppColors.primary
              : AppColors.secondary,
        ),
      ),
    );
  }
}

class _Sparkle extends StatelessWidget {
  const _Sparkle({
    required this.controller,
    required this.size,
  });

  final Animation<double> controller;
  final double size;

  @override
  Widget build(BuildContext context) {
    return ScaleTransition(
      scale: controller,
      child: Icon(
        Icons.auto_awesome_rounded,
        size: size,
        color: AppColors.secondary,
      ),
    );
  }
}