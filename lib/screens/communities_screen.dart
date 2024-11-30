import 'dart:developer';

import 'package:flutter/material.dart';
import '../model/service_response.dart';
import '/model/comment.dart';
import '/model/community.dart';
import '/model/post.dart';
import '../constants/colors.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'community_posts_screen.dart';
import '../service/service.dart';

class CommunitiesScreen extends StatefulWidget {
  final Service service;

  const CommunitiesScreen({super.key, required this.service});

  @override
  _CommunitiesScreenState createState() => _CommunitiesScreenState();
}

class _CommunitiesScreenState extends State<CommunitiesScreen> {
  late Future<ServiceResponse<List<Community>>> _communitiesFuture;

  @override
  void initState() {
    super.initState();
    _communitiesFuture = widget.service.fetchCommunitiesWithPosts();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Communities'),
        backgroundColor: AppColors.primaryColor,
      ),
      body: FutureBuilder<ServiceResponse<List<Community>>>(
        future: _communitiesFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(
              child: Text('Error: ${snapshot.error}'),
            );
          } else if (snapshot.hasData && snapshot.data!.data != null) {
            final communities = snapshot.data!.data!;
            return ListView.builder(
              itemCount: communities.length,
              itemBuilder: (context, index) {
                final community = communities[index];
                return ExpansionTile(
                  title: Text(
                    community.name,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textColor,
                    ),
                  ),
                  children: community.posts.map((post) {
                    return ListTile(
                      title: Text(
                        post.title, // Assuming Post has a title field
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: AppColors.textColor,
                        ),
                      ),
                      subtitle: Text(
                        post.content, // Assuming Post has a content field
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    );
                  }).toList(),
                );
              },
            );
          } else {
            return const Center(child: Text('No communities available.'));
          }
        },
      ),
    );
  }
}


