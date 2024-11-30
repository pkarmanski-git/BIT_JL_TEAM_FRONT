import 'package:flutter/material.dart';
import '/model/comment.dart';
import '/model/comunity.dart';
import '/model/post.dart';
import '../constants/colors.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'AddPostScreen.dart';
import 'PostDetailScreen.dart';


class CommunityPostsScreen extends StatefulWidget {
  final Community community;

  const CommunityPostsScreen({required this.community, super.key});

  @override
  _CommunityPostsScreenState createState() => _CommunityPostsScreenState();
}

class _CommunityPostsScreenState extends State<CommunityPostsScreen> {
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadPosts();
  }

  void _loadPosts() async {
    // TODO: Fetch posts for the community from backend
    // For now, we'll use mock data
    setState(() {
      widget.community.posts = [
        Post(
          id: 1,
          title: 'Welcome to ${widget.community.name}',
          content: 'This is the first post in ${widget.community.name}!',
          author: 'Admin',
          timestamp: DateTime.now(),
          comments: [],
        ),
      ];
      isLoading = false;
    });
  }

  void _addPost() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AddPostScreen(community: widget.community),
      ),
    ).then((_) {
      _loadPosts(); // Refresh posts after adding a new one
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.community.name),
        backgroundColor: AppColors.primaryColor,
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : widget.community.posts.isEmpty
          ? const Center(child: Text('No posts yet.'))
          : ListView.builder(
        itemCount: widget.community.posts.length,
        itemBuilder: (context, index) {
          final post = widget.community.posts[index];
          return ListTile(
            title: Text(post.title),
            subtitle: Text('By ${post.author}'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => PostDetailScreen(post: post),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addPost,
        child: const Icon(Icons.add),
        backgroundColor: AppColors.primaryColor,
      ),
    );
  }
}
