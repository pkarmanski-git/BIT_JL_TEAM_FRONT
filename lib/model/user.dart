import 'package:jl_team_front_bit/model/profile.dart';
import 'package:jl_team_front_bit/model/token.dart';

import 'hobby.dart';

class User{
  Token? token;
  bool isLogged = false;
  Profile? profile;
  List<Hobby>? hobbies;
}