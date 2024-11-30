import 'package:flutter/material.dart';
import '/model/comment.dart';
import '/model/community.dart';
import '/model/post.dart';
import '../constants/colors.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'EditCommentScreen.dart';
import 'EditPostScreen.dart';

class PostDetailScreen extends StatefulWidget {
  final Post post;

  const PostDetailScreen({required this.post, super.key});

  @override
  _PostDetailScreenState createState() => _PostDetailScreenState();
}
class _PostDetailScreenState extends State<PostDetailScreen> {
  final _commentController = TextEditingController();

  void _addComment() {
    if (_commentController.text.isNotEmpty) {
      setState(() {
        widget.post.comments.add(
          Comment(
            id: widget.post.comments.length + 1,
            content: _commentController.text,
            author: 'You',
            timestamp: DateTime.now(),
          ),
        );
        _commentController.clear();
      });
      // TODO: Send comment to backend
    }
  }

  void _editPost() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EditPostScreen(post: widget.post),
      ),
    ).then((result) {
      if (result == 'deleted') {
        Navigator.pop(context); // Go back if post was deleted
      } else {
        setState(() {}); // Refresh the post details
      }
    });
  }


  void _editComment(Comment comment) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EditCommentScreen(comment: comment),
      ),
    ).then((result) {
      if (result == 'deleted') {
        setState(() {
          widget.post.comments.remove(comment);
        });
      } else {
        setState(() {}); // Refresh the comments
      }
    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.post.title),
        backgroundColor: AppColors.primaryColor,
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: _editPost,
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text(
              widget.post.content,
              style: const TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 20),
            const Divider(),
            const Text(
              'Comments',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            Expanded(
              child: widget.post.comments.isEmpty
                  ? const Center(child: Text('No comments yet.'))
                  : ListView.builder(
                itemCount: widget.post.comments.length,
                itemBuilder: (context, index) {
                  final comment = widget.post.comments[index];
                  return ListTile(
                    title: Text(comment.content),
                    subtitle: Text(
                        'By ${comment.author} at ${comment.timestamp}'),
                    trailing: comment.author == 'You'
                        ? IconButton(
                      icon: const Icon(Icons.edit),
                      onPressed: () => _editComment(comment),
                    )
                        : null,
                  );
                },
              ),
            ),
            const Divider(),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _commentController,
                    decoration:
                    const InputDecoration(hintText: 'Add a comment...'),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.send),
                  onPressed: _addComment,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
