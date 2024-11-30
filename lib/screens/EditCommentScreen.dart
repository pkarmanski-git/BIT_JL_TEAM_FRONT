import 'package:flutter/material.dart';
import '/model/comment.dart';
import '/model/comunity.dart';
import '/model/post.dart';
import '../constants/colors.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';


class EditCommentScreen extends StatefulWidget {
  final Comment comment;

  const EditCommentScreen({required this.comment, super.key});

  @override
  _EditCommentScreenState createState() => _EditCommentScreenState();
}
class _EditCommentScreenState extends State<EditCommentScreen> {
  final _formKey = GlobalKey<FormState>();
  late String content;

  @override
  void initState() {
    super.initState();
    content = widget.comment.content;
  }

  void _updateComment() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      // TODO: Update comment in backend
      setState(() {
        widget.comment.content = content;
      });

      Navigator.pop(context);
    }
  }

  void _deleteComment() {
    // TODO: Delete comment from backend
    Navigator.pop(context, 'deleted');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Comment'),
        backgroundColor: AppColors.primaryColor,
        actions: [
          IconButton(
            icon: const Icon(Icons.delete),
            onPressed: _deleteComment,
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
                initialValue: content,
                decoration: const InputDecoration(labelText: 'Comment'),
                maxLines: 3,
                onSaved: (value) => content = value ?? '',
                validator: (value) =>
                value!.isEmpty ? 'Please enter a comment' : null,
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _updateComment,
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
