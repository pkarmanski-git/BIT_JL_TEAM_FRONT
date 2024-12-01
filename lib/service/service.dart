import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:jl_team_front_bit/model/user.dart';
import 'package:jl_team_front_bit/model/community.dart';
import 'package:jl_team_front_bit/rest/hobby_service/dto/get_user_profile_dto.dart';
import 'package:jl_team_front_bit/rest/hobby_service/dto/hobbie_dto.dart';
import 'package:jl_team_front_bit/rest/hobby_service/dto/profile_me_dto.dart';
import 'package:jl_team_front_bit/rest/hobby_service/dto/update_hobby_profile_dto.dart';
import 'package:jl_team_front_bit/rest/hobby_service/dto/user_profile_dto.dart';
import 'package:logger/logger.dart';

import '../enums/service_errors.dart';
import '../model/answer.dart';
import '../model/hobby.dart';
import '../model/profile.dart';
import '../model/profile_me.dart';
import '../model/service_response.dart';
import '../model/token.dart';
import '../rest/hobby_service/dto/get_hobbies_dto.dart';
import '../rest/hobby_service/dto/login_dto.dart';
import '../rest/hobby_service/dto/profile_dto.dart';
import '../rest/hobby_service/dto/register_dto.dart';
import '../rest/hobby_service/dto/token_dto.dart';
import '../rest/hobby_service/dto/token_refresh_dto.dart';
import '../rest/hobby_service/dto/upload_quiz_dto.dart';
import '../rest/rest_repository.dart';
import '../utils/config.dart';

class Service {
  final Logger logger = Logger();
  final User user = User();
  late final Config config;
  final storage = const FlutterSecureStorage();
  late final RestRepository restRepository;

  Service();

  Future<void> init() async {
    config = await loadConfig();
    restRepository = RestRepository(config: config);
    String? refreshToken = await storage.read(key: 'refreshToken');
    if(refreshToken != null && refreshToken != "") {
      await this.refreshToken(refreshToken);
      await this.getUserProfile();
      await this.getUserHobby();
    }
  }


  Future<ServiceResponse> register(String email, String password, String repeatedPassword) async{
    try{
      RegisterDTO registerDTO = RegisterDTO(email, password, repeatedPassword);
      await restRepository.register(registerDTO);
      return ServiceResponse(data: null, error: ServiceErrors.ok);
    }catch (e){
      logger.e(e);
      return ServiceResponse(data: null, error: ServiceErrors.loginError);
    }
  }

  Future<ServiceResponse> login(String email, String password) async{
    try{
      var loginDTO = LoginDTO(email: email, password: password);
      TokenDTO login = await restRepository.login(loginDTO);
      user.token = Token(access: login.access, refresh: login.refresh);
      user.isLogged = true;
      await storage.write(key: 'refreshToken', value: login.refresh);
      return ServiceResponse(data: null, error: ServiceErrors.ok);
    }catch (e){
      logger.e(e.toString());
      return ServiceResponse(data: null, error: ServiceErrors.loginError);
    }
  }

  Future<ServiceResponse> logout() async{
    try{
      await restRepository.logout(user);
      user.token = Token(access: "", refresh: "");
      user.isLogged = false;
      await storage.write(key: 'refreshToken', value: "");
      return ServiceResponse(data: null, error: ServiceErrors.ok);
    }catch (e){
      logger.e(e.toString());
      return ServiceResponse(data: null, error: ServiceErrors.loginError);
    }
  }

  Future<ServiceResponse> refreshToken(String token) async{
    try{
      var loginDTO = TokenRefreshDTO(token);
      TokenDTO login = await restRepository.refreshToken(loginDTO);
      user.token = Token(access: login.access, refresh: login.refresh);
      user.isLogged = true;
      await storage.write(key: 'refreshToken', value: login.refresh);
      return ServiceResponse(data: null, error: ServiceErrors.ok);
    }catch (e){
      logger.e(e.toString());
      return ServiceResponse(data: null, error: ServiceErrors.loginError);
    }
  }

  Future<ServiceResponse<List<Community>>> fetchCommunitiesWithPosts() async {
    try {
      final communities = await restRepository.fetchCommunitiesWithPosts(); // Updated method in RestRepository
      return ServiceResponse(data: communities, error: ServiceErrors.ok);
    } catch (e) {
      logger.e(e.toString());
      return ServiceResponse(data: null, error: ServiceErrors.genericError);
    }
  }

  Future<ServiceResponse<ProfileDTO>> uploadQuiz(List<Answer> answers) async {
    try {
      var data = UploadQuizDTO(answers);
      ProfileDTO response = await restRepository.uploadQuiz(user, data);
      user.profile = Profile.fromProfileDTO(response);
      return ServiceResponse(data: response, error: ServiceErrors.ok);
    } catch (e) {
      logger.e(e.toString());
      return ServiceResponse(data: null, error: ServiceErrors.genericError);
    }
  }

  Future<ServiceResponse<List<Hobby>>> getMatchedHobbies() async {
    try {
      GetHobbiesDTO response = await restRepository.getMatchedHobby(user);
      return ServiceResponse(data: response.results.map((result) => Hobby.fromDTO(result)).toList(), error: ServiceErrors.ok);
    } catch (e) {
      logger.e(e.toString());
      return ServiceResponse(data: null, error: ServiceErrors.genericError);
    }
  }

  Future<ServiceResponse> profileUser(ProfileMe data) async{
    try {
      ProfileMeDTO profileMeDTO = ProfileMeDTO(data.username, data.age, data.location);
      Object response = await restRepository.profileUser(user, profileMeDTO);
      return ServiceResponse(data: null, error: ServiceErrors.ok);
    } catch (e) {
      logger.e(e.toString());
      return ServiceResponse(data: null, error: ServiceErrors.genericError);
    }
  }

  Future<ServiceResponse> getUserProfile() async{
    try {
      GetUserProfileDTO response = await restRepository.getUserProfile(user);
      user.profile = Profile(character: response.results.character);
      return ServiceResponse(data: null, error: ServiceErrors.ok);
    } catch (e) {
      logger.e(e.toString());
      return ServiceResponse(data: null, error: ServiceErrors.genericError);
    }
  }


  Future<ServiceResponse> updateUserHobby(List<int> saveHobbies, List<int> deleteHobbies) async{
    try {
      var data = UpdateHobbyProfileDTO(saveHobbies, deleteHobbies);
      await restRepository.updateUserHobbies(user, data);
      return ServiceResponse(data: null, error: ServiceErrors.ok);
    } catch (e) {
      logger.e(e.toString());
      return ServiceResponse(data: null, error: ServiceErrors.genericError);
    }
  }

  Future<ServiceResponse> getUserHobby() async{
    try {
      List<HobbyDTO> response = await restRepository.getUserHobbies(user);
      List<Hobby> hobbies = response.map((item) => Hobby.fromDTO(item)).toList();
      user.hobbies = hobbies;
      return ServiceResponse(data: hobbies, error: ServiceErrors.ok);
    } catch (e) {
      logger.e(e.toString());
      return ServiceResponse(data: null, error: ServiceErrors.genericError);
    }
  }

}



