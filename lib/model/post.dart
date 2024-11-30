import 'comment.dart';

class Post {
  int id;
  String title;
  String content;
  String author;
  DateTime timestamp;
  List<Comment> comments;

  Post({
    required this.id,
    required this.title,
    required this.content,
    required this.author,
    required this.timestamp,
    required this.comments,
  });

  factory Post.fromJson(Map<String, dynamic> json) {
    return Post(
      id: json['id'],
      title: json['title'],
      content: json['content'],
      author: json['author'],
      timestamp: DateTime.parse(json['timestamp']),
      comments: (json['comments'] as List)
          .map((c) => Comment.fromJson(c))
          .toList(),
    );
  }
}
