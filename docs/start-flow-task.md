Read AGENTS.md fully first. This task fixes UI details and the registration flow of the Orchid app.

For THIS task only, rule 9 (frozen screens) is lifted for: auth, link_identity, select_children, child_details, verification_rejected, privacy, phone_verification (renamed to email_verification in Stage 3). Update AGENTS.md rule 9 and the screen map accordingly in Stage 0.

Setup:
- Create the branch feature/flow-ui-fixes from the current main (git checkout main, then git checkout -b feature/flow-ui-fixes).
- Do NOT push.
- Do NOT touch Firebase files, android/, ios/ or pubspec.yaml.
- After each stage run flutter analyze (no new issues in files you touched) and make ONE commit with the message given. Do not start the next stage if analyze shows new errors.
- Use tokens and shared widgets only (AppColors, AppDimens, AppTextStyles, AppAssets). Use withValues(alpha: x), never withOpacity. No hardcoded colors, sizes or route strings.
- Keep all texts unchanged unless this prompt says otherwise. No overflow on 360x640.

================ STAGE 0 ================
Commit: `docs(agents): open flow screens for ui fixes`
1. Update AGENTS.md rule 9: the screens listed above are open for this task (UI fixes + flow logic).
2. Update the screen map status of those screens accordingly.

================ STAGE 1: Back button + headers ================
Commit: `refactor(ui): unify back button and fix screen headers`
1. Create the shared widget core/widgets/app_back_button.dart (AppBackButton):
   - Placed at the TOP-RIGHT of the screen in RTL, using DIRECTIONAL values (AlignmentDirectional.topStart / PositionedDirectional(start: ...)), consistent with AGENTS.md section 7. Wrap it in Directionality(textDirection: TextDirection.rtl) if the host screen is a legacy screen that is not already RTL, so it always lands on the right.
   - Same size, color and tap area everywhere. Default onPressed = Get.back().
   - Icon: Icons.arrow_forward_rounded under RTL (it points right = "back" in Arabic). Make sure the icon renders pointing RIGHT on every screen, including legacy screens that are not wrapped in RTL (in that case wrap the button itself in RTL Directionality). Report which icon/direction ended up on screen.
   - Add it to the shared widgets catalog in AGENTS.md section 6.
2. Use it on every screen that has a back action: link_identity, select_children, privacy, phone_verification, register, and any other screen with a back arrow. Remove the duplicated custom back buttons and the raw AppBars that exist only for a back arrow. Do NOT add it to splash, onboarding, login, home, or verification_rejected and child_details (those two are handled below). If a screen already has something at the top-right that conflicts with the button, do not break the layout: report it in Notes.
3. Password fields (login, register): keep the show/hide eye icon on the physical LEFT side of the field (the owner wants it on the left, opposite to the back button). Use a suffix/prefix that renders on the left regardless of the screen's directionality, and verify visually.
4. link_identity: remove the AppBar completely (use AppBackButton in the body instead).
5. verification_rejected:
   - Remove the AppBar title text "01 / تعذر استكمال التسجيل" and any step label above it.
   - Remove the "العودة إلى البداية" button (it sends the user to the start flow, which is wrong here).
   - Keep ONE action: the button currently labeled "مراجعة البيانات". Rename it "اختيار طفل آخر". It goes back to select_children.
   - Remove the back arrow on this screen (the button replaces it).
6. child_details:
   - Remove the back arrow.
   - Add a primary button at the bottom labeled "متابعة" that navigates to Routes.privacy (use the same navigation the current continue logic uses; if a continue button already exists, fix its label and position instead of duplicating it).
   - Add a secondary text button "رجوع" below it that goes back to select_children.
7. privacy:
   - Remove the title/step text in the AppBar area (the "خصوصيتك أولاً" header text above).
   - Remove the extra top button above "أوافق وأتابع" (keep only the bottom consent button).
   - Keep the consent checkbox logic.

================ STAGE 2: Registration details only on first signup ================
Commit: `fix(flow): registration details only on first signup`
1. Today login always goes to Routes.linkIdentity. Change the AuthController login: after success call SessionService.markLoggedIn(), then navigate with Get.offAllNamed(Get.find<SessionService>().resolveStartRoute()), so a user with registrationComplete goes straight to Routes.home and an unfinished user resumes at the saved step.
2. Register keeps going to Routes.linkIdentity, and resets progress: saveStep(Routes.linkIdentity) and registrationComplete = false.
3. Add a clear comment: login is still fake; with Firebase the account state will come from the real user profile.
4. Verify resolveStartRoute handles login correctly in all cases and report any gap (for example a user who never registered logging in with the fake login).

================ STAGE 3: Replace phone verification with email verification ================
Commit: `refactor(flow): replace phone verification with email verification (UI + mock logic)`
Phone verification is removed from the product (children's app: less personal data, SMS is unreliable and may cost money). Replace it with EMAIL verification.
1. Rename the module phone_verification to email_verification (folder, binding, controller, view) and Routes.phoneVerification to Routes.emailVerification in app_routes.dart and app_pages.dart. Update every reference, including SessionService.resolveStartRoute and the allowed resume steps (phoneVerification becomes emailVerification), and AGENTS.md (screen map, section 9 navigation, section 9b).
2. Remove: the phone number display, the OTP input usage on this screen, the hardcoded "123456", the OTP and masked-phone methods of the mock auth repository, the "تعديل رقم الهاتف" button, and any phone-related constants or strings that become unused (for example the OTP length). If OtpInput becomes unused, keep the shared widget but mention it in Notes.
3. New screen content (same visual style; reuse StepHeader, AppButton, NoticeBanner and AppBackButton):
   - Title: "تأكيد البريد الإلكتروني".
   - A short text explaining that a verification link was sent to the user's email.
   - Show the email address (LTR).
   - Primary button: "تم التأكيد، تابع".
   - Text button: "إعادة إرسال الرابط" with a 60 second cooldown timer (Timer disposed in onClose).
   - A small text button "تغيير البريد الإلكتروني" that goes to Routes.register ONLY if that makes sense in the flow; otherwise omit it and report why.
4. Logic through the abstract AuthRepository: add sendEmailVerification(), reloadAndCheckVerified() -> Future<bool>, and currentEmail. Implement them in the MOCK repository for now (sendEmailVerification = a short delay; reloadAndCheckVerified returns true when the user taps the continue button), with a clear comment: // TODO: replace with FirebaseAuth currentUser.sendEmailVerification() / currentUser.reload() / emailVerified. The controller calls only the repository (Get.find<AuthRepository>() registered in the binding).
5. On success: SessionService.markRegistrationComplete(), then Get.offAllNamed(Routes.home). If not verified: AppSnackbar.warning("لم يتم تأكيد البريد بعد، تحقق من صندوق الوارد").
6. Navigation order stays: privacy -> emailVerification -> home.

================ FINAL ================
Finish with the summary format from AGENTS.md section 12, plus:
- A table of the commits with their hashes.
- Which back arrow icon you chose and what direction it actually renders on screen.
- Manual test checklist for me to run on a device:
  (1) the back button is at the top-right on every screen that has one, and the arrow points right;
  (2) the eye icon of password fields is on the left;
  (3) the rejected screen has exactly one action ("اختيار طفل آخر");
  (4) child details has "متابعة" + "رجوع"; privacy leads to email verification, not phone;
  (5) after a full registration, kill the app and log in again: it goes to home, not link identity;
  (6) a brand new register goes through link identity, select child, privacy, email verification, then home.
- Notes: anything suspicious you saw but did not change.
Never push. Never edit android/, ios/, pubspec.yaml or Firebase files.