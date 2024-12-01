import 'dart:convert';
import 'dart:math';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:swipe_cards/swipe_cards.dart';
import '../constants/colors.dart';
import '../enums/service_errors.dart';
import '../model/hobby.dart';
import '../model/service_response.dart';
import '../service/service.dart';

class SwipeScreen extends StatefulWidget {
  final Service service;

  const SwipeScreen({
    Key? key,
    required this.service,
  }) : super(key: key);

  @override
  _SwipeScreenState createState() => _SwipeScreenState();
}

class _SwipeScreenState extends State<SwipeScreen> with TickerProviderStateMixin {
  List<Hobby> hobbies = [];
  List<Uint8List?> decodedImages = []; // Lista zdekodowanych obrazów
  MatchEngine? _matchEngine;
  bool isLoading = false;

  late AnimationController _animationController;
  late Animation<double> _heightAnimation;
  bool _isDetailsVisible = false;
  int currentIndex = 0;

  @override
  void initState() {
    super.initState();
    _loadHobbies();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );

    _heightAnimation = Tween<double>(
      begin: 0.0,
      end: 300.0,
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
        hobbies = response.data!;

        // Zdekoduj obrazy przed utworzeniem kart
        decodedImages = hobbies.map((hobby) {
          if (hobby.image != null && hobby.image!.isNotEmpty) {
            return base64Decode(hobby.image!);
          } else {
            return null;
          }
        }).toList();

        setState(() {
          _matchEngine = MatchEngine(
            swipeItems: hobbies.asMap().entries.map((entry) {
              int index = entry.key;
              Hobby hobby = entry.value;
              return SwipeItem(
                content: hobby,
                likeAction: () {
                  widget.service.updateUserHobby([hobby.id], []);
                  _onSwipe();
                },
                nopeAction: () {
                  widget.service.updateUserHobby([], [hobby.id]);
                  _onSwipe();
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

  void _onSwipe() {
    setState(() {
      if (currentIndex < hobbies.length - 1) {
        currentIndex++;
      }
      if (_isDetailsVisible) {
        _animationController.reverse();
        _isDetailsVisible = false;
      }
    });
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
              Hobby? currentHobby = currentIndex < hobbies.length
                  ? hobbies[currentIndex]
                  : null;
              return Container(
                height: _heightAnimation.value,
                width: double.infinity,
                color: Colors.grey[200],
                padding: const EdgeInsets.all(16.0),
                child: currentHobby != null &&
                    currentHobby.summary.isNotEmpty
                    ? SingleChildScrollView(
                  child: Text(
                    currentHobby.summary,
                    style: const TextStyle(fontSize: 18),
                    textAlign: TextAlign.justify,
                  ),
                )
                    : const SizedBox.shrink(),
              );
            },
          ),
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
        Hobby hobby = hobbies[index];
        Uint8List? imageData = decodedImages[index]; // Pobierz zdekodowany obraz
        return Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          child: Column(
            children: [
              Expanded(
                child: imageData != null
                    ? Image.memory(
                  imageData,
                  fit: BoxFit.cover,
                  width: double.infinity,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      width: double.infinity,
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
                  width: double.infinity,
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
              IconButton(
                icon: Icon(_isDetailsVisible
                    ? Icons.keyboard_arrow_down
                    : Icons.keyboard_arrow_up),
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
        );
      },
      onStackFinished: _showCompletionDialog,
      upSwipeAllowed: false,
      fillSpace: true,
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
                // Możesz wykonać dodatkowe akcje, np. powrót do poprzedniego ekranu
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
