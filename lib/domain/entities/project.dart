
import 'project_image.dart';

class Project {
  final int id;
  final String name;
  final String mainImageUrl;
  final String? categoryInfo;
  final String? projectType;
  // Detailed fields (nullable as they only come from details API)
  final String? description;
  final String? iconIdentifier;
  final String? client;
  final String? completionDate;
  final List<String>? technologies;
  final List<ProjectImage>? projectImages;

  Project({
    required this.id,
    required this.name,
    required this.mainImageUrl,
    this.categoryInfo,
    this.projectType,
    // Details fields are optional in the constructor
    this.description,
    this.iconIdentifier,
    this.client,
    this.completionDate,
    this.technologies,
    this.projectImages,
  });

  // Factory for list items (index API)
  factory Project.fromJsonList(Map<String, dynamic> json) {
    return Project(
      id: json['id'] as int,
      name: json['name'] as String,
      mainImageUrl: json['main_image_url'] as String,
      categoryInfo: json['category_info'] as String?,
      projectType: json['project_type'] as String?,
    );
  }

  // Factory for detail items (show API)
   factory Project.fromJsonDetail(Map<String, dynamic> json) {
     // Helper to safely cast list elements
     List<T> _castList<T>(List<dynamic>? list) {
       return list?.map((e) => e as T).toList() ?? [];
     }

     return Project(
       id: json['id'] as int,
       name: json['name'] as String,
       mainImageUrl: json['main_image_url'] as String,
       categoryInfo: json['category_info'] as String?,
       projectType: json['project_type'] as String?,
       // Parse detail fields
       description: json['description'] as String?,
       iconIdentifier: json['icon_identifier'] as String?,
       client: json['client'] as String?,
       completionDate: json['completion_date'] as String?,
       // Safely parse technologies (stored as JSON array string in DB, cast to array in Model)
       technologies: _castList<String>(json['technologies'] as List?),
       // Parse project images
       projectImages: (json['project_images'] as List?)
           ?.map((imgJson) => ProjectImage.fromJson(imgJson as Map<String, dynamic>))
           .toList(),
     );
   }
}