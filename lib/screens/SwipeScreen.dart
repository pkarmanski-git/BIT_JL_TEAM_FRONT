import 'package:flutter/material.dart';
import 'package:swipe_cards/swipe_cards.dart';
import '../model/hobby_swipe.dart';
import '../constants/colors.dart';

class SwipeScreen extends StatefulWidget {
  const SwipeScreen({super.key});

  @override
  _SwipeScreenState createState() => _SwipeScreenState();
}

class _SwipeScreenState extends State<SwipeScreen> {
  List<HobbySwipe> hobbies = [];
  List<HobbySwipe> likedHobbies = [];
  late MatchEngine _matchEngine;
  bool showDetails = false; // Flag for showing details
  HobbySwipe? currentHobby; // Currently selected hobby

  @override
  void initState() {
    super.initState();
    _loadHobbies();
  }

  void _loadHobbies() {
    setState(() {
      hobbies = [
        HobbySwipe(
          1,
          'Photography',
          'https://via.placeholder.com/400',
          'Photography is the art of capturing light with a camera.',
        ),
        HobbySwipe(
          2,
          'Cooking',
          'https://via.placeholder.com/400',
          'Cooking is the practice of preparing food by combining ingredients.',
        ),
        HobbySwipe(
          3,
          'Gardening',
          'https://via.placeholder.com/400',
          'Gardening is the activity of growing and maintaining the garden.',
        ),
      ];

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
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Discover Hobbies'),
        backgroundColor: AppColors.primaryColor,
      ),
      body: hobbies.isEmpty
          ? const Center(child: CircularProgressIndicator())
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
    return SwipeCards(
      matchEngine: _matchEngine,
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
                  child: Image.network(
                    hobby.imageBase64,
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
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text(
                    hobby.summary,
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
      likeTag: Icon(Icons.favorite, color: Colors.green, size: 100),
      nopeTag: Icon(Icons.close, color: Colors.red, size: 100),
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
            currentHobby!.summary,
            style: const TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 20),
          Image.network(
            currentHobby!.imageBase64,
            height: 200,
            width: double.infinity,
            fit: BoxFit.cover,
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
          ),
          const SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              currentHobby!.details ?? 'No additional details available.',
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
}
