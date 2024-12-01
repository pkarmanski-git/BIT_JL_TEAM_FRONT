import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:jl_team_front_bit/enums/service_errors.dart';
import 'package:jl_team_front_bit/model/hobby.dart';
import 'package:jl_team_front_bit/model/service_response.dart';
import 'package:jl_team_front_bit/service/service.dart';

class MyHobbiesScreen extends StatefulWidget {
  final Service service;

  const MyHobbiesScreen({Key? key, required this.service}) : super(key: key);

  @override
  _MyHobbiesScreenState createState() => _MyHobbiesScreenState();
}

class _MyHobbiesScreenState extends State<MyHobbiesScreen> {
  List<Hobby> hobbies = [];
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadHobbies();
  }

  Future<void> _loadHobbies() async {
    setState(() {
      isLoading = true;
    });
    try {
      // Fetch the user's hobbies from the backend
      ServiceResponse response = await widget.service.getUserHobby();
      if (response.error == ServiceErrors.ok) {
        setState(() {
          hobbies = response.data!;
        });
      } else {
        _showErrorSnackbar("Failed to load hobbies: ${response.error}");
      }
    } catch (e) {
      _showErrorSnackbar("An error occurred while loading hobbies: $e");
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  void _showErrorSnackbar(String message) {
    final snackBar = SnackBar(
      content: Text(message),
      backgroundColor: Colors.red,
    );
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.palette,
              color: Colors.white,
              size: 24,
            ),
            const SizedBox(width: 8),
            Text(
              'My Hobbies',
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20,
                color: Colors.white,
              ),
            ),
          ],
        ),
        flexibleSpace: Container(
          decoration: const BoxDecoration(
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
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : hobbies.isEmpty
          ? const Center(
        child: Text(
          'You have no hobbies.',
          style: TextStyle(fontSize: 18),
        ),
      )
          : GridView.builder(
        padding: const EdgeInsets.all(16),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 1, // One tile per row
          childAspectRatio: 4 / 1, // 4:1 width-to-height ratio
          mainAxisSpacing: 16,
        ),
        itemCount: hobbies.length,
        itemBuilder: (context, index) {
          final hobby = hobbies[index];
          return _buildHobbyTile(hobby);
        },
      ),
    );
  }

  Widget _buildHobbyTile(Hobby hobby) {
    return GestureDetector(
      onTap: () {
        // Handle tap if needed
      },
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          image: hobby.image != null && hobby.image!.isNotEmpty
              ? DecorationImage(
            image: MemoryImage(base64Decode(hobby.image!)),
            fit: BoxFit.cover,
            colorFilter: ColorFilter.mode(
              Colors.black.withOpacity(0.4),
              BlendMode.darken,
            ),
          )
              : null,
        ),
        child: Container(
          decoration: BoxDecoration(
            color: hobby.image != null && hobby.image!.isNotEmpty
                ? Colors.transparent
                : Colors.grey.withOpacity(0.4),
            borderRadius: BorderRadius.circular(10),
          ),
          alignment: Alignment.center,
          child: Text(
            hobby.name,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.bold,
              shadows: [
                Shadow(
                  blurRadius: 5,
                  color: Colors.black54,
                  offset: Offset(2, 2),
                ),
              ],
            ),
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }
}