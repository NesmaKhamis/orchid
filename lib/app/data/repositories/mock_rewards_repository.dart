import 'dart:async';

import '../../core/constants/app_assets.dart';
import '../../core/constants/app_constants.dart';
import '../../routes/app_routes.dart';
import '../models/daily_activity.dart';
import '../models/reward_item.dart';
import '../models/reward_request.dart';
import 'rewards_repository.dart';

class MockRewardsRepository implements RewardsRepository {
  MockRewardsRepository({int initialBalance = 85, int initialTodayEarned = 20})
      : _balance = initialBalance,
        _todayEarned = initialTodayEarned;

  int _balance;
  final int _todayEarned;
  final StreamController<int> _balanceController =
      StreamController<int>.broadcast();

  final List<RewardItem> _rewards = <RewardItem>[
    const RewardItem(
      id: 'reward-drawing-kit',
      title: 'دفتر رسم وألوان شمعية',
      description:
          'دفتر رسم فاخر بأوراق بيضاء سميكة مناسبة لكل أنواع الألوان، مع علبة ألوان شمعية براقة لتنطلق في عالم الإبداع والبهجة.',
      cost: 60,
      imageAsset: AppAssets.rewardPlaceholder,
      emoji: '🎨', // TODO: replace emoji with final reward image
      stock: 5,
      pickupInstructions:
          'الاستلام من مكتب استقبال مركز الأوركيد يومي الأحد والثلاثاء مع إبراز هوية ولي الأمر.',
    ),
    const RewardItem(
      id: 'reward-orchid-plush',
      title: 'دمية زهرة الأوركيد اللطيفة',
      description:
          'دمية ناعمة مصممة بحب على شكل زهرة الأوركيد الباسمة لتكون صديقتك الوفية أثناء النوم والمغامرات.',
      cost: 120,
      imageAsset: AppAssets.rewardPlaceholder,
      emoji: '🧸', // TODO: replace emoji with final reward image
      stock: 3,
      pickupInstructions:
          'الاستلام من غرفة الأنشطة بالجمعية خلال أوقات الدوام الرسمي.',
    ),
    const RewardItem(
      id: 'reward-magic-mug',
      title: 'كوب الأوركيد السحري',
      description:
          'كوب حراري مبهج تظهر عليه رسومات زهرة الأوركيد وأصدقائها عند سكب المشروب الدافئ.',
      cost: 40,
      imageAsset: AppAssets.rewardPlaceholder,
      emoji: '🎒', // TODO: replace emoji with final reward image
      stock: 8,
      pickupInstructions:
          'الاستلام من مكتب الجمعية الرئيسي بعد يومين من تأكيد الطلب.',
    ),
    const RewardItem(
      id: 'reward-wooden-puzzle',
      title: 'مجموعة ألعاب تركيب خشبية',
      description:
          'ألعاب تركيب خشبية ممتعة وممتازة لتحدي الذكاء وبناء القلاع والقصور الخيالية.',
      cost: 350,
      imageAsset: AppAssets.rewardPlaceholder,
      emoji: '🧩', // TODO: replace emoji with final reward image
      stock: 2,
      pickupInstructions:
          'الاستلام من قسم الهدايا في الجمعية مصطحباً بطاقة العائلة.',
    ),
    const RewardItem(
      id: 'reward-pencil-case',
      title: 'حقيبة ألوان ومقلمة مدرسية',
      description:
          'مقلمة مدرسية لطيفة وجميلة مزودة بأقلام تلوين ومسطرة وممحاة مرحة.',
      cost: 50,
      imageAsset: AppAssets.rewardPlaceholder,
      emoji: '✏️', // TODO: replace emoji with final reward image
      stock: 0,
      pickupInstructions:
          'الاستلام من مقر الجمعية عند توفر الدفعة الجديدة.',
    ),
    const RewardItem(
      id: 'reward-hero-badge',
      title: 'شارة بطل الأوركيد المميزة',
      description:
          'شارة لامعة تثبت على صدرك أو حقيبتك المدرسية تعبيراً عن تميزك ومشاركتك الإيجابية في أنشطة الأوركيد.',
      cost: 30,
      imageAsset: AppAssets.rewardPlaceholder,
      emoji: '🏅', // TODO: replace emoji with final reward image
      stock: 15,
      pickupInstructions:
          'الاستلام فوراً من المشرفة في ورشتك التفاعلية القادمة.',
    ),
  ];

  final List<DailyActivity> _activities = <DailyActivity>[
    const DailyActivity(
      id: 'act-mood',
      title: 'تسجيل مشاعري اليوم',
      coins: AppConstants.moodCheckInCoins,
      isCompleted: true,
      route: null,
    ),
    const DailyActivity(
      id: 'act-drawing',
      title: 'رسمة في المرسم الصغير',
      coins: AppConstants.drawingCoins,
      isCompleted: true,
      route: Routes.drawing,
    ),
    const DailyActivity(
      id: 'act-coloring',
      title: 'تلوين لوحة إبداعية',
      coins: AppConstants.coloringCoins,
      isCompleted: false,
      route: Routes.guidedColoring,
    ),
    const DailyActivity(
      id: 'act-singing',
      title: 'إنشاد نشيد الأوركيد',
      coins: AppConstants.singingCoins,
      isCompleted: false,
      route: Routes.singing,
    ),
    const DailyActivity(
      id: 'act-workshop',
      title: 'حضور ورشة عمل تفاعلية',
      coins: AppConstants.workshopCoins,
      isCompleted: false,
      route: Routes.workshops,
    ),
  ];

  final List<RewardRequest> _requests = <RewardRequest>[
    RewardRequest(
      id: 'req-sample-ready',
      rewardId: 'reward-hero-badge',
      rewardTitle: 'شارة بطل الأوركيد المميزة',
      cost: 30,
      status: RewardRequestStatus.ready,
      createdAt: DateTime.now().subtract(const Duration(days: 2)),
      pickupInstructions:
          'الاستلام فوراً من المشرفة في ورشتك التفاعلية القادمة.',
    ),
    RewardRequest(
      id: 'req-sample-review',
      rewardId: 'reward-magic-mug',
      rewardTitle: 'كوب الأوركيد السحري',
      cost: 40,
      status: RewardRequestStatus.review,
      createdAt: DateTime.now().subtract(const Duration(days: 1)),
      pickupInstructions:
          'الاستلام من مكتب الجمعية الرئيسي بعد يومين من تأكيد الطلب.',
    ),
  ];

  @override
  Future<int> getBalance() async {
    await Future<void>.delayed(const Duration(milliseconds: 150));
    return _balance;
  }

  @override
  Stream<int> watchBalance() async* {
    yield _balance;
    yield* _balanceController.stream;
  }

  @override
  Future<int> getTodayEarnedCoins() async {
    await Future<void>.delayed(const Duration(milliseconds: 100));
    return _todayEarned;
  }

  @override
  Future<List<DailyActivity>> getDailyActivities() async {
    await Future<void>.delayed(const Duration(milliseconds: 150));
    return List<DailyActivity>.unmodifiable(_activities);
  }

  @override
  Future<List<RewardItem>> getRewards() async {
    await Future<void>.delayed(const Duration(milliseconds: 200));
    return List<RewardItem>.unmodifiable(_rewards);
  }

  @override
  Future<RewardItem?> getRewardById(String id) async {
    await Future<void>.delayed(const Duration(milliseconds: 100));
    final int index = _rewards.indexWhere((RewardItem item) => item.id == id);
    if (index == -1) return null;
    return _rewards[index];
  }

  @override
  Future<List<RewardRequest>> getRequests() async {
    await Future<void>.delayed(const Duration(milliseconds: 150));
    return List<RewardRequest>.unmodifiable(_requests);
  }

  @override
  Future<RewardRequest> redeem(String rewardId) async {
    await Future<void>.delayed(const Duration(milliseconds: 300));
    final int index = _rewards.indexWhere((RewardItem item) => item.id == rewardId);
    if (index == -1) {
      throw const RewardsFailure('عذراً، المكافأة المطلوبة غير موجودة.');
    }
    final RewardItem item = _rewards[index];
    if (item.isOutOfStock) {
      throw const RewardsFailure('عذراً، لقد نفدت كمية هذه المكافأة حالياً.');
    }
    if (_balance < item.cost) {
      final int diff = item.cost - _balance;
      throw RewardsFailure('رصيدك من العملات لا يكفي. ينقصك $diff عملة لإتمام طلب هذه المكافأة!');
    }

    _balance -= item.cost;
    _rewards[index] = item.copyWith(stock: item.stock - 1);

    final RewardRequest newRequest = RewardRequest(
      id: 'req-${DateTime.now().millisecondsSinceEpoch}',
      rewardId: item.id,
      rewardTitle: item.title,
      cost: item.cost,
      status: RewardRequestStatus.review,
      createdAt: DateTime.now(),
      pickupInstructions: item.pickupInstructions,
    );

    _requests.insert(0, newRequest);
    _balanceController.add(_balance);

    return newRequest;
  }
}
