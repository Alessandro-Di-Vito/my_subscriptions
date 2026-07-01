class CategoryItem {
  const CategoryItem({
    required this.id,
    required this.slug,
    required this.name,
    this.icon,
    this.color,
    required this.isPreset,
  });

  final String id;
  final String slug;
  final String name;
  final String? icon;
  final String? color;
  final bool isPreset;

  factory CategoryItem.fromJson(Map<String, dynamic> json) {
    return CategoryItem(
      id: json['id'] as String,
      slug: json['slug'] as String,
      name: json['name'] as String,
      icon: json['icon'] as String?,
      color: json['color'] as String?,
      isPreset: json['isPreset'] as bool? ?? false,
    );
  }
}
