# AGENTS.md — Orchid (orchid_app)

Read this file fully before every task. It is the single source of truth for architecture,
design tokens, reusable widgets and quality rules. Prompts you receive will be short and will
rely on this file, so follow it strictly.

---

## 1. Product context

Orchid is an Arabic-only (RTL) Flutter mobile app for children aged 5–12 and their parents,
focused on emotional well-being (feelings check-ins, workshops). A parent registers, verifies
their email, verifies the family identity, selects a child and confirms the child's details,
then the child's space opens (feelings check-in, home, workshops).

- UI language: Arabic only. All user-facing strings are Arabic. Code, identifiers, comments: English.
- Design source of truth: Figma frames (390 × 940). Every UI task comes with a screenshot of the
  frame. **The screenshot wins over any text description in a prompt.** If the screenshot is
  missing or ambiguous, ask instead of guessing.
- Tone of UI: soft, friendly, child-safe: pastel surfaces, rounded corners, purple primary.

### Figma source

- Design file: https://www.figma.com/design/figLaRSBdENieD7UA6ADng/Untitled?node-id=3-26164
- If a Figma MCP server is connected (tool names containing `figma`), use it **before coding any UI task**:
  1. Fetch the file/node above and locate the frame named in the prompt (frame names are in Arabic).
  2. Read exact texts, colors, font sizes, spacing, radii and layout from the node data, not from guesses.
  3. Update the token table in section 5 if Figma values differ from it, and tell me in the summary.
  4. Export or reference images only if they are missing from `assets/images/` — and report missing assets instead of inventing them.
- If no Figma tool is available, rely on the screenshot attached to the prompt.
- Never write any Figma token or API key into the repo (code, docs, config, commits).

## 2. Hard rules (never break)

1. **Do NOT edit `pubspec.yaml`** except to add the approved packages listed in rule 11.
   Everything else (version changes, assets, fonts) still needs to be reported in the final summary.
   If a task seems to need anything else, stop and report it in the final summary.
2. **Do NOT create or edit** `firebase_options.dart`, `google-services.json`,
   `GoogleService-Info.plist`, or anything under `android/` and `ios/`.
   **Temporary exception (Firebase integration only):** while the `feature/firebase-integration`
   work is in progress, `firebase_options.dart`, the Android Gradle files
   (`android/settings.gradle.kts`, `android/app/build.gradle.kts`), the Android manifest files and
   the iOS Firebase files may be edited. Every other `android/`/`ios/` file stays off-limits.
   `google-services.json` and `GoogleService-Info.plist` must still never be committed (they stay
   in `.gitignore`), and no fake/placeholder copy of them may be created. This exception ends
   when the Firebase integration task is closed; remove it from this file in that commit.
3. **Never hardcode** colors, font sizes, radii, spacing or asset paths inside a view. Use the
   tokens in section 5 and `AppAssets`.
4. **Never copy-paste a UI block** that already exists as a shared widget (section 6). If a
   needed widget does not exist yet, create it in `core/widgets/` first, then use it.
5. **No business logic in views.** Views only render state and forward events to the controller.
6. **No mock data inside controllers.** Mock data lives in a repository (section 8).
7. **No string route literals** (`'/login'`). Always use `Routes.xxx`.
8. Keep the scope tight: do not refactor or change behavior outside what the task asks.
   Anything extra you notice goes to the "Notes" part of your final summary, not into the diff.
9. **Legacy screens: visual freeze, limited scope.** `splash`, `onboarding` and `home` remain frozen.
  For the `feature/notifications` task, the home bell icon and header are OPEN to open notifications and align the header layout.
  For the `feature/feelings` task, the home mood card area is OPEN (display & navigation to feelings screen).
  For the `feature/rewards` task, the home daily-challenge card and `main_shell` are
  OPEN for UI polish. For the tab header consistency task, the home header area is OPEN to unify home and rewards tab headers. For the `docs/start-flow-task.md` task, `auth` (login/register),
  `link_identity`, `select_children`, `child_details`, `verification_rejected`, `privacy` and
  `email_verification` are OPEN for UI fixes and flow logic. Outside these tasks, preserve the
  existing visual freeze and touch these screens only when a prompt explicitly asks.
10. New screens must feel consistent with the legacy ones (same purple, rounded fields and buttons,
   animation style) wherever the Figma does not say otherwise.
11. Available packages only: `get`, `flutter_animate`, `audioplayers`, `firebase_core`,
   `cloud_firestore`, `firebase_auth`, `cupertino_icons`, `shared_preferences`.

## 3. Tech stack

Flutter (SDK ^3.11.4), GetX (`get ^4.7.3`) for state, routing and DI, `flutter_animate` for
animations, Firebase (not wired yet; auth is mocked).

## 4. Architecture

Feature-first modules with GetX. Target structure:

```
lib/
  main.dart                         # Firebase init (later), GetMaterialApp, theme, RTL builder
  app/
    core/
      constants/
        app_assets.dart             # every asset path as a static const
        app_strings.dart            # shared strings only (validation messages, common labels)
        app_constants.dart          # business constants (min/max child age 5–12, verification timers)
      theme/
        app_colors.dart             # color tokens
        app_text_styles.dart        # text style tokens
        app_dimens.dart             # spacing + radius + sizes
        app_theme.dart              # ThemeData built from the tokens
      utils/
        validators.dart             # pure functions: String? Function(String?)
        app_snackbar.dart           # the ONLY way to show snackbars
        date_utils.dart             # age calculation, date formatting
      widgets/                      # shared design-system widgets (section 6)
    data/
      models/                       # plain Dart models (ChildModel, ...)
      repositories/                 # abstract repository + MockXxxRepository implementation
    modules/
      <feature>/
        bindings/<feature>_binding.dart
        controllers/<feature>_controller.dart
        views/<feature>_view.dart
        widgets/                    # widgets used ONLY by this feature
    routes/
      app_routes.dart               # Routes constants
      app_pages.dart                # GetPage list (the only place routes are registered)
```

Rules:
- `main.dart` must use `AppPages.routes` and `AppPages.initial`. No inline `getPages`.
- Every route has a Binding class. No inline `BindingsBuilder` and no `Get.put` inside controllers.
- Models never live inside controller files. Controllers never import views.
- A module may import `core/` and `data/`. A module must never import another module's
  controller or view. Pass data between screens with `Get.arguments` (typed model) or via a
  shared repository/service registered in a binding.
- File names: `snake_case.dart`. Classes: `UpperCamelCase`. One public class per file (small
  private helper widgets in the same file are fine).

## 5. Design tokens

Define these in `core/theme/`. Values come from the existing code and from the Figma colors
(pastel values were sampled from a screenshot — if you can inspect the Figma file, trust Figma
and update this table).

**Colors (`AppColors`)**

| Token | Value | Use |
|---|---|---|
| `primary` | `0xFF8B53A8` | buttons, links, icons, selected borders |
| `white` | `0xFFFFFFFF` | cards on cream backgrounds |
| `textDark` | `0xFF2D2D2D` | titles, labels |
| `textSubtitle` | `0xFF6B588C` | subtitles on onboarding-style screens |
| `textMuted` | `0xFF757575` | hints, captions |
| `inputBg` | `0xFFFAF9FC` | text field background |
| `border` | `0xFFE0E0E0` | field and card borders |
| `background` | `0xFFFAFAF2` (cream, approx.) | screen background in the new design |
| `coolLavender` | `0xFFF8F5FC` | cool lavender background on Home and Rewards |
| `lavender` | `0xFFF0E0F0` | soft purple surfaces, secondary button background |
| `softYellow` | `0xFFF8F0C8` | warning / note banners |
| `softMint` | `0xFFE0F0E0` | success banners, positive chips |
| `softPink` | `0xFFF0D8E8` | feelings cards, accents |
| `softBlue` | `0xFFE0E8F0` | feelings cards, accents |
| `success` | `0xFF2E7D32` | success text and icons |
| `splashGradient` | `D8F3DC → E8E8F4 → FFF0F5` | splash background only |
| `error` | `0xFFD32F2F` | validation errors |
| `palettePink` | `0xFFE86A92` | drawing color swatch (placeholder hex, confirm with Figma) |
| `paletteYellow` | `0xFFF5C542` | drawing color swatch (placeholder hex, confirm with Figma) |
| `paletteGreen` | `0xFF58B368` | drawing color swatch (placeholder hex, confirm with Figma) |
| `paletteBlue` | `0xFF4E7AC7` | drawing color swatch (placeholder hex, confirm with Figma) |
| `paletteNavy` | `0xFF2D3A5E` | drawing color swatch (placeholder hex, confirm with Figma) |

Use `color.withValues(alpha: x)` — never `withOpacity` (deprecated).

**Dimens (`AppDimens`)**: spacing scale `4, 8, 12, 16, 20, 24, 28, 32, 40`; screen horizontal
padding `24`; radius `field 16`, `card 20`, `button 26`, `pill 32`, `chip 12`; button height `52`.

**Text styles (`AppTextStyles`)**: `h1` 27 bold, `h2` 22–24 bold, `title` 18 bold, `label` 14 bold,
`body` 14, `bodySmall` 13, `caption` 12. Always `fontFamily` from the theme (do not set it per widget).

**Assets**: every path goes through `AppAssets` (`orchidSingle`, `orchidMascot`, `orchidOpen`,
`orchidWink`, `leafCorner`, `welcome`, `q`). Existing files in `assets/images/`:
`leaf_corner.png, orchid_mascot.png, orchid_open.png, orchid_single.png, orchid_wink.png, q.png, welcome.png`.
`leaf_top.png` does NOT exist — use `leaf_corner.png` instead.

**Orchid face images are not available yet** (sad / happy / worried / shy and others). Until the designer's final files are added, `AppAssets` must define `orchidFaceHappy`, `orchidFaceSad`, `orchidFaceWorried`, `orchidFaceShy` (and more if needed), all temporarily pointing to an existing image (e.g. `orchid_single.png`) with a `// TODO: replace with final asset` comment. Screens use ONLY these constants, so swapping the real images later means editing `app_assets.dart` only. Never reference an asset file that does not exist.

## 6. Shared widgets catalog (`core/widgets/`)

Build each once, reuse everywhere. Widgets are stateless/GetX-agnostic: they take values and
callbacks, never a controller.

| Widget | Purpose / key params |
|---|---|
| `AppScaffold` | Screen shell: background (`plain`, `cream`, `gradient`), optional corner leaf decoration, `SafeArea`, optional scroll, standard horizontal padding, optional `title` + back button app bar. |
| `AppButton` | `label`, `onPressed`, `variant` (`primary` / `soft` / `text`), `isLoading`, `icon`, `fullWidth`. Handles disabled + loading state. |
| `AppBackButton` | Shared RTL back action with a consistent 48px tap target; defaults to `Get.back()`. |
| `AppTextField` | Label above the field, `controller`, `hint`, `prefixIcon`, `suffix`, `keyboardType`, `validator`, `readOnly`, `onTap`, `maxLength`, `obscureText`, `textDirection`, `fillColor`. |
| `PasswordField` | Wraps `AppTextField` with its own show/hide toggle (local state, no controller flag). |
| `SectionTitle` | Centered title + optional emoji + optional subtitle. |
| `NoticeBanner` | `tone` (`info` lavender / `warning` yellow / `success` mint / `danger` soft pink), icon, text. Used in many frames. |
| `StatusChip` | Small pill label (e.g. green "verified" tag), `tone`. |
| `OrchidImage` | `Image.asset` with a built-in fallback icon. Replaces every `errorBuilder` copy. |
| `AnimatedOrchid` | Animated orchid hero switching between `orchidOpen` and `orchidWink`; owns its wink timer. Params: `size` (default 240), `autoStart` (default true). |
| `SelectableCard` | Card with selected/unselected look + tap; used by child selection and feelings. |
| `OtpInput` | N separate digit boxes, `length` (default 6), `onChanged`, `onCompleted`, optional `OtpInputController.clear()`, autofocus first box, auto-advance, backspace to previous, paste fills all boxes. |
| `AnimatedEntrance` | Extension/wrapper over `flutter_animate` for the common fade+slide entrance. |
| `StepHeader` | Registration header: `stepLabel`, bold `title`, optional `onBack` (defaults to pop), lock icon in a white circle, back chevron. Reused by registration screens. |
| `InfoRow` | Title + value row for read-only data cards (created in prompt C1). |
| `AppCheckboxTile` | Labelled checkbox tile: `label`, `value`, `onChanged`, `tone` (lavender/mint/pink). Whole tile is tappable. |
| `SectionCard` | Tinted tappable card: tone, icon/emoji, title, subtitle, arrow (created in prompt C6). |
| `CoinBalanceCard` | Animated balance display with AnimatedOrchid, coin count, encouraging copy and daily cap progress bar. |
| `HeroCardContainer` | Reusable tinted hero card shell with lavender/soft-mint surface, primary/success border tint, standard/completed variants, and card radius (CoinBalanceCard, Home challenge, Mood card). |
| `RewardCard` | Card showing reward image, title, cost, and availability state (order button / progress / out-of-stock). |
| `RequestStatusChip` | Status badge for reward requests mapping RewardRequestStatus to Arabic label and semantic tone. |
| `ParentGateDialog` | Child-safe arithmetic parent gate dialog and `showParentGateDialog` helper before sensitive actions. |
| `AppSegmentedTabs` | Segmented control with equal-width buttons (labels, selectedIndex, onChanged). |
| `AppBottomNavBar` | Bottom navigation driven by a list of items (label, icon, activeIcon) (created in prompt C6). |
| `NotificationCard` | Card displaying an AppNotification with category pastel tone, unread purple dot, and relative time. |
| `FeelingCard` | Card representing a single feeling with a large emoji and an Arabic label. |
| `AppHeaderBar` | Screen top bar: back button, optional caption above a bold title, optional trailing widget (e.g. sound toggle). |
| `TabHeader` | Unified top header for shell tabs: title, subtitle, optional trailing action, and consistent spacing. |

Helpers: `AppSnackbar.info/success/warning/error(message)`, `Validators.required/email/password/match/nationalId/phone`,
`AppDateUtils.ageFrom(DateTime)`, `AppDateUtils.format(DateTime)`.

## 7. RTL and Arabic rules

- **Do NOT force RTL globally**: the legacy screens are built with manual physical alignments and
  would flip. Instead `AppScaffold` wraps its content in `Directionality(textDirection: TextDirection.rtl)`,
  so every new screen (which must use `AppScaffold`) is RTL and legacy screens are untouched.
- Use directional values: `EdgeInsetsDirectional`, `AlignmentDirectional`, `TextAlign.start/end`,
  `BorderRadiusDirectional`. Never use `Alignment.centerRight`, `TextAlign.right`, `left:`/`right:`
  in `Positioned` for layout that should flip.
- In a text field, the leading icon is `prefixIcon` (it appears on the right in RTL), the
  trailing one is `suffixIcon`. Do not "fix" direction by swapping icons manually.
- Phone numbers, national IDs, emails and OTP digits are LTR content: use
  `textDirection: TextDirection.ltr` on those fields.
- Directional icons (`Icons.arrow_forward_rounded`, `Icons.arrow_back_rounded`) mirror
  automatically under RTL. Use `arrow_forward` for "next" and `arrow_back` for "back"; never
  flip them manually.

## 8. GetX and data conventions

Controllers:
- `final` for every Rx field: `final isLoading = false.obs;`
- Dispose every `TextEditingController` / `FocusNode` / `Timer` in `onClose`.
- Never hold `BuildContext`. Date pickers / dialogs are called from the view, and the controller
  receives the result (`onDatePicked(DateTime)`).
- Navigation: `Get.toNamed(Routes.xxx, arguments: typedModel)`.
- Controllers talk to repositories (`Get.find<ChildrenRepository>()` registered in a binding),
  never to hardcoded lists.

Views:
- `GetView<TController>`; reactive parts wrapped in the smallest possible `Obx`.
- Extract any widget block > ~40 lines or used twice into a widget (feature-local or shared).
- Use `const` wherever possible. No `Get.width` for layout: use `LayoutBuilder`,
  `FractionallySizedBox` or fixed/`ConstrainedBox` sizes from `AppDimens`.

Forms:
- Use `Form` + `GlobalKey<FormState>` (owned by the controller) + validators from `Validators`.
  Error messages in Arabic, friendly, short.

Data:
- `data/models/` plain immutable classes with `const` constructors, `fromMap`/`toMap` when
  Firestore is introduced.
- `data/repositories/xxx_repository.dart` = abstract class; `mock_xxx_repository.dart` = fake
  implementation with `Future.delayed`. Firebase repositories are selected in the relevant binding.

## 9. Screen map (Figma frame → module → route)

Status: ✅ built (new) · 🔒 legacy, frozen (see rule 9) · 🔓 open for this task · 🔶 placeholder route wired, real screen pending · ⬜ not built.

Note: for `docs/start-flow-task.md`, `auth` (login/register), `link_identity`, `select_children`,
`child_details`, `verification_rejected`, `privacy` and `email_verification` are open for both UI
fixes and flow logic.

| Figma frame | Module | Route | Status |
|---|---|---|---|
| Splash | `splash` | `Routes.splash` | 🔒 |
| بداية الرحلة (welcome) | `onboarding` | `Routes.onboarding` | 🔒 |
| Login (not in current Figma set) | `auth` | `Routes.login` | 🔓 |
| Register (not in current Figma set) | `auth` | `Routes.register` | 🔓 |
| التسجيل — تعرّف على الأسرة (family identification) | `link_identity` | `Routes.linkIdentity` | 🔓 |
| التحقق — قبول ("اطمئن، كل شيء مناسب") = the existing child details screen | `child_details` | `Routes.childDetails` | 🔓 |
| التحقق — رفض (age out of range 5–12) | `verification` | `Routes.verificationRejected` | 🔓 |
| التسجيل — خصوصيتك أولاً (privacy & consent) | `privacy` | `Routes.privacy` | 🔓 |
| التسجيل — تأكيد البريد الإلكتروني | `email_verification` | `Routes.emailVerification` | 🔓 |
| المشاعر — كيف قلبك اليوم؟ | feelings | Routes.feelingsBefore | ✅ |
| الرئيسية (home) inside the bottom-nav shell | `main_shell`, `home` | `Routes.home` | ✅ built by teammate, frozen |
| المكافآت والهدايا (rewards) inside the bottom-nav shell | `main_shell`, `rewards` | `Routes.rewards` | ✅ |
| تفاصيل المكافأة (reward details) | `rewards` | `Routes.rewardDetails` | ✅ |
| طلباتي من المكافآت (reward requests) | `rewards` | `Routes.myRewardRequests` | ✅ |
| الملف الشخصي (profile) inside the bottom-nav shell | `main_shell`, `profile` | `Routes.profile` | ✅ |
| حديقة الإبداع — عَبِّر عن نفسك | `express_yourself` | `Routes.expressYourself` (from home card "عَبِّر عن نفسك") | ✅ |
| الرسم الحر — مرسمي الصغير (drawing canvas) | `drawing` | `Routes.drawing` (from express_yourself card "الرسم الحر") | ✅ |
| التلوين الموجه (guided coloring) | `guided_coloring` | `Routes.guidedColoring` (from express_yourself card "التلوين الموجه") | ✅ |
| الغناء والإنشاد (singing) | `singing` | `Routes.singing` (from express_yourself card "الغناء والإنشاد") | ✅ |
| تسجيل النشيد (song recording) | `song_recording` | `Routes.songRecording` (from singing card tap; play circle only previews) | ✅ |
| الورشات — الرئيسية (workshops list) | `workshops` | `Routes.workshops` | ✅ |
| الورشات — التفاصيل (workshop details + map) | `workshops` | `Routes.workshopDetails` | ✅ |
| الورشات المسجلة (registered workshops) | `workshops` | `Routes.myWorkshops` | ✅ |
| الإشعارات (notifications) | `notifications` | `Routes.notifications` | ✅ |
| Select children / Child details (current code, not in Figma set) | `select_children`, `child_details` | `Routes.selectChildren`, `Routes.childDetails` | 🔒 |

Update this table in the same commit whenever a screen's status changes.

Current registration navigation:
`splash → onboarding → login/register → login (email prefilled) → emailVerification if unverified, otherwise linkIdentity → selectChildren → (age 5–12) childDetails → home`.
Out-of-range children route to `verificationRejected`.
`SelectChildrenController` checks the age with `AppDateUtils.ageFrom` against `AppConstants.minChildAge` / `maxChildAge` and routes accordingly.
`childDetails` is the Figma "verification accepted" screen; its continue button completes registration and navigates to `Routes.home`.

Shared app state (selected child, parent) lives in a `SessionService` (`GetxService`), never in constructor chains.

## 9d. Rewards

- Coins are earned only by completing daily activities: mood check-in, drawing,
  guided coloring, singing/song recording, and attending a workshop.
- Coins are spent on real rewards handed out by the charity. Redemption creates a
  request and follows these statuses: `pending` ("طلب جديد"), `review` ("قيد
  المراجعة"), `ready` ("جاهزة للاستلام"), and `received` ("تم الاستلام").
- Every redemption requires parent confirmation through a child-safe parent gate.
  No PIN is stored.
- Rewards have limited stock. Out-of-stock and insufficient-coins are separate
  states with friendly Arabic feedback.
- A daily coin cap limits earning to support healthy screen habits.
- Rewards data is mock-backed for now. Firebase implementations are selected in
  bindings only when the persistence layer is introduced.

## 9e. Feelings

- 6 core feelings (happy, sad, worried, shy, angry, tired) represented with warm, supportive, child-safe Arabic copy. "كل المشاعر مقبولة".
- The child records feelings ONCE per day, ONLY from the Home mood card. No second record the same day.
- The Rewards tab never opens the feelings screen. The "mood check-in" activity row there is display-only: not tappable, no route.
- When a record exists today, the Rewards activity row shows completed state: green (`AppColors.softMint` background, `AppColors.success` check icon and text) and updates immediately and reactively when the child records from Home.
- Home mood card: if no record today -> invitation, opens the check-in screen (`Routes.feelingsBefore`). If a record exists today -> success state (`AppColors.softMint` background, `AppColors.success` check icon), not tappable.
- The "after activity" check-in is REMOVED: creative activities (drawing, guided coloring, song recording) do not trigger feelings check-in.
- Privacy rule: Records are only saved. They are NEVER shown to parents or to the charity anywhere in the UI (no history screen, no profile section). The only thing shown back to the child is today's last feeling on the Home card.
- Coins: Awarded only on the first check-in of the day up to the daily coin cap through `RewardsRepository.completeActivity('act-mood')`.

## 9b. Session and first-launch logic

- `SessionService` (`GetxService`) is the only owner of: `onboardingSeen`, `isLoggedIn`,
  `registrationComplete`, `lastStep`, `selectedChildId`.
- `SessionStorage` is an abstract class. `FirebaseSessionStorage` stores account progress in
  Firestore and uses `LocalSessionStorage` (`shared_preferences`) for onboarding and per-user cache
  fallback; it is registered in `InitialBinding`.
- Splash decides the next route through `SessionService`, never directly.
- Logout = `SessionService.logout()` then `Get.offAllNamed(Routes.login)`.

## 9c. Firebase

- **Auth source of truth is `FirebaseAuth`.** The session is whatever `FirebaseAuth.instance
  .currentUser` says; `SessionService` mirrors it, it is not the authority.
- **Profile data lives in Firestore `users/{uid}`** (parent profile and its children).
  Nothing else owns profile data.
- **`onboardingSeen` stays in local storage** (`SessionStorage` / `shared_preferences`). It is a
  device-level flag and is never written to Firestore.
- **Repositories stay abstract.** Firebase implementations (`FirebaseAuthRepository`,
  `FirestoreUserRepository`, ...) are swapped in the **binding only**; controllers and views keep
  talking to the abstract repository, exactly like the mock ones today.
- **No direct Firebase calls inside views.** Views never import `firebase_auth`,
  `cloud_firestore` or `firebase_core`; they go through the controller, which goes through the
  repository. If a view needs data, add it to the controller.
- `Firebase.initializeApp` happens once, in `main.dart`, before `SessionService.init()`. On
  platforms without a configuration (`DefaultFirebaseOptions.currentPlatform` throws
  `UnsupportedError`) the app logs it and falls back to local mode instead of crashing.

## 10. Workflow for every new screen

1. Read the screenshot. List the sections (header, body blocks, banners, buttons) before coding.
2. Map each section to an existing shared widget. Create missing shared widgets first.
3. Create the module (binding, controller, view, local widgets) + route in `app_routes.dart`
   and `app_pages.dart`.
4. Put fake data in a mock repository, not in the controller.
5. Add entrance animations only where the design implies motion, via `AnimatedEntrance`.
6. Run `flutter analyze` and fix every issue in files you touched.
7. Update section 9 and, if you created a widget, section 6.
8. Finish with the summary format in section 12.

## 11. Definition of done

- [ ] `flutter analyze` shows no new warnings or errors (and none in files you touched).
- [ ] No hardcoded `Color(...)`, font sizes, asset strings or route strings in views/controllers.
- [ ] No duplicated UI block that a shared widget could cover.
- [ ] RTL verified: no physical left/right alignment; Arabic text and LTR numbers render correctly.
- [ ] Works on small screens (360 × 640) without overflow and on 390 × 940 matching the frame.
- [ ] Loading, empty and error states exist where the screen has async work.
- [ ] Controllers dispose everything they create.
- [ ] `AGENTS.md` tables updated.

## 12. Final summary format (every task)

1. What changed (files created / modified / deleted).
2. Decisions you made where the prompt or design was ambiguous.
3. Anything blocked (missing asset, package or font needed, Firebase config).
4. Output of `flutter analyze` (counts only is fine).

## 13. Known issues backlog (from the audit of the current code)

Items 2, 9, 11, 12 concern frozen legacy screens: do NOT fix them unless a prompt says so. Items 1, 3–7
may be fixed by their dedicated prompt (no visual change). Never make any of them worse.

1. **Fixed** — `main.dart` now uses `AppPages.initial` and `AppPages.routes` (no inline
   `getPages`; initial route is `Routes.splash`).
2. Two dead color files (`core/constant/app_colors.dart` with a different purple, and an empty
   `core/constants/app_colors.dart`), plus an empty `app_theme.dart`. Colors are repeated as
   literals in every view (`0xFF8B53A8` ×9, `0xFF2D2D2D` ×8, `0xFFFAF9FC` ×5).
3. **Fixed** — splash has a single controller navigation decision, and the wink animation
   state lives in the shared `AnimatedOrchid` widget.
4. `ChildModel` is defined in `select_children_controller.dart`, and
   `select_children_controller` ↔ `child_details_controller` import each other (circular).
   `SelectChildrenController` also imports a view.
5. `ChildDetailsController` hardcodes ID/birth date/fallback child; `ChildDetailsView` is
   navigated with `Get.to` + inline binding instead of a route.
6. `LinkIdentityController` contains dead members (`idController` getter returning null,
   `verifyIdentity` getter returning null) and a hardcoded color.
7. Route strings hardcoded in controllers (`'/link-identity'`, `'/register'`, `'/select-children'`).
8. `leaf_top.png` → use `leaf_corner.png` (the referenced `leaf_top.png` is missing).
9. No Arabic RTL guarantee: no localization delegates or `Directionality`; views use physical
   `Alignment.centerRight`, `TextAlign.right`.
10. Theme font `Cairo` is set but no font is declared in `pubspec.yaml` (needs a team decision).
11. No form validation (login/register accept empty and mismatched passwords).
12. 16× deprecated `withOpacity`; 5× `Get.width` for layout.
13. No session/persistence (fixed in start flow refresh).

## 14. Git

Small, focused commits. Message format: `type(scope): summary`, e.g.
`feat(privacy): add privacy consent screen`, `refactor(core): extract AppButton and AppTextField`.
Do not commit generated or sensitive files (`google-services.json`, `GoogleService-Info.plist`).