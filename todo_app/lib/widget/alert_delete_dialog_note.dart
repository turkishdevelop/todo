import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import '../models/note_helper.dart';
import 'package:todo_app/models/note_data.dart';
import 'package:todo_app/utils/app_localization.dart';

// ignore: must_be_immutable
class AlertDeleteDialog extends StatelessWidget {
  Note note;

  AlertDeleteDialog({this.note});

  @override
  Widget build(BuildContext context) {

    final myProvider = Provider.of<NoteData>(context);
    return AlertDialog(
      content: Text(
        AppLocalizations.of(context).translate('alertAskingDelete'),
        style: TextStyle(fontSize: 22),
      ),
      actions: <Widget>[
        IconButton(
          icon: Icon(FontAwesomeIcons.ban),
          onPressed: () {
            Navigator.pop(context);
          },
          color: Colors.red,
        ),
        IconButton(
          icon: Icon(FontAwesomeIcons.check),
          onPressed: () {
            myProvider.deleteNote(note);
            Navigator.pop(context);
          },
          color: Colors.green,
        ),
      ],
    );
  }
}
