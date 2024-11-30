class RegisterDTO{
  String username;
  String email;
  String password;
  String passwordRepeated;

  RegisterDTO(this.username, this.email, this.password, this.passwordRepeated);

  @override
  Map<String, dynamic> toJson() {
    return {
      'username': username,
      'email': email,
      'password': password,
      'passwordRepeated': passwordRepeated,
    };
  }
}