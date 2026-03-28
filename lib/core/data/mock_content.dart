import 'package:nuance/core/models/nuance_models.dart';

const String kDailyFocus =
    'Track how three outlets frame the same climate policy vote.';

const List<LessonMission> kCampaignMissions = [
  LessonMission(
    id: 'm1',
    title: 'Headline Heat Check',
    summary: 'Spot emotion-loaded wording and classify its framing style.',
    status: MissionStatus.completed,
    xpReward: 20,
    minutes: 4,
  ),
  LessonMission(
    id: 'm2',
    title: 'Perspective Triangulation',
    summary: 'Compare left, center, and right takes on one breaking story.',
    status: MissionStatus.completed,
    xpReward: 30,
    minutes: 6,
  ),
  LessonMission(
    id: 'm3',
    title: 'Missing Context Hunt',
    summary: 'Find key context omitted across two headlines.',
    status: MissionStatus.active,
    xpReward: 35,
    minutes: 7,
  ),
  LessonMission(
    id: 'm4',
    title: 'Source Ownership Radar',
    summary: 'Investigate who owns each source and what influence that adds.',
    status: MissionStatus.locked,
    xpReward: 45,
    minutes: 9,
  ),
  LessonMission(
    id: 'm5',
    title: 'Nuance Boss Round',
    summary: 'Synthesize coverage into a neutral, evidence-led recap.',
    status: MissionStatus.locked,
    xpReward: 60,
    minutes: 10,
  ),
];

const List<StoryPerspective> kStoryPerspectives = [
  StoryPerspective(
    source: 'Metro Ledger',
    leaning: 'Center-Left',
    headline: 'Climate package framed as overdue relief for urban families',
    framingNote:
        'Focuses on cost savings and pollution burden in dense cities.',
    credibilityScore: 84,
  ),
  StoryPerspective(
    source: 'National Wire',
    leaning: 'Center',
    headline: 'Senate passes climate package after narrow bipartisan deal',
    framingNote: 'Highlights voting margins, budget impacts, and timeline.',
    credibilityScore: 91,
  ),
  StoryPerspective(
    source: 'Frontier Post',
    leaning: 'Center-Right',
    headline: 'Climate package criticized as expensive mandate on industries',
    framingNote: 'Emphasizes compliance costs and regional economic concerns.',
    credibilityScore: 79,
  ),
];

const List<FrameSignal> kFrameSignals = [
  FrameSignal(label: 'Emotion-Led Language', value: 0.62),
  FrameSignal(label: 'Policy Detail Depth', value: 0.78),
  FrameSignal(label: 'Economic Impact Focus', value: 0.55),
  FrameSignal(label: 'Social Impact Focus', value: 0.69),
  FrameSignal(label: 'Quoted Sources Diversity', value: 0.41),
];

const List<ChallengeModule> kChallengeModules = [
  ChallengeModule(
    title: 'Bias Blitz',
    description: 'Classify 10 headlines by framing in under 90 seconds.',
    difficulty: 'Fast',
    duration: '2 min',
    xpReward: 40,
  ),
  ChallengeModule(
    title: 'Context Rescue',
    description: 'Pick the strongest missing context statement.',
    difficulty: 'Medium',
    duration: '5 min',
    xpReward: 55,
  ),
  ChallengeModule(
    title: 'Source Showdown',
    description: 'Rank sources by evidence quality and transparency.',
    difficulty: 'Hard',
    duration: '7 min',
    xpReward: 70,
  ),
];

const List<BadgeProgress> kBadges = [
  BadgeProgress(
    name: 'Frame Finder',
    description: 'Detected 25 framing tactics',
    unlocked: true,
  ),
  BadgeProgress(
    name: 'Cross-Check',
    description: 'Compared 15 stories across 3+ sources',
    unlocked: true,
  ),
  BadgeProgress(
    name: 'Neutral Narrator',
    description: 'Rewrote 10 headlines with neutral wording',
    unlocked: false,
  ),
  BadgeProgress(
    name: 'Evidence Scout',
    description: 'Flagged unsupported claims in 20 stories',
    unlocked: false,
  ),
];
