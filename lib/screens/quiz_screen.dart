import 'package:flutter/material.dart';
import 'package:swipe_cards/swipe_cards.dart';
import 'dart:convert';

import '../model/question.dart';
import '../service/service.dart';

class QuizScreen extends StatefulWidget {
  final Service service;

  const QuizScreen({super.key, required this.service});

  @override
  _QuizScreenState createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  List<SwipeItem> _swipeItems = [];
  late MatchEngine _matchEngine;
  List<Map<String, dynamic>> answers = [];

  final String defaultBackgroundImage = 'assets/images/default_background.png';

  List<Question> questions = [
    Question(text: 'Do you enjoy being the center of attention?'),
    Question(
      text: 'Does this image suit you?',
      imagePath: 'assets/images/party.jpg',
      isImageQuestion: true,
    ),
    Question(text: 'Do you prefer planning over spontaneity?'),
    Question(
      text: 'Does this image suit you?',
      imagePath: 'assets/images/reading.jpg',
      isImageQuestion: true,
    ),
    Question(text: 'Is it easy for you to empathize with others?'),
    Question(
      text: 'Does this image suit you?',
      imagePath: 'assets/images/volunteer.jpeg',
      isImageQuestion: true,
    ),
    Question(text: 'Do you feel comfortable taking risks?'),
    Question(
      text: 'Does this image suit you?',
      imagePath: 'assets/images/skydiving.jpg',
      isImageQuestion: true,
    ),
    Question(text: 'Do you feel energized after social interactions?'),
    Question(
      text: 'Does this image suit you?',
      imagePath: 'assets/images/concert.jpg',
      isImageQuestion: true,
    ),
    Question(text: 'Do you trust your intuition when making decisions?'),
    Question(
      text: 'Does this image suit you?',
      imagePath: 'assets/images/compass.jpg',
      isImageQuestion: true,
    ),
    Question(text: 'Do you prefer working in a structured environment?'),
    Question(
      text: 'Does this image suit you?',
      imagePath: 'assets/images/office.jpg',
      isImageQuestion: true,
    ),
    Question(text: 'Do you often contemplate the deeper meaning of life?'),
    Question(
      text: 'Does this image suit you?',
      imagePath: 'assets/images/stargazing.jpg',
      isImageQuestion: true,
    ),
    Question(text: 'Are you comfortable adapting to new situations?'),
    Question(text: 'Do you enjoy exploring new places?'),
    Question(text: 'Do you find it easy to express your feelings?'),
    Question(
      text: 'Does this image suit you?',
      imagePath: 'assets/images/artist.jpg',
      isImageQuestion: true,
    ),
    Question(text: 'Do you prefer to work alone rather than in a team?'),
    Question(
      text: 'Does this image suit you?',
      imagePath: 'assets/images/teamwork.jpg',
      isImageQuestion: true,
    ),
    Question(text: 'Are you detail-oriented?'),
    Question(
      text: 'Does this image suit you?',
      imagePath: 'assets/images/puzzle.jpg',
      isImageQuestion: true,
    ),
    Question(text: 'Do you enjoy taking the lead in group activities?'),
    Question(
      text: 'Does this image suit you?',
      imagePath: 'assets/images/leader.jpg',
      isImageQuestion: true,
    ),
    Question(text: 'Do you often set goals for yourself?'),
  ];

  int currentQuestionIndex = 0;

  Map<String, String> imageStatements = {
    'party.jpg': 'User likes going to parties',
    'reading.jpg': 'User enjoys reading',
    'volunteer.jpeg': 'User likes volunteering',
    'skydiving.jpg': 'User is interested in skydiving',
    'concert.jpg': 'User enjoys attending concerts',
    'compass.jpg': 'User trusts their intuition',
    'office.jpg': 'User prefers structured environments',
    'stargazing.jpg': 'User often contemplates the meaning of life',
    'artist.jpg': 'User finds it easy to express feelings',
    'teamwork.jpg': 'User prefers to work in teams',
    'puzzle.jpg': 'User is detail-oriented',
    'leader.jpg': 'User enjoys taking the lead in group activities',
  };

  @override
  void initState() {
    super.initState();

    for (var question in questions) {
      _swipeItems.add(SwipeItem(
        content: question,
        likeAction: () {
          _recordAnswer(question, true);
        },
        nopeAction: () {
          _recordAnswer(question, false);
        },
      ));
    }

    _matchEngine = MatchEngine(swipeItems: _swipeItems);
  }

  void _recordAnswer(Question question, bool answerValue) {
    String statement = generateStatement(question, answerValue);

    answers.add({
      'statement': statement,
      'answer': answerValue,
    });

    setState(() {
      currentQuestionIndex++;
    });

    if (answers.length == questions.length) {
      _onQuizComplete();
    }
  }

  String generateStatement(Question question, bool answerValue) {
    String statement;
    if (question.isImageQuestion && question.imagePath != null) {
      String imageName = question.imagePath!.split('/').last;
      statement = imageStatements[imageName] ?? 'Unknown preference';
      if (!answerValue) {
        if (statement.startsWith('User ')) {
          statement = statement.replaceFirst('User ', 'User does not ');
        } else {
          statement = 'User does not ' + statement;
        }
      }
    } else {
      statement = question.text;

      if (statement.endsWith('?')) {
        statement = statement.substring(0, statement.length - 1);
      }

      if (statement.startsWith('Do you ')) {
        statement = statement.replaceFirst('Do you ', '');
        statement = 'User ' + (answerValue ? '' : 'does not ') + statement;
      } else if (statement.startsWith('Are you ')) {
        statement = statement.replaceFirst('Are you ', '');
        statement = 'User is ' + (answerValue ? '' : 'not ') + statement;
      } else if (statement.startsWith('Is it ')) {
        statement = statement.replaceFirst('Is it ', '');
        statement = 'It is ' + (answerValue ? '' : 'not ') + statement + ' for the user';
      } else {
        statement = 'User ' + (answerValue ? '' : 'does not ') + statement;
      }
    }

    return statement;
  }

  void _onQuizComplete() {
    // String jsonAnswers = jsonEncode({'questions': answers});



    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => QuizScreen(service: widget.service,)),
    );
  }

  @override
  Widget build(BuildContext context) {
    double progress = currentQuestionIndex / questions.length;

    return Scaffold(
      appBar: AppBar(
        title: Text('Personality Quiz'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: Stack(
              children: [
                LinearProgressIndicator(
                  value: progress,
                  backgroundColor: Colors.grey[300],
                  color: Colors.blueAccent,
                  minHeight: 20,
                ),
                Positioned.fill(
                  child: Center(
                    child: Text(
                      '${currentQuestionIndex}/${questions.length} Questions Answered',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: Center(
              child: _swipeItems.isNotEmpty
                  ? Stack(
                children: [
                  // Gradient tła
                  Row(
                    children: [
                      Expanded(
                        child: Container(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [Colors.red.withOpacity(0.3), Colors.transparent],
                              begin: Alignment.centerLeft,
                              end: Alignment.centerRight,
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        child: Container(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [Colors.transparent, Colors.green.withOpacity(0.3)],
                              begin: Alignment.centerLeft,
                              end: Alignment.centerRight,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  // Karty SwipeCards
                  SwipeCards(
                    matchEngine: _matchEngine,
                    itemBuilder: (BuildContext context, int index) {
                      Question question = questions[index];
                      return Card(
                        elevation: 6,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        margin: EdgeInsets.symmetric(horizontal: 20, vertical: 40),
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(16),
                            image: question.isImageQuestion
                                ? null // Brak tła dla pytań z obrazkiem
                                : DecorationImage(
                              image: AssetImage(
                                question.imagePath ?? defaultBackgroundImage,
                              ),
                              fit: BoxFit.cover,
                              colorFilter: ColorFilter.mode(
                                Colors.black.withOpacity(0.4),
                                BlendMode.darken,
                              ),
                            ),
                          ),
                          child: question.isImageQuestion
                              ? Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              Expanded(
                                child: ClipRRect(
                                  borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(16),
                                    topRight: Radius.circular(16),
                                  ),
                                  child: Image.asset(
                                    question.imagePath!,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: Text(
                                  question.text,
                                  style: TextStyle(
                                    fontSize: 24,
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ],
                          )
                              : Center(
                            child: Padding(
                              padding: const EdgeInsets.all(24.0),
                              child: Text(
                                question.text,
                                style: TextStyle(
                                  fontSize: 28,
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                    onStackFinished: () {
                      if (answers.length < questions.length) {
                        _onQuizComplete();
                      }
                    },
                    upSwipeAllowed: false,
                    fillSpace: true,
                  ),
                ],
              )
                  : Text('No questions available'),
            ),
          ),
        ],
      ),
    );
  }
}

// Zakładam, że masz gotowy ekran ThankYouPage
class ThankYouPage extends StatelessWidget {
  final String jsonAnswers;

  ThankYouPage(this.jsonAnswers);

  @override
  Widget build(BuildContext context) {
    // Możesz obsłużyć dane JSON według potrzeb
    return Scaffold(
      appBar: AppBar(
        title: Text('Thank You'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Text(
          'Thank you for completing the quiz!',
          style: TextStyle(fontSize: 24),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
