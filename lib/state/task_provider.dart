// ignore_for_file: prefer_final_fields

import 'package:flutter/material.dart';
import 'package:project_novaflow/data/auth/auth_provider.dart';
import 'package:project_novaflow/data/models/task_model.dart';
import 'package:project_novaflow/data/models/app_error.dart';
import 'package:project_novaflow/data/services/task_helper.dart';
import 'package:project_novaflow/data/services/database_helper.dart';

class TaskProvider extends ChangeNotifier {
  final AuthProvider authProvider;

  TaskProvider(this.authProvider);

  List<Task> _tasks = [];
  List<Task> get tasks => _tasks;

  List<String> _categories = [];
  List<String> get categories => _categories;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  AppError? _error;
  AppError? get error => _error;

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  void _setError(String source, Object e) {
    _error = AppError(message: e.toString(), source: source, raw: e);

    notifyListeners();
  }

  void clearError() {
    _error = null;
    notifyListeners();
  }

  Future<void> loadTasks() async {
    final user = authProvider.currentUser;
    if (user == null) return;

    _setLoading(true);
    clearError();

    try {
      _tasks = await DBHelper.getByAuthor(user);
    } catch (e) {
      _setError("loadTasks", e);
    }

    _setLoading(false);
  }

  Future<void> addTask(Task task) async {
    clearError();

    try {
      await DBHelper.insert(task);
      await loadTasks();
    } catch (e) {
      _setError("addTask", e);
    }
  }

  Future<void> deleteTask(int id) async {
    final user = authProvider.currentUser;
    if (user == null) return;

    clearError();

    try {
      await DBHelper.delete(id, user);
      await loadTasks();
    } catch (e) {
      _setError("deleteTask", e);
    }
  }

  Future<void> updateTask(Task task) async {
    clearError();

    try {
      await DBHelper.update(task);
      await loadTasks();
    } catch (e) {
      _setError("updateTask", e);
    }
  }

  Future<void> loadCategories() async {
    final user = authProvider.currentUser;
    if (user == null) return;

    clearError();

    try {
      final db = await DatabaseHelper.db;

      final res = await db.query(
        'categories',
        where: 'author = ?',
        whereArgs: [user],
      );

      _categories = res.map((e) => e['name'] as String).toList();
      notifyListeners();
    } catch (e) {
      _setError("loadCategories", e);
    }
  }

  Future<void> addCategory(String name) async {
    final user = authProvider.currentUser;
    if (user == null) return;

    clearError();

    try {
      final db = await DatabaseHelper.db;

      await db.insert('categories', {'name': name, 'author': user});

      await loadCategories();
    } catch (e) {
      _setError("addCategory", e);
    }
  }

  Future<void> deleteCategory(String name) async {
    try {
      final db = await DatabaseHelper.db;

      await db.delete(
        'categories',
        where: 'name = ? AND author = ?',
        whereArgs: [name, authProvider.currentUser!],
      );

      await loadCategories();
    } catch (e) {
      _setError("deleteCategory", e);
      notifyListeners();
    }
  }

  Future<void> deleteAllTasks() async {
    final user = authProvider.currentUser;
    if (user == null) return;

    clearError();

    try {
      await DBHelper.deleteAllTasks(user);
      await loadTasks();
    } catch (e) {
      _setError("deleteAllTasks", e);
    }
  }

  Future<void> deleteAllCategories(String author) async {
    final db = await DatabaseHelper.db;

    await db.delete('categories', where: 'author = ?', whereArgs: [author]);
  }

  Future<void> deleteAccount() async {
    final user = authProvider.currentUser;
    if (user == null) return;

    clearError();

    try {
      await DBHelper.deleteAllTasks(user);
      await DBHelper.deleteAllCategories(user);
      await DBHelper.deleteAccount(user);

      _tasks.clear();
      notifyListeners();
    } catch (e) {
      _setError("deleteAccount", e);
    }
  }
}
