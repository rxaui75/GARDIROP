import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'dart:io';

import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_text_styles.dart';
import '../../domain/item_draft.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ReviewItemScreen extends StatefulWidget {
  const ReviewItemScreen({
    super.key,
    required this.draft,
    this.itemId,
  });

  final ItemDraft draft;
  final String? itemId;

  bool get isEditing => itemId != null;

  @override
  State<ReviewItemScreen> createState() => _ReviewItemScreenState();
}

class _ReviewItemScreenState extends State<ReviewItemScreen> {
  late TextEditingController nameController;
  late TextEditingController brandController;
  late TextEditingController materialController;
  late TextEditingController fitController;
  late TextEditingController seasonController;

  late String category;
  late String? color;
  late Color selectedColor;
  late int quantity;

  late List<String> occasions;
  late List<String> styles;
  late List<String> tags;
  late TextEditingController notesController;
  bool isSaving = false;

  @override
  void initState() {
    super.initState();

    nameController = TextEditingController(
      text: widget.draft.name,
    );

    brandController = TextEditingController(
      text: widget.draft.brand ?? '',
    );

    materialController = TextEditingController(
      text: widget.draft.material ?? '',
    );

    fitController = TextEditingController(
      text: widget.draft.fit ?? '',
    );

    seasonController = TextEditingController(
      text: widget.draft.season ?? '',
    );

    category = widget.draft.category;
    color = widget.draft.colorHex;
    selectedColor = _colorFromHex(
      widget.draft.colorHex ?? '#FFFFFF',
    );
    quantity = widget.draft.quantity;

    occasions = [...widget.draft.occasion];
    styles = [...widget.draft.style];
    tags = [...widget.draft.tags];

    notesController = TextEditingController(
      text: widget.draft.notes ?? '',
    );
  }


  @override
  void dispose() {
    nameController.dispose();
    brandController.dispose();
    materialController.dispose();
    fitController.dispose();
    seasonController.dispose();
    notesController.dispose();

    super.dispose();
  }

  bool get canSave {
    return nameController.text.trim().isNotEmpty &&
        category.trim().isNotEmpty;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.light,
      appBar: AppBar(
        backgroundColor: AppColors.light,
        elevation: 0,
        scrolledUnderElevation: 0,
        foregroundColor: AppColors.dark,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios_new_rounded,
            size: 20,
          ),
          onPressed: () => context.pop(),
        ),
        title: Text(
          widget.isEditing ? 'Edit Item' : 'Review Item',
          style: AppTextStyles.h2.copyWith(
            color: AppColors.dark,
          ),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        top: false,
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(
            20,
            10,
            20,
            32,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _ItemImage(
                imagePath: widget.draft.imagePath,
                selectedColor: selectedColor,
              ),

              const SizedBox(height: 24),

              _SectionLabel(
                text: 'Item Name',
                requiredField: true,
              ),
              const SizedBox(height: 8),

              _TextFieldBox(
                controller: nameController,
                hintText: 'Item name',
                onChanged: (_) => setState(() {}),
              ),

              const SizedBox(height: 18),

              _SectionLabel(
                text: 'Category',
                requiredField: true,
              ),
              const SizedBox(height: 8),

              _SelectBox(
                value: category,
                onTap: _showCategorySheet,
              ),

              const SizedBox(height: 18),

              _OptionalLabel(text: 'Color'),
              const SizedBox(height: 8),

              _SelectBox(
                value: '${_getColorName(selectedColor)}  •  ${color ?? '#FFFFFF'}',
                leading: Container(
                  width: 22,
                  height: 22,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: selectedColor,
                    border: Border.all(
                      color: Colors.black12,
                    ),
                  ),
                ),
                onTap: _showFullColorPicker,
              ),

              const SizedBox(height: 18),

              _OptionalLabel(text: 'Brand'),
              const SizedBox(height: 8),

              _TextFieldBox(
                controller: brandController,
                hintText: 'Add brand',
              ),

              const SizedBox(height: 18),

              _OptionalLabel(text: 'Material'),
              const SizedBox(height: 8),

              _SelectBox(
                value: materialController.text.isNotEmpty
                    ? materialController.text
                    : 'Choose material',
                muted: materialController.text.isEmpty,
                onTap: _showMaterialSheet,
              ),

              const SizedBox(height: 18),

              _OptionalLabel(text: 'Fit'),
              const SizedBox(height: 8),

              _SelectBox(
                value: fitController.text.isNotEmpty
                    ? fitController.text
                    : 'Choose fit',
                muted: fitController.text.isEmpty,
                onTap: _showFitSheet,
              ),

              const SizedBox(height: 18),

              _OptionalLabel(text: 'Season'),
              const SizedBox(height: 8),

              _MultiChoiceField(
                selectedItems: seasonController.text.isEmpty
                    ? []
                    : seasonController.text.split(', '),
                placeholder: 'Choose seasons',
                onTap: _showSeasonSheet,
              ),

              const SizedBox(height: 18),

              _OptionalLabel(text: 'Occasion'),
              const SizedBox(height: 8),

              _MultiChoiceField(
                selectedItems: occasions,
                placeholder: 'Choose occasions',
                onTap: _showOccasionSheet,
              ),

              const SizedBox(height: 18),

              _OptionalLabel(text: 'Style'),
              const SizedBox(height: 8),

              _MultiChoiceField(
                selectedItems: styles,
                placeholder: 'Choose styles',
                onTap: _showStyleSheet,
              ),

              const SizedBox(height: 18),

              _OptionalLabel(text: 'Tags'),
              const SizedBox(height: 8),

              _TagEditor(
                items: tags,
                emptyText: 'Add tags',
                onAdd: () {
                  _showSimpleAddDialog(
                    title: 'Add Tag',
                    onAdd: (value) {
                      setState(() {
                        tags.add(value);
                      });
                    },
                  );
                },
                onRemove: (value) {
                  setState(() {
                    tags.remove(value);
                  });
                },
              ),

              const SizedBox(height: 18),

              _OptionalLabel(text: 'Notes'),
              const SizedBox(height: 8),

              TextField(
                controller: notesController,
                minLines: 3,
                maxLines: 5,
                style: AppTextStyles.body.copyWith(
                  color: AppColors.dark,
                ),
                decoration: InputDecoration(
                  hintText: 'Add a personal note...',
                  filled: true,
                  fillColor: Colors.white,
                  contentPadding: const EdgeInsets.all(16),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),

              const SizedBox(height: 18),

              _OptionalLabel(text: 'Quantity'),
              const SizedBox(height: 8),

              _QuantitySelector(
                quantity: quantity,
                onMinus: () {
                  if (quantity <= 1) return;

                  setState(() {
                    quantity--;
                  });
                },
                onPlus: () {
                  setState(() {
                    quantity++;
                  });
                },
              ),

              const SizedBox(height: 30),

              SizedBox(
                width: double.infinity,
                height: 56,
                child: FilledButton(
                  onPressed: canSave && !isSaving
                      ? _saveItem
                      : null,
                  style: FilledButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    disabledBackgroundColor:
                    AppColors.secondary.withOpacity(0.25),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18),
                    ),
                  ),
                  child: isSaving
                      ? const SizedBox(
                    width: 22,
                    height: 22,
                    child: CircularProgressIndicator(
                      strokeWidth: 2.2,
                      color: Colors.white,
                    ),
                  )
                      : Text(
                    widget.isEditing ? 'Save Changes' : 'Save Item',
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

  Future<void> _saveItem() async {
    if (!canSave || isSaving) return;

    final user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please sign in before saving an item.'),
        ),
      );
      return;
    }

    setState(() {
      isSaving = true;
    });

    try {
      final updatedDraft = widget.draft.copyWith(
        name: nameController.text.trim(),
        category: category,
        colorHex: color,
        brand: brandController.text.trim(),
        material: materialController.text.trim(),
        fit: fitController.text.trim(),
        season: seasonController.text.trim(),
        occasion: occasions,
        style: styles,
        tags: tags,
        notes: notesController.text.trim(),
        quantity: quantity,
      );

      final seasons = seasonController.text
          .split(',')
          .map((season) => season.trim())
          .where((season) => season.isNotEmpty)
          .toList();

      final itemData = <String, dynamic>{
        'name': updatedDraft.name,
        'category': updatedDraft.category,

        'colorHex': updatedDraft.colorHex,
        'colorName': _getColorName(selectedColor),

        'brand': updatedDraft.brand,
        'material': updatedDraft.material,
        'fit': updatedDraft.fit,

        'seasons': seasons,
        'occasions': updatedDraft.occasion,
        'styles': updatedDraft.style,
        'tags': updatedDraft.tags,

        'notes': updatedDraft.notes,
        'quantity': updatedDraft.quantity,

        'imagePath': updatedDraft.imagePath,
        'source': updatedDraft.source.name,

        'updatedAt': FieldValue.serverTimestamp(),
      };

      if (widget.isEditing) {
        await FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .collection('wardrobe_items')
            .doc(widget.itemId!)
            .update(itemData);

        if (!mounted) return;

        context.pop();
      } else {
        itemData['createdAt'] = FieldValue.serverTimestamp();

        final document = await FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .collection('wardrobe_items')
            .add(itemData);

        if (!mounted) return;

        context.go(
          '/closet/item-added/${document.id}',
        );
      }
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Could not save item: $e'),
        ),
      );
    } finally {
      if (mounted) {
        setState(() {
          isSaving = false;
        });
      }
    }
  }

  void _showCategorySheet() {
    const categories = [
      'Tops',
      'Bottoms',
      'Outerwear',
      'Dresses',
      'Shoes',
      'Bags',
      'Accessories',
    ];

    showModalBottomSheet(
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
              20,
              20,
              20,
              28,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Choose Category',
                  style: AppTextStyles.h3.copyWith(
                    color: AppColors.dark,
                  ),
                ),
                const SizedBox(height: 16),
                ...categories.map(
                      (item) => ListTile(
                    title: Text(item),
                    trailing: category == item
                        ? const Icon(
                      Icons.check_rounded,
                    )
                        : null,
                    onTap: () {
                      setState(() {
                        category = item;
                      });
                      context.pop();
                    },
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _showColorSheet() {
    const colors = [
      'White',
      'Black',
      'Cream',
      'Beige',
      'Brown',
      'Gray',
      'Navy',
      'Blue',
      'Red',
      'Pink',
      'Green',
      'Gold',
      'Silver',
    ];

    showModalBottomSheet(
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
              20,
              20,
              20,
              28,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Choose Color',
                  style: AppTextStyles.h3.copyWith(
                    color: AppColors.dark,
                  ),
                ),
                const SizedBox(height: 16),
                Wrap(
                  spacing: 10,
                  runSpacing: 10,
                  children: colors.map(
                        (item) {
                      final selected = color == item;

                      return InkWell(
                        borderRadius:
                        BorderRadius.circular(20),
                        onTap: () {
                          setState(() {
                            color = item;
                          });
                          context.pop();
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 14,
                            vertical: 10,
                          ),
                          decoration: BoxDecoration(
                            color: selected
                                ? AppColors.primary
                                : Colors.white,
                            borderRadius:
                            BorderRadius.circular(20),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              _ColorDot(
                                colorName: item,
                              ),
                              const SizedBox(width: 8),
                              Text(
                                item,
                                style:
                                AppTextStyles.small.copyWith(
                                  color: selected
                                      ? Colors.white
                                      : AppColors.dark,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ).toList(),
                ),
              ],
            ),
          ),
        );
      },
    );
  }


  void _showFitSheet() {
    const fits = [
      'Slim',
      'Regular',
      'Relaxed',
      'Oversized',
    ];

    showModalBottomSheet(
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
              20,
              20,
              20,
              28,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Choose Fit',
                  style: AppTextStyles.h3.copyWith(
                    color: AppColors.dark,
                  ),
                ),

                const SizedBox(height: 16),

                ...fits.map(
                      (fit) => ListTile(
                    title: Text(fit),
                    trailing:
                    fitController.text == fit
                        ? const Icon(
                      Icons.check_rounded,
                    )
                        : null,
                    onTap: () {
                      setState(() {
                        fitController.text = fit;
                      });

                      context.pop();
                    },
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }


  void _showSeasonSheet() {
    const seasons = [
      'Spring',
      'Summer',
      'Autumn',
      'Winter',
    ];

    final selected = seasonController.text.isEmpty
        ? <String>[]
        : seasonController.text.split(', ');

    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.light,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(28),
        ),
      ),
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setSheetState) {
            return SafeArea(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(
                  20,
                  20,
                  20,
                  28,
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'Choose Seasons',
                      style: AppTextStyles.h3.copyWith(
                        color: AppColors.dark,
                      ),
                    ),

                    const SizedBox(height: 16),

                    Wrap(
                      spacing: 10,
                      runSpacing: 10,
                      children: seasons.map(
                            (season) {
                          final isSelected =
                          selected.contains(season);

                          return FilterChip(
                            label: Text(season),
                            selected: isSelected,
                            onSelected: (value) {
                              setSheetState(() {
                                if (value) {
                                  selected.add(season);
                                } else {
                                  selected.remove(season);
                                }
                              });
                            },
                          );
                        },
                      ).toList(),
                    ),

                    const SizedBox(height: 24),

                    SizedBox(
                      width: double.infinity,
                      child: FilledButton(
                        onPressed: () {
                          setState(() {
                            seasonController.text =
                                selected.join(', ');
                          });

                          context.pop();
                        },
                        child: const Text('Done'),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  void _showSimpleAddDialog({
    required String title,
    required ValueChanged<String> onAdd,
  }) {
    final controller = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: AppColors.light,
          title: Text(title),
          content: TextField(
            controller: controller,
            autofocus: true,
          ),
          actions: [
            TextButton(
              onPressed: () => context.pop(),
              child: const Text('Cancel'),
            ),
            FilledButton(
              onPressed: () {
                final value = controller.text.trim();

                if (value.isEmpty) return;

                onAdd(value);
                context.pop();
              },
              child: const Text('Add'),
            ),
          ],
        );
      },
    );
  }

  void _showFullColorPicker() {
    Color tempColor = selectedColor;

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: AppColors.light,
          title: const Text('Choose Color'),
          content: SingleChildScrollView(
            child: ColorPicker(
              pickerColor: tempColor,
              onColorChanged: (newColor) {
                tempColor = newColor;
              },
              enableAlpha: false,
              displayThumbColor: true,
              labelTypes: const [],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => context.pop(),
              child: const Text('Cancel'),
            ),
            FilledButton(
              onPressed: () {
                setState(() {
                  selectedColor = tempColor;
                  color = _colorToHex(tempColor);
                });

                context.pop();
              },
              child: const Text('Done'),
            ),
          ],
        );
      },
    );
  }
  void _showStyleSheet() {
    const styleOptions = [
      'Casual',
      'Minimal',
      'Classic',
      'Streetwear',
      'Sporty',
      'Elegant',
      'Chic',
      'Formal',
    ];

    final selected = [...styles];

    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.light,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(28),
        ),
      ),
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setSheetState) {
            return SafeArea(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(
                  20,
                  20,
                  20,
                  28,
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'Choose Styles',
                      style: AppTextStyles.h3.copyWith(
                        color: AppColors.dark,
                      ),
                    ),

                    const SizedBox(height: 16),

                    Wrap(
                      spacing: 10,
                      runSpacing: 10,
                      children: styleOptions.map(
                            (style) {
                          final isSelected =
                          selected.contains(style);

                          return FilterChip(
                            label: Text(style),
                            selected: isSelected,
                            onSelected: (value) {
                              setSheetState(() {
                                if (value) {
                                  selected.add(style);
                                } else {
                                  selected.remove(style);
                                }
                              });
                            },
                          );
                        },
                      ).toList(),
                    ),

                    const SizedBox(height: 24),

                    SizedBox(
                      width: double.infinity,
                      child: FilledButton(
                        onPressed: () {
                          setState(() {
                            styles = selected;
                          });

                          context.pop();
                        },
                        child: const Text('Done'),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  void _showOccasionSheet() {
    const occasionOptions = [
      'Everyday',
      'University',
      'Work',
      'Formal',
      'Evening',
      'Travel',
      'Sport',
      'Events',
    ];

    final selected = [...occasions];

    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.light,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(28),
        ),
      ),
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setSheetState) {
            return SafeArea(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(
                  20,
                  20,
                  20,
                  28,
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'Choose Occasions',
                      style: AppTextStyles.h3.copyWith(
                        color: AppColors.dark,
                      ),
                    ),

                    const SizedBox(height: 16),

                    Wrap(
                      spacing: 10,
                      runSpacing: 10,
                      children: occasionOptions.map(
                            (occasion) {
                          final isSelected =
                          selected.contains(occasion);

                          return FilterChip(
                            label: Text(occasion),
                            selected: isSelected,
                            onSelected: (value) {
                              setSheetState(() {
                                if (value) {
                                  selected.add(occasion);
                                } else {
                                  selected.remove(occasion);
                                }
                              });
                            },
                          );
                        },
                      ).toList(),
                    ),

                    const SizedBox(height: 24),

                    SizedBox(
                      width: double.infinity,
                      child: FilledButton(
                        onPressed: () {
                          setState(() {
                            occasions = selected;
                          });

                          context.pop();
                        },
                        child: const Text('Done'),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  void _showMaterialSheet() {
    const materials = [
      'Cotton',
      'Linen',
      'Denim',
      'Wool',
      'Leather',
      'Polyester',
      'Silk',
      'Satin',
      'Knit',
      'Fleece',
      'Other',
    ];

    showModalBottomSheet(
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
              20,
              20,
              20,
              28,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Choose Material',
                  style: AppTextStyles.h3.copyWith(
                    color: AppColors.dark,
                  ),
                ),

                const SizedBox(height: 16),

                Wrap(
                  spacing: 10,
                  runSpacing: 10,
                  children: materials.map(
                        (material) {
                      final isSelected =
                          materialController.text == material;

                      return ChoiceChip(
                        label: Text(material),
                        selected: isSelected,
                        onSelected: (_) {
                          setState(() {
                            materialController.text = material;
                          });

                          context.pop();
                        },
                      );
                    },
                  ).toList(),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  String _getColorName(Color color) {
    const namedColors = <String, Color>{
      'Black': Color(0xFF000000),
      'Charcoal': Color(0xFF36454F),
      'Gray': Color(0xFF808080),
      'Silver': Color(0xFFC0C0C0),
      'White': Color(0xFFFFFFFF),
      'Cream': Color(0xFFFFFDD0),
      'Ivory': Color(0xFFFFFFF0),

      'Beige': Color(0xFFF5F5DC),
      'Tan': Color(0xFFD2B48C),
      'Camel': Color(0xFFC19A6B),
      'Brown': Color(0xFF795548),
      'Chocolate': Color(0xFF7B3F00),

      'Burgundy': Color(0xFF800020),
      'Maroon': Color(0xFF800000),
      'Red': Color(0xFFFF0000),
      'Coral': Color(0xFFFF7F50),

      'Pink': Color(0xFFFFC0CB),
      'Rose': Color(0xFFFF007F),
      'Dusty Rose': Color(0xFFC9A0A0),
      'Mauve': Color(0xFFE0B0FF),

      'Orange': Color(0xFFFFA500),
      'Yellow': Color(0xFFFFFF00),
      'Mustard': Color(0xFFFFDB58),
      'Gold': Color(0xFFFFD700),

      'Olive': Color(0xFF808000),
      'Khaki': Color(0xFFC3B091),
      'Sage': Color(0xFFBCB88A),
      'Green': Color(0xFF008000),
      'Emerald': Color(0xFF50C878),

      'Mint': Color(0xFF98FF98),
      'Teal': Color(0xFF008080),
      'Turquoise': Color(0xFF40E0D0),

      'Navy': Color(0xFF000080),
      'Blue': Color(0xFF0000FF),
      'Sky Blue': Color(0xFF87CEEB),
      'Denim Blue': Color(0xFF1560BD),

      'Purple': Color(0xFF800080),
      'Lavender': Color(0xFFE6E6FA),
      'Lilac': Color(0xFFC8A2C8),
      'Plum': Color(0xFF8E4585),
    };

    String closestName = 'Custom';
    double smallestDistance = double.infinity;

    for (final entry in namedColors.entries) {
      final dr = color.red - entry.value.red;
      final dg = color.green - entry.value.green;
      final db = color.blue - entry.value.blue;

      final distance =
      (dr * dr + dg * dg + db * db).toDouble();

      if (distance < smallestDistance) {
        smallestDistance = distance;
        closestName = entry.key;
      }
    }

    return closestName;
  }

  Color _colorFromHex(String hex) {
    final cleaned = hex.replaceAll('#', '');

    return Color(
      int.parse(
        cleaned.length == 6
            ? 'FF$cleaned'
            : cleaned,
        radix: 16,
      ),
    );
  }

  String _colorToHex(Color color) {
    final r = color.red.toRadixString(16).padLeft(2, '0');
    final g = color.green.toRadixString(16).padLeft(2, '0');
    final b = color.blue.toRadixString(16).padLeft(2, '0');

    return '#${r.toUpperCase()}${g.toUpperCase()}${b.toUpperCase()}';
  }
}

class _ItemImage extends StatelessWidget {
  const _ItemImage({
    required this.imagePath,
    required this.selectedColor,
  });

  final String imagePath;
  final Color selectedColor;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ClipRRect(
        borderRadius: BorderRadius.circular(22),
        child: Container(
          width: 220,
          height: 220,
          color: AppColors.sand,
          child: ColorFiltered(
            colorFilter: ColorFilter.mode(
              selectedColor,
              BlendMode.modulate,
            ),
            child: imagePath.startsWith('assets/')
                ? Image.asset(
              imagePath,
              fit: BoxFit.contain,
            )
                : Image.file(
              File(imagePath),
              fit: BoxFit.contain,
              errorBuilder: (context, error, stackTrace) {
                return const Center(
                  child: Icon(
                    Icons.broken_image_outlined,
                    size: 42,
                    color: AppColors.secondary,
                  ),
                );
              },
            )
          ),
        ),
      ),
    );
  }
}

class _SectionLabel extends StatelessWidget {
  const _SectionLabel({
    required this.text,
    this.requiredField = false,
  });

  final String text;
  final bool requiredField;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          text,
          style: AppTextStyles.caption.copyWith(
            color: AppColors.dark,
            fontWeight: FontWeight.w600,
          ),
        ),
        if (requiredField)
          Text(
            ' *',
            style: AppTextStyles.caption.copyWith(
              color: AppColors.primary,
            ),
          ),
      ],
    );
  }
}

class _OptionalLabel extends StatelessWidget {
  const _OptionalLabel({
    required this.text,
  });

  final String text;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment:
      MainAxisAlignment.spaceBetween,
      children: [
        Text(
          text,
          style: AppTextStyles.caption.copyWith(
            color: AppColors.dark,
            fontWeight: FontWeight.w600,
          ),
        ),
        Text(
          'Optional',
          style: AppTextStyles.small.copyWith(
            color: AppColors.secondary,
          ),
        ),
      ],
    );
  }
}

class _TextFieldBox extends StatelessWidget {
  const _TextFieldBox({
    required this.controller,
    required this.hintText,
    this.onChanged,
  });

  final TextEditingController controller;
  final String hintText;
  final ValueChanged<String>? onChanged;

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      onChanged: onChanged,
      style: AppTextStyles.body.copyWith(
        color: AppColors.dark,
      ),
      decoration: InputDecoration(
        hintText: hintText,
        filled: true,
        fillColor: Colors.white,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 15,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }
}

class _SelectBox extends StatelessWidget {
  const _SelectBox({
    required this.value,
    required this.onTap,
    this.leading,
    this.muted = false,
  });

  final String value;
  final VoidCallback onTap;
  final Widget? leading;
  final bool muted;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(14),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(14),
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 15,
          ),
          child: Row(
            children: [
              if (leading != null) ...[
                leading!,
                const SizedBox(width: 10),
              ],
              Expanded(
                child: Text(
                  value,
                  style: AppTextStyles.body.copyWith(
                    color: muted
                        ? AppColors.secondary
                        : AppColors.dark,
                  ),
                ),
              ),
              const Icon(
                Icons.chevron_right_rounded,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _TagEditor extends StatelessWidget {
  const _TagEditor({
    required this.items,
    required this.emptyText,
    required this.onAdd,
    required this.onRemove,
  });

  final List<String> items;
  final String emptyText;
  final VoidCallback onAdd;
  final ValueChanged<String> onRemove;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Wrap(
        spacing: 8,
        runSpacing: 8,
        crossAxisAlignment: WrapCrossAlignment.center,
        children: [
          ...items.map(
                (item) => InputChip(
              label: Text(item),
              onDeleted: () => onRemove(item),
              backgroundColor: AppColors.beige,
              side: BorderSide.none,
            ),
          ),
          ActionChip(
            avatar: const Icon(
              Icons.add_rounded,
              size: 18,
            ),
            label: Text(
              items.isEmpty ? emptyText : 'Add',
            ),
            onPressed: onAdd,
            side: BorderSide.none,
            backgroundColor: AppColors.sand,
          ),
        ],
      ),
    );
  }
}

class _QuantitySelector extends StatelessWidget {
  const _QuantitySelector({
    required this.quantity,
    required this.onMinus,
    required this.onPlus,
  });

  final int quantity;
  final VoidCallback onMinus;
  final VoidCallback onPlus;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 54,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        children: [
          IconButton(
            onPressed: onMinus,
            icon: const Icon(
              Icons.remove_rounded,
            ),
          ),
          Expanded(
            child: Center(
              child: Text(
                '$quantity',
                style: AppTextStyles.body.copyWith(
                  color: AppColors.dark,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
          IconButton(
            onPressed: onPlus,
            icon: const Icon(
              Icons.add_rounded,
            ),
          ),
        ],
      ),
    );
  }
}

class _ColorDot extends StatelessWidget {
  const _ColorDot({
    required this.colorName,
  });

  final String colorName;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 18,
      height: 18,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: _resolveColor(colorName),
        border: Border.all(
          color: Colors.black12,
        ),
      ),
    );
  }

  Color _resolveColor(String colorName) {
    switch (colorName.toLowerCase()) {
      case 'white':
        return Colors.white;
      case 'black':
        return Colors.black;
      case 'cream':
        return const Color(0xFFF1E7D6);
      case 'beige':
        return const Color(0xFFD8C3A5);
      case 'brown':
        return const Color(0xFF6B4932);
      case 'gray':
        return Colors.grey;
      case 'navy':
        return const Color(0xFF24324A);
      case 'blue':
        return const Color(0xFF6E97C5);
      case 'red':
        return const Color(0xFFA74343);
      case 'pink':
        return const Color(0xFFD7A7A7);
      case 'green':
        return const Color(0xFF7C8A6D);
      case 'gold':
        return const Color(0xFFC9A227);
      case 'silver':
        return const Color(0xFFBFC3C7);
      default:
        return AppColors.secondary;
    }
  }
}

class _MultiChoiceField extends StatelessWidget {
  const _MultiChoiceField({
    required this.selectedItems,
    required this.placeholder,
    required this.onTap,
  });

  final List<String> selectedItems;
  final String placeholder;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(14),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(14),
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 15,
          ),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  selectedItems.isEmpty
                      ? placeholder
                      : selectedItems.join(', '),
                  style: AppTextStyles.body.copyWith(
                    color: selectedItems.isEmpty
                        ? AppColors.secondary
                        : AppColors.dark,
                  ),
                ),
              ),

              const Icon(
                Icons.chevron_right_rounded,
              ),
            ],
          ),
        ),
      ),
    );
  }
}