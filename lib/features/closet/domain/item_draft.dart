class ItemDraft {
  const ItemDraft({
    required this.name,
    required this.category,
    required this.imagePath,
    this.colorHex,
    this.brand,
    this.material,
    this.fit,
    this.season,
    this.occasion = const [],
    this.style = const [],
    this.tags = const [],
    this.quantity = 1,
    this.source = ItemDraftSource.quickAdd,
    this.notes,
  });

  // Essential
  final String name;
  final String category;
  final String imagePath;

  // Optional
  final String? colorHex;
  final String? brand;
  final String? material;
  final String? fit;
  final String? season;

  final List<String> occasion;
  final List<String> style;
  final List<String> tags;

  // Defaults to 1, so the user is never forced to fill it in.
  final int quantity;

  final ItemDraftSource source;
  final String? notes;

  ItemDraft copyWith({
    String? name,
    String? category,
    String? imagePath,
    String? colorHex,
    String? brand,
    String? material,
    String? fit,
    String? season,
    List<String>? occasion,
    List<String>? style,
    List<String>? tags,
    int? quantity,
    ItemDraftSource? source,
    String? notes,
  }) {
    return ItemDraft(
      name: name ?? this.name,
      category: category ?? this.category,
      imagePath: imagePath ?? this.imagePath,
      colorHex: colorHex ?? this.colorHex,
      brand: brand ?? this.brand,
      material: material ?? this.material,
      fit: fit ?? this.fit,
      season: season ?? this.season,
      occasion: occasion ?? this.occasion,
      style: style ?? this.style,
      tags: tags ?? this.tags,
      quantity: quantity ?? this.quantity,
      source: source ?? this.source,
      notes: notes ?? this.notes,
    );
  }
}

enum ItemDraftSource {
  quickAdd,
  aiScan,
}