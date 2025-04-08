// project.dart
class Project {
  final String id;
  final String title;
  final String description;
  final String category;
  final double rating;
  final double progress;
  final String imageUrl;

  const Project({
    required this.id,
    required this.title,
    required this.description,
    required this.category,
    required this.rating,
    required this.progress,
    required this.imageUrl,
  });
}