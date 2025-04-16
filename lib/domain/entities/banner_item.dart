class BannerItem {
  final int id;
  final String imageUrl;
  final String? title;
  final String? targetUrl; // Represents the deep link or navigation target

  BannerItem({
    required this.id,
    required this.imageUrl,
    this.title,
    this.targetUrl,
  });

  factory BannerItem.fromJson(Map<String, dynamic> json) {
    return BannerItem(
      id: json['id'] as int,
      imageUrl: json['image_url'] as String,
      title: json['title'] as String?,
      targetUrl: json['target_url'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'imageUrl': imageUrl,
      'title': title,
      'targetUrl': targetUrl,
    };
  }
}