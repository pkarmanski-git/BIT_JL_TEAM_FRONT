import 'package:jl_team_front_bit/rest/quiz_gen_service/dto/login_dto.dart';
import 'package:jl_team_front_bit/rest/quiz_gen_service/dto/register_dto.dart';
import 'package:jl_team_front_bit/rest/quiz_gen_service/dto/token_dto.dart';
import 'package:jl_team_front_bit/rest/quiz_gen_service/dto/token_refresh_dto.dart';

import '../model/user.dart';
import '../utils/config.dart';

class RestRepository {
  final Config config;
  // final Logger logger = Logger();
  final Object service = new Object();

  RestRepository({required this.config}){
    //Tu serwis init
  }

  // Future<Object> register(RegisterDTO data) async {
  //     Object response = await service.register(data);
  //     return response;
  // }
  //
  //
  // Future<TokenDTO> login(LoginDTO data) async {
  //   TokenDTO responseDTO = await service.login(data);
  //   return responseDTO;
  // }
  //
  // Future<Object> logout(User user) async {
  //   Object response = await service.logout(user);
  //   return response;
  // }
  //
  //
  // Future<TokenDTO> refreshToken(TokenRefreshDTO data) async {
  //   TokenDTO responseDTO = await service.refresh(data);
  //   return responseDTO;
  // }

}