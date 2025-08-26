import 'package:flutter/material.dart';
import '../../data/mock_feed_api.dart';

class PostCard extends StatelessWidget {
  const PostCard({super.key, required this.post, required this.onLike, required this.onComment});
  final Post post;
  final VoidCallback onLike;
  final VoidCallback onComment;

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context).textTheme;
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          ListTile(
            contentPadding: EdgeInsets.zero,
            leading: CircleAvatar(backgroundImage: NetworkImage(post.avatarUrl)),
            title: Text(post.author, style: t.titleMedium),
            subtitle: const Text('Just now'),
            trailing: const Icon(Icons.more_horiz),
          ),
          const SizedBox(height: 8),
          Text(post.text, style: t.bodyLarge),
          if (post.imageUrl != null) ...[
            const SizedBox(height: 12),
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.network(post.imageUrl!, height: 220, width: double.infinity, fit: BoxFit.cover),
            ),
          ],
          const SizedBox(height: 8),
          Row(children: [
            IconButton(
              onPressed: onLike,
              icon: Icon(post.likedByMe ? Icons.favorite : Icons.favorite_border),
            ),
            Text('${post.likes}'),
            const SizedBox(width: 16),
            TextButton.icon(onPressed: onComment, icon: const Icon(Icons.mode_comment_outlined), label: Text('Comment (${post.comments.length})')),
          ]),
        ]),
      ),
    );
  }
}
