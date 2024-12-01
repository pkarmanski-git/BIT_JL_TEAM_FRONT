import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:jl_team_front_bit/enums/service_errors.dart';
import 'package:jl_team_front_bit/model/hobby.dart';
import 'package:swipe_cards/swipe_cards.dart';
import '../constants/colors.dart';
import '../model/service_response.dart';
import '../service/service.dart';

class SwipeScreen extends StatefulWidget {
  final Service service;

  const SwipeScreen({
    super.key,
    required this.service,
  });

  @override
  _SwipeScreenState createState() => _SwipeScreenState();
}

class _SwipeScreenState extends State<SwipeScreen> {
  List<Hobby> hobbies = [];
  List<Hobby> likedHobbies = [];
  MatchEngine? _matchEngine;
  bool showDetails = false;
  Hobby? currentHobby;
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
      ServiceResponse<List<Hobby>> response = await widget.service.getMatchedHobbies();
      if (response.error == ServiceErrors.ok) {
        setState(() {
          hobbies = response.data!;
          _matchEngine = MatchEngine(
            swipeItems: hobbies.map((hobby) {
              return SwipeItem(
                content: hobby,
                likeAction: () {
                  likedHobbies.add(hobby);
                },
                nopeAction: () {},
              );
            }).toList(),
          );
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.travel_explore,
              color: Colors.white,
              size: 24,
            ),
            const SizedBox(width: 8),
            Text(
              'Discover Hobbies',
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
          ? const Center(child: CircularProgressIndicator())
          : hobbies.isEmpty
          ? const Center(child: Text('No hobbies found.'))
          : Column(
        children: [
          if (showDetails && currentHobby != null)
            Expanded(child: _buildDetailsView(context))
          else
            Expanded(child: _buildSwipeView(context)),
        ],
      ),
    );
  }

  Widget _buildSwipeView(BuildContext context) {
    if (_matchEngine == null) {
      return const Center(child: CircularProgressIndicator());
    }

    return SwipeCards(
      matchEngine: _matchEngine!,
      itemBuilder: (context, index) {
        final hobby = hobbies[index];
        return GestureDetector(
          onTap: () {
            setState(() {
              showDetails = true;
              currentHobby = hobby;
            });
          },
          child: Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            child: Column(
              children: [
                Expanded(
                  child: hobby.image != null && hobby.image!.isNotEmpty
                      ? Image.memory(
                    base64Decode(hobby.image!),
                    fit: BoxFit.cover,
                    width: double.infinity,
                    errorBuilder: (context, error, stackTrace) {
                    return Container(
                      color: Colors.grey,
                      child: const Icon(
                        Icons.image,
                        size: 100,
                        color: Colors.white,
                      ),
                    );
            },
          )
              : Container(
          color: Colors.grey,
          child: const Icon(
            Icons.image,
            size: 100,
            color: Colors.white,
          ),
        ),

        ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text(
                    hobby.name,
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textColor,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            ),
          ),
        );
      },
      onStackFinished: _showCompletionDialog,
      upSwipeAllowed: false,
      fillSpace: true,
      likeTag: const Icon(Icons.favorite, color: Colors.green, size: 100),
      nopeTag: const Icon(Icons.close, color: Colors.red, size: 100),
    );
  }

  Widget _buildDetailsView(BuildContext context) {
    return GestureDetector(
      onTap: () {
        setState(() {
          showDetails = false;
          currentHobby = null;
        });
      },
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            currentHobby!.name,
            style: const TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 20),
          currentHobby?.image != null
              ? Image.memory(
            base64Decode(currentHobby!.image!),
            fit: BoxFit.cover,
            width: double.infinity,
            errorBuilder: (context, error, stackTrace) {
              return Container(
                color: Colors.grey,
                child: const Icon(
                  Icons.image,
                  size: 100,
                  color: Colors.white,
                ),
              );
            },
          )
              : Container(
            color: Colors.grey,
            child: const Icon(
              Icons.image,
              size: 100,
              color: Colors.white,
            ),
          ),

          const SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              currentHobby!.name,
              style: const TextStyle(fontSize: 18),
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(height: 20),
          const Text(
            '(Tap anywhere to go back to swiping)',
            style: TextStyle(fontSize: 16, fontStyle: FontStyle.italic),
          ),
        ],
      ),
    );
  }

  void _showCompletionDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('No More Hobbies'),
          content: const Text('You have swiped through all hobbies.'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  void _showErrorSnackbar(String message) {
    final snackBar = SnackBar(
      content: Text(message),
      backgroundColor: Colors.red,
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}
