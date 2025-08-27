import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/di.dart';
import 'mock_feed_api.dart';

class FeedRepository extends StateNotifier<AsyncValue<List<Post>>> {
  FeedRepository(this._api) : super(const AsyncValue.loading()) { refresh(); }
  final MockFeedApi _api;

  Future<void> refresh() async => state = AsyncValue.data(await _api.fetch());
  Future<void> toggleLike(String id) async { await _api.like(id); await refresh(); }
  Future<void> addComment(String id, String text) async { await _api.comment(id, text); await refresh(); }

  // UPDATED: accept optional image path/url
  Future<void> createPost(String text, {String? imageUrl}) async {
    await _api.create(text, imageUrl: imageUrl);
    await refresh();
  }
}

final feedProvider = StateNotifierProvider<FeedRepository, AsyncValue<List<Post>>>(
  (_) => FeedRepository(sl<MockFeedApi>()),
);
