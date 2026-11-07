import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gardirop/l10n/app_localizations.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_text_styles.dart';
import '../../application/onboarding_controller.dart';
import 'package:go_router/go_router.dart';

class FitSizeScreen extends ConsumerStatefulWidget {
  const FitSizeScreen({super.key});

  @override
  ConsumerState<FitSizeScreen> createState() =>
      _FitSizeScreenState();
}

class _FitSizeScreenState extends ConsumerState<FitSizeScreen> {
  Future<void> _selectSize() async {
    final onboarding = ref.read(onboardingControllerProvider);

    final sizes = onboarding.stylingFor == 'man'
        ? ['XS', 'S', 'M', 'L', 'XL', 'XXL']
        : ['XS', 'S', 'M', 'L', 'XL', 'XXL'];

    final selected = await showModalBottomSheet<String>(
      context: context,
      backgroundColor: AppColors.light,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(28),
        ),
      ),
      builder: (context) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(
              24,
              18,
              24,
              28,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 42,
                  height: 4,
                  decoration: BoxDecoration(
                    color: AppColors.taupe,
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
                const SizedBox(height: 20),
                ...sizes.map(
                      (size) => ListTile(
                    title: Text(
                      size,
                      style: AppTextStyles.body.copyWith(
                        color: AppColors.dark,
                      ),
                    ),
                    trailing: onboarding.size == size
                        ? const Icon(
                      Icons.check_rounded,
                      color: AppColors.primary,
                    )
                        : null,
                    onTap: () {
                      Navigator.of(context).pop(size);
                    },
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );

    if (selected != null) {
      ref
          .read(onboardingControllerProvider.notifier)
          .setSize(selected);
    }
  }

  Future<void> _selectFit() async {
    final l10n = AppLocalizations.of(context)!;
    final onboarding = ref.read(onboardingControllerProvider);

    final fits = [
      ('slim', l10n.fitSlim),
      ('regular', l10n.fitRegular),
      ('relaxed', l10n.fitRelaxed),
      ('oversized', l10n.fitOversized),
    ];

    final selected = await showModalBottomSheet<String>(
      context: context,
      backgroundColor: AppColors.light,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(28),
        ),
      ),
      builder: (context) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(
              24,
              18,
              24,
              28,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 42,
                  height: 4,
                  decoration: BoxDecoration(
                    color: AppColors.taupe,
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
                const SizedBox(height: 20),
                ...fits.map(
                      (fit) => ListTile(
                    title: Text(
                      fit.$2,
                      style: AppTextStyles.body.copyWith(
                        color: AppColors.dark,
                      ),
                    ),
                    trailing: onboarding.fitPreference == fit.$1
                        ? const Icon(
                      Icons.check_rounded,
                      color: AppColors.primary,
                    )
                        : null,
                    onTap: () {
                      Navigator.of(context).pop(fit.$1);
                    },
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );

    if (selected != null) {
      ref
          .read(onboardingControllerProvider.notifier)
          .setFitPreference(selected);
    }
  }

  Future<void> _enterHeight() async {
    final l10n = AppLocalizations.of(context)!;
    final onboarding = ref.read(onboardingControllerProvider);

    String inputValue =
        onboarding.heightCm?.toStringAsFixed(0) ?? '';

    final value = await showDialog<double>(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: AppColors.light,
          title: Text(
            l10n.enterHeight,
            style: AppTextStyles.h3.copyWith(
              color: AppColors.dark,
            ),
          ),
          content: TextFormField(
            initialValue: inputValue,
            autofocus: true,
            keyboardType: const TextInputType.numberWithOptions(
              decimal: true,
            ),
            decoration: InputDecoration(
              suffixText: l10n.centimeters,
            ),
            onChanged: (value) {
              inputValue = value;
            },
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                final parsed =
                double.tryParse(inputValue.trim());

                if (parsed != null && parsed > 0) {
                  Navigator.of(context).pop(parsed);
                }
              },
              child: const Text('Save'),
            ),
          ],
        );
      },
    );

    if (!mounted) return;

    if (value != null) {
      ref
          .read(onboardingControllerProvider.notifier)
          .setHeight(value);
    }
  }

  Future<void> _enterWeight() async {
    final l10n = AppLocalizations.of(context)!;
    final onboarding = ref.read(onboardingControllerProvider);

    String inputValue =
        onboarding.weightKg?.toStringAsFixed(0) ?? '';

    final result = await showDialog<_WeightDialogResult>(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: AppColors.light,
          title: Text(
            l10n.enterWeight,
            style: AppTextStyles.h3.copyWith(
              color: AppColors.dark,
            ),
          ),
          content: TextFormField(
            initialValue: inputValue,
            autofocus: true,
            keyboardType: const TextInputType.numberWithOptions(
              decimal: true,
            ),
            decoration: InputDecoration(
              suffixText: l10n.kilograms,
            ),
            onChanged: (value) {
              inputValue = value;
            },
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(
                  const _WeightDialogResult(clear: true),
                );
              },
              child: const Text('Clear'),
            ),
            ElevatedButton(
              onPressed: () {
                final parsed =
                double.tryParse(inputValue.trim());

                if (parsed != null && parsed > 0) {
                  Navigator.of(context).pop(
                    _WeightDialogResult(
                      value: parsed,
                    ),
                  );
                }
              },
              child: const Text('Save'),
            ),
          ],
        );
      },
    );

    if (!mounted || result == null) return;

    ref
        .read(onboardingControllerProvider.notifier)
        .setWeight(
      result.clear ? null : result.value,
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final onboarding = ref.watch(onboardingControllerProvider);

    final isArabic =
        Localizations.localeOf(context).languageCode == 'ar';

    String fitLabel() {
      switch (onboarding.fitPreference) {
        case 'slim':
          return l10n.fitSlim;
        case 'regular':
          return l10n.fitRegular;
        case 'relaxed':
          return l10n.fitRelaxed;
        case 'oversized':
          return l10n.fitOversized;
        default:
          return l10n.selectFit;
      }
    }

    final canContinue =
        onboarding.size != null &&
            onboarding.fitPreference != null &&
            onboarding.heightCm != null;

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
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              IconButton(
                onPressed: () =>
                    Navigator.of(context).maybePop(),
                padding: EdgeInsets.zero,
                alignment: AlignmentDirectional.centerStart,
                icon: Icon(
                  isArabic
                      ? Icons.arrow_forward_ios_rounded
                      : Icons.arrow_back_ios_new_rounded,
                  size: 20,
                  color: AppColors.dark,
                ),
              ),

              const SizedBox(height: 10),

              const Row(
                children: [
                  Expanded(
                    child: _ProgressLine(active: true),
                  ),
                  SizedBox(width: 6),
                  Expanded(
                    child: _ProgressLine(active: true),
                  ),
                  SizedBox(width: 6),
                  Expanded(
                    child: _ProgressLine(active: true),
                  ),
                  SizedBox(width: 6),
                  Expanded(
                    child: _ProgressLine(active: true),
                  ),
                ],
              ),

              const SizedBox(height: 26),

              Center(
                child: Text(
                  l10n.fitSizeTitle,
                  textAlign: TextAlign.center,
                  style: AppTextStyles.h2.copyWith(
                    color: AppColors.dark,
                    fontSize: 26,
                  ),
                ),
              ),

              const SizedBox(height: 8),

              Center(
                child: Text(
                  l10n.fitSizeSubtitle,
                  textAlign: TextAlign.center,
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.secondary,
                    fontSize: 14,
                    height: 1.35,
                  ),
                ),
              ),

              const SizedBox(height: 28),

              _DetailRow(
                icon: Icons.shopping_bag_outlined,
                label: l10n.mySize,
                value: onboarding.size ?? l10n.selectSize,
                onTap: _selectSize,
              ),

              _DetailRow(
                icon: Icons.favorite_border_rounded,
                label: l10n.fitPreference,
                value: fitLabel(),
                onTap: _selectFit,
              ),

              _DetailRow(
                icon: Icons.straighten_rounded,
                label: l10n.height,
                value: onboarding.heightCm == null
                    ? l10n.enterHeight
                    : '${onboarding.heightCm!.toStringAsFixed(0)} ${l10n.centimeters}',
                onTap: _enterHeight,
              ),

              _DetailRow(
                icon: Icons.monitor_weight_outlined,
                label: l10n.weightOptional,
                value: onboarding.weightKg == null
                    ? '--'
                    : '${onboarding.weightKg!.toStringAsFixed(0)} ${l10n.kilograms}',
                onTap: _enterWeight,
              ),

              const Spacer(),

              SizedBox(
                width: double.infinity,
                height: 58,
                child: ElevatedButton(
                  onPressed: canContinue
                      ? () {
                    ref
                        .read(onboardingControllerProvider.notifier)
                        .generateStyleDna();

                    context.push('/onboarding/style-dna');
                  }
                      : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.dark,
                    disabledBackgroundColor:
                    AppColors.taupe.withValues(
                      alpha: 0.55,
                    ),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  child: Text(
                    l10n.continueButton,
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

class _DetailRow extends StatelessWidget {
  const _DetailRow({
    required this.icon,
    required this.label,
    required this.value,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final String value;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(18),
          child: Container(
            constraints: const BoxConstraints(
              minHeight: 66,
            ),
            padding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 12,
            ),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.55),
              borderRadius: BorderRadius.circular(18),
              border: Border.all(
                color: AppColors.taupe.withValues(alpha: 0.7),
              ),
            ),
            child: Row(
              children: [
                Icon(
                  icon,
                  color: AppColors.dark,
                  size: 22,
                ),

                const SizedBox(width: 14),

                Expanded(
                  child: Text(
                    label,
                    style: AppTextStyles.body.copyWith(
                      color: AppColors.dark,
                      fontSize: 15,
                    ),
                  ),
                ),

                Text(
                  value,
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.secondary,
                    fontSize: 13,
                  ),
                ),

                const SizedBox(width: 8),

                const Icon(
                  Icons.chevron_right_rounded,
                  color: AppColors.secondary,
                  size: 20,
                ),
              ],
            ),
          ),
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
            : AppColors.taupe.withValues(alpha: 0.65),
        borderRadius: BorderRadius.circular(20),
      ),
    );
  }
}

class _WeightDialogResult {
  const _WeightDialogResult({
    this.value,
    this.clear = false,
  });

  final double? value;
  final bool clear;
}