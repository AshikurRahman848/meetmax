class Post {
  Post({
    required this.id,
    required this.author,
    required this.avatarUrl,
    required this.text,
    required this.imageUrl,
    this.likes = 0,
    this.likedByMe = false,
    this.comments = const [],
  });
  final String id, author, avatarUrl, text;
  final String? imageUrl;
  int likes;
  bool likedByMe;
  List<String> comments;
}

class MockFeedApi {
  final List<Post> _posts = List.generate(6, (i) => Post(
    id: '$i',
    author: 'Alex $i',
    avatarUrl: 'https://i.pravatar.cc/150?img=${(i+4)%70}',
    text: 'Placeholder post #$i — what’s happening?',
    imageUrl: i.isEven ? 'https://picsum.photos/seed/$i/900/600' : null,
    likes: i * 2,
  ));

  Future<List<Post>> fetch() async {
    await Future.delayed(const Duration(milliseconds: 350));
    return List<Post>.from(_posts);
  }

  Future<void> like(String id) async {
    await Future.delayed(const Duration(milliseconds: 120));
    final p = _posts.firstWhere((e) => e.id == id);
    p.likedByMe = !p.likedByMe;
    p.likes += p.likedByMe ? 1 : -1;
  }

  Future<void> comment(String id, String text) async {
    await Future.delayed(const Duration(milliseconds: 160));
    _posts.firstWhere((e) => e.id == id).comments.add(text);
  }

  Future<void> create(String text, {String? imageUrl}) async {
    await Future.delayed(const Duration(milliseconds: 180));
    _posts.insert(0, Post(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      author: 'You',
      avatarUrl: 'https://i.pravatar.cc/150?img=1',
      text: text,
      imageUrl: imageUrl,
    ));
  }
}
