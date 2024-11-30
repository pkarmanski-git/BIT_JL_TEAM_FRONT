import 'package:jl_team_front_bit/rest/hobby_service/dto/question_dto.dart';

import '../../../model/answer.dart';


class UploadQuizDTO{
  List<QuestionDTO> questions = [];
  
  UploadQuizDTO(List<Answer> answers){
      this.questions = answers.map((answer) => QuestionDTO(answer.question, answer.answer)).toList();
  }
  
  @override
  Map<String, dynamic> toJson() {
    return {
      "questions": questions.map((question) => question.toJson()).toList()
    };
  }

}