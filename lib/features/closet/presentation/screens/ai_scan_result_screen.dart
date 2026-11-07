import 'dart:io';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:gardirop/l10n/app_localizations.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_text_styles.dart';
import '../../data/wardrobe_save_service.dart';
import '../../domain/item_draft.dart';

class AiScanResultScreen extends StatefulWidget {
  const AiScanResultScreen({
    super.key,
    required this.draft,
    required this.analysis,
  });

  final ItemDraft draft;
  final Map<String, dynamic> analysis;

  @override
  State<AiScanResultScreen> createState() =>
      _AiScanResultScreenState();
}

class _AiScanResultScreenState extends State<AiScanResultScreen> {
  bool _isSaving = false;

  Future<void> _saveToCloset() async {
    if (_isSaving) return;

    setState(() {
      _isSaving = true;
    });

    try {
      final colorName =
      widget.analysis['colorName']?.toString().trim();

      final itemId = await WardrobeSaveService.addItem(
        draft: widget.draft,
        colorName: colorName,
      );

      if (!mounted) return;

      context.go('/closet/item-added/$itemId');
    } catch (error) {
      if (!mounted) return;

      debugPrint('SAVE AI ITEM ERROR: $error');

      final l10n = AppLocalizations.of(context)!;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(l10n.couldNotSaveItem),
        ),
      );
    } finally {
      if (mounted) {
        setState(() {
          _isSaving = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    final colorName =
    widget.analysis['colorName']?.toString().trim();

    final displayedColorName =
    colorName == null || colorName.isEmpty
        ? l10n.notDetected
        : colorName;

    final seasons = _displayList(
      widget.analysis['seasons'],
      fallback: widget.draft.season,
      emptyValue: l10n.notDetected,
    );

    final occasions = _displayList(
      widget.analysis['occasions'],
      emptyValue: l10n.notDetected,
    );

    final styles = _displayList(
      widget.analysis['styles'],
      emptyValue: l10n.notDetected,
    );

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
                  24,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        IconButton(
                          onPressed: () => context.pop(),
                          padding: EdgeInsets.zero,
                          constraints: const BoxConstraints(
                            minWidth: 44,
                            minHeight: 44,
                          ),
                          icon: const Icon(
                            Icons.arrow_back_ios_new_rounded,
                            size: 20,
                            color: AppColors.dark,
                          ),
                        ),
                        const Spacer(),
                        Text(
                          l10n.aiResultTitle,
                          style: AppTextStyles.small.copyWith(
                            color: AppColors.dark,
                            fontWeight: FontWeight.w600,
                            letterSpacing: 2,
                          ),
                        ),
                        const Spacer(),
                        const SizedBox(width: 44),
                      ],
                    ),

                    const SizedBox(height: 18),

                    // Main detected item image
                    ClipRRect(
                      borderRadius: BorderRadius.circular(14),
                      child: AspectRatio(
                        aspectRatio: 1.08,
                        child: Stack(
                          fit: StackFit.expand,
                          children: [
                            Image.file(
                              File(widget.draft.imagePath),
                              fit: BoxFit.cover,
                            ),

                            Align(
                              alignment: Alignment.bottomCenter,
                              child: Padding(
                                padding: const EdgeInsets.only(
                                  bottom: 14,
                                ),
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 14,
                                    vertical: 8,
                                  ),
                                  decoration: BoxDecoration(
                                    color: AppColors.dark.withValues(
                                      alpha: 0.82,
                                    ),
                                    borderRadius:
                                    BorderRadius.circular(20),
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      const Icon(
                                        Icons.check_rounded,
                                        size: 17,
                                        color: Colors.white,
                                      ),
                                      const SizedBox(width: 6),
                                      Text(
                                        l10n.itemDetected,
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 13,
                                          fontWeight:
                                          FontWeight.w500,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    const SizedBox(height: 20),

                    Text(
                      widget.draft.name,
                      style: AppTextStyles.h2.copyWith(
                        color: AppColors.dark,
                      ),
                    ),

                    const SizedBox(height: 4),

                    Text(
                      l10n.detectedByGardi,
                      style: AppTextStyles.caption.copyWith(
                        color: AppColors.secondary,
                      ),
                    ),

                    const SizedBox(height: 18),

                    const Divider(height: 1),

                    _ResultRow(
                      label: l10n.category,
                      value: widget.draft.category,
                    ),

                    _ResultRow(
                      label: l10n.color,
                      value: displayedColorName,
                    ),

                    _ResultRow(
                      label: l10n.material,
                      value: _valueOrFallback(
                        widget.draft.material,
                        l10n.notDetected,
                      ),
                    ),

                    _ResultRow(
                      label: l10n.fit,
                      value: _valueOrFallback(
                        widget.draft.fit,
                        l10n.notDetected,
                      ),
                    ),

                    _ResultRow(
                      label: l10n.season,
                      value: seasons,
                    ),

                    _ResultRow(
                      label: l10n.style,
                      value: styles,
                    ),

                    _ResultRow(
                      label: l10n.occasion,
                      value: occasions,
                    ),

                    if (widget.draft.tags.isNotEmpty) ...[
                      const SizedBox(height: 18),

                      Text(
                        l10n.tags,
                        style: AppTextStyles.caption.copyWith(
                          color: AppColors.secondary,
                        ),
                      ),

                      const SizedBox(height: 10),

                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: widget.draft.tags.map((tag) {
                          return Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 13,
                              vertical: 8,
                            ),
                            decoration: BoxDecoration(
                              color: AppColors.taupe.withValues(
                                alpha: 0.45,
                              ),
                              borderRadius:
                              BorderRadius.circular(18),
                            ),
                            child: Text(
                              tag,
                              style:
                              AppTextStyles.caption.copyWith(
                                color: AppColors.dark,
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                    ],
                  ],
                ),
              ),
            ),

            // Bottom actions
            Container(
              padding: const EdgeInsets.fromLTRB(
                20,
                12,
                20,
                18,
              ),
              decoration: BoxDecoration(
                color: AppColors.light,
                boxShadow: [
                  BoxShadow(
                    color:
                    Colors.black.withValues(alpha: 0.05),
                    blurRadius: 18,
                    offset: const Offset(0, -4),
                  ),
                ],
              ),
              child: SafeArea(
                top: false,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SizedBox(
                      width: double.infinity,
                      height: 54,
                      child: ElevatedButton(
                        onPressed:
                        _isSaving ? null : _saveToCloset,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.dark,
                          foregroundColor: Colors.white,
                          disabledBackgroundColor:
                          AppColors.dark.withValues(
                            alpha: 0.65,
                          ),
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius:
                            BorderRadius.circular(16),
                          ),
                        ),
                        child: _isSaving
                            ? const SizedBox(
                          width: 22,
                          height: 22,
                          child:
                          CircularProgressIndicator(
                            strokeWidth: 2.2,
                            color: Colors.white,
                          ),
                        )
                            : Text(
                          l10n.saveToMyCloset,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 8),

                    TextButton.icon(
                      onPressed: () {
                        context.push(
                          '/closet/review-item',
                          extra: widget.draft,
                        );
                      },
                      icon: const Icon(
                        Icons.edit_outlined,
                        size: 18,
                      ),
                      label: Text(
                        l10n.reviewEditDetails,
                      ),
                      style: TextButton.styleFrom(
                        foregroundColor: AppColors.dark,
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
  }

  String _displayList(
      dynamic value, {
        String? fallback,
        required String emptyValue,
      }) {
    if (value is List) {
      final items = value
          .map((item) => item.toString().trim())
          .where((item) => item.isNotEmpty)
          .toList();

      if (items.isNotEmpty) {
        return items.join(', ');
      }
    }

    if (fallback != null && fallback.trim().isNotEmpty) {
      return fallback;
    }

    return emptyValue;
  }

  String _valueOrFallback(
      String? value,
      String fallback,
      ) {
    if (value == null || value.trim().isEmpty) {
      return fallback;
    }

    return value;
  }
}

class _ResultRow extends StatelessWidget {
  const _ResultRow({
    required this.label,
    required this.value,
  });

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        vertical: 15,
      ),
      decoration: const BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: Color(0xFFE8E1DA),
          ),
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 95,
            child: Text(
              label,
              style: AppTextStyles.caption.copyWith(
                color: AppColors.dark,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: AppTextStyles.caption.copyWith(
                color: AppColors.secondary,
              ),
            ),
          ),
        ],
      ),
    );
  }
}