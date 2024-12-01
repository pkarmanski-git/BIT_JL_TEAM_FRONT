import 'hobbie_dto.dart';

class GetHobbiesDTO {
  int count;
  String? next;
  String? previous;
  List<HobbyDTO> results;

  GetHobbiesDTO({
    required this.count,
    this.next,
    this.previous,
    required this.results,
  });

  factory GetHobbiesDTO.fromJson(Map<String, dynamic> json) {
    return GetHobbiesDTO(
      count: json['count'],
      next: json['next'],
      previous: json['previous'],
      results: (json['results'] as List<dynamic>)
          .map((item) => HobbyDTO.fromJson(item as Map<String, dynamic>))
          .toList(),
    );
  }
}
