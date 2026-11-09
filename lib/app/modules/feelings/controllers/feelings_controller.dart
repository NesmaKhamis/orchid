import 'package:get/get.dart';

import '../../../core/services/session_service.dart';
import '../../../data/models/mood_record.dart';
import '../../../data/repositories/mood_repository.dart';
import '../../../data/repositories/rewards_repository.dart';
import '../../../routes/app_routes.dart';

/// Suggestion for a calming activity when feeling difficult emotions.
class CalmingSuggestion {
  const CalmingSuggestion({
    required this.message,
    required this.buttonLabel,
    required this.route,
  });

  final String message;
  final String buttonLabel;
  final String route;
}

class FeelingsController extends GetxController {
  FeelingsController({
    required MoodRepository moodRepository,
    required RewardsRepository rewardsRepository,
    SessionService? sessionService,
  })  : _moodRepository = moodRepository,
        _rewardsRepository = rewardsRepository,
        _sessionService = sessionService;

  final MoodRepository _moodRepository;
  final RewardsRepository _rewardsRepository;
  final SessionService? _sessionService;

  // Reactive state
  final Rx<Feeling?> selectedFeeling = Rx<Feeling?>(null);
  final RxBool isLoading = false.obs;
  final RxBool isSubmitted = false.obs;
  final RxInt coinsAwarded = 0.obs;
  final RxString supportiveMessage = ''.obs;
  final Rx<CalmingSuggestion?> calmingSuggestion = Rx<CalmingSuggestion?>(null);
  final RxString errorMessage = ''.obs;

  @override
  void onInit() {
    super.onInit();
    _checkExistingRecord();
  }

  Future<void> _checkExistingRecord() async {
    try {
      final String? childId = _sessionService?.selectedChildId;
      final MoodRecord? existing =
          await _moodRepository.getTodayLastRecord(childId: childId);
      if (existing != null) {
        selectedFeeling.value = existing.feeling;
        _buildSupportiveMessage(existing.feeling);
        isSubmitted.value = true;
      }
    } catch (_) {}
  }

  void selectFeeling(Feeling feeling) {
    if (isSubmitted.value) return;
    selectedFeeling.value = feeling;
  }

  Future<void> submit() async {
    final Feeling? feeling = selectedFeeling.value;
    if (feeling == null || isLoading.value || isSubmitted.value) {
      return;
    }

    try {
      isLoading.value = true;
      errorMessage.value = '';

      final String? childId = _sessionService?.selectedChildId;

      final MoodRecord? existing =
          await _moodRepository.getTodayLastRecord(childId: childId);
      if (existing != null) {
        selectedFeeling.value = existing.feeling;
        _buildSupportiveMessage(existing.feeling);
        isSubmitted.value = true;
        return;
      }

      final MoodRecord record = MoodRecord(
        id: '',
        childId: childId,
        feeling: feeling,
        phase: MoodPhase.before,
        createdAt: DateTime.now(),
      );

      await _moodRepository.saveRecord(record);

      // Award daily activity coins (only on first check-in of the day, within daily cap)
      final int awarded = await _rewardsRepository.completeActivity('act-mood');
      coinsAwarded.value = awarded;

      _buildSupportiveMessage(feeling);
      isSubmitted.value = true;
    } catch (e) {
      errorMessage.value = 'حدث خطأ أثناء حفظ المشاعر. حاول مرة أخرى.';
    } finally {
      isLoading.value = false;
    }
  }

  void _buildSupportiveMessage(Feeling feeling) {
    switch (feeling) {
      case Feeling.happy:
        supportiveMessage.value =
            'رائع أن تشعر بالسعادة والبهجة! ابتسامتك تنير الأوركيد 🌟';
        break;
      case Feeling.sad:
        supportiveMessage.value =
            'من الطبيعي أن نشعر بالحزن أحياناً، كل المشاعر مقبولة. الوردة معك دائماً 🌸';
        break;
      case Feeling.worried:
        supportiveMessage.value =
            'أنت بأمان وقلقك سيمر بهدوء. تنفّس بعمق ودعنا نعبّر معاً 🌿';
        break;
      case Feeling.shy:
        supportiveMessage.value =
            'الخجل شعور لطيف وصادق، ونحن نحبك كما أنت تماماً 🌷';
        break;
      case Feeling.angry:
        supportiveMessage.value =
            'الغضب طاقة طبيعية تمر بنا وتهدأ. كل المشاعر مرحب بها يا بطل 💫';
        break;
      case Feeling.tired:
        supportiveMessage.value =
            'جسمك وقلبك يستحقان الراحة الآن. خذ نفساً هادئاً واستمتع بلحظات لطيفة ☁️';
        break;
    }

    // Calming activity suggestion for difficult feelings (sad, worried, angry, tired)
    calmingSuggestion.value = _resolveCalmingSuggestion(feeling);
  }

  CalmingSuggestion? _resolveCalmingSuggestion(Feeling feeling) {
    switch (feeling) {
      case Feeling.sad:
        return const CalmingSuggestion(
          message: 'ما رأيك أن تلوّن لوحة هادئة لتشعر براحة أكبر؟',
          buttonLabel: 'التلوين الموجه',
          route: Routes.guidedColoring,
        );
      case Feeling.worried:
        return const CalmingSuggestion(
          message: 'الرسم الحر يساعدك على التعبير وتفريغ القلق بهدوء.',
          buttonLabel: 'مرسمي الصغير',
          route: Routes.drawing,
        );
      case Feeling.angry:
        return const CalmingSuggestion(
          message: 'جرّب أن تُنشد نشيداً معنا لتستعيد هدوءك وطاقتك الإيجابية.',
          buttonLabel: 'الغناء والإنشاد',
          route: Routes.singing,
        );
      case Feeling.tired:
        return const CalmingSuggestion(
          message: 'استمع إلى نشيد لطيف وهادئ يريحك.',
          buttonLabel: 'الغناء والإنشاد',
          route: Routes.singing,
        );
      case Feeling.happy:
      case Feeling.shy:
        return null;
    }
  }

  void finish() {
    Get.back();
  }

  void goToCalmingActivity(String route) {
    Get.offNamed(route);
  }
}
