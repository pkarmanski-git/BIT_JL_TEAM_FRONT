import 'package:jl_team_front_bit/rest/hobby_service/dto/question_dto.dart';


class UploadQuizDTO{
  List<QuestionDTO> questions;

  UploadQuizDTO({required this.questions});

  @override
  Map<String, dynamic> toJson() {
    return {
      "question": questions.map((question) => question.toJson()).toList()
    };
  }

}