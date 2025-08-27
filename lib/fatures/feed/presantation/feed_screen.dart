import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:meetmax/common/widget/nav_bar.dart';
import 'package:meetmax/fatures/feed/presantation/create_post_screen.dart';
import 'package:meetmax/fatures/feed/presantation/widget/post_cart.dart';
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
    final postsState = ref.watch(feedProvider);

    return Scaffold(
      backgroundColor: const Color(0xFFF3F6FA),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        toolbarHeight: 64,
        titleSpacing: 0,
        title: Padding(
          padding: const EdgeInsets.only(right: 12),
          child: Row(
            children: [
              const CircleAvatar(
                radius: 16,
                backgroundImage: NetworkImage('https://i.pravatar.cc/150?img=1'),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxHeight: 36),
                  child: TextField(
                    textAlignVertical: TextAlignVertical.center,
                    decoration: InputDecoration(
                      isDense: true,
                      hintText: 'Search for something here...',
                      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      prefixIcon: const Icon(Icons.search, size: 20),
                      filled: true,
                      fillColor: const Color(0xFFF5F7FA),
                      border: OutlineInputBorder(
                        borderSide: BorderSide.none,
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      body: postsState.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Error: $e')),
        data: (posts) => RefreshIndicator(
          onRefresh: () => ref.read(feedProvider.notifier).refresh(),
          child: ListView.builder(
            padding: const EdgeInsets.all(12),
            // stories + composer + recent events + posts + birthdays + spacer
            itemCount: 3 + posts.length + 2,
            itemBuilder: (context, index) {
              // 0: stories row
              if (index == 0) return const _StoriesRow();

              // 1: composer (taps to CreatePostScreen)
              if (index == 1) {
                return _Composer(
                  onPost: (text, {String? imagePath}) => ref
                      .read(feedProvider.notifier)
                      .createPost(text, imageUrl: imagePath),
                );
              }

              // 2: recent events
              if (index == 2) return const _RecentEvents();

              // posts
              final postsStart = 3;
              final postsEnd = postsStart + posts.length;

              // after posts: birthdays + spacer
              if (index >= postsEnd) {
                if (index == postsEnd) return const _BirthdaysSection();
                return const SizedBox(height: 80);
              }

              final p = posts[index - postsStart];
              return PostCard(
                post: p,
                onLike: () => ref.read(feedProvider.notifier).toggleLike(p.id),
                onComment: () =>
                    ref.read(feedProvider.notifier).addComment(p.id, 'Nice!'),
              );
            },
          ),
        ),
      ),
      bottomNavigationBar:
          AppNavBar(index: _tab, onTap: (i) => setState(() => _tab = i)),
    );
  }
}

class _StoriesRow extends StatelessWidget {
  const _StoriesRow();

  @override
  Widget build(BuildContext context) {
    final people =
        List.generate(10, (i) => 'https://i.pravatar.cc/150?img=${i + 2}');
    return SizedBox(
      height: 120,
      child: Card(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: people.length + 1,
            separatorBuilder: (_, __) => const SizedBox(width: 12),
            itemBuilder: (context, i) {
              if (i == 0) {
                return _StoryAvatar(
                  imageUrl: people.first,
                  label: 'You',
                  showAdd: true,
                );
              }
              return _StoryAvatar(imageUrl: people[i - 1], label: 'Friend $i');
            },
          ),
        ),
      ),
    );
  }
}

class _StoryAvatar extends StatelessWidget {
  const _StoryAvatar({
    required this.imageUrl,
    required this.label,
    this.showAdd = false,
  });
  final String imageUrl;
  final String label;
  final bool showAdd;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Stack(
          children: [
            const CircleAvatar(radius: 28),
            CircleAvatar(radius: 28, backgroundImage: NetworkImage(imageUrl)),
            if (showAdd)
              Positioned(
                right: -2,
                bottom: -2,
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.blue,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  padding: const EdgeInsets.all(2),
                  child: const Icon(Icons.add, size: 16, color: Colors.white),
                ),
              ),
          ],
        ),
        const SizedBox(height: 6),
        SizedBox(
          width: 70,
          child: Text(
            label,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 12),
          ),
        ),
      ],
    );
  }
}

class _Composer extends StatelessWidget {
  const _Composer({required this.onPost});
  final void Function(String text, {String? imagePath}) onPost;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        leading: const CircleAvatar(
          backgroundImage: NetworkImage('https://i.pravatar.cc/150?img=1'),
        ),
        title: const Text("What's happening?"),
        onTap: () async {
          final result = await Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const CreatePostScreen()),
          );
          if (result is Map) {
            final text = (result['text'] as String?)?.trim() ?? '';
            final imagePath = result['imagePath'] as String?;
            if (text.isNotEmpty || (imagePath != null && imagePath.isNotEmpty)) {
              onPost(text, imagePath: imagePath);
            }
          }
        },
      ),
    );
  }
}

class _RecentEvents extends StatelessWidget {
  const _RecentEvents();

  @override
  Widget build(BuildContext context) {
    Widget item(IconData icon, String title, String subtitle, String seen) {
      return Card(
        child: ListTile(
          leading: CircleAvatar(child: Icon(icon)),
          title: Text(title, style: const TextStyle(fontWeight: FontWeight.w600)),
          subtitle:
              Text(subtitle, maxLines: 2, overflow: TextOverflow.ellipsis),
          trailing: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [
              Text('8 seen', style: TextStyle(fontSize: 12)),
              SizedBox(height: 2),
              CircleAvatar(
                radius: 10,
                backgroundImage: NetworkImage('https://i.pravatar.cc/150?img=7'),
              ),
            ],
          ),
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: const [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 4, vertical: 8),
              child: Text('Recent Event',
                  style: TextStyle(fontWeight: FontWeight.w700)),
            ),
            Icon(Icons.more_horiz),
          ],
        ),
        item(Icons.school, 'Graduation Ceremony',
            'The graduation ceremony is also sometimes called...', '8 seen'),
        item(Icons.camera_alt, 'Photography Ideas',
            'Reflections. Reflections work because they can create...',
            '11 seen'),
      ],
    );
  }
}

class _BirthdaysSection extends StatelessWidget {
  const _BirthdaysSection();

  @override
  Widget build(BuildContext context) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: const [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 4, vertical: 8),
            child: Text('Birthdays',
                style: TextStyle(fontWeight: FontWeight.w700)),
          ),
          Text('See All'),
        ],
      ),
      Card(
        child: ListTile(
          leading: const CircleAvatar(
            backgroundImage: NetworkImage('https://i.pravatar.cc/150?img=12'),
          ),
          title: const Text('Edilson De Carvalho'),
          subtitle: const Text('Birthday today'),
          trailing:
              IconButton(onPressed: () {}, icon: const Icon(Icons.send)),
        ),
      ),
      Card(
        child: ListTile(
          leading: const Icon(Icons.cake_outlined),
          title: const Text('Upcoming birthdays'),
          subtitle: const Text('See 12 others have upcoming birthdays'),
          onTap: () {},
        ),
      ),
    ]);
  }
}
