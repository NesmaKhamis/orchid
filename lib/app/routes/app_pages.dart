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
import '../modules/main_shell/bindings/main_shell_binding.dart';
import '../modules/main_shell/views/main_shell_view.dart';
import '../modules/link_identity/bindings/link_identity_binding.dart';
import '../modules/link_identity/views/link_identity_view.dart';
import '../modules/onboarding/bindings/onboarding_binding.dart';
import '../modules/onboarding/views/onboarding_view.dart';
import '../modules/email_verification/bindings/email_verification_binding.dart';
import '../modules/email_verification/views/email_verification_view.dart';
import '../modules/privacy/bindings/privacy_binding.dart';
import '../modules/privacy/views/privacy_view.dart';
import '../modules/select_children/bindings/select_children_binding.dart';
import '../modules/select_children/views/select_children_view.dart';
import '../modules/splash/bindings/splash_binding.dart';
import '../modules/splash/views/splash_view.dart';
import '../modules/verification_rejected/bindings/verification_rejected_binding.dart';
import '../modules/verification_rejected/views/verification_rejected_view.dart';
import '../modules/workshops/bindings/workshop_details_binding.dart';
import '../modules/workshops/bindings/my_workshops_binding.dart';
import '../modules/workshops/bindings/workshops_binding.dart';
import '../modules/workshops/views/workshop_details_view.dart';
import '../modules/workshops/views/workshop_list_view.dart';
import '../modules/workshops/views/my_workshops_view.dart';
import '../modules/profile/bindings/profile_binding.dart';
import '../modules/profile/views/profile_view.dart';
import '../modules/rewards/bindings/rewards_binding.dart';
import '../modules/rewards/bindings/reward_details_binding.dart';
import '../modules/rewards/bindings/my_reward_requests_binding.dart';
import '../modules/rewards/views/rewards_view.dart';
import '../modules/rewards/views/reward_details_view.dart';
import '../modules/rewards/views/my_reward_requests_view.dart';
import '../modules/notifications/bindings/notifications_binding.dart';
import '../modules/notifications/views/notifications_view.dart';
import '../modules/feelings/bindings/feelings_binding.dart';
import '../modules/feelings/views/feelings_view.dart';
import 'app_routes.dart';

class AppPages {
  AppPages._();

  static const initial = Routes.home;

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
      page: () => const MainShellView(),
      binding: MainShellBinding(),
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
      name: Routes.emailVerification,
      page: () => const EmailVerificationView(),
      binding: EmailVerificationBinding(),
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
    GetPage(
      name: Routes.workshops,
      page: () => const WorkshopListView(),
      binding: WorkshopsBinding(),
    ),
    GetPage(
      name: Routes.workshopDetails,
      page: () => const WorkshopDetailsView(),
      binding: WorkshopDetailsBinding(),
    ),
    GetPage(
      name: Routes.myWorkshops,
      page: () => const MyWorkshopsView(),
      binding: MyWorkshopsBinding(),
    ),
    GetPage(
      name: Routes.rewards,
      page: () => const RewardsView(),
      binding: RewardsBinding(),
    ),
    GetPage(
      name: Routes.rewardDetails,
      page: () => const RewardDetailsView(),
      binding: RewardDetailsBinding(),
    ),
    GetPage(
      name: Routes.myRewardRequests,
      page: () => const MyRewardRequestsView(),
      binding: MyRewardRequestsBinding(),
    ),
    GetPage(
      name: Routes.notifications,
      page: () => const NotificationsView(),
      binding: NotificationsBinding(),
    ),
    GetPage(
      name: Routes.profile,
      page: () => const ProfileView(),
      binding: ProfileBinding(),
    ),
    GetPage(
      name: Routes.feelingsBefore,
      page: () => const FeelingsView(),
      binding: FeelingsBinding(),
    ),
    GetPage(
      name: Routes.feelingsAfter,
      page: () => const FeelingsView(),
      binding: FeelingsBinding(),
    ),
  ];
}
