class ProfileDTO{
  Map<String, int>? character;

  ProfileDTO(this.character);

  factory ProfileDTO.fromJson(Map<String, dynamic> json) {
    Map<String, int> characterMap = Map<String, int>.from(json['character']);
    return ProfileDTO(characterMap);
  }
}