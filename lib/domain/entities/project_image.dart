class ProjectImage {
  final int id;
  final String imageUrl;
  final String? altText;

  ProjectImage({
    required this.id,
    required this.imageUrl,
    this.altText,
  });

  factory ProjectImage.fromJson(Map<String, dynamic> json) {
    return ProjectImage(
      id: json['id'] as int,
      imageUrl: json['image_url'] as String,
      altText: json['alt_text'] as String?,
    );
  }
}