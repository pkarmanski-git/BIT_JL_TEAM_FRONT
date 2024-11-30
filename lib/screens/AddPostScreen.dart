import 'package:flutter/material.dart';
import '/model/comment.dart';
import '/model/community.dart';
import '/model/post.dart';
import '../constants/colors.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';


class AddPostScreen extends StatefulWidget {
  final Community community;

  const AddPostScreen({required this.community, super.key});

  @override
  _AddPostScreenState createState() => _AddPostScreenState();
}
class _AddPostScreenState extends State<AddPostScreen> {
  final _formKey = GlobalKey<FormState>();
  String title = '';
  String content = '';

  void _submitPost() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      // TODO: Send post to backend
      // For now, we'll add it to the local list
      setState(() {
        widget.community.posts.add(
          Post(
            id: widget.community.posts.length + 1,
            title: title,
            content: content,
            author: 'You',
            timestamp: DateTime.now(),
            comments: [],
          ),
        );
      });

      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Post'),
        backgroundColor: AppColors.primaryColor,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                decoration: const InputDecoration(labelText: 'Title'),
                onSaved: (value) => title = value ?? '',
                validator: (value) =>
                value!.isEmpty ? 'Please enter a title' : null,
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Content'),
                maxLines: 5,
                onSaved: (value) => content = value ?? '',
                validator: (value) =>
                value!.isEmpty ? 'Please enter content' : null,
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _submitPost,
                child: const Text('Submit'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryColor,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
