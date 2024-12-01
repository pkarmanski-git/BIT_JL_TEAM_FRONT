class UserProfileDTO {
  String username;
  int age;
  String location;
  Map<String, int> character;

  UserProfileDTO({required this.username, required this.age, required this.location, required this.character});

  factory UserProfileDTO.fromJson(Map<String, dynamic> json) {
    return UserProfileDTO(
        username: json['username'],
        age: json['age'],
        location: json['location'],
        character: Map<String, int>.from(json['character'])
    );
  }
}
