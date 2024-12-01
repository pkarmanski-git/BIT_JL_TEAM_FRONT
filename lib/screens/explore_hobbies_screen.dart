import 'dart:convert';
import 'dart:math';

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

class _SwipeScreenState extends State<SwipeScreen> with TickerProviderStateMixin {
  List<Hobby> hobbies = [];
  MatchEngine? _matchEngine;
  bool showDetails = false;
  Hobby? currentHobby;
  bool isLoading = false;
  OverlayEntry? overlayEntry; // Store the overlay entry

  late AnimationController _animationController;
  late Animation<Offset> _offsetAnimation;
  late Animation<double> _heightAnimation;
  bool _isDetailsVisible = false; // Track visibility of the details

  @override
  void initState() {
    super.initState();
    _loadHobbies();

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );

    // Animation for sliding up the content
    _offsetAnimation = Tween<Offset>(
      begin: Offset(0, 0), // initial position (no movement)
      end: Offset(0, -0.3), // end position (move up)
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));

    // Animation for expanding the hidden area (height)
    _heightAnimation = Tween<double>(
      begin: 0.0, // Start with 0 height (hidden)
      end: 150.0, // Expand to desired height
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));
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
                  widget.service.updateUserHobby([hobby.id], []);
                },
                nopeAction: () {
                  widget.service.updateUserHobby([], [hobby.id]);
                },
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
        title: const Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.travel_explore,
              color: Colors.white,
              size: 24,
            ),
            SizedBox(width: 8),
            Text(
              'Discover Hobbies',
              style: TextStyle(
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
          ? Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            HobbyLoader(),
            const SizedBox(height: 85),
            const Text(
              "Loading hobbies... Please wait!",
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.teal,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      )
          : hobbies.isEmpty
          ? const Center(child: Text('No hobbies found.'))
          : Column(
        children: [
          Expanded(child: _buildSwipeView(context)),
          AnimatedBuilder(
            animation: _heightAnimation,
            builder: (context, child) {
              return Container(
                height: _heightAnimation.value,
                width: double.infinity,
                color: Colors.grey[200],
                padding: const EdgeInsets.all(16.0),
                child: currentHobby != null && currentHobby!.summary.isNotEmpty
                    ? Text(
                  currentHobby!.summary,
                  style: TextStyle(fontSize: 18),
                )
                    : const SizedBox.shrink(),
              );
            },
          )
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
        // Zmienna `hobby` zawiera dane obiektu, który jest aktualnie wyświetlany.

        return GestureDetector(
          onTap: () {
            // Możesz np. przypisać dane do zmiennej, żeby później użyć
            setState(() {
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
                    hobby.name, // Tekst wyciągnięty z obiektu hobby
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textColor,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.keyboard_arrow_up),
                  onPressed: () {
                    if (_isDetailsVisible) {
                      _animationController.reverse();
                    } else {
                      _animationController.forward();
                    }

                    setState(() {
                      _isDetailsVisible = !_isDetailsVisible;
                    });
                  },
                  color: Colors.black,
                  iconSize: 30,
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

class HobbyLoader extends StatefulWidget {
  @override
  _HobbyLoaderState createState() => _HobbyLoaderState();
}

class _HobbyLoaderState extends State<HobbyLoader>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  final List<IconData> hobbyIcons = [
    Icons.sports_basketball,
    Icons.music_note,
    Icons.camera_alt,
    Icons.book,
    Icons.palette,
    Icons.computer,
    Icons.directions_bike,
    Icons.flight,
  ];

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: Duration(seconds: 4),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return RotationTransition(
      turns: _controller,
      child: Stack(
        alignment: Alignment.center,
        children: hobbyIcons.map((iconData) {
          int index = hobbyIcons.indexOf(iconData);
          double angle = (2 * pi * index) / hobbyIcons.length;
          return Transform.translate(
            offset: Offset(
              60 * cos(angle),
              60 * sin(angle),
            ),
            child: Icon(
              iconData,
              size: 30,
              color: Colors.teal,
            ),
          );
        }).toList(),
      ),
    );
  }
}
