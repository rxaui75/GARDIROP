class StyleDna {
  const StyleDna({
    required this.tags,
    required this.highlights,
  });

  /// الكلمات اللي تظهر داخل الـ bubbles
  /// مثال:
  /// Minimal, Classic, Chic, Versatile, Timeless
  final List<String> tags;

  /// الجمل المختصرة اللي تظهر تحت الـ bubbles
  /// مثال:
  /// Clean and polished looks
  /// Versatile for everyday life
  final List<String> highlights;
}