import 'package:flutter/material.dart';
import 'package:jl_team_front_bit/model/service_response.dart';
import 'package:jl_team_front_bit/screens/swipe_screen.dart';
import 'package:swipe_cards/swipe_cards.dart';

import '../enums/service_errors.dart';
import '../factories/image_factory.dart';
import '../factories/question_factory.dart';
import '../model/answer.dart';
import '../model/question.dart';
import '../service/service.dart';

class QuizScreen extends StatefulWidget {
  final Service service;

  const QuizScreen({super.key, required this.service, required String nickname});

  @override
  _QuizScreenState createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  List<SwipeItem> _swipeItems = [];
  late MatchEngine _matchEngine;
  List<Answer> answers = [];

  final String defaultBackgroundImage = 'assets/images/default_background.png';

  List<Question> questions = QuestionFactory.createQuestions();

  int currentQuestionIndex = 0;
  bool isLoading = false;

  Map<String, String> imageStatements = ImageStatementFactory.createImageStatements();

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

    answers.add(Answer(statement, answerValue));

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

  void _onQuizComplete() async {
    setState(() {
      isLoading = true;
    });

    try {
      ServiceResponse response = await widget.service.uploadQuiz(answers);
      if (response.error == ServiceErrors.ok) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => SwipeScreen(service: widget.service)),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("Something went wrong!"))
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("An error occurred!"))
      );
    } finally {
      setState(() {
        isLoading = false;
      });
    }
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
          // Wyświetlanie loadera, jeśli jest w trakcie ładowania
          if (isLoading)
            Center(
              child: CircularProgressIndicator(),
            )
          else
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
                    // SwipeCards
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
                                  ? null
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
