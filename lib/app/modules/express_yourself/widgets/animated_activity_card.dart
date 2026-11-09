import 'dart:async';
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_dimens.dart';
import '../../../core/theme/app_text_styles.dart';

class AnimatedActivityCard extends StatefulWidget {
  const AnimatedActivityCard({
    super.key,
    required this.index,
    required this.floatPhase,
    required this.backgroundColor,
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onPressedDown,
    required this.onTap,
  });

  static const Duration entranceDuration = Duration(milliseconds: 450);
  static const Duration entranceStagger = Duration(milliseconds: 120);
  static const Duration floatDuration = Duration(milliseconds: 2200);

  final int index;
  final double floatPhase;
  final Color backgroundColor;
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onPressedDown;
  final VoidCallback onTap;

  @override
  State<AnimatedActivityCard> createState() => _AnimatedActivityCardState();
}

class _AnimatedActivityCardState extends State<AnimatedActivityCard>
    with TickerProviderStateMixin {
  late final AnimationController _entranceController;
  late final AnimationController _floatController;
  bool _pressed = false;
  bool? _animationsDisabled;

  @override
  void initState() {
    super.initState();
    _entranceController = AnimationController(
      vsync: this,
      duration: AnimatedActivityCard.entranceDuration,
    );
    _floatController = AnimationController(
      vsync: this,
      duration: AnimatedActivityCard.floatDuration,
      value: widget.floatPhase,
    );
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final bool disableAnimations = MediaQuery.of(context).disableAnimations;
    if (_animationsDisabled == disableAnimations) return;
    _animationsDisabled = disableAnimations;
    if (disableAnimations) {
      _entranceController.stop();
      _entranceController.value = 1;
      _floatController.stop();
    } else {
      _entranceController.value = 0;
      _floatController.repeat(reverse: true);
      _startEntrance();
    }
  }

  @override
  void dispose() {
    _entranceController.dispose();
    _floatController.dispose();
    super.dispose();
  }

  Future<void> _startEntrance() async {
    await Future<void>.delayed(
      AnimatedActivityCard.entranceStagger * widget.index,
    );
    if (!mounted || _animationsDisabled == true) return;
    _entranceController.forward();
  }

  void _onTapDown(TapDownDetails details) {
    setState(() => _pressed = true);
    unawaited(HapticFeedback.lightImpact());
    widget.onPressedDown();
  }

  @override
  Widget build(BuildContext context) {
    final Widget card = Padding(
      padding: const EdgeInsetsDirectional.symmetric(
        horizontal: AppDimens.screenHorizontalPadding,
      ),
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTapDown: _onTapDown,
        onTapUp: (_) => setState(() => _pressed = false),
        onTapCancel: () => setState(() => _pressed = false),
        onTap: widget.onTap,
        child: AnimatedScale(
          scale: _pressed ? 0.96 : 1,
          duration: Duration(milliseconds: _pressed ? 120 : 360),
          curve: _pressed ? Curves.easeOut : Curves.elasticOut,
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.all(AppDimens.space16),
            decoration: BoxDecoration(
              color: widget.backgroundColor,
              borderRadius: BorderRadius.circular(AppDimens.radiusCard),
            ),
            child: Row(
              children: <Widget>[
                AnimatedBuilder(
                  animation: _floatController,
                  child: _buildIconTile(),
                  builder: (BuildContext context, Widget? child) {
                    final double offset =
                        math.sin(_floatController.value * math.pi * 2) * 3;
                    return Transform.translate(
                      offset: Offset(0, offset),
                      child: child,
                    );
                  },
                ),
                const SizedBox(width: AppDimens.space16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        widget.title,
                        style: AppTextStyles.label,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: AppDimens.space4),
                      Text(
                        widget.subtitle,
                        style: AppTextStyles.caption.copyWith(
                          color: AppColors.textMuted,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: AppDimens.space8),
                const Icon(
                  Icons.arrow_forward_ios_rounded,
                  size: 16,
                  color: AppColors.textMuted,
                ),
              ],
            ),
          ),
        ),
      ),
    );

    return Semantics(
      button: true,
      label: widget.title,
      child: AnimatedBuilder(
        animation: _entranceController,
        child: card,
        builder: (BuildContext context, Widget? child) {
          final double progress = Curves.easeOutCubic.transform(
            _entranceController.value,
          );
          return Opacity(
            opacity: progress,
            child: Transform.translate(
              offset: Offset(0, 24 * (1 - progress)),
              child: child,
            ),
          );
        },
      ),
    );
  }

  Widget _buildIconTile() {
    final Color petalColor = Color.lerp(
      widget.backgroundColor,
      Colors.white,
      0.45,
    )!.withValues(alpha: 0.56);

    return Container(
      width: 48,
      height: 48,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppDimens.radiusField),
      ),
      child: Stack(
        children: <Widget>[
          PositionedDirectional(
            start: 5,
            top: 5,
            child: _Petal(color: petalColor, width: 7, height: 11),
          ),
          PositionedDirectional(
            end: 6,
            bottom: 5,
            child: _Petal(color: petalColor, width: 6, height: 9),
          ),
          Center(child: Icon(widget.icon, color: AppColors.primary, size: 24)),
        ],
      ),
    );
  }
}

class _Petal extends StatelessWidget {
  const _Petal({
    required this.color,
    required this.width,
    required this.height,
  });

  final Color color;
  final double width;
  final double height;

  @override
  Widget build(BuildContext context) {
    return Transform.rotate(
      angle: math.pi / 4,
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(height),
        ),
      ),
    );
  }
}
