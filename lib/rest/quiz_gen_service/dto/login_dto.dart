import '../../interfaces/dto.dart';

class LoginDTO implements DTO<LoginDTO> {
  String email;
  String password;

  LoginDTO({required this.email, required this.password});

  @override
  Map<String, dynamic> toJson() {
    return {
      'email': email,
      'password': password,
    };
  }

  @override
  factory LoginDTO.fromJson(Map<String, dynamic> json) {
    return LoginDTO(
      email: json['email'],
      password: json['password'],
    );
  }
}
