import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:meetmax/common/widget/nav_bar.dart';
import 'package:meetmax/fatures/feed/presantation/widget/post_cart.dart';
import '../../auth/data/auth_repository.dart';
import '../data/feed_repository.dart';

class FeedScreen extends ConsumerStatefulWidget {
  const FeedScreen({super.key});
  @override
  ConsumerState<FeedScreen> createState() => _FeedScreenState();
}

class _FeedScreenState extends ConsumerState<FeedScreen> {
  int _tab = 0;

  @override
  Widget build(BuildContext context) {
    final feed = ref.watch(feedProvider);
    return Scaffold(
      appBar: AppBar(
        title: SearchBar(
          hintText: 'Search for something here...',
          leading: const Padding(padding: EdgeInsets.only(left: 8), child: CircleAvatar(child: Icon(Icons.person))),
          trailing: [IconButton(onPressed: (){}, icon: const Icon(Icons.messenger_outline))],
        ),
        actions: [IconButton(onPressed: () => ref.read(authRepositoryProvider).signOut(), icon: const Icon(Icons.logout))],
      ),
      body: feed.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text(e.toString())),
        data: (posts) => RefreshIndicator(
          onRefresh: () => ref.read(feedProvider.notifier).refresh(),
          child: ListView.builder(
            padding: const EdgeInsets.all(12),
            itemCount: posts.length + 1,
            itemBuilder: (_, i) {
              if (i == 0) {
                return Card(
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                      TextField(
                        minLines: 3, maxLines: 5,
                        decoration: const InputDecoration(
                          hintText: 'What’s happening?',
                          border: InputBorder.none,
                          filled: true, fillColor: Color(0xFFF5F7FA),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Row(children: const [
                        Icon(Icons.videocam_outlined), SizedBox(width: 8), Text('Live Video'),
                        SizedBox(width: 18),
                        Icon(Icons.photo_outlined), SizedBox(width: 8), Text('Photo/Video'),
                        SizedBox(width: 18),
                        Icon(Icons.sentiment_satisfied_alt_outlined), SizedBox(width: 8), Text('Feeling'),
                      ]),
                      const SizedBox(height: 12),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(onPressed: () => ref.read(feedProvider.notifier).createPost('New post'), child: const Text('Post')),
                      ),
                    ]),
                  ),
                );
              }
              final p = posts[i - 1];
              return PostCard(
                post: p,
                onLike: () => ref.read(feedProvider.notifier).toggleLike(p.id),
                onComment: () => ref.read(feedProvider.notifier).addComment(p.id, 'Nice!'),
              );
            },
          ),
        ),
      ),
      bottomNavigationBar: AppNavBar(index: _tab, onTap: (i) => setState(() => _tab = i)),
    );
  }
}
