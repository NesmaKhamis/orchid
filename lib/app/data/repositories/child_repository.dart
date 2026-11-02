import '../models/child_model.dart';

abstract class ChildRepository {
  Future<List<ChildModel>> getChildren();
}
