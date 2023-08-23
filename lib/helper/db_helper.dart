import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:provider_sqlite/model/note.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  Future<Database> initializeDB() async {
    String path = await getDatabasesPath();
    return openDatabase(
      join(path, 'tododatabase.db'),
      onCreate: (database, version) async {
        await database.execute(
          'CREATE TABLE notes(id INTEGER PRIMARY KEY, title TEXT, subTitle TEXT, favourite INTEGER NOT NULL DEFAULT 0)',
        );
      },
      version: 1,
    );
  }

  Future<List<NoteModel>> getAllNote() async {
    final db = await initializeDB();
    final List<Map<String, dynamic>> queryResult = await db.query('notes');

    return List.generate(queryResult.length, (index) {
      return NoteModel(
          id: queryResult[index]['id'],
          title: queryResult[index]['title'],
          subTitle: queryResult[index]['subTitle'],
          favourite: queryResult[index]['favourite']);
    });
  }

  Future<void> insertNote(NoteModel task) async {
    final db = await initializeDB();
    await db.insert(
      'notes',
      task.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );

    print("Hello $task");
  }

  Future<void> deleteNote(int id) async {
    final db = await initializeDB();
    await db.delete(
      'notes',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<void> addFavpurite(int value, int idx) async {
    final db = await initializeDB();
    await db
        .rawUpdate('UPDATE notes SET favourite = ? where id = ?', [value, idx]);
  }
}
