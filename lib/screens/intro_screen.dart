import 'dart:async';
import 'package:flutter/material.dart';
import 'quiz_screen.dart';
import '../service/service.dart';

class IntroScreen extends StatefulWidget {
  final Service service;

  const IntroScreen({Key? key, required this.service}) : super(key: key);

  @override
  _IntroScreenState createState() => _IntroScreenState();
}

class _IntroScreenState extends State<IntroScreen> with TickerProviderStateMixin {
  String fullText =
      "Let's Discover Your Personality!\nGet ready to answer some questions.";
  String displayedText = "";
  int currentIndex = 0;
  bool reverseTyping = false; // To control reverse text animation
  bool showAgreeGif = false;
  bool showDisagreeGif = false;

  late AnimationController _colorController;
  late Animation<Color?> _backgroundColor;

  @override
  void initState() {
    super.initState();
    _setupBackgroundAnimation();
    _startTypingAnimation();
  }

  void _setupBackgroundAnimation() {
    _colorController = AnimationController(
      duration: const Duration(milliseconds: 500), // Faster duration for color changes
      vsync: this,
    );
    _backgroundColor = ColorTween(
      begin: Colors.teal.shade50,
      end: Colors.green.shade300,
    ).animate(_colorController);
  }

  void _startTypingAnimation() {
    Timer.periodic(const Duration(milliseconds: 50), (timer) {
      if (!reverseTyping && currentIndex < fullText.length) {
        setState(() {
          displayedText += fullText[currentIndex];
          currentIndex++;
        });
      } else if (!reverseTyping && currentIndex == fullText.length) {
        Future.delayed(const Duration(seconds: 2), () {
          setState(() {
            reverseTyping = true; // Begin reverse typing after 2 seconds
          });
        });
      } else if (reverseTyping && displayedText.isNotEmpty) {
        // Reverse typing happens faster (2x speed)
        Timer(const Duration(milliseconds: 25), () {
          setState(() {
            displayedText = displayedText.substring(0, displayedText.length - 1);
          });
        });
      } else if (reverseTyping && displayedText.isEmpty) {
        timer.cancel();
        Future.delayed(const Duration(milliseconds: 500), () {
          _showGifs();
        });
      }
    });
  }

  void _animateBackground({required bool toGreen}) {
    // Reset the animation controller to ensure it starts from the beginning
    _colorController.reset();

    // Set the appropriate color tween based on the flag
    ColorTween colorTween = toGreen
        ? ColorTween(
      begin: Colors.teal.shade50,
      end: Colors.green.shade300,
    )
        : ColorTween(
      begin: Colors.white,
      end: Colors.red.shade300,
    );

    _backgroundColor = colorTween.animate(_colorController);

    // Play the animation once
    _colorController.duration = const Duration(seconds: 3); // Adjust transition speed
    _colorController.forward();
  }



  void _showGifs() {
    // Show "AGREE" gif
    setState(() {
      showAgreeGif = true;
    });
    _animateBackground(toGreen: true); // Animate to green once
    Future.delayed(const Duration(seconds: 4), () {
      setState(() {
        showAgreeGif = false;
        showDisagreeGif = true;
      });
      _animateBackground(toGreen: false); // Animate to red once
      Future.delayed(const Duration(seconds: 4), () {
        // Navigate to QuizScreen
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => QuizScreen(service: widget.service, nickname: "User"),
          ),
        );
      });
    });
  }




  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AnimatedBuilder(
        animation: _colorController,
        builder: (context, child) {
          return Container(
            color: _backgroundColor.value, // Dynamic background color
            child: Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Show typing animation text
                    if (displayedText.isNotEmpty)
                      Text(
                        displayedText,
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.teal.shade800,
                          height: 1.5,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    // Show "AGREE" gif
                    if (showAgreeGif)
                      Column(
                        children: [
                          Image.asset(
                            'assets/gifs/swipe-right.gif',
                            height: 200,
                          ),
                          const SizedBox(height: 16),
                          Text(
                            "AGREE",
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Colors.green.shade800,
                            ),
                          ),
                        ],
                      ),
                    // Show "DISAGREE" gif
                    if (showDisagreeGif)
                      Column(
                        children: [
                          Image.asset(
                            'assets/gifs/swipe-left.gif',
                            height: 200,
                          ),
                          const SizedBox(height: 16),
                          Text(
                            "DISAGREE",
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Colors.red.shade800,
                            ),
                          ),
                        ],
                      ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  @override
  void dispose() {
    _colorController.dispose();
    super.dispose();
  }
}
