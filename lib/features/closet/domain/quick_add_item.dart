class QuickAddItem {
  const QuickAddItem({
    required this.id,
    required this.name,
    required this.category,
    required this.audience,
    required this.assetPath,
    required this.defaultColor,
    required this.colorEditable,
    required this.supportsCustomColor,
    required this.defaultQuantity,
    required this.quantityEditable,
  });

  final String id;
  final String name;
  final String category;
  final String audience;
  final String assetPath;
  final String defaultColor;

  final bool colorEditable;
  final bool supportsCustomColor;
  final int defaultQuantity;
  final bool quantityEditable;

  factory QuickAddItem.fromJson(Map<String, dynamic> json) {
    return QuickAddItem(
      id: json['id'] as String,
      name: json['name'] as String,
      category: json['category'] as String,
      audience: json['audience'] as String,
      assetPath: json['assetPath'] as String,
      defaultColor: json['defaultColor'] as String,
      colorEditable: json['colorEditable'] as bool? ?? true,
      supportsCustomColor:
      json['supportsCustomColor'] as bool? ?? true,
      defaultQuantity:
      json['defaultQuantity'] as int? ?? 1,
      quantityEditable:
      json['quantityEditable'] as bool? ?? true,
    );
  }
}