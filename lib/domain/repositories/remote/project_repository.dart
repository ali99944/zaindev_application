
import '../../entities/project.dart';

abstract class IProjectRepository {
  Future<List<Project>> getProjects({bool featuredOnly = false});
  Future<Project> getProjectDetails(int projectId);
}