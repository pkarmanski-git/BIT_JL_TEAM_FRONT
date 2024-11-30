class QuestionDTO{
  String name;
  bool response;

  QuestionDTO(this.name, this.response);

  @override
  Map<String, dynamic> toJson() {
    return {
      "name": name,
      "response": response
    };
  }
}