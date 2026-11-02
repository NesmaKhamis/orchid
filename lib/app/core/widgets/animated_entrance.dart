import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

/// Extension/wrapper over flutter_animate for fade+slide entrance.
class AnimatedEntrance extends StatelessWidget {
  const AnimatedEntrance({
    super.key,
    required this.child,
    this.delay = Duration.zero,
    this.duration = const Duration(milliseconds: 400),
    this.offset = const Offset(0, 20),
  });

  final Widget child;
  final Duration delay;
  final Duration duration;
  final Offset offset;

  @override
  Widget build(BuildContext context) {
    return child
        .animate(delay: delay)
        .fadeIn(duration: duration)
        .slide(begin: offset, duration: duration);
  }
}

extension AnimatedEntranceExtension on Widget {
  Widget animatedEntrance({
    Duration delay = Duration.zero,
    Duration duration = const Duration(milliseconds: 400),
    Offset offset = const Offset(0, 20),
  }) {
    return AnimatedEntrance(
      delay: delay,
      duration: duration,
      offset: offset,
      child: this,
    );
  }
}
