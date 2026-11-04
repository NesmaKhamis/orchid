# AGENTS.md — Orchid (orchid_app)

Read this file fully before every task. It is the single source of truth for architecture,
design tokens, reusable widgets and quality rules. Prompts you receive will be short and will
rely on this file, so follow it strictly.

---

## 1. Product context

Orchid is an Arabic-only (RTL) Flutter mobile app for children aged 5–12 and their parents,
focused on emotional well-being (feelings check-ins, workshops). A parent registers, verifies
the family identity, accepts the privacy terms, verifies a phone number, and then the child's
space opens (feelings check-in, home, workshops).

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

1. **Do NOT edit `pubspec.yaml`** (no new packages, no version changes, no asset/font changes).
   If a task seems to need a package or a font, stop and report it in the final summary.
2. **Do NOT create or edit** `firebase_options.dart`, `google-services.json`,
   `GoogleService-Info.plist`, or anything under `android/` and `ios/`.
3. **Never hardcode** colors, font sizes, radii, spacing or asset paths inside a view. Use the
   tokens in section 5 and `AppAssets`.
4. **Never copy-paste a UI block** that already exists as a shared widget (section 6). If a
   needed widget does not exist yet, create it in `core/widgets/` first, then use it.
5. **No business logic in views.** Views only render state and forward events to the controller.
6. **No mock data inside controllers.** Mock data lives in a repository (section 8).
7. **No string route literals** (`'/login'`). Always use `Routes.xxx`.
8. Keep the scope tight: do not refactor or change behavior outside what the task asks.
   Anything extra you notice goes to the "Notes" part of your final summary, not into the diff.
9. **Legacy screens are FROZEN.** `splash`, `onboarding`, `auth` (login/register), `link_identity`,
   `select_children`, `child_details` were designed and built by a teammate and look better than
   the Figma. Do not change their visuals, layout, colors, texts or widget trees, and do not
   restyle or "migrate" them to shared widgets. Touch them only when a prompt explicitly asks,
   and then only for the listed logic/navigation change.
10. New screens must feel consistent with the legacy ones (same purple, rounded fields and buttons,
   animation style) wherever the Figma does not say otherwise.
11. Available packages only: `get`, `flutter_animate`, `audioplayers`, `firebase_core`,
   `cloud_firestore`, `firebase_auth`, `cupertino_icons`.

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
        app_constants.dart          # business constants (min/max child age 5–12, OTP length, timers)
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
| `textDark` | `0xFF2D2D2D` | titles, labels |
| `textSubtitle` | `0xFF6B588C` | subtitles on onboarding-style screens |
| `textMuted` | `0xFF757575` | hints, captions |
| `inputBg` | `0xFFFAF9FC` | text field background |
| `border` | `0xFFE0E0E0` | field and card borders |
| `background` | `0xFFFAFAF2` (cream, approx.) | screen background in the new design |
| `lavender` | `0xFFF0E0F0` | soft purple surfaces, secondary button background |
| `softYellow` | `0xFFF8F0C8` | warning / note banners |
| `softMint` | `0xFFE0F0E0` | success banners, positive chips |
| `softPink` | `0xFFF0D8E8` | feelings cards, accents |
| `softBlue` | `0xFFE0E8F0` | feelings cards, accents |
| `splashGradient` | `D8F3DC → E8E8F4 → FFF0F5` | splash background only |
| `error` | `0xFFD32F2F` | validation errors |
| `palettePink` | `0xFFE86A92` | drawing color swatch (placeholder hex, confirm with Figma) |
| `paletteYellow` | `0xFFF5C542` | drawing color swatch (placeholder hex, confirm with Figma) |
| `paletteGreen` | `0xFF58B368` | drawing color swatch (placeholder hex, confirm with Figma) |
| `paletteBlue` | `0xFF4E7AC7` | drawing color swatch (placeholder hex, confirm with Figma) |
| `paletteNavy` | `0xFF2D3A5E` | drawing color swatch (placeholder hex, confirm with Figma) |

Use `color.withValues(alpha: x)` — never `withOpacity` (deprecated).

**Dimens (`AppDimens`)**: spacing scale `4, 8, 12, 16, 20, 24, 28, 32, 40`; screen horizontal
padding `24`; radius `field 16`, `card 20`, `button 26`, `chip 12`; button height `52`.

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
| `AppTextField` | Label above the field, `controller`, `hint`, `prefixIcon`, `suffix`, `keyboardType`, `validator`, `readOnly`, `onTap`, `maxLength`, `obscureText`. |
| `PasswordField` | Wraps `AppTextField` with its own show/hide toggle (local state, no controller flag). |
| `SectionTitle` | Centered title + optional emoji + optional subtitle. |
| `NoticeBanner` | `tone` (`info` lavender / `warning` yellow / `success` mint / `danger` soft pink), icon, text. Used in many frames. |
| `StatusChip` | Small pill label (e.g. green "verified" tag), `tone`. |
| `OrchidImage` | `Image.asset` with a built-in fallback icon. Replaces every `errorBuilder` copy. |
| `SelectableCard` | Card with selected/unselected look + tap; used by child selection and feelings. |
| `OtpInput` | N separate digit boxes, `onCompleted`, `length` (default 6). |
| `AnimatedEntrance` | Extension/wrapper over `flutter_animate` for the common fade+slide entrance. |
| `StepHeader` | Registration header: small step label ("02 / تأكيد الهاتف • 4 من 4"), bold title, lock icon in a white circle, back chevron (created in prompt C3, reused by C2 and C4). |
| `InfoRow` | Title + value row for read-only data cards (created in prompt C1). |
| `AppCheckboxTile` | Labelled checkbox with optional "required" marker (created in prompt C3). |
| `SectionCard` | Tinted tappable card: tone, icon/emoji, title, subtitle, arrow (created in prompt C6). |
| `AppBottomNavBar` | Bottom navigation driven by a list of items (label, icon, activeIcon) (created in prompt C6). |
| `AppHeaderBar` | Screen top bar: back button, optional caption above a bold title, optional trailing widget (e.g. sound toggle). |

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
- Controllers talk to repositories (`Get.find<ChildRepository>()` registered in a binding),
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
  implementation with `Future.delayed`. Swapping to Firebase later must only touch the binding.

## 9. Screen map (Figma frame → module → route)

Status: ✅ built (new) · 🔒 legacy, frozen (see rule 9) · ⬜ not built.

| Figma frame | Module | Route | Status |
|---|---|---|---|
| Splash | `splash` | `Routes.splash` | 🔒 |
| بداية الرحلة (welcome) | `onboarding` | `Routes.onboarding` | 🔒 |
| Login (not in current Figma set) | `auth` | `Routes.login` | 🔒 |
| Register (not in current Figma set) | `auth` | `Routes.register` | 🔒 |
| التسجيل — تعرّف على الأسرة (family identification) | `link_identity` | `Routes.linkIdentity` | 🔒 |
| التحقق — قبول ("اطمئن، كل شيء مناسب") = the existing child details screen | `child_details` | `Routes.childDetails` | 🔒 |
| التحقق — رفض (age out of range 5–12) | `verification` | `Routes.verificationRejected` | ⬜ |
| التسجيل — خصوصيتك أولاً (privacy & consent) | `privacy` | `Routes.privacy` | ⬜ |
| التسجيل — تأكد من هاتفك (phone OTP) | `phone_verification` | `Routes.phoneVerification` | ⬜ |
| المشاعر — قبل (how is your heart today) | `feelings` | `Routes.feelingsBefore` | ⬜ |
| الرئيسية (home) inside the bottom-nav shell | `main_shell`, `home` | `Routes.home` (temporary direct route from `childDetails`; shell not built yet) | ✅ |
| حديقة الإبداع — عَبِّر عن نفسك | `express_yourself` | `Routes.expressYourself` (from home card "عَبِّر عن نفسك") | ✅ |
| الرسم الحر — مرسمي الصغير (drawing canvas) | `drawing` | `Routes.drawing` (from express_yourself card "الرسم الحر") | ✅ |
| التلوين الموجه (guided coloring) | `guided_coloring` | `Routes.guidedColoring` (from express_yourself card "التلوين الموجه") | ✅ |
| الغناء والإنشاد (singing) | `singing` | `Routes.singing` (from express_yourself card "الغناء والإنشاد") | ✅ |
| تسجيل النشيد (song recording) | `song_recording` | `Routes.songRecording` (from singing card tap; play circle only previews) | ✅ |
| الورشات — الرئيسية (workshops list) | `workshops` | `Routes.workshops` | ⬜ |
| الورشات — التفاصيل (workshop details + map) | `workshops` | `Routes.workshopDetails` | ⬜ |
| المشاعر — بعد (how do you feel now) | `feelings` | `Routes.feelingsAfter` | ⬜ |
| Select children / Child details (current code, not in Figma set) | `select_children`, `child_details` | `Routes.selectChildren`, `Routes.childDetails` | 🔒 |

Update this table in the same commit whenever a screen's status changes.

Proposed navigation (confirm with the team, then edit here):
`splash → onboarding → login/register → linkIdentity → selectChildren → (child age 5–12) childDetails | (otherwise) verificationRejected → privacy → phoneVerification → feelingsBefore → mainShell (home / workshops) → workshopDetails → feelingsAfter`.
`childDetails` is the Figma "verification accepted" screen; its continue button will navigate to `Routes.privacy`.

Shared app state (selected child, parent) lives in a `SessionService` (`GetxService`), never in constructor chains.

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

1. `main.dart` defines its own inline `getPages` and ignores `AppPages` → `Splash` and
   `Onboarding` are unreachable; initial route is `/login`.
2. Two dead color files (`core/constant/app_colors.dart` with a different purple, and an empty
   `core/constants/app_colors.dart`), plus an empty `app_theme.dart`. Colors are repeated as
   literals in every view (`0xFF8B53A8` ×9, `0xFF2D2D2D` ×8, `0xFFFAF9FC` ×5).
3. Splash navigates twice: `SplashController.onReady` (10 s delay) and a 3 s `Timer` inside
   the view. Timers and wink animation state live in the view.
4. `ChildModel` is defined in `select_children_controller.dart`, and
   `select_children_controller` ↔ `child_details_controller` import each other (circular).
   `SelectChildrenController` also imports a view.
5. `ChildDetailsController` hardcodes ID/birth date/fallback child; `ChildDetailsView` is
   navigated with `Get.to` + inline binding instead of a route.
6. `LinkIdentityController` contains dead members (`idController` getter returning null,
   `verifyIdentity` getter returning null) and a hardcoded color.
7. Route strings hardcoded in controllers (`'/link-identity'`, `'/register'`, `'/select-children'`).
8. `leaf_top.png` is referenced (onboarding) but missing; `leaf_corner.png` exists.
9. No Arabic RTL guarantee: no localization delegates or `Directionality`; views use physical
   `Alignment.centerRight`, `TextAlign.right`.
10. Theme font `Cairo` is set but no font is declared in `pubspec.yaml` (needs a team decision).
11. No form validation (login/register accept empty and mismatched passwords).
12. 16× deprecated `withOpacity`; 5× `Get.width` for layout.

## 14. Git

Small, focused commits. Message format: `type(scope): summary`, e.g.
`feat(privacy): add privacy consent screen`, `refactor(core): extract AppButton and AppTextField`.
Do not commit generated or sensitive files (`google-services.json`, `GoogleService-Info.plist`).