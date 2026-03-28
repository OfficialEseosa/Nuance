import 'package:flutter/material.dart';
import 'package:nuance/core/data/mock_content.dart';
import 'package:nuance/core/data/news_service.dart';
import 'package:nuance/core/models/news_cluster.dart';
import 'package:nuance/core/models/news_story.dart';

class NewsProvider extends ChangeNotifier {
  NewsProvider(this._newsService);

  final NewsService _newsService;

  bool _isLoading = true;
  String? _error;
  DateTime? _lastUpdated;
  List<NewsStory> _stories = const [];
  List<NewsCluster> _clusters = const [];

  bool get isLoading => _isLoading;
  String? get error => _error;
  DateTime? get lastUpdated => _lastUpdated;
  List<NewsStory> get stories => _stories;
  List<NewsCluster> get clusters => _clusters;
  NewsStory? get topStory => _stories.isEmpty ? null : _stories.first;
  NewsCluster? get topCluster => _clusters.isEmpty ? null : _clusters.first;

  Future<void> initialize() async {
    await refreshStories();
  }

  Future<void> refreshStories() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final fetched = await _newsService.fetchLatestStories(limit: 36);
      if (fetched.isNotEmpty) {
        _stories = fetched;
        _clusters = _buildClusters(fetched);
        _lastUpdated = DateTime.now().toUtc();
      } else {
        _stories = _fallbackStories();
        _clusters = _buildClusters(_stories);
        _error = 'Live feeds unavailable. Showing fallback stories.';
      }
    } catch (e) {
      _stories = _fallbackStories();
      _clusters = _buildClusters(_stories);
      _error = 'Unable to fetch live stories: $e';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  NewsCluster? clusterForStory(NewsStory story) {
    for (final cluster in _clusters) {
      if (cluster.stories.any((s) => s.id == story.id)) {
        return cluster;
      }
    }

    final fallbackPeers = _stories
        .where(
          (candidate) =>
              candidate.id != story.id && candidate.category == story.category,
        )
        .toList(growable: false);

    final candidateStories = <NewsStory>[
      story,
      ...fallbackPeers,
    ].take(4).toList(growable: false);
    if (candidateStories.length < 2) return null;

    return NewsCluster(
      id: 'ad_hoc_${story.id}',
      topicTitle: story.title,
      category: story.category,
      stories: candidateStories,
      topicTokens: _topicTokens(story.title, story.summary),
      isSynthesized: true,
    );
  }

  List<NewsCluster> _buildClusters(List<NewsStory> stories) {
    final sortedStories = [...stories]
      ..sort((a, b) => b.publishedAt.compareTo(a.publishedAt));

    final clusters = <NewsCluster>[];
    for (final story in sortedStories) {
      final tokens = _topicTokens(story.title, story.summary);
      final matchIndex = _findClusterIndex(
        clusters: clusters,
        category: story.category,
        tokens: tokens,
      );

      if (matchIndex == -1) {
        clusters.add(
          NewsCluster(
            id: 'cluster_${story.category.toLowerCase()}_${_clusterTokenKey(tokens)}',
            topicTitle: story.title,
            category: story.category,
            stories: [story],
            topicTokens: tokens,
          ),
        );
      } else {
        final cluster = clusters[matchIndex];
        cluster.stories.add(story);
        cluster.topicTokens.addAll(tokens);
      }
    }

    for (final cluster in clusters) {
      cluster.stories.sort((a, b) => b.publishedAt.compareTo(a.publishedAt));
      if (cluster.stories.length > 4) {
        cluster.stories.removeRange(4, cluster.stories.length);
      }
    }

    final sourceRichClusters = clusters
        .where((cluster) => cluster.sources.length >= 2)
        .toList(growable: false);
    final result = sourceRichClusters.isNotEmpty
        ? sourceRichClusters
        : _synthesizeClusters(sortedStories);

    result.sort((a, b) {
      final sourceDiff = b.sources.length.compareTo(a.sources.length);
      if (sourceDiff != 0) return sourceDiff;
      return b.latestPublishedAt.compareTo(a.latestPublishedAt);
    });
    return result;
  }

  int _findClusterIndex({
    required List<NewsCluster> clusters,
    required String category,
    required Set<String> tokens,
  }) {
    var bestIndex = -1;
    var bestScore = 0;

    for (var i = 0; i < clusters.length; i++) {
      final cluster = clusters[i];
      if (cluster.category != category) continue;

      final overlap = cluster.topicTokens.intersection(tokens).length;
      if (overlap > bestScore && overlap >= 2) {
        bestIndex = i;
        bestScore = overlap;
      }
    }
    return bestIndex;
  }

  List<NewsCluster> _synthesizeClusters(List<NewsStory> stories) {
    final byCategory = <String, List<NewsStory>>{};
    for (final story in stories) {
      byCategory.putIfAbsent(story.category, () => <NewsStory>[]).add(story);
    }

    final synthesized = <NewsCluster>[];
    for (final entry in byCategory.entries) {
      final distinctBySource = <String, NewsStory>{};
      for (final story in entry.value) {
        distinctBySource.putIfAbsent(story.source, () => story);
      }
      final group = distinctBySource.values.take(4).toList(growable: false);
      if (group.length < 2) continue;

      final topicTokens = <String>{};
      for (final item in group) {
        topicTokens.addAll(_topicTokens(item.title, item.summary));
      }

      synthesized.add(
        NewsCluster(
          id: 'synth_${entry.key.toLowerCase()}_${synthesized.length}',
          topicTitle: group.first.title,
          category: entry.key,
          stories: [...group],
          topicTokens: topicTokens,
          isSynthesized: true,
        ),
      );
    }

    return synthesized;
  }

  Set<String> _topicTokens(String title, String summary) {
    const stopWords = {
      'the',
      'a',
      'an',
      'and',
      'or',
      'to',
      'of',
      'in',
      'on',
      'for',
      'with',
      'after',
      'before',
      'from',
      'into',
      'over',
      'under',
      'at',
      'is',
      'are',
      'was',
      'were',
      'be',
      'as',
      'that',
      'this',
      'it',
      'its',
      'by',
      'new',
      'latest',
      'live',
      'says',
      'say',
      'amid',
      'about',
      'up',
      'out',
      'more',
      'than',
      'their',
      'his',
      'her',
      'our',
      'your',
      'they',
      'them',
    };

    final tokens = <String>{};
    final merged = '$title $summary'.toLowerCase();
    for (final token in merged.split(RegExp(r'[^a-z0-9]+'))) {
      if (token.length < 4) continue;
      if (stopWords.contains(token)) continue;
      tokens.add(token);
      if (tokens.length >= 12) break;
    }
    return tokens;
  }

  String _clusterTokenKey(Set<String> tokens) {
    if (tokens.isEmpty) return 'general';
    final sorted = [...tokens]..sort();
    return sorted.take(4).join('_');
  }

  List<NewsStory> _fallbackStories() {
    final now = DateTime.now().toUtc();
    return List.generate(kStoryPerspectives.length, (index) {
      final item = kStoryPerspectives[index];
      return NewsStory(
        id: 'fallback_$index',
        source: item.source,
        leaning: item.leaning,
        title: item.headline,
        summary: item.framingNote,
        url: 'https://example.com/story/$index',
        publishedAt: now.subtract(Duration(hours: index)),
        category: 'World',
        credibilityScore: item.credibilityScore,
      );
    });
  }
}
