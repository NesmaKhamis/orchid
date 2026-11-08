import 'package:get/get.dart';
import '../modules/auth/bindings/auth_binding.dart';
import '../modules/auth/views/login_view.dart';
import '../modules/auth/views/register_view.dart';
import '../modules/child_details/bindings/child_details_binding.dart';
import '../modules/child_details/views/child_details_view.dart';
import '../modules/link_identity/bindings/link_identity_binding.dart';
import '../modules/link_identity/views/link_identity_view.dart';
import '../modules/onboarding/bindings/onboarding_binding.dart';
import '../modules/onboarding/views/onboarding_view.dart';
import '../modules/profile/bindings/profile_binding.dart';
import '../modules/profile/views/profile_view.dart';
import '../modules/select_children/bindings/select_children_binding.dart';
import '../modules/select_children/views/select_children_view.dart';
import '../modules/splash/bindings/splash_binding.dart';
import '../modules/splash/views/splash_view.dart';
import 'app_routes.dart';

class AppPages {
  AppPages._();

  static const initial = Routes.splash;

  static final routes = [
    GetPage(
      name: Routes.splash,
      page: () => const SplashView(),
      binding: SplashBinding(),
    ),
    GetPage(
      name: Routes.onboarding,
      page: () => const OnboardingView(),
      binding: OnboardingBinding(),
    ),
    GetPage(
      name: Routes.login,
      page: () => const LoginView(),
      binding: AuthBinding(),
    ),
    GetPage(
      name: Routes.register,
      page: () => const RegisterView(),
      binding: AuthBinding(),
    ),
    GetPage(
      name: Routes.linkIdentity,
      page: () => const LinkIdentityView(),
      binding: LinkIdentityBinding(),
    ),
    GetPage(
      name: Routes.selectChildren,
      page: () => const SelectChildrenView(),
      binding: SelectChildrenBinding(),
    ),
    GetPage(
      name: Routes.childDetails,
      page: () => const ChildDetailsView(),
      binding: ChildDetailsBinding(),
    ),
    GetPage(
      name: Routes.profile,
      page: () => const ProfileView(),
      binding: ProfileBinding(),
    ),
  ];
}
