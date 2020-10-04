import 'dart:collection';
import 'dart:io';

import 'package:flutter/foundation.dart' as foundation;
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';
import 'note_helper.dart';

class NoteData extends foundation.ChangeNotifier {
  List<Note> _notes = [];

  var box;

  NoteData() {
    initializeDatabase();
  }

  initializeDatabase() async {
    Directory dir = await getExternalStorageDirectory();
    Hive.init(dir.path);
    Hive.registerAdapter(NoteAdapter());

    Hive.openBox<Note>('note').then(
      (value) {
        value.values.forEach((element) {
          print(element.note);
          _notes.add(element);
          notifyListeners();
        });
      },
    );
  }

  /// An unmodifiable view of the items in the note.
  UnmodifiableListView<Note> get notes => UnmodifiableListView(_notes);

  int get taskListCount => _notes.length;

  //@Add Working 100%
  void addNote(Note note) async {
    box = await Hive.openBox<Note>('note').then((value) {
      value.add(note);
      _notes.add(note);
      notifyListeners();
    });
  }

  //@Delete Working 100%
  void deleteNote(Note note) async {
    int index = _notes.indexOf(note);
    box = await Hive.openBox<Note>('note').then((value) {
      value.deleteAt(index);
      _notes.remove(note);
      notifyListeners();
    });

  }

  //@Update Working 100%
  void updateNote(Note oldNote,Note newNote) async{

    int index = _notes.indexOf(oldNote);
    box = await Hive.openBox<Note>('note').then((value) {
      value.putAt(index, newNote);
      _notes[_notes.indexWhere((note) => note == note)] = newNote;
      notifyListeners();
    });
  }
}
