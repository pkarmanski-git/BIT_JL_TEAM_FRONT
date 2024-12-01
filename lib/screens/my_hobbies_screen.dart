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
  bool showDetails = false;
  Hobby? currentHobby;

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
      ServiceResponse response = await widget.service.getUserHobby();
      if(response.error == ServiceErrors.ok){
        setState(() {
          hobbies = widget.service.user.hobbies??[];
        });
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

  void _showHobbyDetails(Hobby hobby) {
    setState(() {
      showDetails = true;
      currentHobby = hobby;
    });
  }

  void _hideHobbyDetails() {
    setState(() {
      showDetails = false;
      currentHobby = null;
    });
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
          : Stack(
        children: [
          Visibility(
            visible: !showDetails,
            child: GridView.builder(
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
          ),
          if (showDetails && currentHobby != null)
            _buildDetailsView(),
        ],
      ),
    );
  }

  Widget _buildHobbyTile(Hobby hobby) {
    return GestureDetector(
      onTap: () {
        _showHobbyDetails(hobby);
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

  Widget _buildDetailsView() {
    return GestureDetector(
      onTap: _hideHobbyDetails,
      child: Container(
        color: Colors.black54, // Semi-transparent background
        child: Center(
          child: SingleChildScrollView(
            child: Card(
              margin: const EdgeInsets.symmetric(horizontal: 24, vertical: 48),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (currentHobby?.image != null && currentHobby!.image!.isNotEmpty)
                    ClipRRect(
                      borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
                      child: Image.memory(
                        base64Decode(currentHobby!.image!),
                        fit: BoxFit.cover,
                        width: double.infinity,
                        height: 200,
                        errorBuilder: (context, error, stackTrace) {
                          return Container(
                            color: Colors.grey,
                            height: 200,
                            child: const Icon(
                              Icons.image,
                              size: 100,
                              color: Colors.white,
                            ),
                          );
                        },
                      ),
                    ),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Text(
                      currentHobby!.name,
                      style: const TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  if (currentHobby?.summary != null && currentHobby!.summary.isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: Text(
                        currentHobby!.summary,
                        style: const TextStyle(fontSize: 18),
                        textAlign: TextAlign.justify,
                      ),
                    ),
                  const SizedBox(height: 16),
                  const Text(
                    '(Tap anywhere to close)',
                    style: TextStyle(fontSize: 16, fontStyle: FontStyle.italic),
                  ),
                  const SizedBox(height: 16),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
