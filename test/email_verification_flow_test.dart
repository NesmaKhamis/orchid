import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:orchid_app/app/core/constants/app_assets.dart';
import 'package:orchid_app/app/core/services/session_service.dart';
import 'package:orchid_app/app/core/services/session_storage.dart';
import 'package:orchid_app/app/data/models/child_model.dart';
import 'package:orchid_app/app/data/repositories/auth_repository.dart';
import 'package:orchid_app/app/data/repositories/children_repository.dart';
import 'package:orchid_app/app/modules/auth/bindings/auth_binding.dart';
import 'package:orchid_app/app/modules/auth/controllers/auth_controller.dart';
import 'package:orchid_app/app/modules/child_details/bindings/child_details_binding.dart';
import 'package:orchid_app/app/modules/child_details/controllers/child_details_controller.dart';
import 'package:orchid_app/app/modules/email_verification/bindings/email_verification_binding.dart';
import 'package:orchid_app/app/modules/email_verification/controllers/email_verification_controller.dart';
import 'package:orchid_app/app/routes/app_routes.dart';

void main() {
  testWidgets('registration sends verification after account creation', (
    WidgetTester tester,
  ) async {
    Get.testMode = true;
    final _VerificationAuthRepository authRepository =
        _VerificationAuthRepository();
    final _VerificationSessionStorage storage = _VerificationSessionStorage();
    Get.put<AuthRepository>(authRepository);
    Get.put<SessionService>(SessionService(storage, authRepository));

    await tester.pumpWidget(
      GetMaterialApp(
        initialRoute: Routes.register,
        getPages: <GetPage<dynamic>>[
          GetPage<dynamic>(
            name: Routes.register,
            page: () => const Scaffold(body: Text('Register')),
            binding: AuthBinding(),
          ),
          GetPage<dynamic>(
            name: Routes.login,
            page: () => const Scaffold(body: Text('Login')),
            binding: AuthBinding(),
          ),
        ],
      ),
    );

    final AuthController controller = Get.find<AuthController>();
    controller.nameController.text = 'Parent';
    controller.emailController.text = 'parent@example.com';
    controller.passwordController.text = 'password123';
    controller.confirmPasswordController.text = 'password123';

    await controller.register();
    expect(controller.isLoading.value, isFalse);
    await tester.pumpAndSettle();

    expect(authRepository.events, <String>['signUp', 'sendEmailVerification']);
    expect(storage.registrationCompleteValue, isFalse);
    expect(storage.lastStepValue, Routes.emailVerification);
    expect(Get.currentRoute, Routes.login);
    expect(
      Get.find<AuthController>().emailController.text,
      'parent@example.com',
    );
    expect(find.text('Login'), findsOneWidget);
    expect(find.text('تم إنشاء الحساب بنجاح'), findsOneWidget);

    await tester.pump(const Duration(seconds: 4));
    await tester.pumpAndSettle();
    await tester.pumpWidget(const SizedBox.shrink());
    Get.reset();
    await authRepository.dispose();
  });

  testWidgets('confirmed email opens parent identity verification', (
    WidgetTester tester,
  ) async {
    Get.testMode = true;
    final _VerificationAuthRepository authRepository =
        _VerificationAuthRepository();
    final _VerificationSessionStorage storage = _VerificationSessionStorage();
    Get.put<AuthRepository>(authRepository);
    Get.put<SessionService>(SessionService(storage, authRepository));

    await tester.pumpWidget(
      GetMaterialApp(
        initialRoute: Routes.emailVerification,
        getPages: <GetPage<dynamic>>[
          GetPage<dynamic>(
            name: Routes.emailVerification,
            page: () => const Scaffold(body: Text('Verification')),
            binding: EmailVerificationBinding(),
          ),
          GetPage<dynamic>(
            name: Routes.home,
            page: () => const Scaffold(body: Text('Home')),
          ),
          GetPage<dynamic>(
            name: Routes.linkIdentity,
            page: () => const Scaffold(body: Text('Parent verification')),
          ),
        ],
      ),
    );

    await tester.pump();
    await tester.pump();
    final EmailVerificationController controller =
        Get.find<EmailVerificationController>();
    await controller.confirm();
    await tester.pumpAndSettle();

    expect(storage.registrationCompleteValue, isFalse);
    expect(storage.lastStepValue, Routes.linkIdentity);
    expect(find.text('Parent verification'), findsOneWidget);

    await tester.pumpWidget(const SizedBox.shrink());
    Get.reset();
    await authRepository.dispose();
  });

  testWidgets('child details completion marks registration and opens home', (
    WidgetTester tester,
  ) async {
    Get.testMode = true;
    final _VerificationAuthRepository authRepository =
        _VerificationAuthRepository();
    final _VerificationSessionStorage storage = _VerificationSessionStorage();
    final _VerificationChildrenRepository childrenRepository =
        _VerificationChildrenRepository();
    Get.put<AuthRepository>(authRepository);
    Get.put<SessionService>(SessionService(storage, authRepository));
    Get.put<ChildrenRepository>(childrenRepository);

    await tester.pumpWidget(
      GetMaterialApp(
        initialRoute: Routes.home,
        getPages: <GetPage<dynamic>>[
          GetPage<dynamic>(
            name: Routes.home,
            page: () => const Scaffold(body: Text('Home')),
          ),
          GetPage<dynamic>(
            name: Routes.childDetails,
            page: () => const Scaffold(body: Text('Child details')),
            binding: ChildDetailsBinding(),
          ),
        ],
      ),
    );

    final ChildModel child = ChildModel(
      id: 'child-1',
      name: 'Child',
      grade: 'Grade',
      avatarAsset: AppAssets.orchidSingle,
      nationalId: '123456789',
      birthDate: DateTime(2018),
    );
    Get.toNamed(Routes.childDetails, arguments: child);
    await tester.pumpAndSettle();

    await Get.find<ChildDetailsController>().proceedToDashboard();
    await tester.pumpAndSettle();

    expect(storage.registrationCompleteValue, isTrue);
    expect(storage.lastStepValue, Routes.home);
    expect(Get.find<SessionService>().selectedChildId, child.id);
    expect(childrenRepository.savedChild?.id, child.id);
    expect(Get.currentRoute, Routes.home);
    expect(find.text('Home'), findsOneWidget);

    await tester.pumpWidget(const SizedBox.shrink());
    Get.reset();
    await authRepository.dispose();
  });
}

class _VerificationAuthRepository implements AuthRepository {
  final StreamController<String?> _authChanges =
      StreamController<String?>.broadcast();
  final List<String> events = <String>[];

  @override
  Stream<String?> get authStateChanges => _authChanges.stream;

  @override
  String? get currentUserId => 'user-1';

  @override
  bool get isEmailVerified => true;

  @override
  String get currentEmail => 'parent@example.com';

  @override
  Future<bool> reloadAndCheckVerified() async => true;

  @override
  Future<void> sendEmailVerification() async {
    events.add('sendEmailVerification');
  }

  @override
  Future<void> signIn({required String email, required String password}) =>
      throw UnimplementedError();

  @override
  Future<void> signOut() async {}

  @override
  Future<void> signUp({
    required String email,
    required String password,
    required String name,
  }) async {
    events.add('signUp');
  }

  Future<void> dispose() => _authChanges.close();
}

class _VerificationSessionStorage implements SessionStorage {
  bool registrationCompleteValue = false;
  String? lastStepValue = Routes.emailVerification;

  @override
  Future<bool> get registrationComplete async => registrationCompleteValue;

  @override
  Future<void> clear() async {}

  @override
  Future<bool> get onboardingSeen async => true;

  @override
  Future<void> setOnboardingSeen(bool value) async {}

  @override
  Future<void> setRegistrationComplete(bool value) async {
    registrationCompleteValue = value;
  }

  @override
  Future<String?> get lastStep async => lastStepValue;

  @override
  Future<void> setLastStep(String? value) async {
    lastStepValue = value;
  }

  @override
  Future<String?> get selectedChildId async => null;

  @override
  Future<void> setSelectedChildId(String? value) async {}
}

class _VerificationChildrenRepository implements ChildrenRepository {
  ChildModel? savedChild;

  @override
  Future<List<ChildModel>> getChildren() async => <ChildModel>[];

  @override
  Future<void> saveChild(ChildModel child) async {
    savedChild = child;
  }
}
