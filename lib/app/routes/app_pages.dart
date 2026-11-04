import 'package:get/get.dart';
import '../modules/auth/bindings/auth_binding.dart';
import '../modules/auth/views/login_view.dart';
import '../modules/auth/views/register_view.dart';
import '../modules/child_details/bindings/child_details_binding.dart';
import '../modules/child_details/views/child_details_view.dart';
import '../modules/express_yourself/bindings/express_yourself_binding.dart';
import '../modules/express_yourself/views/express_yourself_view.dart';
import '../modules/drawing/bindings/drawing_binding.dart';
import '../modules/drawing/views/drawing_view.dart';
import '../modules/guided_coloring/bindings/guided_coloring_binding.dart';
import '../modules/guided_coloring/views/guided_coloring_view.dart';
import '../modules/singing/bindings/singing_binding.dart';
import '../modules/singing/views/singing_view.dart';
import '../modules/song_recording/bindings/song_recording_binding.dart';
import '../modules/song_recording/views/song_recording_view.dart';
import '../modules/home/bindings/home_binding.dart';
import '../modules/home/views/home_view.dart';
import '../modules/feelings/bindings/feelings_before_binding.dart';
import '../modules/feelings/views/feelings_before_view.dart';
import '../modules/link_identity/bindings/link_identity_binding.dart';
import '../modules/link_identity/views/link_identity_view.dart';
import '../modules/onboarding/bindings/onboarding_binding.dart';
import '../modules/onboarding/views/onboarding_view.dart';
import '../modules/phone_verification/bindings/phone_verification_binding.dart';
import '../modules/phone_verification/views/phone_verification_view.dart';
import '../modules/privacy/bindings/privacy_binding.dart';
import '../modules/privacy/views/privacy_view.dart';
import '../modules/select_children/bindings/select_children_binding.dart';
import '../modules/select_children/views/select_children_view.dart';
import '../modules/splash/bindings/splash_binding.dart';
import '../modules/splash/views/splash_view.dart';
import '../modules/verification_rejected/bindings/verification_rejected_binding.dart';
import '../modules/verification_rejected/views/verification_rejected_view.dart';
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
      name: Routes.home,
      page: () => const HomeView(),
      binding: HomeBinding(),
    ),
    GetPage(
      name: Routes.expressYourself,
      page: () => const ExpressYourselfView(),
      binding: ExpressYourselfBinding(),
    ),
    GetPage(
      name: Routes.drawing,
      page: () => const DrawingView(),
      binding: DrawingBinding(),
    ),
    GetPage(
      name: Routes.guidedColoring,
      page: () => const GuidedColoringView(),
      binding: GuidedColoringBinding(),
    ),
    GetPage(
      name: Routes.verificationRejected,
      page: () => const VerificationRejectedView(),
      binding: VerificationRejectedBinding(),
    ),
    GetPage(
      name: Routes.privacy,
      page: () => const PrivacyView(),
      binding: PrivacyBinding(),
    ),
    GetPage(
      name: Routes.phoneVerification,
      page: () => const PhoneVerificationView(),
      binding: PhoneVerificationBinding(),
    ),
    GetPage(
      name: Routes.feelingsBefore,
      page: () => const FeelingsBeforeView(),
      binding: FeelingsBeforeBinding(),
    ),
    GetPage(
      name: Routes.singing,
      page: () => const SingingView(),
      binding: SingingBinding(),
    ),
    GetPage(
      name: Routes.songRecording,
      page: () => const SongRecordingView(),
      binding: SongRecordingBinding(),
    ),
  ];
}
