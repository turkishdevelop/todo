import 'package:firebase_admob/firebase_admob.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_app/items/note_item.dart';
import 'package:todo_app/models/note_data.dart';

// ignore: must_be_immutable
class NoteListWidget extends StatelessWidget {


  @override
  Widget build(BuildContext context) {
    return Consumer<NoteData>(
      builder: (_, noteData, child) => ListView.builder(
        itemBuilder: (context, index) {
          return NoteItem(
            note: noteData.notes[index],
          );
        },
        itemCount: noteData.notes.length,
      ),
    );
  }
}
