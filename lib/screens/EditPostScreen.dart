import 'package:flutter/material.dart';
import '/model/comment.dart';
import '/model/comunity.dart';
import '/model/post.dart';
import '../constants/colors.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';


class EditPostScreen extends StatefulWidget {
  final Post post;

  const EditPostScreen({required this.post, super.key});

  @override
  _EditPostScreenState createState() => _EditPostScreenState();
}

class _EditPostScreenState extends State<EditPostScreen> {
  final _formKey = GlobalKey<FormState>();
  late String title;
  late String content;

  @override
  void initState() {
    super.initState();
    title = widget.post.title;
    content = widget.post.content;
  }

  void _updatePost() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      // TODO: Update post in backend
      setState(() {
        widget.post.title = title;
        widget.post.content = content;
      });

      Navigator.pop(context);
    }
  }

  void _deletePost() {
    // TODO: Delete post from backend
    Navigator.pop(context, 'deleted');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Post'),
        backgroundColor: AppColors.primaryColor,
        actions: [
          IconButton(
            icon: const Icon(Icons.delete),
            onPressed: _deletePost,
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                initialValue: title,
                decoration: const InputDecoration(labelText: 'Title'),
                onSaved: (value) => title = value ?? '',
                validator: (value) =>
                value!.isEmpty ? 'Please enter a title' : null,
              ),
              TextFormField(
                initialValue: content,
                decoration: const InputDecoration(labelText: 'Content'),
                maxLines: 5,
                onSaved: (value) => content = value ?? '',
                validator: (value) =>
                value!.isEmpty ? 'Please enter content' : null,
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _updatePost,
                child: const Text('Update'),
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
