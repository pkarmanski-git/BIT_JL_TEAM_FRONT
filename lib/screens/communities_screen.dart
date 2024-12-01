import 'package:flutter/material.dart';
import '../model/service_response.dart';
import '/model/community.dart';
import '../constants/colors.dart';
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
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.psychology,
              color: Colors.white,
              size: 24,
            ),
            const SizedBox(width: 8),
            Text(
              'Communities',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20,
                color: Colors.white,
              ),
            ),
          ],
        ),
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.teal, Colors.greenAccent],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
        centerTitle: true,
        elevation: 4,
        toolbarHeight: 70,
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


