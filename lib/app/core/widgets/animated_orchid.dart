import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../constants/app_assets.dart';

/// Animated orchid hero used by the splash and onboarding screens.
class AnimatedOrchid extends StatefulWidget {
  const AnimatedOrchid({
    super.key,
    this.size = 240,
    this.autoStart = true,
  });

  final double size;
  final bool autoStart;

  @override
  State<AnimatedOrchid> createState() => _AnimatedOrchidState();
}

class _AnimatedOrchidState extends State<AnimatedOrchid> {
  Timer? _winkTimer;
  bool _isWinking = false;

  @override
  void initState() {
    super.initState();
    if (widget.autoStart) {
      _startWinkAnimation();
    }
  }

  void _startWinkAnimation() {
    _winkTimer = Timer.periodic(const Duration(seconds: 2), (timer) async {
      if (!mounted) return;
      setState(() => _isWinking = true);

      await Future<void>.delayed(const Duration(milliseconds: 350));

      if (!mounted) return;
      setState(() => _isWinking = false);
    });
  }

  @override
  void dispose() {
    _winkTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: widget.size,
      height: widget.size,
      child: AnimatedCrossFade(
        duration: const Duration(milliseconds: 140),
        crossFadeState: _isWinking
            ? CrossFadeState.showSecond
            : CrossFadeState.showFirst,
        firstChild: Image.asset(AppAssets.orchidOpen),
        secondChild: Image.asset(AppAssets.orchidWink),
      ),
    )
        .animate(onPlay: (controller) => controller.repeat(reverse: true))
        .shake(
          duration: 3000.ms,
          hz: 0.5,
          offset: const Offset(0, 8),
        )
        .rotate(duration: 4000.ms, begin: -0.02, end: 0.02);
  }
}
