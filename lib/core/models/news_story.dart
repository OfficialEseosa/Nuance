class NewsStory {
  const NewsStory({
    required this.id,
    required this.source,
    required this.leaning,
    required this.title,
    required this.summary,
    required this.url,
    required this.publishedAt,
    required this.category,
    required this.credibilityScore,
  });

  final String id;
  final String source;
  final String leaning;
  final String title;
  final String summary;
  final String url;
  final DateTime publishedAt;
  final String category;
  final int credibilityScore;
}
