import 'dart:async';
import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../../core/constants/app_assets.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_dimens.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/widgets/orchid_image.dart';

class MascotGreeting extends StatefulWidget {
  const MascotGreeting({super.key, required this.onMascotTapped});

  final VoidCallback onMascotTapped;

  static const List<String> tapMessages = <String>[
    'اختر اللي بيريحك اليوم',
    'أنا هون معك',
    'كل رسمة وكل صوت إله مكان',
  ];

  @override
  State<MascotGreeting> createState() => MascotGreetingState();
}

class MascotGreetingState extends State<MascotGreeting>
    with TickerProviderStateMixin {
  static const Duration idleDuration = Duration(seconds: 3);
  static const Duration tapMessageDuration = Duration(seconds: 3);
  static const Duration firstGreetingDuration = Duration(seconds: 4);

  late final AnimationController _idleController;
  late final AnimationController _bounceController;
  Timer? _messageTimer;
  String? _message;
  bool? _animationsDisabled;
  int _messageIndex = -1;

  @override
  void initState() {
    super.initState();
    _idleController = AnimationController(vsync: this, duration: idleDuration);
    _bounceController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 650),
      value: 1,
    );
    _message = _timeGreeting();
    _scheduleDismissal(firstGreetingDuration);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final bool disableAnimations = MediaQuery.of(context).disableAnimations;
    if (_animationsDisabled == disableAnimations) return;
    _animationsDisabled = disableAnimations;
    if (disableAnimations) {
      _idleController.stop();
      _bounceController.stop();
      _bounceController.value = 1;
    } else {
      _idleController.repeat();
    }
  }

  @override
  void dispose() {
    _messageTimer?.cancel();
    _idleController.dispose();
    _bounceController.dispose();
    super.dispose();
  }

  void showMessage(String message) {
    setState(() => _message = message);
    _scheduleDismissal(tapMessageDuration);
    _bounce();
  }

  void _scheduleDismissal(Duration duration) {
    _messageTimer?.cancel();
    _messageTimer = Timer(duration, () {
      if (mounted) setState(() => _message = null);
    });
  }

  void _bounce() {
    if (_animationsDisabled != true) _bounceController.forward(from: 0);
  }

  void _onMascotTapped() {
    _messageIndex = (_messageIndex + 1) % MascotGreeting.tapMessages.length;
    showMessage(MascotGreeting.tapMessages[_messageIndex]);
    widget.onMascotTapped();
  }

  String _timeGreeting() {
    final int hour = DateTime.now().hour;
    if (hour < 12) return 'صباح الخير يا بطل';
    if (hour < 18) return 'نهارك جميل يا بطل';
    return 'مساء الهدوء';
  }

  @override
  Widget build(BuildContext context) {
    final bool disableAnimations = _animationsDisabled ?? false;
    final Duration bubbleFadeDuration = disableAnimations
        ? Duration.zero
        : const Duration(milliseconds: 220);

    return SizedBox(
      height: 180,
      child: Padding(
        padding: const EdgeInsetsDirectional.symmetric(
          horizontal: AppDimens.screenHorizontalPadding,
        ),
        child: Stack(
          children: <Widget>[
            SizedBox(
              height: 136,
              child: Row(
                children: <Widget>[
                  const Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          'ما الذي تحبّه اليوم؟',
                          style: AppTextStyles.title,
                        ),
                        SizedBox(height: AppDimens.space4),
                        Text(
                          'لا توجد طريقة خاطئة للتعبير.',
                          style: AppTextStyles.bodySmall,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: AppDimens.space16),
                  GestureDetector(
                    onTap: _onMascotTapped,
                    child: Semantics(
                      button: true,
                      label: 'زهرة الأوركيد',
                      child: AnimatedBuilder(
                        animation: Listenable.merge(<Listenable>[
                          _idleController,
                          _bounceController,
                        ]),
                        child: const OrchidImage(
                          assetPath: AppAssets.orchidSingle,
                          width: 136,
                          height: 136,
                        ),
                        builder: (BuildContext context, Widget? child) {
                          final double angle =
                              math.sin(_idleController.value * math.pi * 2) *
                              (math.pi / 90);
                          final double breath =
                              1 +
                              (1 -
                                      math.cos(
                                        _idleController.value * math.pi * 2,
                                      )) *
                                  0.03;
                          final double bounce = Curves.elasticOut.transform(
                            _bounceController.value,
                          );
                          return Transform.rotate(
                            angle: angle,
                            child: Transform.scale(
                              scale: breath * bounce,
                              child: child,
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
            PositionedDirectional(
              end: 0,
              bottom: 0,
              child: IgnorePointer(
                child: AnimatedOpacity(
                  opacity: _message == null ? 0 : 1,
                  duration: bubbleFadeDuration,
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 200),
                    child: Container(
                      padding: const EdgeInsetsDirectional.symmetric(
                        horizontal: AppDimens.space12,
                        vertical: AppDimens.space8,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(
                          AppDimens.radiusCard,
                        ),
                        border: Border.all(
                          color: AppColors.lavender.withValues(alpha: 0.8),
                        ),
                      ),
                      child: Text(
                        _message ?? '',
                        textAlign: TextAlign.center,
                        style: AppTextStyles.caption.copyWith(
                          color: AppColors.textSubtitle,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
