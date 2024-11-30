

import 'package:logger/logger.dart';

import '../model/user.dart';
import '../utils/config.dart';
import 'hobby_service/dto/login_dto.dart';
import 'hobby_service/dto/register_dto.dart';
import 'hobby_service/dto/token_dto.dart';
import 'hobby_service/dto/token_refresh_dto.dart';
import 'hobby_service/hobby_service.dart';

class RestRepository {
  late Config config;
  final Logger logger = Logger();
  late HobbyService service;

  RestRepository({required this.config}){
    this.config = config;
    this.service = new HobbyService(baseUrl: config.hobbyServiceAddress);
  }

  Future<Object> register(RegisterDTO data) async {
      Object response = await service.register(data);
      return response;
  }


  Future<TokenDTO> login(LoginDTO data) async {
    TokenDTO responseDTO = await service.login(data);
    return responseDTO;
  }

  Future<Object> logout(User user) async {
    Object response = await service.logout(user);
    return response;
  }


  Future<TokenDTO> refreshToken(TokenRefreshDTO data) async {
    TokenDTO responseDTO = await service.refresh(data);
    return responseDTO;
  }

}