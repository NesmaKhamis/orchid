/// The 6 core feelings for child emotional check-in.
///
/// Orchid face images are not available yet (sad / happy / worried / shy and others).
/// Until the designer's final files are added, large emojis are used on pastel cards.
/// // TODO: replace emoji with orchid face asset
enum Feeling {
  happy('سعيد', '😊'),
  sad('حزين', '😢'),
  worried('قلقان', '😟'),
  shy('خجول', '🫣'),
  angry('غاضب', '😡'),
  tired('متعب', '🥱');

  const Feeling(this.label, this.emoji);

  final String label;
  final String emoji;
}

/// The phase of mood check-in.
enum MoodPhase {
  before,
  after,
}

extension FeelingX on Feeling {
  static Feeling fromString(String? value) {
    return Feeling.values.firstWhere(
      (f) => f.name == value,
      orElse: () => Feeling.happy,
    );
  }
}

extension MoodPhaseX on MoodPhase {
  static MoodPhase fromString(String? value) {
    return MoodPhase.values.firstWhere(
      (p) => p.name == value,
      orElse: () => MoodPhase.before,
    );
  }
}
