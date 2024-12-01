import 'dart:convert';

import 'package:jl_team_front_bit/rest/hobby_service/dto/update_hobby_profile_dto.dart';
import 'package:jl_team_front_bit/rest/hobby_service/dto/upload_quiz_dto.dart';
import 'package:logger/logger.dart';
import 'package:http/http.dart' as http;

import '../../model/user.dart';
import 'dto/get_hobbies_dto.dart';
import 'dto/get_user_profile_dto.dart';
import 'dto/hobbie_dto.dart';
import 'dto/login_dto.dart';
import 'dto/profile_dto.dart';
import 'dto/profile_me_dto.dart';
import 'dto/register_dto.dart';
import 'dto/token_dto.dart';
import 'dto/token_refresh_dto.dart';
import 'dto/user_profile_dto.dart';

class HobbyService{
  final String baseUrl;
  final Logger logger = Logger();
  final Duration duration = const Duration(seconds: 60);

  HobbyService({required this.baseUrl});

  Future<Object> register(RegisterDTO data) async{
    const endpoint = "/auth/register/";
    final url = Uri.parse('$baseUrl$endpoint');
    try {
      logger.i(url);
      logger.i(data.toJson());
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: json.encode(data.toJson()),
      ).timeout(duration);
      logger.i(response.body);
      if(response.statusCode != 200 && response.statusCode != 201){
        throw Exception('Error in POST request: $response');
      }
      return Object();
    } catch (e) {
      throw Exception('Error in POST request: $e');
    }
  }

  Future<TokenDTO> login(LoginDTO data) async {
    const endpoint = "/auth/login/";
    final url = Uri.parse('$baseUrl$endpoint');
    try {
      logger.i(url);
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: json.encode(data.toJson()),
      ).timeout(duration);
      logger.i(response.body);
      if(response.statusCode != 200 && response.statusCode != 201){
        throw Exception('Error in POST request: $response');
      }
      return TokenDTO.fromJson(json.decode(response.body));
    } catch (e) {
      throw Exception('Error in POST request: $e');
    }
  }

  Future<Object> logout(User user) async {
    const endpoint = "/auth/logout/";
    final url = Uri.parse('$baseUrl$endpoint');
    String? accessToken = user.token?.access;
    try {
      logger.i(url);
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $accessToken',
        },
      ).timeout(duration);
      logger.i(response.body);
      return Object();
    } catch (e) {
      throw Exception('Error in POST request: $e');
    }
  }

  Future<TokenDTO> refresh(TokenRefreshDTO data) async {
    const endpoint = "/auth/token/refresh/";
    final url = Uri.parse('$baseUrl$endpoint');
    try {
      logger.i(url);
      logger.i(data.toJson());
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: json.encode(data.toJson()),
      ).timeout(duration);
      logger.i(response.body);
      if(response.statusCode != 200 && response.statusCode != 201){
        throw Exception('Error in POST request: $response');
      }
      return TokenDTO.fromJson(json.decode(response.body));
    } catch (e) {
      throw Exception('Error in POST request: $e');
    }
  }

  Future<ProfileDTO> uploadQuiz(User user, UploadQuizDTO data) async{
    const endpoint = "/profile/upload-quiz/";
    final url = Uri.parse('$baseUrl$endpoint');
    try {
      logger.i(url);
      logger.i(data.toJson());
      String? accessToken = user.token?.access;
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $accessToken',
        },
        body: json.encode(data.toJson()),
      ).timeout(duration);
      logger.i(response.body);
      if(response.statusCode != 200 && response.statusCode != 201){
        throw Exception('Error in POST request: $response');
      }
      return ProfileDTO.fromJson(json.decode(response.body));
    } catch (e) {
      throw Exception('Error in POST request: $e');
    }
  }

  Future<GetHobbiesDTO> getMatchedHobbies(User user) async{
    const endpoint = "/hobby-matching/";
    final url = Uri.parse('$baseUrl$endpoint');
    try {
      logger.i(url);
      String? accessToken = user.token?.access;
      final response = await http.get(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $accessToken',
        },
      ).timeout(duration);
      logger.i(response.body);
      if(response.statusCode != 200 && response.statusCode != 201){
        throw Exception('Error in POST request: $response');
      }
      return GetHobbiesDTO.fromJson(json.decode(response.body));
    } catch (e) {
      throw Exception('Error in POST request: $e');
    }
  }

  Future<Object> profileUser(User user, ProfileMeDTO data) async{
    const endpoint = "/profile/me/";
    final url = Uri.parse('$baseUrl$endpoint');
    try {
      logger.i(url);
      String? accessToken = user.token?.access;
      final response = await http.patch(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $accessToken',
        },
        body: json.encode(data.toJson()),
      ).timeout(duration);
      logger.i(response.body);
      if(response.statusCode != 200 && response.statusCode != 201){
        throw Exception('Error in POST request: $response');
      }
      return Object();
    } catch (e) {
      throw Exception('Error in POST request: $e');
    }
  }

  Future<UserProfileDTO> getUserProfile(User user) async{
    const endpoint = "/profile/me/";
    final url = Uri.parse('$baseUrl$endpoint');
    try {
      logger.i(url);
      String? accessToken = user.token?.access;
      final response = await http.get(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $accessToken',
        },
      ).timeout(duration);
      logger.i(response.body);
      if(response.statusCode != 200 && response.statusCode != 201){
        throw Exception('Error in POST request: $response');
      }
      return UserProfileDTO.fromJson(json.decode(response.body));
    } catch (e) {
      throw Exception('Error in POST request: $e');
    }
  }

  Future<void> updateUserHobbies(User user, UpdateHobbyProfileDTO data) async{
    const endpoint = "/profile/update-hobbies-profiles/";
    final url = Uri.parse('$baseUrl$endpoint');
    try {
      logger.i(url);
      logger.i(data.toJson());
      String? accessToken = user.token?.access;
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $accessToken',
        },
        body: json.encode(data.toJson())
      ).timeout(duration);
      logger.i(response.body);
      if(response.statusCode != 200 && response.statusCode != 201){
        throw Exception('Error in POST request: $response');
      }
    } catch (e) {
      throw Exception('Error in POST request: $e');
    }
  }


  Future<List<HobbyDTO>> getUserHobbies(User user) async {
    const endpoint = "/profile/get-my-hobbies/";
    final url = Uri.parse('$baseUrl$endpoint');

    try {
      logger.i(url);

      String? accessToken = user.token?.access;
      if (accessToken == null) {
        throw Exception('Access token is null');
      }

      final response = await http.get(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $accessToken',
        },
      ).timeout(duration);

      logger.i(response.body);

      if (response.statusCode != 200 && response.statusCode != 201) {
        throw Exception('Error in GET request: ${response.statusCode} ${response.body}');
      }

      List<dynamic> responseList = json.decode(response.body);
      return responseList.map((item) => HobbyDTO.fromJson(item)).toList();

    } catch (e) {
      logger.e('Error in getUserHobbies: $e');
      throw Exception('Error while fetching hobbies: $e');
    }
  }


}