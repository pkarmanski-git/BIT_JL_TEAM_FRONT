class Comment {
  int id;
  String content;
  String author;
  DateTime timestamp;

  Comment({
    required this.id,
    required this.content,
    required this.author,
    required this.timestamp,
  });

  factory Comment.fromJson(Map<String, dynamic> json) {
    return Comment(
      id: json['id'],
      content: json['content'],
      author: json['author'],
      timestamp: DateTime.parse(json['timestamp']),
    );
  }
}
