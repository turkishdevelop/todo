import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import '../models/note_helper.dart';
import 'package:todo_app/models/note_data.dart';
import 'package:todo_app/utils/app_localization.dart';

// ignore: must_be_immutable
class AlertNote extends StatelessWidget {
  String title;
  String note;

  AlertNote(this.title);

  final noteController = TextEditingController();

  @override
  Widget build(BuildContext context) {

    return StatefulBuilder(
      builder: (_, setState) {
        final myProvider = Provider.of<NoteData>(_);

        return AlertDialog(
          title: Text(title),
          actions: <Widget>[
            IconButton(
              icon: Icon(
                FontAwesomeIcons.check,
                color: Colors.green,
              ),
              onPressed: () {
                if(noteController.text!=''){
                  myProvider.addNote(Note(note: noteController.text));
                }

                Navigator.pop(_);
              },
              color: Colors.green,
            ),
          ],
          content: Container(
            child: TextField(
              controller: noteController,
              keyboardType: TextInputType.multiline,
              maxLength: 1000,
              maxLines: 8,
              decoration: InputDecoration(
                  hintText: AppLocalizations.of(context)
                      .translate('alertNoteHintText')),
            ),
          ),
        );
      },
    );
  }
}
