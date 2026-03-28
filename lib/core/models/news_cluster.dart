import 'package:nuance/core/models/news_story.dart';

class NewsCluster {
  NewsCluster({
    required this.id,
    required this.topicTitle,
    required this.category,
    required this.stories,
    required this.topicTokens,
    this.isSynthesized = false,
  });

  final String id;
  final String topicTitle;
  final String category;
  final List<NewsStory> stories;
  final Set<String> topicTokens;
  final bool isSynthesized;

  NewsStory get primaryStory => stories.first;

  DateTime get latestPublishedAt =>
      stories.map((s) => s.publishedAt).reduce((a, b) => a.isAfter(b) ? a : b);

  Set<String> get sources => stories.map((s) => s.source).toSet();
}
