import '../../interfaces/dto.dart';

class TokenDTO implements DTO<TokenDTO>{
  String refresh;
  String access;

  TokenDTO({required this.refresh, required this.access});

  @override
  Map<String, dynamic> toJson() {
    throw UnimplementedError();
  }

  @override
  factory TokenDTO.fromJson(Map<String, dynamic> json) {
    return TokenDTO(
      refresh: json['refresh'],
      access: json['access'],
    );
  }

}