import 'feeling.dart';

/// Arguments passed when navigating to the feelings check-in screen.
class FeelingsArgs {
  const FeelingsArgs({
    this.phase = MoodPhase.before,
    this.activityId,
    this.previousFeeling,
  });

  final MoodPhase phase;
  final String? activityId;
  final Feeling? previousFeeling;
}
