  import '../../../core/utils/api_helper.dart';
import '../../../core/utils/logger.dart';
import '../../../core/utils/parse_error.dart';
import '../../../domain/entities/project.dart';
import '../../../domain/repositories/remote/project_repository.dart';

class ProjectRepositoryImpl implements IProjectRepository {
  final ApiHelper _apiHelper;

  ProjectRepositoryImpl(this._apiHelper);

  @override
  Future<List<Project>> getProjects({bool featuredOnly = false}) async {
    try {
      String endpoint = 'projects';
      if (featuredOnly) {
        endpoint += '?featured=true';
      }
      final responseData = await _apiHelper.getData<List<dynamic>>(endpoint);
      final projects = responseData
          .map((projectJson) => Project.fromJsonList(projectJson as Map<String, dynamic>))
          .toList();
      return projects;
    } catch (e) {
      perror("GetProjects Error: $e");
      throw parseApiError(e);
    }
  }

  @override
  Future<Project> getProjectDetails(int projectId) async {
    try {
      final responseData = await _apiHelper.getData<Map<String, dynamic>>(
        'projects/$projectId'
      );
      return Project.fromJsonDetail(responseData);
    } catch (e) {
      perror("GetProjectDetails Error (ID $projectId): $e");
      throw parseApiError(e);
    }
  }

}