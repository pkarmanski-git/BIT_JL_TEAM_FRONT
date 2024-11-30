import '../model/question.dart';

class QuestionFactory {
  static List<Question> createQuestions() {
    return [
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
  }
}
