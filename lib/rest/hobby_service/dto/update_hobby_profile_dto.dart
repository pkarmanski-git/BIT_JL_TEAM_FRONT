class UpdateHobbyProfileDTO{
  List<int> approvedHobbies;
  List<int> deletedHobbies;

  UpdateHobbyProfileDTO(this.approvedHobbies, this.deletedHobbies);

  @override
  Map<String, dynamic> toJson() {
    return {
      "approvedHobbies": approvedHobbies,
      "deletedHobbies": deletedHobbies
    };
  }
}