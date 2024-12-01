import 'package:jl_team_front_bit/rest/hobby_service/dto/user_profile_dto.dart';

class GetUserProfileDTO{
  UserProfileDTO results;

  GetUserProfileDTO({required this.results});

  factory GetUserProfileDTO.fromJson(Map<String, dynamic> json) {
    return GetUserProfileDTO(
        results: UserProfileDTO.fromJson(json)
    );
  }
}