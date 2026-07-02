import 'package:sqflite/sqflite.dart';
import 'package:project_novaflow/data/services/database_helper.dart';

enum LoginStatus { success, userNotFound, wrongPassword }

class LoginHelper {
  Future<Database> get db async => await DatabaseHelper.db;

  Future<int> register(String username, String password) async {
    try {
      final dbClient = await db;

      return await dbClient.insert('users', {
        'username': username,
        'password': password,
      });
    } catch (e) {
      throw Exception("REGISTER FAILED: $e");
    }
  }

  Future<LoginStatus> checkLogin(String username, String password) async {
    try {
      final dbClient = await db;

      // Cek apakah username ada
      final users = await dbClient.query(
        'users',
        where: 'username = ?',
        whereArgs: [username],
      );

      if (users.isEmpty) {
        return LoginStatus.userNotFound;
      }

      // Cek apakah username + password cocok
      final login = await dbClient.query(
        'users',
        where: 'username = ? AND password = ?',
        whereArgs: [username, password],
      );

      if (login.isNotEmpty) {
        return LoginStatus.success;
      }

      return LoginStatus.wrongPassword;
    } catch (e) {
      throw Exception("LOGIN FAILED: $e");
    }
  }
}
