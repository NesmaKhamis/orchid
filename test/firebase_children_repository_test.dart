import 'package:flutter_test/flutter_test.dart';
import 'package:orchid_app/app/data/repositories/firebase_children_repository.dart';

void main() {
  test(
    'returns predefined children when Firebase is not initialized',
    () async {
      final FirebaseChildrenRepository repository =
          FirebaseChildrenRepository();

      final children = await repository.getChildren();

      expect(children, hasLength(3));
      expect(children.first.name, 'محمد أحمد دياب');
    },
  );
}
