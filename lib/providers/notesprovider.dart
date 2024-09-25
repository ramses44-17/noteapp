import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:noteapp/utils/database.dart';
import 'package:noteapp/utils/noteclass.dart';

class NotesProvider extends ChangeNotifier {
  late List<Note> _notes = notesBox.values.toList();
  List<Note> get notes => _notes;
  Database db = Database();
  Box<Note> notesBox = Hive.box('notesBox');
  void addNotes(Note note) {
    _notes.insert(0, note);
    db.addData(note);
    notifyListeners();
  }

  void deleteNote(String id) {
    _notes.removeWhere((note) => note.id == id);
    db.deleteData(id);
    notifyListeners();
    
  }

  void togglePinned(String id) {
    Note note = _notes.lastWhere((note) => note.id == id);
    note.isPinned = !note.isPinned;
    db.updateData(id, note);
    notifyListeners();
  }

  void updateNote(String id, String contentUpdated, String titleUpdated) {
    Note note = _notes.lastWhere((note) => note.id == id);
    note.content = contentUpdated;
    note.title = titleUpdated;
    note.createdAt = DateTime.now();
    db.updateData(id, note);
    notifyListeners();
  }
}
