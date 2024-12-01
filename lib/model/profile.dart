import '../rest/hobby_service/dto/profile_dto.dart';

class Profile {
  Map<String, int> character;

  Profile(ProfileDTO profileDTO) : character = Map<String, int>.from(profileDTO.character);
}
