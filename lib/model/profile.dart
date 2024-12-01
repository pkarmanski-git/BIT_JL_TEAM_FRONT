import '../rest/hobby_service/dto/profile_dto.dart';

class Profile {
  Map<String, int>? character;

  Profile.fromProfileDTO(ProfileDTO profileDTO){
    if(profileDTO.character == null){
      character = {};
    }else{
      character = Map<String, int>.from(profileDTO.character!);
    }
  }

  Profile({required this.character});
}
