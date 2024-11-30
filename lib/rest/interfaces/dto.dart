abstract class DTO<T> {
  Map<String, dynamic> toJson();

  // static T fromJson(Map<String, dynamic> json) {
  //   throw UnimplementedError('fromJson dla tego typu nie jest zaimplementowane');
  // }
}
