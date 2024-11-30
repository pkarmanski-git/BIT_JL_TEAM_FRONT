import 'package:flutter/material.dart';
import '/model/comment.dart';
import '/model/comunity.dart';
import '/model/post.dart';
import '../constants/colors.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'CommunityPostsScreen.dart';


class CommunitiesScreen extends StatefulWidget {
  const CommunitiesScreen({super.key});

  @override
  _CommunitiesScreenState createState() => _CommunitiesScreenState();
}
class _CommunitiesScreenState extends State<CommunitiesScreen> {
  List<Community> communities = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadCommunities();
  }

  void _loadCommunities() async {
    // TODO: Replace with actual API call to fetch communities
    // For now, we'll use mock data
    setState(() {
      communities = [
        Community(
          id: 1,
          name: 'Local Community',
          posts: [],
        ),
        Community(
          id: 2,
          name: 'Global Community',
          posts: [],
        ),
      ];
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Communities'),
        backgroundColor: AppColors.primaryColor,
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
        itemCount: communities.length,
        itemBuilder: (context, index) {
          final community = communities[index];
          return ListTile(
            title: Text(community.name),
            trailing: const Icon(Icons.arrow_forward),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      CommunityPostsScreen(community: community),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
