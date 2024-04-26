// ignore_for_file: prefer_const_declarations, depend_on_referenced_packages

// import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseServices {
  static Future<Database> _openDatabase() async {
    final databasePath = await getDatabasesPath();
    final databaseFile = join(databasePath, 'profile_pictures.db');
    return openDatabase(databaseFile,
        version: 1, onCreate: _createDatabaseFile);
  }

  static Future<void> _createDatabaseFile(Database db, int version) async {
    final String sql =
        'CREATE TABLE IF NOT EXISTS pfp(userID INTEGER PRIMARY KEY AUTOINCREMENT, email TEXT, path TEXT)';
    await db.execute(sql);
  }

  static Future<int> addUserDetails(String email, String path) async {
    final db = await _openDatabase();
    final Map<String, dynamic> userDetails = {
      'email': email,
      'path': path,
    };
    final int result = await db.insert('pfp', userDetails);
    return result;
  }

  // static Future<int> updateUserDetails(
  //     int id, String email, String path) async {
  //   final db = await _openDatabase();
  //   final Map<String, dynamic> userDetails = {
  //     'email': email,
  //     'path': path,
  //   };
  //   final int result = await db
  //       .update('pfp', userDetails, where: 'userID = ?', whereArgs: [id]);
  //   return result;
  // }

  static Future<Map<String, dynamic>> getUsersDetailsByEmail(
      String email) async {
    final db = await _openDatabase();
    List<Map<String, dynamic>> result =
        await db.query('pfp', where: 'email = ?', whereArgs: [email], limit: 1);
    return result.isNotEmpty ? result.first : {};
  }

  static Future<int> deleteUserDetails(String email) async {
    final db = await _openDatabase();
    final int result =
        await db.delete('pfp', where: 'email = ?', whereArgs: [email]);
    return result;
  }
}
