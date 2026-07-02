import 'package:sqflite/sqflite.dart';
import 'package:project_novaflow/data/models/task_model.dart';
import 'package:project_novaflow/data/services/database_helper.dart';

class DBHelper {
  Future<Database> get db async => await DatabaseHelper.db;

  static Future<int> insert(Task task) async {
    try {
      final dbClient = await DatabaseHelper.db;
      return await dbClient.insert('tasks', task.toMap());
    } catch (e) {
      throw Exception("INSERT TASK FAILED: $e");
    }
  }

  static Future<List<Task>> getByAuthor(String author) async {
    try {
      final dbClient = await DatabaseHelper.db;

      final res = await dbClient.query(
        'tasks',
        where: 'author = ?',
        whereArgs: [author],
        orderBy: 'createdAt DESC',
      );

      return res.map((e) => Task.fromMap(e)).toList();
    } catch (e) {
      throw Exception("GET TASK FAILED: $e");
    }
  }

  static Future<int> update(Task task) async {
    try {
      final dbClient = await DatabaseHelper.db;

      return await dbClient.update(
        'tasks',
        task.toMap(),
        where: 'id = ? AND author = ?',
        whereArgs: [task.id, task.author],
      );
    } catch (e) {
      throw Exception("UPDATE TASK FAILED: $e");
    }
  }

  static Future<int> delete(int id, String author) async {
    try {
      final dbClient = await DatabaseHelper.db;

      return await dbClient.delete(
        'tasks',
        where: 'id = ? AND author = ?',
        whereArgs: [id, author],
      );
    } catch (e) {
      throw Exception("DELETE TASK FAILED: $e");
    }
  }

  static Future<int> deleteAllTasks(String author) async {
    try {
      final dbClient = await DatabaseHelper.db;

      return await dbClient.delete(
        'tasks',
        where: 'author = ?',
        whereArgs: [author],
      );
    } catch (e) {
      throw Exception("DELETE ALL TASK FAILED: $e");
    }
  }

  static Future<int> deleteAccount(String author) async {
    try {
      final dbClient = await DatabaseHelper.db;

      return await dbClient.delete(
        'users',
        where: 'username = ?',
        whereArgs: [author],
      );
    } catch (e) {
      throw Exception("DELETE ACCOUNT FAILED: $e");
    }
  }

  static Future<int> deleteAllCategories(String author) async {
    try {
      final dbClient = await DatabaseHelper.db;

      return await dbClient.delete(
        'categories',
        where: 'author = ?',
        whereArgs: [author],
      );
    } catch (e) {
      throw Exception("DELETE ALL CATEGORY FAILED: $e");
    }
  }
}
