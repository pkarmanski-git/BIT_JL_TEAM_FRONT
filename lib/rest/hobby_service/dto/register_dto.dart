class RegisterDTO{
  String email;
  String password;
  String passwordRepeated;

  RegisterDTO(this.email, this.password, this.passwordRepeated);

  @override
  Map<String, dynamic> toJson() {
    return {
      'email': email,
      'password': password,
      'passwordRepeated': passwordRepeated,
    };
  }
}