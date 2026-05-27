class PostModel {
  final String id;
  final String authorName;
  final String text;
  final String tag;
  final Map<String, int> reactions;
  final int comments;
  final String category;
  final DateTime createdAt;

  PostModel({
    required this.id,
    required this.authorName,
    required this.text,
    required this.tag,
    required this.reactions,
    required this.comments,
    required this.category,
    required this.createdAt,
  });
}
