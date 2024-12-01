class ProfileMeDTO{
  String username;
  int age;
  String location;

  ProfileMeDTO(this.username, this.age, this.location);

  @override
  Map<String, dynamic> toJson() {
    return {
      "username": username,
      "age": int,
      "location": location
    };
  }
}