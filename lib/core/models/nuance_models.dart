enum MissionStatus { completed, active, locked }

class LessonMission {
  const LessonMission({
    required this.id,
    required this.title,
    required this.summary,
    required this.status,
    required this.xpReward,
    required this.minutes,
  });

  final String id;
  final String title;
  final String summary;
  final MissionStatus status;
  final int xpReward;
  final int minutes;
}

class StoryPerspective {
  const StoryPerspective({
    required this.source,
    required this.leaning,
    required this.headline,
    required this.framingNote,
    required this.credibilityScore,
  });

  final String source;
  final String leaning;
  final String headline;
  final String framingNote;
  final int credibilityScore;
}

class FrameSignal {
  const FrameSignal({required this.label, required this.value});

  final String label;
  final double value;
}

class ChallengeModule {
  const ChallengeModule({
    required this.title,
    required this.description,
    required this.difficulty,
    required this.duration,
    required this.xpReward,
  });

  final String title;
  final String description;
  final String difficulty;
  final String duration;
  final int xpReward;
}

class BadgeProgress {
  const BadgeProgress({
    required this.name,
    required this.description,
    required this.unlocked,
  });

  final String name;
  final String description;
  final bool unlocked;
}
