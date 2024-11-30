import 'dart:async';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  // Singleton
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  factory DatabaseHelper() => _instance;
  DatabaseHelper._internal();

  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    // Inicjalizacja bazy danych
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    // Ścieżka do bazy danych w katalogu aplikacji
    String path = join(await getDatabasesPath(), 'quiz_answers.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
    );
  }

  // Tworzenie tabeli
  Future _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE answers (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        questionText TEXT,
        answerText TEXT
      )
    ''');
  }

  // Metoda zapisu odpowiedzi
  Future<int> insertAnswer(String questionText, String answerText) async {
    Database db = await database;
    return await db.insert(
      'answers',
      {
        'questionText': questionText,
        'answerText': answerText,
      },
    );
  }

  // Opcjonalnie: Metoda pobierania odpowiedzi
  Future<List<Map<String, dynamic>>> getAnswers() async {
    Database db = await database;
    return await db.query('answers');
  }
}
