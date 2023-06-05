class Post {
  final String title;
  final String content;
  final String creator;
  final DateTime createdAt;
  final List? comments;

  Post({
    required this.title,
    required this.content,
    required this.creator,
    required this.createdAt,
    this.comments
  });
}
