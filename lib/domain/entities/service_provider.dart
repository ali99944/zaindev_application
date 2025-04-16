class ServiceProviderInfo { // Use a simpler name for nested info
  final int id;
  final String name;
  final String? logoUrl;

  ServiceProviderInfo({
    required this.id,
    required this.name,
    this.logoUrl,
  });

  factory ServiceProviderInfo.fromJson(Map<String, dynamic> json) {
    return ServiceProviderInfo(
      id: json['id'] as int,
      name: json['name'] as String,
      logoUrl: json['logo_url'] as String?,
    );
  }
}