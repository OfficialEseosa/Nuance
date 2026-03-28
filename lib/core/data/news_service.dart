import 'dart:async';

import 'package:http/http.dart' as http;
import 'package:nuance/core/models/news_story.dart';
import 'package:xml/xml.dart';

class NewsService {
  NewsService({http.Client? client}) : _client = client ?? http.Client();

  final http.Client _client;

  static final List<_FeedConfig> _feeds = [
    _FeedConfig(
      source: 'BBC',
      leaning: 'Center',
      url: 'https://feeds.bbci.co.uk/news/world/rss.xml',
      credibilityScore: 91,
    ),
    _FeedConfig(
      source: 'NPR',
      leaning: 'Center-Left',
      url: 'https://feeds.npr.org/1004/rss.xml',
      credibilityScore: 89,
    ),
    _FeedConfig(
      source: 'The Guardian',
      leaning: 'Center-Left',
      url: 'https://www.theguardian.com/world/rss',
      credibilityScore: 86,
    ),
    _FeedConfig(
      source: 'NYTimes',
      leaning: 'Center-Left',
      url: 'https://rss.nytimes.com/services/xml/rss/nyt/World.xml',
      credibilityScore: 88,
    ),
  ];

  Future<List<NewsStory>> fetchLatestStories({int limit = 24}) async {
    final feedResults = await Future.wait(
      _feeds.map(_fetchStoriesFromFeed),
      eagerError: false,
    );

    final stories = feedResults.expand((stories) => stories).toList()
      ..sort((a, b) => b.publishedAt.compareTo(a.publishedAt));

    return stories.take(limit).toList(growable: false);
  }

  Future<List<NewsStory>> _fetchStoriesFromFeed(_FeedConfig feed) async {
    try {
      final response = await _client
          .get(
            Uri.parse(feed.url),
            headers: const {'User-Agent': 'Nuance/1.0 (+https://github.com)'},
          )
          .timeout(const Duration(seconds: 8));

      if (response.statusCode != 200 || response.body.trim().isEmpty) {
        return const [];
      }

      final document = XmlDocument.parse(response.body);
      final items = document.findAllElements('item');

      return items
          .take(12)
          .map((item) => _toNewsStory(item, feed))
          .whereType<NewsStory>()
          .toList(growable: false);
    } catch (_) {
      return const [];
    }
  }

  NewsStory? _toNewsStory(XmlElement item, _FeedConfig feed) {
    final title = _cleanText(_elementText(item, 'title'));
    final summary = _cleanText(_elementText(item, 'description'));
    final link = _cleanText(_elementText(item, 'link'));
    final pubDateRaw = _elementText(item, 'pubDate');

    if (title.isEmpty || link.isEmpty) return null;

    final publishedAt =
        _parsePublishedDate(pubDateRaw) ?? DateTime.now().toUtc();

    final category = _inferCategory('$title $summary');
    final id = '${feed.source}_${_normalizeKey(link)}';

    return NewsStory(
      id: id,
      source: feed.source,
      leaning: feed.leaning,
      title: title,
      summary: summary.isEmpty
          ? 'Tap to compare framing across sources.'
          : summary,
      url: link,
      publishedAt: publishedAt,
      category: category,
      credibilityScore: feed.credibilityScore,
    );
  }

  String _elementText(XmlElement parent, String name) {
    final node = parent.getElement(name);
    if (node == null) return '';
    return node.innerText.trim();
  }

  String _cleanText(String value) {
    if (value.isEmpty) return value;

    var text = value
        .replaceAll(RegExp(r'<[^>]*>'), ' ')
        .replaceAll('&nbsp;', ' ')
        .replaceAll('&amp;', '&')
        .replaceAll('&quot;', '"')
        .replaceAll('&#39;', "'")
        .replaceAll('&lt;', '<')
        .replaceAll('&gt;', '>')
        .replaceAll(RegExp(r'\s+'), ' ')
        .trim();

    if (text.length > 220) {
      text = '${text.substring(0, 217)}...';
    }
    return text;
  }

  String _inferCategory(String text) {
    final lower = text.toLowerCase();
    if (lower.contains('election') ||
        lower.contains('senate') ||
        lower.contains('president') ||
        lower.contains('congress') ||
        lower.contains('parliament')) {
      return 'Politics';
    }
    if (lower.contains('climate') ||
        lower.contains('emissions') ||
        lower.contains('wildfire') ||
        lower.contains('hurricane') ||
        lower.contains('energy')) {
      return 'Climate';
    }
    if (lower.contains('market') ||
        lower.contains('inflation') ||
        lower.contains('economy') ||
        lower.contains('tariff') ||
        lower.contains('trade')) {
      return 'Business';
    }
    if (lower.contains('ai') ||
        lower.contains('technology') ||
        lower.contains('cyber') ||
        lower.contains('chip')) {
      return 'Tech';
    }
    return 'World';
  }

  String _normalizeKey(String text) {
    return text.toLowerCase().replaceAll(RegExp(r'[^a-z0-9]+'), '_');
  }

  DateTime? _parsePublishedDate(String value) {
    if (value.trim().isEmpty) return null;

    final isoParsed = DateTime.tryParse(value);
    if (isoParsed != null) return isoParsed.toUtc();

    final regex = RegExp(
      r'^\w{3},\s(\d{1,2})\s(\w{3})\s(\d{4})\s(\d{2}):(\d{2}):(\d{2})',
    );
    final match = regex.firstMatch(value.trim());
    if (match == null) return null;

    final monthMap = <String, int>{
      'jan': 1,
      'feb': 2,
      'mar': 3,
      'apr': 4,
      'may': 5,
      'jun': 6,
      'jul': 7,
      'aug': 8,
      'sep': 9,
      'oct': 10,
      'nov': 11,
      'dec': 12,
    };

    final day = int.tryParse(match.group(1)!);
    final month = monthMap[match.group(2)!.toLowerCase()];
    final year = int.tryParse(match.group(3)!);
    final hour = int.tryParse(match.group(4)!);
    final minute = int.tryParse(match.group(5)!);
    final second = int.tryParse(match.group(6)!);

    if ([day, month, year, hour, minute, second].contains(null)) {
      return null;
    }

    return DateTime.utc(year!, month!, day!, hour!, minute!, second!);
  }
}

class _FeedConfig {
  const _FeedConfig({
    required this.source,
    required this.leaning,
    required this.url,
    required this.credibilityScore,
  });

  final String source;
  final String leaning;
  final String url;
  final int credibilityScore;
}
