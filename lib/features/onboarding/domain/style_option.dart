class StyleOption {
  const StyleOption({
    required this.id,
    required this.title,
    required this.description,
    required this.imagePath,
    required this.audience,
  });

  final String id;
  final String title;
  final String description;
  final String imagePath;

  /// woman or man
  final String audience;
}