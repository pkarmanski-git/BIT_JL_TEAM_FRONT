import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;

class Config {
  final String quizGenServiceAddress;

  Config({required this.quizGenServiceAddress});

  factory Config.fromJson(Map<String, dynamic> json) {
    return Config(quizGenServiceAddress: json['quiz_gen_address']);
  }
}

Future<Config> loadConfig() async {
  final configString = await rootBundle.loadString('assets/config/config.json');
  final configJson = json.decode(configString);
  return Config.fromJson(configJson);
}
