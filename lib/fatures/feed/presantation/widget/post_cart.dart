import 'dart:io';
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

    Widget? _postImage() {
      final src = post.imageUrl;
      if (src == null || src.isEmpty) return null;
      final isHttp = src.startsWith('http');
      final img = isHttp ? Image.network(src, fit: BoxFit.cover) : Image.file(File(src), fit: BoxFit.cover);
      return ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: AspectRatio(aspectRatio: 4 / 3, child: img),
      );
    }

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Row(
            children: [
              CircleAvatar(backgroundImage: NetworkImage(post.avatarUrl)),
              const SizedBox(width: 8),
              Expanded(
                child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text(post.author, style: t.titleMedium),
                  Text('Public · 15h', style: t.bodySmall),
                ]),
              ),
              IconButton(onPressed: () {}, icon: const Icon(Icons.more_horiz)),
            ],
          ),
          const SizedBox(height: 8),
          if (post.text.isNotEmpty) Text(post.text),
          const SizedBox(height: 8),
          if (_postImage() != null) _postImage()!,
          const SizedBox(height: 6),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(children: [
                const Icon(Icons.thumb_up_alt, size: 16),
                const SizedBox(width: 6),
                Text('${post.likes}'),
              ]),
              Text('${post.comments.length} Comments   17 Share', style: t.bodySmall),
            ],
          ),
          const Divider(height: 18),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              TextButton.icon(onPressed: onLike, icon: Icon(post.likedByMe ? Icons.favorite : Icons.favorite_border), label: const Text('Like')),
              TextButton.icon(onPressed: onComment, icon: const Icon(Icons.mode_comment_outlined), label: Text('Comments (${post.comments.length})')),
              TextButton.icon(onPressed: () {}, icon: const Icon(Icons.share_outlined), label: const Text('Share')),
            ],
          ),
          const SizedBox(height: 6),
          Row(
            children: [
              const CircleAvatar(radius: 16, backgroundImage: NetworkImage('https://i.pravatar.cc/150?img=1')),
              const SizedBox(width: 8),
              Expanded(
                child: TextField(
                  decoration: InputDecoration(
                    hintText: 'Write a comment...',
                    filled: true, fillColor: const Color(0xFFF5F7FA),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                    border: OutlineInputBorder(
                      borderSide: BorderSide.none,
                      borderRadius: BorderRadius.circular(24),
                    ),
                  ),
                ),
              ),
              IconButton(onPressed: () {}, icon: const Icon(Icons.image_outlined)),
              IconButton(onPressed: () {}, icon: const Icon(Icons.gif_box_outlined)),
              IconButton(onPressed: () {}, icon: const Icon(Icons.send)),
            ],
          ),
        ]),
      ),
    );
  }
}
