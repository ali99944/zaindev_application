class ServiceCategory {
  final int id; // Match Laravel ID type (usually int)
  final String name;
  final String icon; // String identifier from API

  ServiceCategory({
    required this.id,
    required this.name,
    required this.icon,
  });

  factory ServiceCategory.fromJson(Map<String, dynamic> json) {
    return ServiceCategory(
      id: json['id'] as int,
      name: json['name'] as String,
      icon: json['icon'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'icon': icon,
    };
  }
}