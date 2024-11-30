import 'package:jl_team_front_bit/model/post.dart';

class Community {
  int id;
  String name;
  List<Post> posts;

  Community({required this.id, required this.name, required this.posts});

  factory Community.fromJson(Map<String, dynamic> json) {
    return Community(
      id: json['id'],
      name: json['name'],
      posts: (json['posts'] as List).map((p) => Post.fromJson(p)).toList(),
    );
  }
}
