import 'package:flutter/material.dart';
import 'package:provider_sqlite/helper/db_helper.dart';
import 'package:provider_sqlite/model/note.dart';

class NoteProvider extends ChangeNotifier {
  // late DatabaseHelper? _databaseHelper;
  List _noteList = [];
  List get noteList => _noteList;

  void fetchNotes() async {
    final db = DatabaseHelper();
    _noteList = await db.getAllNote();
    // return _noteList.map((json) => NoteModel.fromJson(json)).toList();
    notifyListeners();
    print("All note: ${_noteList}");
  }

  Future<void> addNote(NoteModel notes) async {
    final db = DatabaseHelper();
    await db.insertNote(notes);
    _noteList.add(notes);
    notifyListeners();
  }

  
}
