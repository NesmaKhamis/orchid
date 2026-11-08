import '../models/child_model.dart';

abstract class ChildrenRepository {
  Future<List<ChildModel>> getChildren();
}
