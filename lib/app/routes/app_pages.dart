import 'package:get/get.dart';
import '../modules/auth/views/login_view.dart';
import '../modules/auth/views/register_view.dart';
import '../modules/onboarding/views/onboarding_view.dart';
import '../modules/splash/views/splash_view.dart';
import '../modules/home/views/home_view.dart';
import '../modules/home/controllers/home_controller.dart';
import '../modules/child_details/views/child_details_view.dart';
import '../modules/child_details/controllers/child_details_controller.dart';
import 'app_routes.dart';

class AppPages {
  AppPages._();

static const INITIAL = Routes.HOME;
  static final routes = [
    GetPage(
      name: Routes.SPLASH,
      page: () => const SplashView(),
    ),
    GetPage(
      name: Routes.ONBOARDING,
      page: () => const OnboardingView(),
    ),
    GetPage(
      name: Routes.LOGIN,
      page: () => const LoginView(),
    ),
    GetPage(
      name: Routes.REGISTER,
      page: () => const RegisterView(),
    ),
    GetPage(
      name: '/child-details',
      page: () => const ChildDetailsView(),
      binding: BindingsBuilder(() {
        Get.put(ChildDetailsController());
      }),
    ),
    GetPage(
      name: '/home',
      page: () => const HomeView(),
      binding: BindingsBuilder(() {
        Get.put(HomeController());
      }),
    ),
  ];
}