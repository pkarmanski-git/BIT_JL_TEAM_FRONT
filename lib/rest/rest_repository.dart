

import 'dart:convert';

import 'package:jl_team_front_bit/rest/hobby_service/dto/get_user_profile_dto.dart';
import 'package:jl_team_front_bit/rest/hobby_service/dto/update_hobby_profile_dto.dart';
import 'package:jl_team_front_bit/rest/hobby_service/dto/user_profile_dto.dart';
import 'package:logger/logger.dart';
import 'package:jl_team_front_bit/model/community.dart';
import '../model/user.dart';
import '../utils/config.dart';
import 'hobby_service/dto/get_hobbies_dto.dart';
import 'hobby_service/dto/hobbie_dto.dart';
import 'hobby_service/dto/login_dto.dart';
import 'hobby_service/dto/profile_dto.dart';
import 'hobby_service/dto/profile_me_dto.dart';
import 'hobby_service/dto/register_dto.dart';
import 'hobby_service/dto/token_dto.dart';
import 'hobby_service/dto/token_refresh_dto.dart';
import 'hobby_service/dto/upload_quiz_dto.dart';
import 'hobby_service/hobby_service.dart';

class RestRepository {
  late Config config;
  final Logger logger = Logger();
  late HobbyService service;

  RestRepository({required this.config}){
    this.config = config;
    this.service = new HobbyService(baseUrl: config.hobbyServiceAddress);
  }

  get client => null;

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

  Future<void> uploadQuiz(User user, UploadQuizDTO data) async{
    await service.uploadQuiz(user, data);
    return;
  }

  Future<GetHobbiesDTO> getMatchedHobby(User user) async{
    GetHobbiesDTO response = await service.getMatchedHobbies(user);
    return response;
  }

  Future<List<Community>> fetchCommunitiesWithPosts() async {
    final response = await client.get('${config.baseUrl}/communities');
    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.map((json) => Community.fromJson(json)).toList();
    } else {
      throw Exception('Failed to fetch communities');
    }
  }

  Future<Object> profileUser(User user, ProfileMeDTO data) async{
    Object response = await service.profileUser(user, data);
    return response;
  }

  Future<UserProfileDTO> getUserProfile(User user) async{
    UserProfileDTO response = await service.getUserProfile(user);
    return response;
  }

  Future<void> updateUserHobbies(User user, UpdateHobbyProfileDTO data) async{
    await service.updateUserHobbies(user, data);
  }

  Future<List<HobbyDTO>> getUserHobbies(User user) async{
    List<HobbyDTO> response = await service.getUserHobbies(user);
    return response;
  }
}