import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;

class Config {
  final String hobbyServiceAddress;

  Config({required this.hobbyServiceAddress});

  factory Config.fromJson(Map<String, dynamic> json) {
    return Config(hobbyServiceAddress: json['hobby_service_address']);
  }

  get baseUrl => null;
}

Future<Config> loadConfig() async {
  final configString = await rootBundle.loadString('assets/config/config.json');
  final configJson = json.decode(configString);
  return Config.fromJson(configJson);
}
