import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../application/saved_looks_provider.dart';
import 'package:gardirop/l10n/app_localizations.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_text_styles.dart';
import '../../../closet/domain/wardrobe_item.dart';
import '../../domain/saved_look.dart';

class SavedLookDetailScreen extends ConsumerStatefulWidget {
  const SavedLookDetailScreen({
    super.key,
    required this.look,
    required this.items,
  });

  final SavedLook look;
  final List<WardrobeItem> items;

  @override
  ConsumerState<SavedLookDetailScreen> createState() =>
      _SavedLookDetailScreenState();
}

class _SavedLookDetailScreenState
    extends ConsumerState<SavedLookDetailScreen> {
  bool _isDeleting = false;

  Future<void> _confirmDelete() async {
    if (_isDeleting) return;
    final l10n = AppLocalizations.of(context)!;
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        backgroundColor: AppColors.light,
        title: Text(l10n.deleteLookConfirmTitle),
        content: Text(l10n.deleteLookConfirmMessage),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(false),
            child: Text(MaterialLocalizations.of(dialogContext).cancelButtonLabel),
          ),
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(true),
            child: Text(
              l10n.deleteLook,
              style: const TextStyle(color: Colors.redAccent),
            ),
          ),
        ],
      ),
    );
    if (confirmed != true || !mounted) return;

    setState(() => _isDeleting = true);
    try {
      await ref.read(savedLooksRepositoryProvider).deleteLook(widget.look.id);
      if (!mounted) return;
      Navigator.of(context).pop();
    } catch (error, stackTrace) {
      debugPrint('Delete saved look failed: $error\n$stackTrace');
      if (!mounted) return;
      setState(() => _isDeleting = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n.deleteLookError)),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final assessment = switch (widget.look.overallAssessment) {
      'works_well' => l10n.gardiWorksWell,
      'almost_there' => l10n.gardiAlmostThere,
      _ => l10n.gardiNeedsAdjustment,
    };

    return Scaffold(
      backgroundColor: AppColors.light,
      appBar: AppBar(
        backgroundColor: AppColors.light,
        foregroundColor: AppColors.primary,
        elevation: 0,
        centerTitle: true,
        title: Text(
          l10n.myLooks,
          style: AppTextStyles.h3.copyWith(color: AppColors.primary),
        ),
        actions: [
          if (_isDeleting)
            const Padding(
              padding: EdgeInsets.all(14),
              child: SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(strokeWidth: 2),
              ),
            )
          else
            PopupMenuButton<String>(
              icon: const Icon(Icons.more_vert_rounded),
              onSelected: (value) {
                if (value == 'delete') _confirmDelete();
              },
              itemBuilder: (context) => [
                PopupMenuItem<String>(
                  value: 'delete',
                  child: Row(
                    children: [
                      const Icon(Icons.delete_outline_rounded,
                          color: Colors.redAccent),
                      const SizedBox(width: 10),
                      Text(l10n.deleteLook),
                    ],
                  ),
                ),
              ],
            ),
        ],
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(18, 8, 18, 28),
          children: [
            Container(
              height: 300,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppColors.beige,
                borderRadius: BorderRadius.circular(26),
              ),
              child: _DetailBoard(items: widget.items.take(6).toList()),
            ),
            const SizedBox(height: 20),
            _SectionCard(
              icon: Icons.auto_awesome_rounded,
              title: l10n.gardiTakeTitle,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 11,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.sand,
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: Text(
                      assessment,
                      style: AppTextStyles.small.copyWith(
                        color: AppColors.primary,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  if (widget.look.summary.trim().isNotEmpty) ...[
                    const SizedBox(height: 12),
                    Text(
                      widget.look.summary,
                      style: AppTextStyles.body.copyWith(
                        color: AppColors.dark,
                        height: 1.45,
                      ),
                    ),
                  ],
                ],
              ),
            ),
            if (widget.look.strengths.isNotEmpty) ...[
              const SizedBox(height: 14),
              _SectionCard(
                icon: Icons.checkroom_rounded,
                title: l10n.gardiWhyItWorks,
                child: Column(
                  children: [
                    for (var i = 0; i < widget.look.strengths.length; i++) ...[
                      _TextPoint(
                        icon: Icons.check_rounded,
                        text: widget.look.strengths[i],
                      ),
                      if (i < widget.look.strengths.length - 1)
                        const SizedBox(height: 12),
                    ],
                  ],
                ),
              ),
            ],
            if (widget.look.suggestions.isNotEmpty) ...[
              const SizedBox(height: 14),
              _SectionCard(
                icon: Icons.lightbulb_outline_rounded,
                title: l10n.gardiSuggestions,
                child: Column(
                  children: [
                    for (var i = 0; i < widget.look.suggestions.length; i++) ...[
                      _SuggestionTile(text: widget.look.suggestions[i]),
                      if (i < widget.look.suggestions.length - 1)
                        const SizedBox(height: 10),
                    ],
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _SectionCard extends StatelessWidget {
  const _SectionCard({
    required this.icon,
    required this.title,
    required this.child,
  });

  final IconData icon;
  final String title;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: AppColors.beige,
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 42,
                height: 42,
                decoration: const BoxDecoration(
                  color: AppColors.sand,
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, color: AppColors.primary, size: 21),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  title,
                  style: AppTextStyles.h3.copyWith(color: AppColors.primary),
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          child,
        ],
      ),
    );
  }
}

class _TextPoint extends StatelessWidget {
  const _TextPoint({required this.icon, required this.text});

  final IconData icon;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 23,
          height: 23,
          decoration: const BoxDecoration(
            color: AppColors.secondary,
            shape: BoxShape.circle,
          ),
          child: Icon(icon, color: Colors.white, size: 15),
        ),
        const SizedBox(width: 11),
        Expanded(
          child: Text(
            text,
            style: AppTextStyles.body.copyWith(
              color: AppColors.dark,
              height: 1.4,
            ),
          ),
        ),
      ],
    );
  }
}

class _SuggestionTile extends StatelessWidget {
  const _SuggestionTile({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(13),
      decoration: BoxDecoration(
        color: AppColors.light,
        borderRadius: BorderRadius.circular(17),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.only(top: 2),
            child: Icon(
              Icons.tips_and_updates_outlined,
              color: AppColors.secondary,
              size: 20,
            ),
          ),
          const SizedBox(width: 11),
          Expanded(
            child: Text(
              text,
              style: AppTextStyles.body.copyWith(
                color: AppColors.dark,
                height: 1.4,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _DetailBoard extends StatelessWidget {
  const _DetailBoard({required this.items});

  final List<WardrobeItem> items;

  @override
  Widget build(BuildContext context) {
    if (items.isEmpty) {
      return const Center(
        child: Icon(
          Icons.checkroom_rounded,
          color: AppColors.secondary,
          size: 48,
        ),
      );
    }

    return LayoutBuilder(
      builder: (context, constraints) {
        final w = constraints.maxWidth;
        final h = constraints.maxHeight;
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
                    child: _DetailImage(imagePath: items[i].imagePath),
                  ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _DetailImage extends StatelessWidget {
  const _DetailImage({required this.imagePath});

  final String imagePath;

  @override
  Widget build(BuildContext context) {
    Widget placeholder() => const Center(
      child: Icon(
        Icons.checkroom_rounded,
        color: AppColors.secondary,
        size: 32,
      ),
    );

    if (imagePath.isEmpty) return placeholder();
    if (imagePath.startsWith('assets/')) {
      return Image.asset(
        imagePath,
        fit: BoxFit.contain,
        errorBuilder: (_, __, ___) => placeholder(),
      );
    }
    return Image.file(
      File(imagePath),
      fit: BoxFit.contain,
      errorBuilder: (_, __, ___) => placeholder(),
    );
  }
}
