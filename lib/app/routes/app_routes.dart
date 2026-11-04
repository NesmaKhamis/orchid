abstract class _Paths {
  static const splash = '/splash';
  static const onboarding = '/onboarding';
  static const login = '/login';
  static const register = '/register';
  static const linkIdentity = '/link-identity';
  static const selectChildren = '/select-children';
  static const childDetails = '/child-details';
  static const verificationRejected = '/verification-rejected';
  static const privacy = '/privacy';
  static const phoneVerification = '/phone-verification';
}

abstract class Routes {
  Routes._();
  static const splash = _Paths.splash;
  static const onboarding = _Paths.onboarding;
  static const login = _Paths.login;
  static const register = _Paths.register;
  static const linkIdentity = _Paths.linkIdentity;
  static const selectChildren = _Paths.selectChildren;
  static const childDetails = _Paths.childDetails;
  static const verificationRejected = _Paths.verificationRejected;
  static const privacy = _Paths.privacy;
  static const phoneVerification = _Paths.phoneVerification;
}
