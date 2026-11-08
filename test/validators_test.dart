import 'package:flutter_test/flutter_test.dart';
import 'package:orchid_app/app/core/constants/app_strings.dart';
import 'package:orchid_app/app/core/utils/validators.dart';
import 'package:orchid_app/app/modules/link_identity/controllers/link_identity_controller.dart';

void main() {
  group('Validators.nationalId', () {
    test('accepts exactly nine digits', () {
      expect(Validators.nationalId('123456789'), isNull);
    });

    test('rejects empty, non-numeric, and wrong-length values', () {
      expect(Validators.nationalId(''), AppStrings.invalidNationalId);
      expect(Validators.nationalId('12345A789'), AppStrings.invalidNationalId);
      expect(Validators.nationalId('12345678'), AppStrings.invalidNationalId);
      expect(Validators.nationalId('1234567890'), AppStrings.invalidNationalId);
    });
  });

  test(
    'parent identity form shows inline identity and birth date errors',
    () async {
      final LinkIdentityController controller = LinkIdentityController();

      controller.identityController.text = '12345678';
      controller.onIdentityChanged('12345678');
      expect(controller.identityError.value, AppStrings.invalidNationalId);

      controller.identityController.text = '123456789';
      controller.onIdentityChanged('123456789');
      expect(controller.identityError.value, isEmpty);
      await controller.verifyAndSearchChildren();
      expect(
        controller.birthDateError.value,
        'يرجى اختيار تاريخ الميلاد للتحقق',
      );

      controller.onClose();
    },
  );
}
